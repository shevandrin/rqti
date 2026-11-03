#' Exercise display names in previews and exports
#'
#' `options(rqti.task_names = "title")` selects a shared naming policy for
#' qti.js previews, XML/ZIP conversion and LMS uploads. The default, when no
#' option is set, is `"title"`. A helper's `task_names` argument overrides the
#' global option for that call.
#'
#' The available policies are:
#' * `"title"`: the exercise title, falling back to its source filename.
#' * `"filename"`: the source filename without its extension.
#' * `"both"`: `Title (filename)`, omitting the duplicate when they match.
#' * `"hidden"`: generic labels such as `Task 1.1`, `Section 1`, and `Test`.
#'
#' Objects created from Rmd retain the source basename so that later export
#' can use it. For programmatically constructed objects with no source file,
#' filename mode uses the identifier. Existing XML/ZIP inputs use their embedded
#' titles and XML filenames; a title lost before import cannot be recovered.
#' This changes display names, not identifiers, file paths or access settings.
#'
#' Set the global option in the RStudio console; separate Knit sessions read
#' current console settings from the running preview server without a restart.
#' For a persistent preference, set the option in `.Rprofile`.
#' This is an R option (`options()` / `getOption()`), not an environment
#' variable (`Sys.setenv()` / `Sys.getenv()`). Prefer options for rqti settings;
#' rqti manages the environment variables needed to coordinate separate processes.
#'
#' The older `fallback_titles` constructor argument remains supported:
#' `"generic"` selects hidden names and its historical `"filename"` value keeps
#' supplied titles. Its default, `"inherit"`, uses the global policy at export.
#' An explicit `task_names` argument overrides this constructor setting too.
#'
#' OPAL repository display names also use the selected exported title unless
#' `display_name` is supplied explicitly. Existing resources keep their
#' repository name when their content is replaced through the update endpoint.
#'
#' @name task_names
#' @seealso [render_qtijs()], [rmd2xml()], [rmd2zip()], [upload2opal()]
NULL

# One policy for preview and export. Only display titles change; identifiers,
# filenames and source files remain independent of the naming policy.
task_name_mode <- function(task_names = NULL, fallback_titles = "inherit") {
    if (is.null(task_names) && !identical(fallback_titles, "inherit")) {
        # Historical filename mode actually retained the supplied titles.
        task_names <- switch(fallback_titles, filename = "title",
                             generic = "hidden", fallback_titles)
    }
    if (is.null(task_names)) task_names <- getOption("rqti.task_names")
    if (is.null(task_names)) task_names <- preview_console_options()$task_names
    if (is.null(task_names)) task_names <- "title"
    if (!is.character(task_names) || length(task_names) != 1L || is.na(task_names) ||
        !task_names %in% c("title", "filename", "both", "hidden")) {
        stop("task_names / option rqti.task_names must be one of: title, filename, both, hidden.",
             call. = FALSE)
    }
    task_names
}

remember_task_source <- function(object, file) {
    attr(object, "rqti_source_file") <- basename(file)
    if (is(object, "AssessmentItem") && tools::file_ext(file) %in% c("Rmd", "md") &&
        (is.null(rmarkdown::yaml_front_matter(file)$title) || !nzchar(trimws(object@title)))) {
        object@title <- tools::file_path_sans_ext(basename(file))
    }
    object
}

task_display_name <- function(title, file, identifier, mode, generic) {
    filename <- if (length(file) && nzchar(file)) {
        tools::file_path_sans_ext(basename(file))
    } else identifier
    if (!length(title) || is.na(title) || !nzchar(trimws(title))) title <- filename
    switch(mode, title = title, filename = filename, hidden = generic,
           both = if (identical(title, filename)) title else paste0(title, " (", filename, ")"))
}

