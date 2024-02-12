#' Create test zip file with one task xml file from Rmd (md) description
#'
#' Create zip file with test, that contains one xml question specification
#' generated from Rmd (md) description according to qti 2.1 information model
#' @param file a file with markdown description of question.
#' @param path string, optional; a folder to store xml file; working directory
#'   by default
#' @param verification boolean, optional; to check validity of xml file, default
#'   `FALSE`
#' @export
rmd2zip <- function(file, path = getwd(), verification = FALSE) {
    task <- create_question_object(file)
    # to avoid using the same file name for task and test due to the same id
    test_id <- task@identifier
    task@identifier <- paste0("task_", task@identifier)
    section <- new("AssessmentSection", assessment_item = list(task))
    test <- new("AssessmentTestOpal",
                identifier = test_id,
                title = "QTIJS Preview", section = list(section))
    createQtiTest(test, dir = path, verification = verification,
                  zip_only = TRUE)
}

#' Create qti-XML task file from Rmd (md) description
#'
#' Create XML file for question specification from Rmd (md) description
#' according to qti 2.1 infromation model
#' @param file a file with markdown description of the question.
#' @param path string, optional; a folder to store xml file, can contain file
#'   name; working directory by default
#' @param verification boolean, optional; to check validity of xml file, default
#'   `FALSE`
#' @export
rmd2xml <- function(file, path = getwd(), verification = FALSE) {
    task <- create_question_object(file)
    createQtiTask(task, dir = path, verification = verification)
}


#' @importFrom stringr str_split_1
#' @import yaml
#' @importFrom rmarkdown pandoc_convert yaml_front_matter
#' @importFrom knitr knit opts_knit
create_question_object <- function(file, file_dir = NULL) {
    rmd_checker(file)
    attrs <- yaml_front_matter(file)
    # ignore parameters that are not related to object creation
    attrs <- attrs[! names(attrs) %in% c("knit")]

    file_name <- tools::file_path_sans_ext(basename(file))
    tdir <- tempdir()

    md_path <- file.path(tdir, "_temp_md.md")
    knitr::opts_chunk$set(fig.cap="")
    knitr::opts_chunk$set(error=FALSE)
    knitr::opts_knit$set(base.dir = tdir)

    file_p <- knit(input = file, output = md_path, quiet = TRUE)

    # without type attr assign 'gap'
    if (is.null(attrs$type)) attrs$type <- rmd_detect_type(file_p)

    # if Entry task given, replace <<>> by <tag>
    if (tolower(attrs$type) %in% c("gap", "cloze", "dropdown", "dd")) {
        rmd_content <- readLines(file_p, warn = FALSE)
        rmd_mdf <- gsub("<<", "<gap>", rmd_content)
        rmd_mdf <- gsub(">>", "</gap>", rmd_mdf)
        file_p <- file.path(tdir, "temp.rmd")
        writeLines(rmd_mdf, con = file_p)
    }

    tdoc <- pandoc_html_convert(file_p, "_temp_pandoc.html", tdir)

    file_content <- readLines(tdoc)
    modified_content <- c("<body>", file_content, "</body>")
    write(modified_content, tdoc)

    doc <- xml2::read_xml(tdoc, encoding = "utf-8")
    html_qstn <- xml2::xml_find_first(doc, "//section[@id='question']")
    if (length(html_qstn) == 0) {
        stop("The \'question\' section was not found in Rmd", call. = FALSE)
    }
    slots <- if (tolower(attrs$type) %in% c("sc", "singlechoice", "schoice")) {
        create_sc_slots(html_qstn, attrs)
    } else if (tolower(attrs$type) %in% c("mc", "mpc", "multiplechoice")) {
        create_mc_slots(html_qstn, attrs)
    } else if (tolower(attrs$type) %in% c("gap", "cloze", "dropdown", "dd")) {
        create_entry_slots(html_qstn, attrs)
    } else if (tolower(attrs$type) == "order") {
        create_order_slots(html_qstn, attrs)
    } else if (tolower(attrs$type) == "essay") {
        create_essay_slots(attrs)
    } else if (tolower(attrs$type) %in% c("dp", "directedpair", "pair")) {
        if (!any(names(attrs) == "abbr_id")) attrs$abbr_id <- FALSE
        create_dp_slots(html_qstn, attrs)
    } else if (tolower(attrs$type) %in% c("match", "table", "matchtable")) {
        if (!any(names(attrs) == "abbr_id")) attrs$abbr_id <- FALSE
        create_matchtable_slots(html_qstn, attrs)
    } else {
        stop("The type of the task is not specified properly")
    }

    if (is.null(slots$identifier)) slots$identifier <- file_name
    feedback <- list(parse_feedback(doc, file_dir))
    slots <- c(slots, feedback = feedback)
    if (is.null(slots$content)) {
        slots$content <- as.list(paste(clean_question(html_qstn),
                                       collapse = ""))
        }
    slots[["type"]] <- NULL

    object <- do.call(new, slots)
    return(object)
}

