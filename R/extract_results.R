get_duration <- function(file) {
    doc <- xml2::read_xml(file)
    test_duration <- xml2::xml_find_all(doc, ".//d1:testResult/d1:responseVariable")
    ids_test <- xml2::xml_attr(test_result, attr = "identifier")
    val_test <- xml2::xml_text(test_result)
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
    data <- data.frame(identifier = ids_item,
                       duration = as.numeric(durations),
                       score = as.numeric(scores),
                       max_scores = as.numeric(maxes))
    return(data)
}
