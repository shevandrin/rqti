# The function to create RStudio project template.
qti_project <- function(path, ...) {

    # ensure path exists
    dir.create(path, recursive = TRUE, showWarnings = FALSE)
    # collect inputs
    dots <- list(...)
    sys_path <- system.file(package="qti")
    # copy templates
    temps <- c("singlechoice", "multiplechoice", "gap",
               "dropdown", "order", "table",
               "directedpair", "essay")
    temps_dots <- dots[temps]
    temps_files <- Map(copy_template, temps_dots, names(temps_dots),
                       path, dots['render'])

    # create Rprofile
    text <- c(paste0("Sys.setenv(QTI_API_ENDPOINT=\"", dots$url_endpoint, "\")"),
              paste0("Sys.setenv(QTI_AUTOSTART_SERVER=\"", dots$start_server, "\")"),
              "library(qti)")
    contents <- paste(
        paste(text, collapse = "\n"),
        sep = "\n"
    )
    # write to Rprofile
    writeLines(contents, con = file.path(path, ".Rprofile"))

    # create default main R file
    header <- c(
        "# The qti package provides a powerful toolset for creating exercises",
        "# and exams according to the QTI standard directly from R.",
        "# This script serves as a basic introduction to the qti package,",
        "# demonstrating workflow.",
        "#",
        "# Step 1. Prepare set of Rmd files with individual exercises.",
        "# To create Rmd choose one of the Rstudio file templates starting with QTI: ….",
        "# or edit the templates that have been copied to your working directory.\n"
    )
    filter_files <- Filter(Negate(is.null), temps_files)
    print_files <- sapply(filter_files, function(x) paste0('"', x, '"'))
    list_files <- "\"muster_exercise1.Rmd\", \"muster_exercise2.Rmd\""
    if (length(print_files) != 0) {
        list_files <- paste(print_files, collapse = ", ")
    }
    text_rmd <- c(
        paste0("exercises = c(", list_files, ")")
    )

    text_other <- c(
        "",
        "# Step 2. Create sections.\n",
        "section <- section(exercises)\n",
        "# Step 3. Create test.\n",
        "test <- test(section, \"muster_test\")\n",
        "# Step 4. Upload to LMS.\n",
        "upload2opal(test)\n"
    )

    contents <- paste(
        paste(header, collapse = "\n"),
        paste(text_rmd, collapse = "\n"),
        paste(text_other, collapse = "\n"),
        sep = "\n"
    )

    # write to default main R file
    writeLines(contents, con = file.path(path, "main.R"))
}

copy_template <- function(need_copy, name, path, render) {
    if (need_copy) {
        temp <- paste0("rmarkdown/templates/", name,
                       "-simple/skeleton/skeleton.Rmd")
        sys_path <- system.file(package="qti")
        temp_path <- file.path(sys_path, temp)
        file_t <- file.path(path, paste0(name, ".Rmd"))
        file.copy(temp_path, file_t)
        if (render == "OPAL") replace_knit_method(file_t)
        return(basename(file_t))
    }
}

#' @importFrom stringr str_replace
replace_knit_method <- function(file_path) {
    content <- readLines(file_path, warn = FALSE)
    content <- stringr::str_replace(content, "knit: .*", "knit: qti::render_opal")
    writeLines(content, file_path)
}
