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

#' Create data frame with test rusults
#'
#' The function 'get_result_attributes()'creates data frames with the following
#' data about the test results: 'identifier' - question item identifier,
#' 'duration' - time in sec. what candidate spent on this item, 'score' - points
#' that were given to candidate after evaluation, "max_scored' - max poissible
#' score for this item, 'type' - the type of question, 'candidate_answer' -
#' identifiers of chosen options or specific answer (or NA in case there was no
#' response from candidate), 'correct_responses' - identifiers of options or
#' specific answer that consider as a right response for this item
#'
#' @param file A string with a path of the xml test result file
#' @import xml2
#' @return data frame.
#' @export
get_result_attributes <- function(file) {
    doc <- xml2::read_xml(file)
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
    answers <- unlist(lapply(items_result, combine_responses_notes,
                             "candidateResponse"))
    responses <- unlist(lapply(items_result, combine_responses_notes,
                               "correctResponse"))
    data <- data.frame(identifier = ids_item,
                       duration = as.numeric(durations),
                       score = as.numeric(scores),
                       max_scores = as.numeric(maxes),
                       type = types,
                       candidate_answer = answers,
                       correct_responses = responses)
    return(data)
}

identify_question_type <- function(q_id) {
    types <- c("schoice", "mchoice", "num", "cloze", "essay")
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
