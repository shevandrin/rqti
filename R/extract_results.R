#' @import xml2

get_duration <- function(file) {
    doc <- xml2::read_xml(file)
    test_duration <- xml2::xml_find_all(doc, ".//d1:testResult/d1:responseVariable")
    ids_test <- xml2::xml_attr(test_duration, attr = "identifier")
    val_test <- xml2::xml_text(test_duration)
    items_result <- xml_find_all(doc, ".//d1:itemResult")
    ids_item <- xml2::xml_attr(items_result, attr = "identifier")
    val_node <- xml2::xml_find_all(doc, ".//d1:itemResult/d1:responseVariable[@identifier='duration']")
    val_item <- xml2::xml_text(val_node)
    data <- data.frame(identifier = c(ids_test, ids_item),
                       duration = as.numeric(c(val_test, val_item)))
    return(data)
}

get_result_attributes <- function(file) {
    doc <- xml2::read_xml(file)
    items_result <- xml_find_all(doc, ".//d1:itemResult")
    ids_item <- xml2::xml_attr(items_result, attr = "identifier")
    dur_nodes <- xml2::xml_find_all(doc, ".//d1:itemResult/d1:responseVariable[@identifier='duration']")
    durations <- xml2::xml_text(dur_nodes)
    score_nodes <- xml2::xml_find_all(doc, ".//d1:itemResult/d1:outcomeVariable[@identifier='SCORE']")
    scores <- xml2::xml_text(score_nodes)
    maxscore_nodes <- xml2::xml_find_all(doc, ".//d1:itemResult/d1:outcomeVariable[@identifier='MAXSCORE']")
    maxes <- xml2::xml_text(maxscore_nodes)
    types <- unlist(lapply(ids_item, identify_question_type))
    answer_node <- xml2::xml_find_all(doc, ".//d1:itemResult/d1:responseVariable[2]/d1:candidateResponse")
    answers <- sapply(answer_node, combine_answer)
    response_node <- answer_node <- xml2::xml_find_all(doc, ".//d1:itemResult/d1:responseVariable[2]/d1:correctResponse")
    responses <- (lapply(response_node, combine_answer))
    responses[sapply(responses, is.null)] <- NA
    responses <- unlist(responses)
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

combine_answer <- function(node) {
    y <- c()
    for (i in xml2::xml_children(node)) {
        y <- stringr::str_trim(paste(xml2::xml_text(i), y))
    }
    return(y)
}
