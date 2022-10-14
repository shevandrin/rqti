#' @param choices
#'
#'
create_assessmen_item <- function(list_desc, file_name = "task.xml") {
    ns <- c("xmlns" = "http://www.imsglobal.org/xsd/imsqti_v2p1",
            "xmlns:xsi" = "http://www.w3.org/2001/XMLSchema-instance",
            "xsi:schemaLocation" = "http://www.imsglobal.org/xsd/imsqti_v2p1 http://www.imsglobal.org/xsd/qti/qtiv2p1/imsqti_v2p1.xsd",
            "identifier" = "__someIdentifier__",
            "title" = list_desc$metainfo$title,
            "adaptive" =  "false",
            "timeDependent" = "false")
    doc <- xml2::xml_new_document()
    doc <- xml2::xml_new_root("assessmentItem")
    xml2::xml_attrs(doc) <- ns
    create_outcome_declaration(doc, "SCORE")
    create_item_body(doc, list_desc)
    xml2::write_xml(doc, file_name)
    print(paste("see the file ", file_name, " in your work directory"))
}

create_response_declaration <- function(doc, id,
                                        cardinality = "single",
                                        base_type = "identifier") {
    root <- xml2::xml_find_first(doc, "/d1:assessmentItem")
    rd_counts <- length(xml2::xml_find_all(doc, ".//responseDeclaration"))
    root <- xml2::xml_add_child(doc, "responseDeclaration", .where = rd_counts)
    xml2::xml_attrs(root) <- c("identifier" = id,
                               "cardinality" = cardinality,
                               base_type = base_type)
    xml2::xml_add_child(root, "correctResponse")
    return(root)
}

create_mapping <- function(node) {
    item <- xml2::xml_add_child(node, "mapping")
    return(item)
}

create_map_entry <- function(node, map_key, mapped_value,
                             case_sensitive = "false") {
    item <- xml2::xml_add_child(node, "mapEntry")
    xml2::xml_attrs(item) <- c("map_key" = map_key,
                               "mapped_value" = mapped_value,
                               "case_sensitive" = case_sensitive)
    return(item)
}

create_outcome_declaration <- function(doc, id,
                                       cardinality = "single",
                                       base_type = "float") {
    root <- xml2::xml_add_child(doc, "outcomeDeclaration")
    xml2::xml_attrs(root) <- c("identifier" = id,
                               "cardinality" = cardinality,
                               "base_type" = base_type)
    return(doc)
}

create_responce_processing <- function(doc, template = NULL) {
    root <- xml2::xml_add_child(doc, "responseProcessing")
    if (!is.null(template)) xml2::xml_attrs(root) <- c("template" = template)
    return(doc)
}

create_item_body <- function(doc, list_desc) {
    root <- xml2::xml_add_child(doc, "itemBody")
    item <- xml2::xml_add_child(root, "p")
    tq <-  list_desc$metainfo$type
    if (tq == "schoice") {
        xml2::xml_text(item) <- list_desc$question
        print("this is a single choice type of the task")
        create_choice_interaction(root, list_desc, doc, cardinality = "single")
    } else if (tq == "mchoice") {
        xml2::xml_text(item) <- list_desc$question
        print("this is a multiple choice type of the task")
        create_choice_interaction(root, list_desc, doc,
                                  max_choices = 0,
                                  cardinality = "multiple")
    } else if (tq == "string") {
        print("this is a text entry type of the task")
        create_text_entry_interaction(item, list_desc, doc)
    } else if (tq == "order") {
        xml2::xml_text(item) <- "some title or nothing"
        print("this is an order type of the task")
        create_order_interaction(root, list_desc, doc)
    } else if (tq == "association") {
        xml2::xml_text(item) <- "some title or nothing"
        print("this is an asssociation type of the task")
        create_associate_interaction(root, list_desc, doc)
    }
    return(doc)
}

create_choice_interaction <- function(node, list_desc, doc,
                                      shuffle = "true",
                                      max_choices = 1,
                                      min_choices = 0,
                                      orientatioin,
                                      cardinality = "single") {
    root <- xml2::xml_add_child(node, "choiceInteraction")
    xml2::xml_attrs(root) <- c("responseIdentifier" = "RESPONSE",
                               "shuffle" = shuffle,
                               max_choices = max_choices,
                               min_choices = min_choices)
    count <- list_desc$metainfo$length
    ids <- make_test_ids(count, type = "item")
    indexes_trues <-  which(list_desc$metainfo$solution)
    points <- list_desc$metainfo$points
    if (is.null(points)) points <- 1
    positive_grade <- points / length(indexes_trues)
    negative_grade <- - points / (count - length(indexes_trues))
    item <- create_response_declaration(doc, "RESPONSE",
                                        cardinality = cardinality)
    create_mapping(item)
    for (i in 1:count) {
        create_simple_choice(root, ids[i], list_desc$questionlist[i])
        if (i %in% indexes_trues) {
            value_node <- xml2::xml_find_first(doc, ".//correctResponse")
            new_value_node <- xml2::xml_add_child(value_node, "value")
            xml2::xml_text(new_value_node) <- ids[i]
            map_node <- xml2::xml_find_first(doc, ".//mapping")
            create_map_entry(map_node, map_key = ids[i],
                             mapped_value = positive_grade,
                             case_sensitive = "true")
        } else {
            # TODO: to some extent for single choice it is redundancy
            #to add mapping
            map_node <- xml2::xml_find_first(doc, ".//mapping")
            create_map_entry(map_node, map_key = ids[i],
                             mapped_value = negative_grade,
                             case_sensitive = "true")
        }
    }
    # TODO: here must be placed calling for outcome declaration forming
    # without outcome declaration evaluation of multiple choice does not work
    create_responce_processing(doc)
    return(root)
}

