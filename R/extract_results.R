#' @import xml2
#' @import stringr
get_duration <- function(file) {
    doc <- xml2::read_xml(file)
    test_duration <- xml2::xml_find_all(doc,
                                        ".//d1:testResult/d1:responseVariable")
    ids_test <- xml2::xml_attr(test_duration, attr = "identifier")
    val_test <- xml2::xml_text(test_duration)
    items_result <- xml_find_all(doc, ".//d1:itemResult")
    ids_item <- xml2::xml_attr(items_result, attr = "identifier")
    val_node <- xml2::xml_find_all(doc,
                ".//d1:itemResult/d1:responseVariable[@identifier='duration']")
    val_item <- xml2::xml_text(val_node)
    data <- data.frame(identifier = c(ids_test, ids_item),
                       duration = as.numeric(c(val_test, val_item)))
    return(data)
}

#' Create data frame with test results by answers
#'
#' The function `get_result_attr_answers()` creates data frames with the
#' following data about the test results:
#' * 'file_name' - name of the xml file with test results (to identify
#' candidate)
#' * 'datestamp' - date and time of test
#' * 'question_id' - question item identifier
#' * 'duration' - time in sec. what candidate spent on this item
#' * 'candidate_score' - points that were given to candidate after evaluation
#' * 'max_scored' - max possible score for this question item
#' * 'type' - the type of question
#'
#' @param file A string with a path of the xml test result file
#' @import xml2
#' @import lubridate
#' @return data frame.
#' @export
get_result_attr_answers<- function(file) {
    file_name <- basename(file)

    doc <- xml2::read_xml(file)
    node_dt <- xml2::xml_find_first(doc, ".//d1:testResult")
    test_dt <- xml2::xml_attr(node_dt, "datestamp")
    test_dt <- lubridate::ymd_hms(test_dt)

    items_result <- xml_find_all(doc, ".//d1:itemResult")
    ids_item <- xml2::xml_attr(items_result, attr = "identifier")
    dur_nodes <- xml2::xml_find_all(doc,
                ".//d1:itemResult/d1:responseVariable[@identifier='duration']")
    durations <- xml2::xml_text(dur_nodes)
    score_nodes <- xml2::xml_find_all(doc,
                ".//d1:itemResult/d1:outcomeVariable[@identifier='SCORE']")
    scores <- xml2::xml_text(score_nodes)
    maxscore_nodes <- xml2::xml_find_all(doc,
                ".//d1:itemResult/d1:outcomeVariable[@identifier='MAXSCORE']")
    maxes <- xml2::xml_text(maxscore_nodes)
    types <- unlist(lapply(ids_item, identify_question_type))

    data <- data.frame(file_name = rep(file_name, length(ids_item)),
                       datestamp = rep(test_dt, length(ids_item)),
                       question_id = ids_item,
                       duration = as.numeric(durations),
                       candidate_score = as.numeric(scores),
                       max_scores = as.numeric(maxes),
                       question_type = types)
    return(data)
}

#' Create data frame with test results by options of answers
#'
#' The function `get_result_attr_options()` creates data frames with the
#' following data about the individual answers:
#' * 'file_name' - name of the xml file with test results (to identify
#' candidate)
#' * 'datestamp' - date and time of test
#' * 'question_id' - question item identifier
#' * 'base_types' - type of answer (identifier, string or float)
#' * 'id_answer_options' - identifier of each response variable
#' * 'correct_responses' - values that considered as right responses for
#' question
#' * 'cand_responses' - values that were given by candidate
#'
#' @param file A string with a path of the xml test result file
#' @import xml2
#' @import lubridate
#' @return data frame.
#' @export
get_result_attr_options <- function(file) {
    file_name <- basename(file)

    doc <- xml2::read_xml(file)
    node_dt <- xml2::xml_find_first(doc, ".//d1:testResult")
    test_dt <- xml2::xml_attr(node_dt, "datestamp")
    test_dt <- lubridate::ymd_hms(test_dt)

    items_result <- xml2::xml_find_all(doc, ".//d1:itemResult")
    ids_item <- xml2::xml_attr(items_result, attr = "identifier")

    types <- unlist(lapply(ids_item, identify_question_type))

    identifier <-  character(0)
    options <- character(0)
    correct_responses <- character(0)
    cand_responses <- character(0)
    base_types <- character(0)
    for (ch in items_result) {
        res <- get_info(ch)
        len <- length(res$options)
        id <- xml2::xml_attr(ch, attr = "identifier")
        identifier <- append(identifier, rep(id, len))
        options <- append(options, res$options)
        correct_responses <- append(correct_responses, res$corr)
        cand_responses <- append(cand_responses, res$cand)
        base_types <- append(base_types, res$base_types)
    }

    data <- data.frame(
        file_name = rep(file_name, length(identifier)),
        datestamp = rep(test_dt, length(identifier)),
        question_id = identifier,
        base_types =  base_types,
        id_answer_options = options,
        correct_responses = correct_responses,
        cand_responses = cand_responses
    )
    return(data)
}