name_qti_object <- function(object, mode, path = "1.1") {
    if (is.character(object)) {
        doc <- xml2::read_xml(object)
        attr(object, "rqti_display_title") <- if (mode == "both" && identical(xml_name_mode(doc), "both")) {
            xml2::xml_attr(doc, "title")
        } else task_display_name(xml2::xml_attr(doc, "title"), object,
                                xml2::xml_attr(doc, "identifier"), mode, paste("Task", path))
        attr(object, "rqti_name_mode") <- mode
        return(object)
    }
    if (is(object, "AssessmentTest")) {
        if (is.null(attr(object, "rqti_original_title"))) {
            attr(object, "rqti_original_title") <- object@title
        }
        object@title <- task_display_name(attr(object, "rqti_original_title"),
            attr(object, "rqti_source_file"), object@identifier, mode, "Test")
        object@section <- lapply(seq_along(object@section), function(i) {
            name_qti_object(object@section[[i]], mode, as.character(i))
        })
    } else if (is(object, "AssessmentSection")) {
        # Preserve explicitly supplied section labels except in hidden mode.
        if (is.null(attr(object, "rqti_original_title"))) {
            attr(object, "rqti_original_title") <- object@title
        }
        object@title <- if (mode == "hidden") paste("Section", path) else attr(object, "rqti_original_title")
        item <- subsection <- 0L
        object@assessment_item <- lapply(object@assessment_item, function(child) {
            if (is(child, "AssessmentSection")) {
                subsection <<- subsection + 1L
                child_path <- paste0(path, ".", subsection)
            } else {
                item <<- item + 1L
                child_path <- paste0(path, ".", item)
            }
            name_qti_object(child, mode, child_path)
        })
    } else if (is(object, "AssessmentItem")) {
        if (is.null(attr(object, "rqti_original_title"))) {
            attr(object, "rqti_original_title") <- object@title
        }
        object@title <- task_display_name(attr(object, "rqti_original_title"),
            attr(object, "rqti_source_file"), object@identifier, mode, paste("Task", path))
    }
    attr(object, "rqti_name_mode") <- mode
    object
}

rmd_xml_path <- function(file, path) {
    if (dir.exists(path) || !grepl("\\.xml$", path, ignore.case = TRUE)) {
        file.path(path, paste0(tools::file_path_sans_ext(basename(file)), ".xml"))
    } else path
}

copy_named_xml <- function(file, target, mode, generic = "Task 1.1") {
    doc <- xml2::read_xml(file)
    if (mode != "both" || !identical(xml_name_mode(doc), "both")) {
        xml2::xml_attr(doc, "title") <- task_display_name(xml2::xml_attr(doc, "title"),
            file, xml2::xml_attr(doc, "identifier"), mode, generic)
    }
    mark_xml_name_mode(doc, mode)
    xml2::write_xml(doc, target)
    invisible(target)
}

xml_name_mode <- function(doc) {
    node <- xml2::xml_find_first(doc, "./comment()[starts-with(., 'rqti-task-names:')]")
    if (inherits(node, "xml_missing")) return(NULL)
    sub("^rqti-task-names:", "", xml2::xml_text(node))
}

mark_xml_name_mode <- function(doc, mode) {
    xml2::xml_remove(xml2::xml_find_all(doc, "./comment()[starts-with(., 'rqti-task-names:')]"))
    if (!is.null(mode) && mode != "title") {
        comment <- xml2::xml_contents(xml2::read_xml(paste0("<rqti><!--rqti-task-names:", mode, "--></rqti>")))[[1]]
        xml2::xml_add_child(doc, comment, .where = 0)
    }
    invisible(doc)
}