create_entry_slots <- function(html, attrs) {

    html <- xml2::xml_find_all(html, "//section[@id='question']")
    html_str <- paste(clean_question(html), collapse = "")

    entry_gaps <- xml2::xml_find_all(html, "//gap")
    ids <- make_ids(length(entry_gaps), "response")

    gaps <- Map(create_gap_object, entry_gaps, ids)
    end <- unlist(gregexpr("<gap>", html_str)) - 1L
    begin <- unlist(gregexpr("</gap>", html_str)) + 6L
    all <- sort(c(begin, end, 1, nchar(html_str)))

    content <- list()
    for (i in seq(length(all) - 1)) {
        text_chank <- substring(html_str, all[i], all[i + 1L])
        if ((i %% 2) == 0) {
            text_chank <- gaps[i / 2]
        }
        content <- append(content, text_chank)
    }
    attrs <- c(Class = "Entry", content = as.list(list(content)), attrs)
    return(attrs)
}

create_gap_object <- function(entry, id) {
    gap_str <- xml2::xml_text(entry)
    gap_str <- sub("\r\n", " ", gap_str)
    attrs <- yaml::yaml.load(gap_str)
    if (!is.list(attrs)) {
        if (!is.na(suppressWarnings(as.numeric(gap_str)))) {
            object <- new("NumericGap", response_identifier = id,
                          solution = as.numeric(gap_str))
        } else if (length(str_split_1(gap_str, "\\|")) == 1) {
            object <- new("TextGap", response_identifier = id,
                          solution = gap_str)
        } else {
            object <- new("InlineChoice", response_identifier = id,
                          choices = str_split_1(gap_str, "\\|"))
        }
    } else {
        object_class <- switch(attrs$type,
                               "text" = "TextGap",
                               "numeric" = "NumericGap",
                               "text_opal" = "TextGapOpal",
                               "InlineChoice")
        attrs[["type"]] <- NULL
        attrs[["placeholder"]] <- as.character(attrs[["placeholder"]])
        if (!("response_identifier" %in% names(attrs)))  {
            attrs["response_identifier"] <- id
            }
        attrs <- c(Class = object_class, attrs)
        object <- do.call(new, attrs)
    }
    sign_tag <- xml2::read_xml("<sign/>")
    xml2::xml_replace(entry, sign_tag)

    return(object)
}

# creates slots of SingleChoice-object
create_sc_slots <- function(html, attrs) {
    choices_options <- parse_list(html)
    sl <- choices_options$solution
    choices <- choices_options$choices
    if (length(sl) > 1) stop("More than 1 option marked as the correct answer")
    if (length(sl) > 0) attrs$solution <- sl

    attrs <- c(Class = "SingleChoice", choices = list(choices), attrs)
    return(attrs)
}