# takes information from responseVariable tags
get_info <- function(node){
    options_nodes <- xml2::xml_find_all(node, ".//d1:responseVariable")[-1][1]
    data_type <- xml2::xml_attr(options_nodes, "baseType")
    if (data_type == "identifier") info <- get_info_identifier(node, options_nodes)
    if (data_type == "float") info <- get_info_float(node)
    if (data_type == "string") info <- get_info_float(node)
    res <- list(info$options, info$corr, info$cand, info$base_types)
    names(res) <- c("options", "corr", "cand", "base_types")
    return(res)
}

# takes information from tag with identifier as base type of response variable
get_info_identifier <- function(node, options_nodes) {
    options <- stringr::str_split_1(xml2::xml_attr(options_nodes, "choiceSequence"), " ")

    corr_res <- xml2::xml_find_all(node, ".//d1:correctResponse")
    corr_values <- get_value(corr_res)
    corr <- sapply(options, function(x) x %in% corr_values, USE.NAMES = FALSE)

    cand_res <- xml2::xml_find_all(node, ".//d1:candidateResponse")
    cand_values <- get_value(cand_res)
    cand <- sapply(options, function(x) x %in% cand_values, USE.NAMES = FALSE)
    base_types <- rep(xml2::xml_attr(options_nodes, "baseType"), length(options))
    res <- list(options, corr, cand, base_types)

    names(res) <- c("options", "corr", "cand", "base_types")
    return(res)
}

# takes information from tag with float or string as base type of response
# variable
get_info_float <- function(node) {
    options_nodes <- xml2::xml_find_all(node, ".//d1:responseVariable")[-1]
    options <- character(0)
    corr <- character(0)
    cand <- character(0)
    for (opt in options_nodes) {
        id <- xml2::xml_attr(opt, "identifier")
        options <- append(options, id)
        corr_res <- xml2::xml_find_all(opt, ".//d1:correctResponse")
        corr_values <- get_value(corr_res)
        if (length(corr_values) == 0) corr_values = ""
        corr <- append(corr, corr_values)
        cand_res <- xml2::xml_find_all(opt, ".//d1:candidateResponse")
        cand_values <- get_value(cand_res)
        if (length(cand_values) == 0) cand_values = ""
        cand <- append(cand, cand_values)
    }
    base_types <- xml2::xml_attr(options_nodes, "baseType")

    res <- list(options, corr, cand, base_types)
    names(res) <- c("options", "corr", "cand", "base_types")
    return(res)
}

# takes value from tag value
get_value <- function(node) {
    values <- xml2::xml_find_all(node, ".//d1:value")
    value  <- xml2::xml_text(values)
    return(value)
}

# to detect question type
identify_question_type <- function(q_id) {
    types <- c("schoice", "mchoice", "num", "cloze", "essay")
    result <- "unknown"
    for (t in types) {
        if (grepl(t, q_id)) result <- t
    }
    return(result)
}

combine_responses_notes <- function(node, tag) {
    answer_nodes <- xml2::xml_find_all(node, ".//d1:responseVariable")
    answers <- sapply(answer_nodes[-1], combine_answer, tag)
    paste(answers, sep = "", collapse = " ")
}

combine_answer <- function(node, tag) {
    y <- c()
    response <- xml2::xml_find_first(node, paste0(".//d1:", tag))
    if (is.na(response)) {
        y <- NA
    } else {
        for (i in xml2::xml_children(response)) {
            y <- stringr::str_trim(paste(xml2::xml_text(i), y))
        }
    }
    return(y)
}
