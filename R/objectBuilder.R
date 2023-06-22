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
    section <- new("AssessmentSection", assessment_item = list(task))
    test <- new("AssessmentTestOpal", identifier = "test",
                title = "QTIJS Preview", section = list(section))
    createQtiTest(test, dir = path, verification = verification)
}

#' Create qti-XML task file from Rmd (md) description
#'
#' Create XML file for question specification from Rmd (md) description
#' according to qti 2.1 infromation model
#' @param file a file with markdown description of question.
#' @param path string, optional; a folder to store xml file, can contain file
#'   name; working directory by default
#' @param verification boolean, optional; to check validity of xml file, default
#'   `FALSE`
#' @export
rmd2xml <- function(file, path = getwd(), verification = FALSE) {
    task <- create_question_object(file)
    createQtiTask(task, dir = path, verification = verification)
}

#' Create S4 object according to content of markdown file
#'
#' @param file a file with markdown description of question.
#' @importFrom commonmark markdown_html
#' @importFrom htmltools HTML p
#' @importFrom stringr str_extract_all str_sub str_trim str_split_1
#' @importFrom rmarkdown pandoc_convert
#' @import yaml
#' @import parsermd
#' @importFrom utils read.delim
#' @importFrom knitr knit
#' @return an instance of the S4 object (SingleChoice, MultipleChoice,
#'   Entry, Order, OneInRowTable, OneInColTable, MultipleChoiceTable,
#'   DirectedPair).
#' @export
create_question_object <- function(file) {

    file_name <- tools::file_path_sans_ext(basename(file))
    exts <- tools::file_ext(file)
    if (exts == "Rmd") {
        tdir <- tempdir()
        file <- knitr::knit(file,
                            output = file.path(tdir, paste0(file_name, ".md")),
                            quiet = TRUE)
    }

    doc_tree <- parsermd::parse_rmd(file)
    attrs_sec <- parsermd::rmd_select(doc_tree,
                                      parsermd::has_type("rmd_yaml_list"))
    attrs <- yaml.load(parsermd::as_document(attrs_sec))
    # ignore parameters that are not related to object creation
    attrs <- attrs[! names(attrs) %in% c("knit")]
    question <- parsermd::rmd_select(doc_tree,
                                     parsermd::by_section("question"))[-1]
    html <- transform_to_html(parsermd::as_document(question))

    slots <- if (tolower(attrs$type) %in% c("sc", "singlechoice")) {
        create_sc_object(html, attrs)
    } else if (tolower(attrs$type) %in% c("mc", "mpc", "multiplechoice")) {
        create_mc_object(html, attrs)
    } else if (tolower(attrs$type) %in% c("gap", "cloze", "dropdown")) {
        create_entry_object(question, attrs)
    } else if (tolower(attrs$type) == "order") {
        create_order_object(html, attrs)
    } else if (tolower(attrs$type) == "essay") {
        create_essay_object(attrs)
    } else if (tolower(attrs$type) %in% c("dp", "directedpair")) {
        create_dp_object(html, attrs)
    } else if (tolower(attrs$type) %in% c("match")) {
        create_matchtable_object(html, attrs)
    } else {
        stop("The type of task is not specified properly")
    }

    if (is.null(slots$identifier)) slots$identifier <- file_name
    feedback <- list(parse_feedback(file))
    if (is.null(slots$content)) slots$content <- as.list((clean_question(html)))
    slots <- c(slots, feedback = feedback)
    slots[["type"]] <- NULL # rid of type attribute from slots

    if (!is.null(slots[["seed"]])) {
        id <- paste0(slots[["identifier"]], "_S", slots[["seed"]])
        slots[["identifier"]] <- id
        slots[["seed"]] <- NULL
    }

    object <- do.call(new, slots)
    return(object)
}

# creates SingleChoice type of qti-object
create_sc_object <- function(html, attrs) {
    choices_options <- parse_list(html)
    em <- choices_options$solution
    choices <- choices_options$choices
    if (length(em) > 1) stop("More than 1 option marked as the correct answer")
    if (length(em) > 0) attrs$solution = em

    attrs <- c(Class = "SingleChoice", choices = list(choices), attrs)
    return(attrs)
}

