#' @param choices
#'
#'
create_assessment_item <- function(list_desc, file_name = "task.xml") {
    if (is.null(list_desc$metainfo$points)) list_desc$metainfo$points <- 1
    ns <- c("xmlns" = "http://www.imsglobal.org/xsd/imsqti_v2p1",
            "xmlns:xsi" = "http://www.w3.org/2001/XMLSchema-instance",
            "xsi:schemaLocation" = "http://www.imsglobal.org/xsd/imsqti_v2p1 http://www.imsglobal.org/xsd/qti/qtiv2p1/imsqti_v2p1.xsd",
            "identifier" = "__someIdentifier__",
            "title" = paste(list_desc$metainfo$title, format(Sys.time(), "%F-%H-%M-%S")),
            "adaptive" =  "false",
            "timeDependent" = "false")
    doc <- xml2::xml_new_document()
    doc <- xml2::xml_new_root("assessmentItem")
    xml2::xml_attrs(doc) <- ns
    points <- list_desc$metainfo$points
    if (is.null(points)) points <- 1
    create_outcome_declaration(doc, "SCORE", value = 0)
    create_outcome_declaration(doc, "MAXSCORE", value = points)
    create_outcome_declaration(doc, "MINSCORE", value = 0)
    create_item_body(doc, list_desc)
    # all results are stored on "results" folder
    path <- paste("results/", file_name, sep = "")
    xml2::write_xml(doc, path)
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
                               "baseType" = base_type)
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
    xml2::xml_attrs(item) <- c("mapKey" = map_key,
                               "mappedValue" = mapped_value,
                               "caseSensitive" = case_sensitive)
    return(item)
}

create_outcome_declaration <- function(doc, id,
                                       cardinality = "single",
                                       base_type = "float",
                                       value = "0") {
    root <- xml2::xml_add_child(doc, "outcomeDeclaration")
    xml2::xml_attrs(root) <- c("identifier" = id,
                               "cardinality" = cardinality,
                               "baseType" = base_type)
    create_defaul_value(root, value)
    return(doc)
}

create_defaul_value <- function(node, val) {
    root <- xml2::xml_add_child(node, "defaultValue")
    item <- xml2::xml_add_child(root, "value")
    xml2::xml_text(item) <- as.character(val)

}

create_responce_processing <- function(doc, template = NULL) {
    root <- xml2::xml_add_child(doc, "responseProcessing")
    if (!is.null(template)) xml2::xml_attrs(root) <- c("template" = template)
    return(doc)
}