name_qti_archive <- function(file, mode) {
    if (mode == "title") return(file)
    work <- tempfile("rqti-names-")
    dir.create(work)
    zip::unzip(file, exdir = work)
    files <- list.files(work, "\\.xml$", recursive = TRUE, full.names = TRUE)
    tests <- Filter(function(f) xml2::xml_name(xml2::read_xml(f)) == "assessmentTest", files)
    named <- character()
    for (test in tests) {
        doc <- xml2::read_xml(test)
        if (mode != "both" || !identical(xml_name_mode(doc), "both")) {
            xml2::xml_attr(doc, "title") <- task_display_name(xml2::xml_attr(doc, "title"),
                file, xml2::xml_attr(doc, "identifier"), mode, "Test")
        }
        mark_xml_name_mode(doc, mode)
        walk <- function(section, path) {
            if (mode == "hidden") xml2::xml_attr(section, "title") <- paste("Section", path)
            item <- subsection <- 0L
            for (child in xml2::xml_children(section)) {
                kind <- xml2::xml_name(child)
                if (kind == "assessmentSection") {
                    subsection <- subsection + 1L
                    walk(child, paste0(path, ".", subsection))
                } else if (kind == "assessmentItemRef") {
                    item <- item + 1L
                    target <- file.path(dirname(test), xml2::xml_attr(child, "href"))
                    if (file.exists(target) && !target %in% named) {
                        copy_named_xml(target, target, mode, paste("Task", paste0(path, ".", item)))
                        named <<- c(named, target)
                    }
                }
            }
        }
        sections <- xml2::xml_find_all(doc, "./*[local-name()='testPart']/*[local-name()='assessmentSection']")
        for (i in seq_along(sections)) walk(sections[[i]], as.character(i))
        xml2::write_xml(doc, test)
    }
    for (f in setdiff(files, named)) {
        if (xml2::xml_name(xml2::read_xml(f)) == "assessmentItem") copy_named_xml(f, f, mode)
    }
    primary <- if (length(tests)) tests[[1L]] else {
        items <- Filter(function(f) xml2::xml_name(xml2::read_xml(f)) == "assessmentItem", files)
        if (length(items)) items[[1L]] else NULL
    }
    if (!is.null(primary)) {
        title <- xml2::xml_attr(xml2::read_xml(primary), "title")
        for (f in files) {
            doc <- xml2::read_xml(f)
            if (xml2::xml_name(doc) == "manifest") {
                nodes <- xml2::xml_find_all(doc, "./*[local-name()='metadata']//*[local-name()='general']/*[local-name()='title']/*")
                xml2::xml_text(nodes) <- title
                resources <- xml2::xml_find_all(doc, ".//*[local-name()='resource']")
                for (resource in resources) {
                    href <- xml2::xml_attr(resource, "href")
                    target <- file.path(dirname(f), href)
                    if (!is.na(href) && file.exists(target) && grepl("\\.xml$", target)) {
                        content <- xml2::read_xml(target)
                        if (xml2::xml_name(content) %in% c("assessmentTest", "assessmentItem")) {
                            labels <- xml2::xml_find_all(resource, "./*[local-name()='metadata']//*[local-name()='general']/*[local-name()='title']/*")
                            xml2::xml_text(labels) <- xml2::xml_attr(content, "title")
                        }
                    }
                }
                xml2::write_xml(doc, f)
            }
        }
    }
    result_dir <- tempfile("rqti-named-archive-")
    dir.create(result_dir)
    result <- file.path(result_dir, basename(file))
    zip::zipr(result, list.files(work, all.files = TRUE, no.. = TRUE), root = work)
    unlink(work, recursive = TRUE)
    result
}

qti_archive_title <- function(file) {
    work <- tempfile("rqti-title-")
    dir.create(work)
    on.exit(unlink(work, recursive = TRUE), add = TRUE)
    zip::unzip(file, exdir = work)
    docs <- lapply(list.files(work, "\\.xml$", full.names = TRUE, recursive = TRUE), xml2::read_xml)
    for (kind in c("assessmentTest", "assessmentItem")) {
        for (doc in docs) {
            if (xml2::xml_name(doc) == kind) {
                title <- xml2::xml_attr(doc, "title")
                if (!is.na(title) && nzchar(title)) return(title)
            }
        }
    }
    tools::file_path_sans_ext(basename(file))
}