create_mc_object <- function(html, attrs) {
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

create_entry_object <- function(question, attrs) {
    question <- parsermd::as_document(question)
    question <- gsub("<<", "<entry>", question)
    question <- gsub(">>", "</entry>", question)
    html <- transform_to_html(question)

    entry_gaps <- xml2::xml_find_all(html, "//entry")
    gaps_content <- xml2::xml_text(entry_gaps)
    ids <- make_ids(length(entry_gaps), "response")
    # new_gaps <- Map(create_gap_object, ids, gaps_content)

    html_ <- clean_question(html)
    end <- unlist(gregexpr("<entry>", html_)) - 1L
    begin <- unlist(gregexpr("</entry>", html_)) + 8L
    all <- sort(c(begin, end, 1, nchar(html_)))

    content <- list()
    for (i in seq(length(all) - 1)) {
        text_chank <- substring(html_, all[i], all[i + 1L])
        if ((i %% 2) == 0) {
            text_chank <- create_gap_object(ids[i/2], gaps_content[i/2])
        }
        content <- append(content, text_chank)
    }

    attrs <- c(Class = "Entry", content = as.list(list(content)), attrs)
    return(attrs)
}

create_gap_object <- function(id, value) {
    attrs <- yaml::yaml.load(value)
    if (!is.list(attrs)) {
        if (!is.na(suppressWarnings(as.numeric(value)))) {
            object <- new("NumericGap", response_identifier = id,
                          response = as.numeric(value))
        } else if (length(str_split_1(value, "\\|")) == 1) {
            object <- new("TextGap", response_identifier = id, response = value)
        } else {
            object <- new("InlineChoice", response_identifier = id,
                choices = str_split_1(value, "\\|"))
        }
    } else {
        object_class <- switch(attrs$type,
            "text" = "TextGap",
            "numeric" = "NumericGap",
            "text_opal" = "TextGapOpal",
            "InlineChoice")
        attrs[["type"]] <- NULL
        attrs <- c(Class = object_class, attrs, response_identifier = id)
        object <- do.call(new, attrs)
    }
    return(object)
}

make_ids <- function(n, type) {
    paste(type, formatC(1:n, flag = "0", width = nchar(n)), sep = "_")
}

create_essay_object <- function(attrs) {
    attrs <- c(Class = "Essay", attrs)
    return(attrs)
}

create_order_object <- function(html, attrs) {
    choices_options <- parse_list(html)
    choices <- choices_options$choices

    attrs <- c(Class = "Order", choices = list(choices), attrs)
    return(attrs)
}

create_dp_object <- function(html, attrs) {
    choices_options <- parse_list(html)
    choices <- choices_options$choices
    answer_pairs <- sub(" ", "", unlist(strsplit(choices, "\\|")))
    rows <- answer_pairs[c(TRUE, FALSE)]
    cols <- answer_pairs[c(FALSE, TRUE)]

    rows_ids <- make_ids(length(choices), "row")
    cols_ids <- make_ids(length(choices), "col")
    pairs_ids <- paste(rows_ids, cols_ids)

    attrs$answers_scores <- as.numeric(strsplit(as.character(
        attrs$answers_scores), ",")[[1]])

    attrs <- c(Class = "DirectedPair", rows = list(rows), cols = list(cols),
               answers_identifiers = list(pairs_ids),
               rows_identifiers = list(rows_ids),
               cols_identifiers = list(cols_ids),
               attrs)
    return(attrs)
}

create_matchtable_object <- function(html, attrs) {

    # get answers - choices
    table <- read_table(html)
    rows <- as.character(unlist(table[,1]))
    cols <- as.character(colnames(table)[-1])
    rows_ids <- make_ids(length(rows), "row")
    cols_ids <- make_ids(length(cols), "col")
    answers_ids <- c()
    answers_scores <- c()
    for (i in 1:nrow(table)) {
        for (j in 2:ncol(table)) {
            points <- table[i, j]
            if (points > 0) {
                answer_pair = paste(rows_ids[i], cols_ids[j - 1L])
                answers_ids = c(answers_ids, answer_pair)
                answers_scores <- c(answers_scores, points)
            }
        }
    }

    answers_scores <- unlist(answers_scores)
    names(answers_scores) <- NULL
    cls <- define_match_class(answers_ids, rows_ids, cols_ids)

    attrs <- c(Class = cls, rows = list(rows), cols = list(cols),
               answers_identifiers = list(answers_ids),
               rows_identifiers = list(rows_ids),
               cols_identifiers = list(cols_ids),
               answers_scores = list(answers_scores),
               attrs)
    return(attrs)
}

parse_list <- function(html) {
    question_list <- xml2::xml_find_all(html, "//ul")
    choices <- xml2::xml_text(xml2::xml_find_all(
        question_list[length(question_list)], ".//li"))
    em <- xml2::xml_text(xml2::xml_find_all(question_list, ".//em"))
    solution <- which(choices %in% em)
    xml_remove(question_list[length(question_list)])
    return(list(choices = choices, solution = solution))
}

parse_feedback <- function(file) {
    sections <- c("feedback", "feedback\\-", "feedback\\+")
    classes <- c("ModalFeedback", "WrongFeedback", "CorrectFeedback")

    create_fb_object <- function(sec, cls, file) {
        rmd <- parsermd::parse_rmd(file)
        feedback <- rmd_select(rmd, parsermd::by_section(sec))[-1]
        if (length(feedback) == 1) {
            html <- clean_question(transform_to_html(as_document(feedback)))
            f_object <- new(cls, content = as.list(html))
        }
    }

    result <- Map(create_fb_object, sections, classes, file)
    result <- unname(Filter(Negate(is.null), result))
    return(result)
}

# get content of section
# restun text chank
get_task_section <- function(file, section) {
    sec_bord <- grep("^====", file)
    headers <- file[sec_bord - 1L]
    ind <- which(section == tolower(headers))
    begin <- sec_bord[ind] + 1L
    end <- sec_bord[ind + 1L] - 2L
    if (is.na(end)) end <- length(file)
    result <- file[begin:end]
    if (section != "question") {
       result <- result[sapply(result, nchar, USE.NAMES = FALSE) !=  0]
    }
    return(result)
}

# get attributes of question
# return named vector
clean_question <- function(html) {
    content <- as.character(xml2::xml_find_all(html, ".//body"))
    content <- gsub("<\\/?(body)>", "", content)
    content <- gsub("^\\n|\\n$", "", content)
    content <- gsub("<br>", "<br/>", content)
    content <- gsub("\r", "", content)
    content <- as.list(content)
    return(content)
}

transform_to_html <- function(sec) {
    # write section in temp md file
    mdtempfile <- "_deleteme.md"
    writeLines(sec, mdtempfile)
    # read via pandoc
    # it writes result of transformation to temp html file
    htmltempfile <- "_deleteme.html"
    options <- c("-o", htmltempfile, "-f", "markdown", "-t", "html",
                 "--mathml", "--wrap=none", "+RTS", "-M30m")

    rmarkdown::pandoc_convert(mdtempfile, options=options)
    # delete temp md file
    unlink(mdtempfile)
    # read html file
    sect <- xml2::read_html("_deleteme.html", encoding = "UTF-8")
    # delete temp html file
    unlink("_deleteme.html")
    # return lines of processed section
    return(sect)
}

define_match_class <- function(ids, rows, cols) {

    ids <- unlist(strsplit(ids, " "))
    occurrences <- table(c(ids, setdiff(rows, ids), setdiff(cols, ids)))
    unique_rows <- !any(occurrences[rows] > 1)
    unique_cols <- !any(occurrences[cols] > 1)

    if (unique_rows & !unique_cols) {
        cls <- "OneInRowTable"
    } else if (!unique_rows & unique_cols) {
        cls <- "OneInColTable"
    } else {
        cls <- "MultipleChoiceTable"
    }
    return(cls)
}

#' @importFrom rvest html_table
read_table <- function(html) {
    tbl <- xml2::xml_find_all(html, "//table")
    tbl <- tbl[length(tbl)]
    df <- rvest::html_table(tbl, fill = TRUE)[[1]]
    xml_remove(tbl)
    return(df)
}