create_mc_slots <- function(html, attrs) {
    choices_options <- parse_list(html)
    choices <- choices_options$choices
    # define default points as number of right answers * 0.5
    if (length(attrs$points) == 0) {
        attrs$points <- length(choices_options$solution) * 0.5
    }
    attrs$points <- as.numeric(strsplit(as.character(attrs$points), ",")[[1]])
    if (length(attrs$points) == 1) {
        ind_point <- as.numeric(attrs$points) / length(choices_options$solution)
        attrs$points <- rep(0, length(choices))
        attrs$points[choices_options$solution] <- ind_point
    }

    attrs <- c(Class = "MultipleChoice", choices = list(choices), attrs)
    return(attrs)
}

create_matchtable_slots <- function(html, attrs) {
    tbl <- read_table(html, attrs)

    answers_ids <- c()
    answers_scores <- c()
    for (i in seq_len(nrow(tbl$table))) {
        for (j in seq_len(ncol(tbl$table))) {
            points <- tbl$table[i, j]
            if (points > 0) {
                answer_pair <- paste(tbl$rows_ids[i], tbl$cols_ids[j])
                answers_ids <- c(answers_ids, answer_pair)
                answers_scores <- c(answers_scores, points)
            }
        }
    }
    if (is.null(attrs$as_table)) attrs$as_table <- FALSE
    cls <- define_match_class(answers_ids, tbl$rows_ids, tbl$cols_ids,
                              attrs$as_table)
    attrs$abbr_id <- NULL
    attrs$as_table <- NULL
    attrs <- c(Class = cls, rows = list(tbl$rows), cols = list(tbl$cols),
               answers_identifiers = list(answers_ids),
               rows_identifiers = list(tbl$rows_ids),
               cols_identifiers = list(tbl$cols_ids),
               answers_scores = list(answers_scores),
               attrs)
    return(attrs)
}

create_essay_slots <- function(attrs) {
    attrs <- c(Class = "Essay", attrs)
    return(attrs)
}

create_order_slots <- function(html, attrs) {
    choices_options <- parse_list(html)
    choices <- choices_options$choices
    attrs <- c(Class = "Order", choices = list(choices), attrs)
    return(attrs)
}

#' @importFrom stringr str_trim
create_dp_slots <- function(html, attrs) {
    choices_options <- parse_list(html)
    choices <- choices_options$choices
    answer_pairs <- unlist(strsplit(choices, "\\|"))
    answer_pairs <- str_trim(answer_pairs)
    rows <- answer_pairs[c(TRUE, FALSE)]
    cols <- answer_pairs[c(FALSE, TRUE)]

    rows_ids <- define_ids(rows, attrs$abbr, "row")
    cols_ids <- define_ids(cols, attrs$abbr, "col")

    pairs_ids <- paste(rows_ids, cols_ids)

    if (!is.null(attrs$answers_scores)) {
        attrs$answers_scores <- as.numeric(strsplit(as.character(
            attrs$answers_scores), ",")[[1]])
    }

    attrs$abbr_id <- NULL

    attrs <- c(Class = "DirectedPair", rows = list(rows), cols = list(cols),
               answers_identifiers = list(pairs_ids),
               rows_identifiers = list(rows_ids),
               cols_identifiers = list(cols_ids),
               attrs)
    return(attrs)
}

parse_list <- function(html) {
    # find solution indexed in list with possible answers
    question_list <- xml2::xml_find_all(html, "//ul")
    question_list <- question_list[length(question_list)]
    choices  <- xml2::xml_find_all(question_list, ".//li")
    em <- xml2::xml_text(xml2::xml_find_all(question_list, ".//em"))
    is_em <- sapply(choices, function(item) {
                                    item <- unlist(xml_find_first(item, ".//em"))
                                    !is.null(item)
    })
    solution <- which(is_em)
    # build a list with possible answers, that keeps formatting of the content
    # (mathml)
    choices_str <- c()
    for (choice in choices) {
        content <- xml2::xml_contents(choice)
        content <- paste0(as.character(content), collapse = "")
        content <- change_symbols(content)
        if (grepl("^<em>", content)) {
            content <- gsub("^<em>|</em>$", "", content)
        }
        choices_str <- c(choices_str, content)
    }
    xml_remove(question_list[length(question_list)])
    return(list(choices = as.character(choices_str), solution = solution))
}