create_item_body <- function(doc, list_desc) {
    root <- xml2::xml_add_child(doc, "itemBody")
    tq <-  list_desc$metainfo$type
    if (tq == "schoice") {
        print("this is a single choice type of the task")
        create_choice_interaction(root, list_desc, doc, cardinality = "single")
    } else if (tq == "mchoice") {
        print("this is a multiple choice type of the task")
        create_choice_interaction(root, list_desc, doc,
                                  max_choices = 0,
                                  cardinality = "multiple")
    } else if (tq == "order") {
        print("this is an order type of the task")
        create_order_interaction(root, list_desc, doc)
    } else if (tq == "association") {
        print("this is an asssociation type of the task")
        create_associate_interaction_old(root, list_desc, doc)
    } else if (tq %in% c("droplist", "string")) {
        print("this is an dropdown list type of the task")
        create_inline_choice_interation(root, list_desc, doc)
    } else if ((tq == "matchtable")) {
        print("this is a match table list type of the task")
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
    # to markup the lines of question
    markup_question(node, list_desc$question)
    # to create choiceInteraction element
    root <- xml2::xml_add_child(node, "choiceInteraction")
    xml2::xml_attrs(root) <- c("responseIdentifier" = "RESPONSE",
                               "shuffle" = shuffle,
                               "maxChoices" = max_choices,
                               "minChoices" = min_choices)
    count <- list_desc$metainfo$length
    ids <- make_test_ids(count, type = "item")
    indexes_trues <-  which(list_desc$metainfo$solution)
    points <- list_desc$metainfo$points
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
    # to markup the lines of question
    markup_question(node, list_desc$question)
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

create_associate_interaction_old <- function(node, list_desc, doc) {
    rd_node <- create_response_declaration(doc, "RESPONSE",
                                cardinality = "multiple",
                                base_type = "directedPair")
    root <- xml2::xml_add_child(node, "matchInteraction")
    xml2::xml_attrs(root) <- c("responseIdentifier" = "RESPONSE",
                               "shuffle" = "true",
                               "maxAssociations" = "0")
    mapping_node <- create_mapping(rd_node)
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
        match_code <- paste(ids[index], ids[index + 1])
        xml2::xml_text(new_value_node) <- match_code
        # TODO put here creating map entry code with points for answers
        value <- list_desc$metainfo$points / length(list_desc$questionlist)
        create_map_entry(node = mapping_node,
                         map_key = match_code,
                         mapped_value = value)
        index <- index + 2
    }
    url <- "http://www.imsglobal.org/question/qti_v2p1/rptemplates/map_response"
    create_responce_processing(doc, template = url)
    # TODO: here must be placed calling for mapping in order to evaluate answers
    return(doc)
}

create_inline_choice_interation <- function(node, list_desc, doc) {
    question <- rid_missing_rows(list_desc$question)
    gaps <- stringr::str_which(question, "\\<<(.*?)\\>>")
    count_all_gaps <- length(unlist(stringr::str_extract_all(list_desc$question, "\\<<.*?\\>>")))
    points <- list_desc$metainfo$points / count_all_gaps
    ids_response <- make_test_ids(count_all_gaps, "section")
    id_index <- 1
    for (i in seq_len(length(question))) {
        p_item <- xml2::xml_add_child(node, "p")
        if (i %in% gaps){
            instances <- stringr::str_extract_all(question[i], "\\<<.*?\\>>")[[1]]
            low_border <- 1
            ques_text <- question[i]
            # TODO rid of index to change it for which
            index <- 1
            for (j in instances) {
                top_border <- unlist(regexpr("<<", ques_text))[1] - 1
                item <- xml2::xml_add_child(p_item, "span")
                xml2::xml_text(item) <- substring(ques_text, low_border, top_border)
                # TODO base type is needed to switch to string in case of text ecntry
                rd_node <- create_response_declaration(doc, ids_response[id_index], base_type = "identifier")
                create_mapping(rd_node)
                answer <- list_desc$metainfo$solution[index]
                index <- index + 1L
                if (list_desc$metainfo$type == "string") {
                    build_textentry_element(p_item, j, ids_response[id_index],
                                            answer, points, doc)
                } else if (list_desc$metainfo$type == "droplist") {
                    build_dropdown_element(p_item, j, ids_response[id_index], doc)
                }
                id_index <- id_index + 1
                ques_text <- substring(ques_text, top_border + nchar(j) + 1)
            }
            last_text_pos <- tail(unlist(gregexpr(">>", question[i])), n=1) + 2
            ques_tail <- substring(question[i], last_text_pos)
            if (nchar(ques_tail) > 0) {
                item <- xml2::xml_add_child(p_item, "span")
                xml2::xml_text(item) <- ques_tail
            }
        } else {
            xml2::xml_text(p_item) <- question[i]
        }
    }
}

build_dropdown_element <- function(node, params, id_resp, doc) {
    # to create a root element for dropdown list
    item <- xml2::xml_add_child(node, "inlineChoiceInteraction")
    xml2::xml_attrs(item) <- c("responseIdentifier" = id_resp,
                               "shuffle" = "false")
    # to parse params of dropdown list from string as JSON data format
    params <- yaml::yaml.load(stringr::str_sub(params, 3, -3))
    # co create a range of ids for items
    ids <- make_test_ids(length(params$content$options), "item")
    # to find the right correct response to put there an identifier
    path <- paste(".//responseDeclaration[@identifier='", id_resp, "']/correctResponse", sep = "")
    corr_resp_item <- xml2::xml_find_first(doc, path)
    v_node <- xml2::xml_add_child(corr_resp_item, "value")
    xml2::xml_text(v_node) <- as.character(ids[which(params$content$score > 0)])
    # path to create map entry
    path <- paste(".//responseDeclaration[@identifier='", id_resp, "']/mapping", sep = "")
    mapping_item <- xml2::xml_find_first(doc, path)
    # to create inline choice
    for (i in seq_len(length(params$content$options))) {
        create_inline_choice(item, ids[i], params$content$options[i])
        create_map_entry(mapping_item,
                         map_key = ids[i],
                         mapped_value = params$content$score[i])
    }
}

build_textentry_element <- function(node, params, id_resp, answer, points, doc) {
    # to create a root element for text entry
    node <- xml2::xml_add_child(node, "textEntryInteraction")
    xml2::xml_attrs(node) <- c("responseIdentifier" = id_resp)
    params <- try(yaml::yaml.load(stringr::str_sub(params, 3, -3)), silent = TRUE)
    cr_path <- paste(".//responseDeclaration[@identifier='", id_resp, "']/correctResponse", sep = "")
    cr_node <- xml2::xml_find_first(doc, cr_path)
    v_node <- xml2::xml_add_child(cr_node, "value")
    map_path <- paste(".//responseDeclaration[@identifier='", id_resp, "']/mapping", sep = "")
    mapping_node<- xml2::xml_find_first(doc, map_path)
    if (is.null(params)) {
        create_map_entry(mapping_node, map_key = answer, mapped_value = points)
        xml2::xml_text(v_node) <- answer
    } else {
        xml2::xml_text(v_node) <- params$content$response
        if (!is.null(params$content$score)) points <- params$content$score
        for (item in params$content$alternatives) {
            create_map_entry(mapping_node, map_key = item,
                             mapped_value = points,
                             case_sensitive = "true")
            field_len <- params$content$expectedlength
            if (!is.null(field_len)) {
                xml2::xml_set_attr(node, "expectedLength", field_len)
            }
            field_text <- params$content$placeholdertext
            if (!is.null(field_text)) {
                xml2::xml_set_attr(node, "placeholderText", field_text)
            }
        }
    }
}

create_inline_choice <- function(node, id, content) {
    root <- xml2::xml_add_child(node, "inlineChoice")
    xml2::xml_attrs(root) <- c("identifier" = id)
    xml2::xml_text(root) <- content
    return(root)
}

create_associate_interaction <- function(node, list_desc, doc) {
    # to parse the table in question list
    table <- read.markdown(list_desc$questionlist)
    rd_node <- create_response_declaration(doc, "RESPONSE",
                                           cardinality = "multiple",
                                           base_type = "directedPair")
    cr_node <- xml2::xml_find_first(rd_node, "//correctResponse" )
    markup_question(node, list_desc$question)
    root <- xml2::xml_add_child(node, "matchInteraction")
    xml2::xml_attrs(root) <- c("responseIdentifier" = "RESPONSE",
                                "shuffle" = "true",
                                "maxAssociations" = "0")
    mapping_node <- create_mapping(rd_node)
    ids <- make_test_ids(ncol(table) + nrow(table), type = "item")
    items <- table[[1]]
    # to make rows
    create_simple_match(root, items, ids[1:nrow(table)])
    # to make columns
    items <- names(table)[-1]
    create_simple_match(root, items, tail(tail(ids, -nrow(table))))
    # to do matching pairs
    create_matching_pairs(cr_node, mapping_node, table, ids)
    url <- "http://www.imsglobal.org/question/qti_v2p1/rptemplates/map_response"
    create_responce_processing(doc, template = url)
}

create_simple_match <- function(node, items, ids) {
    ms_node <- xml2::xml_add_child(node, "simpleMatchSet")
    for (item in items) {
        item_choice <- xml2::xml_add_child(ms_node, "simpleAssociableChoice")
        xml2::xml_attrs(item_choice) <- c("identifier" = ids[which(items == item)],
                                          "fixed" = "false",
                                          "matchMax" = "0")
        content_node <- xml2::xml_add_child(item_choice, "p")
        xml2::xml_text(content_node) <- item
    }
}

create_matching_pairs <- function(cr_node, map_node, x, ids) {
    negative_points <- - sum(x[, -1]) / length(x[x == 0])
    for (i in 1:nrow(x)) {
        for (j in 2:ncol(x)) {
            points <- x[i, j]
            match <- paste(ids[i], ids[j + nrow(x) - 1])
            if (points > 0) {
                create_map_entry(map_node, map_key = match, mapped_value = points)
                v_node <- xml2::xml_add_child(cr_node, "value")
                xml2::xml_text(v_node) <- match
            } else {
                create_map_entry(map_node, map_key = match, mapped_value = negative_points)
            }
        }
    }
}

read.markdown <- function(file, stringsAsFactors = FALSE, strip.white = TRUE, ...){
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
               stringsAsFactors = stringsAsFactors, strip.white = strip.white, ...)
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

# function to rid of missing rows in question
rid_missing_rows <- function(rows) {
    s <- unlist(lapply(rows, function(x) x != ""))
    return(rows[s])
}

markup_question <- function(node, question) {
    for (str in question) {
        if (str == "") {
            xml2::xml_add_child(node, "br")
        } else {
            p_node <- xml2::xml_add_child(node, "p")
            xml2::xml_text(p_node) <- str
        }
    }
}
