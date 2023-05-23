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
#' @return an instance of the S4 object (SingleChoice, MultipleChoice,
#'   Entry, Order, OneInRowTable, OneInColTable, MultipleChoiceTable,
#'   DirectedPair).
#' @export
create_question_object <- function(file) {

    doc_tree <- parsermd::parse_rmd(file)
    attrs_sec <- parsermd::rmd_select(doc_tree, parsermd::has_type("rmd_yaml_list"))
    attrs <- yaml.load(parsermd::as_document(attrs_sec))
    file_name <- tools::file_path_sans_ext(basename(file))

    object <- switch(tolower(attrs$type),
                     "entry" = create_entry_object(doc_tree, attrs),
                     "sc" =  create_sc_object(doc_tree, attrs, file_name),
                     "mc" = create_mc_object(doc_tree, attrs),
                     "essay" = create_essay_object(doc_tree, attrs),
                     "order" = create_order_object(doc_tree, attrs),
                     "directedpair" = create_dp_object(doc_tree, attrs),
                     "multiplechoicetable" = create_mctable_object(doc_tree, attrs)
    )
    return(object)
}

# creates SingleChoice type of qti-object
create_sc_object <- function(rmd, attrs, file_name) {
    # transform questoin section into html
    question <- parsermd::rmd_select(rmd, parsermd::by_section("question"))[-1]
    html <- transform_to_html(parsermd::as_document(question))

    # get answers - choices
    question_list <- xml2::xml_find_all(html, "//ul")
    choices <- xml2::xml_text(xml2::xml_find_all(
        question_list[length(question_list)], ".//li"))

    # look for <em> to find position of the correct answer
    em <- xml2::xml_text(xml2::xml_find_all(question_list, ".//em"))
    if (length(em) > 1) stop("More than 1 option marked as the correct answer")
    if (length(em) > 0) attrs$solution = which(choices == em)

    # rid of list from question-html
    xml_remove(question_list[length(question_list)])
    # get clean html of question-html
    content <- clean_question(html)

    feedback <- parse_feedback(rmd)

    # align attrs with slots of SingleChoice class
    if (is.null(attrs$identifier)) attrs$identifier <- file_name
    attrs <- c(Class = "SingleChoice", choices = list(choices),
               content = as.list(list(content)), attrs, feedback = as.list(list(feedback)))
    attrs[["type"]] <- NULL # rid of type attribute from attrs

    #create new S4 object
    object <- do.call(new, attrs)
    return(object)
}

create_entry_object <- function(rmd, attrs, file_name) {

}

create_mc_object <- function(rmd, attrs, file_name) {
    # transform questoin section into html
    question <- parsermd::rmd_select(rmd, parsermd::by_section("question"))[-1]
    html <- transform_to_html(parsermd::as_document(question))

    # get answers - choices
    question_list <- xml2::xml_find_all(html, "//ul")
    choices <- xml2::xml_text(xml2::xml_find_all(
        question_list[length(question_list)], ".//li"))

    # look for <em> to find position of the correct answer
    em <- xml2::xml_text(xml2::xml_find_all(question_list, ".//em"))
    if (length(em) > 0) attrs$solution = which(choices == em)

    # rid of list from question-html
    xml_remove(question_list[length(question_list)])
    # get clean html of question-html
    content <- clean_question(html)

    feedback <- parse_feedback(rmd)

    # align attrs with slots of MultipleChoice class
    if (is.null(attrs$identifier)) attrs$identifier <- file_name
    attrs$points <- as.numeric(strsplit(as.character(attrs$points), ",")[[1]])
    attrs <- c(Class = "MultipleChoice", choices = list(choices),
               content = as.list(list(content)), attrs, feedback = as.list(list(feedback)))
    attrs[["type"]] <- NULL # rid of type attribute from attrs

    #create new S4 object
    object <- do.call(new, attrs)
    return(object)
}

create_essay_object <- function(rmd, attrs, file_name) {

}

create_order_object <- function(rmd, attrs, file_name) {

}

create_dp_object <- function(rmd, attrs, file_name) {

}

create_mctable_object <- function(rmd, attrs, file_name) {

}

parse_feedback <- function(rmd) {
    result <- list()
    feedback <- rmd_select(rmd, by_section("feedback"))[-1]
    if (length(feedback) == 1) {
        html <- clean_question(transform_to_html(as_document(feedback)))
        f_object <- new("ModalFeedback", content = as.list(html))
        result <- append(result, f_object)
    }

    w_feedback <- rmd_select(rmd, by_section("wrong feedback"))[-1]
    if (length(w_feedback) == 1) {
        html <- clean_question(transform_to_html(as_document(w_feedback)))
        w_object <- new("WrongFeedback", content = as.list(html))
        result <- append(result, w_object)
    }

    c_feedback <- rmd_select(rmd, by_section("correct feedback"))[-1]
    if (length(c_feedback) == 1) {
        html <- clean_question(transform_to_html(as_document(c_feedback)))
        c_object <- new("CorrectFeedback", content = as.list(html))
        result <- append(result, c_object)
    }
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
    # html <- as.list(HTML(rmarkdown::pandoc_convert(mdtempfile, options=options)))
    rmarkdown::pandoc_convert(mdtempfile, options=options)
    # delete temp md file
    unlink(mdtempfile)
    # read html file
    # sect <- as.list(readLines("_deleteme.html"))
    sect <- xml2::read_html("_deleteme.html", encoding = "UTF-8")
    # delete temp html file
    unlink("_deleteme.html")
    # return lines of processed section
    return(sect)
}

read_table <- function(file, stringsAsFactors = FALSE, strip.white = TRUE, ...){
    if (length(file) > 1) {
        lines <- file
    } else if (grepl('\n', file)) {
        con <- textConnection(file)
        lines <- readLines(con)
        close(con)
    } else {
        lines <- readLines(file)
    }
    lines <- lines[!grepl('^[[:blank:]+-=:_|]*$', lines)]
    lines <- gsub('(^\\s*?\\|)|(\\|\\s*?$)', '', lines)
    read.delim(text = paste(lines, collapse = '\n'), sep = '|',
               stringsAsFactors = stringsAsFactors,
               strip.white = strip.white, ...)
}