# from 'question' section it deletes h1, subsection-tag (leave only children),
# and change some characters
clean_question <- function(html) {
    h1 <- xml2::xml_find_first(html, "h1")
    xml2::xml_remove(h1)
    content <- unlist(sapply(xml2::xml_children(html), delete_subsections,
                             USE.NAMES = FALSE))
    content <- sapply(content, change_symbols, USE.NAMES = FALSE)
    content <- Filter(function(x) x != "", content)
    return(content)
}

# delete subsections inside 'question' section
delete_subsections <- function(html_node) {
    if (xml2::xml_name(html_node) == "section") {
        html_node <- xml2::xml_children(html_node)
    }
    return(as.character(html_node))
}

# change symbols to make html neat
change_symbols <- function(cont) {
    if (!startsWith(cont, "<pre")) {
       cont <- gsub("<br>", "<br/>", cont)
       cont <- gsub("\r", "", cont)
       cont <- gsub("^\\n|\\n$", "", cont)
       cont <- gsub(">\n<", "><", cont)
       cont <- gsub("\n", " ", cont)
       cont <- gsub("<br/> ", "<br/>", cont)
       cont <- gsub("   ", "", cont)
    } else {
        cont <- gsub("<code>", "<code><br />", cont)
        cont <- gsub("\\\r\\\n", "<br />", cont)
    }
    return(cont)
}

read_table <- function(html, attrs) {
    tbl <- xml2::xml_find_all(html, "//table")
    tbl <- tbl[length(tbl)]

    cols <- xml2::xml_find_all(tbl, ".//tr[@class='header']//th")
    cols <- as.character(xml2::xml_contents(cols))

    tbd <- xml2::xml_find_all(tbl, "//tbody")
    tbd <- tbd[length(tbd)]
    tr <- xml2::xml_find_all(tbd, ".//tr/td[1]")
    rows <- sapply(tr, function(x) paste(as.character(xml2::xml_contents(x)),
                                         collapse = " "))
    xml2::xml_remove(tr)

    n_cols <- length(xml2::xml_find_all(tbd, "./tr[1]/td"))
    # rid of the first header of columns if it is given
    cols <- cols[(1 + length(cols) - n_cols):length(cols)]

    rows_ids <- define_ids(rows, attrs$abbr, "row")
    cols_ids <- define_ids(cols, attrs$abbr, "col")

    # find column with id for rows and delete it
    if ("rowid" %in% cols) {
        id_col <- which(cols == "rowid")
        rowid_c <- xml2::xml_find_all(tbd, paste0("./tr/td[", id_col, "]"))
        rows_ids <- xml_text(rowid_c)
        xml2::xml_remove(rowid_c)
        cols <- cols[-id_col]
        cols_ids <- cols_ids[-id_col]
        n_cols <- n_cols - 1
    }

    # find column with id for cols and delete it
    if ("colid" %in% rows) {
        id_row <- which(rows == "colid")
        colid_c <- xml2::xml_find_all(tbd, paste0("./tr[", id_row, "]/td"))
        cols_ids <- xml_text(colid_c)
        xml2::xml_remove(colid_c)
        rows <- rows[-id_row]
        rows_ids <- rows_ids[-id_row]
    }

    cells <- xml2::xml_find_all(tbd, "./tr/td")
    cells <- as.numeric(xml2::xml_text(cells))
    table <- matrix(cells, nrow = length(rows), ncol = n_cols, byrow = TRUE)
    xml2::xml_remove(tbl)
    return(list(rows = rows, rows_ids = rows_ids,
                cols = cols, cols_ids = cols_ids,
                table = table))
}

define_ids <- function(vect, abbr, type) {
    if (abbr) {
        ids <- make_abbr_ids(vect)
    } else {
        ids <- make_ids(length(vect), type)
    }
    return(ids)
}

make_ids <- function(n, type) {
    paste(type, formatC(1:n, flag = "0", width = nchar(n)), sep = "_")
}