create_order_interaction <- function(node, list_desc, doc) {
    create_response_declaration(doc, "RESPONSE",
                                cardinality = "ordered",
                                base_type = "identifier")
    root <- xml2::xml_add_child(node, "orderInteraction")
    xml2::xml_attrs(root) <- c("responseIdentifier" = "RESPONSE",
                               "shuffle" = "true")
    item <- xml2::xml_add_child(root, "prompt")
    xml2::xml_text(item) <- list_desc$question
    ids <- make_test_ids(length(list_desc$questionlist), type = "item")
    ord <- c()
    for (i in seq_len(length(list_desc$questionlist))) {
        create_simple_choice(root, ids[i], list_desc$questionlist[i])
        index <- as.integer(strsplit(list_desc$metainfo$solution,
                                     split = "")[[1]][i])
        ord[index] <- ids[i]
    }
    for (i in ord) {
    value_node <- xml2::xml_find_first(doc, ".//correctResponse")
    new_value_node <- xml2::xml_add_child(value_node, "value")
    xml2::xml_text(new_value_node) <- i
    }
    url <- "http://www.imsglobal.org/question/qti_v2p1/rptemplates/match_correct"
    create_responce_processing(doc, template = url)
}

create_simple_choice <- function(doc, id, content) {
    root <- xml2::xml_add_child(doc, "simpleChoice")
    xml2::xml_attrs(root) <- c("identifier" = id)
    xml2::xml_text(root) <- content
    return(root)
}

create_associate_interaction <- function(node, list_desc, doc) {
    create_response_declaration(doc, "RESPONSE",
                                cardinality = "multiple",
                                base_type = "directPair")
    root <- xml2::xml_add_child(node, "matchInteraction")
    xml2::xml_attrs(root) <- c("responseIdentifier" = "RESPONSE",
                               "shuffle" = "true",
                               "maxAssociations" = "0")
    item <- xml2::xml_add_child(root, "prompt")
    xml2::xml_text(item) <- list_desc$question

    ids <- make_test_ids(length(list_desc$questionlist) * 2, type = "item")
    index <- 1
    xml2::xml_add_child(root, "simpleMatchSet")
    xml2::xml_add_child(root, "simpleMatchSet")
    set_node <- xml2::xml_find_all(root, ".//simpleMatchSet")
    for (i in list_desc$questionlist) {
        option <- strsplit(i,  split = "\\|")[[1]]
        index_awr <- index
        for (j in option) {
            item_choice <- xml2::xml_add_child(set_node[[which(option == j)]],
                                               "simpleAssociableChoice")
            xml2::xml_text(item_choice) <- stringr::str_trim(j)
            xml2::xml_attrs(item_choice) <- c("identifier" = ids[index_awr],
                                              "matchMax" = "1",
                                              "fixed" = "false")
            index_awr <- index_awr + 1
        }
        value_node <- xml2::xml_find_first(doc, ".//correctResponse")
        new_value_node <- xml2::xml_add_child(value_node, "value")
        xml2::xml_text(new_value_node) <- paste(ids[index], ids[index + 1])
        index <- index + 2
    }
    url <- "http://www.imsglobal.org/question/qti_v2p1/rptemplates/map_response"
    create_responce_processing(doc, template = url)
    # TODO: here must be placed calling for outcome declaration forming
    # without outcome declaration evaluation of match type does not work
    return(doc)
}

create_text_entry_interaction <- function(node, list_desc, doc) {
    parse_question <- strsplit(list_desc$question, " ")[[1]]
    gaps <- stringr::str_which(parse_question, "<<>>")
    points <- list_desc$metainfo$points
    if (is.null(points)) points <- length(gaps)

    ids <- make_test_ids(length(gaps), type = "item")
    lbord <- 1
    for (i in gaps) {
        id <-  ids[which(gaps == i)]
        hbord <- i - 1
        before_gap <- paste(parse_question[lbord:hbord], collapse = " ")
        lbord <- i + 1
        item <- xml2::xml_add_child(node, "span")
        xml2::xml_text(item) <- before_gap
        sibitem <- xml2::xml_add_sibling(item, "textEntryInteraction")
        xml2::xml_attrs(sibitem) <- c("responseIdentifier" = id)
        rd_node <- create_response_declaration(doc, id, base_type = "string")
        value_node <- xml2::xml_find_all(doc,
                                       ".//correctResponse")[[which(gaps == i)]]
        new_value_node <- xml2::xml_add_child(value_node, "value")
        sol <- list_desc$metainfo$solution
        xml2::xml_text(new_value_node) <- sol[which(gaps == i)]
        create_map_entry(create_mapping(rd_node),
                         map_key = sol[which(gaps == i)],
                         mapped_value = points / length(gaps))
    }
    after_gap <- paste(tail(parse_question, -lbord + 1), collapse = " ")
    item <- xml2::xml_add_child(node, "span")
    xml2::xml_text(item) <- after_gap
    create_responce_processing(doc)
    return(node)
}

make_test_ids <- function(n, type = c("test", "section", "item")) {
    switch(type,
           "test" = paste("name", make_id(9), sep = "_"),
           paste(type, formatC(1:n, flag = "0", width = nchar(n)), sep = "_")
    )
}

## function to create identfier ids
make_id <- function(size, n = 1L) {
    if (is.null(n)) n <- 1L
    rval <- matrix(sample(0:9, size * n, replace = TRUE), ncol = n, nrow = size)
    rval[1L, ] <- pmax(1L, rval[1L, ])
    colSums(rval * 10^((size - 1L):0L))
}