make_abbr_ids <- function(items) {
    make_abbr <- function(x) {
        count_words <- lengths(strsplit(x, " "))
        if (count_words > 1) {
            pos <- regexpr(" ", x)[1][1]
            x <- paste0(substr(x, 1, pos - 1), "_",
                       abbreviate(substr(x, pos + 1, nchar(x)), minlength = 4,
                                  use.classes = FALSE))
        }
        return(x)
    }

    ids <- sapply(items, make_abbr, USE.NAMES = FALSE)
    counts <- table(ids)
    dupl <- which(counts > 1)
    for (i in dupl) {
        ids[ids == names(counts)[i]] <- paste0(names(counts)[i],
                                               seq_len(counts[i]))
    }
    return(ids)
}

define_match_class <- function(ids, rows, cols, as_table = FALSE) {

    ids <- unlist(strsplit(ids, " "))
    occurrences <- table(c(ids, rows, cols)) - 1
    occ_rows <- occurrences[rows]
    occ_cols <- occurrences[cols]

    # condition one - all rows are equal 1
    cond1 <- all(occ_rows == 1)
    # condition two - all cols are equal 1
    cond2 <- all(occ_cols == 1)
    # condition three - all rows are less or equal than one
    cond3 <- all(occ_rows <= 1)

    if (!cond1 && !cond2) cls <- "MultipleChoiceTable"

    if (cond1) {
        if (cond2) {
            if (as_table) {
                cls <- "OneInRowTable"
            } else {
                 cls <- "DirectedPair"
                 message(paste("The task is converted into \'Directed pair\'",
                               "type. To keep table put \'as_table: TRUE\'",
                               "in yaml section of the Rmd file"))
            }

        } else {
            cls <- "OneInRowTable"
        }
    }

    if (!cond1 && cond2) {
        if (cond3) {
            if (as_table) {
                cls <- "OneInColTable"
            } else {
                cls <- "DirectedPair"
                message(paste("The task is converted into \'Directed pair\'",
                              "type. To keep table put \'as_table=T\'",
                              "in yaml section of the Rmd file"))
            }
        } else {
            cls <- "OneInColTable"
        }
    }
    return(cls)
}

parse_feedback <- function(html, image_dir = NULL) {
    sections <- c("feedback", "feedback-", "feedback+")
    classes <- c("ModalFeedback", "WrongFeedback", "CorrectFeedback")
    create_fb_object <- function(sec, cls, html) {
        feedback <- xml2::xml_find_first(html,
                                         paste0("//h1[text()='", sec, "']"))
        feedback <- xml2::xml_parent(feedback)
        if (length(feedback) > 0) {
            html <- clean_question(feedback)
            f_object <- new(cls, content = as.list(html))
            return(f_object)
        }
    }

    result <- Map(create_fb_object, sections, classes, list(html))
    result <- unname(Filter(Negate(is.null), result))
    return(result)
}

rmd_checker <- function(file) {
    content <- readLines(file)
    helpers <- c("gap_text\\(", "gap_numeric\\(", "dropdown\\(", "mdlist\\(")
    has_helpers <- any(grepl(paste(helpers, collapse = "|"), content))
    has_qti <- any(grepl(".\\(.*rqti.*\\)$", content))
    if (all(has_helpers, !has_qti)) {
        stop("Helper functions are found. Call \'library(rqti)\' inside Rmd file.")
    }
}

rmd_detect_type <- function(file) {
    content <- readLines(file)
    pattern <- c("<<.*?>>", "<gap>.*?</gap>")
    matches <- any(grepl(paste(pattern, collapse = "|"), content))
    if (!matches) {
        stop("Define correct type of the task in yaml section of Rmd file")
    } else {
        return("gap")
    }
}

pandoc_html_convert <- function(input_file, output_file_name, dir_name) {
    options <- c("-o", output_file_name, "-f", "markdown", "-t", "html5",
                 "--mathjax",
                 "--embed-resources",
                 "--section-divs",
                 "--no-highlight",
                 "--wrap=none", "+RTS", "-M512M")
    pandoc_convert(input_file, options = options, wd = dir_name)
    return(file.path(dir_name, output_file_name))
}
