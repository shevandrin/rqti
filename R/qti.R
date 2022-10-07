#' @param choices
#'
#'
create_assessmentItem <- function(listOfdesc, fileName = "task.xml") {
    ns <- c("xmlns" = "http://www.imsglobal.org/xsd/imsqti_v2p1",
            "xmlns:xsi" = "http://www.w3.org/2001/XMLSchema-instance",
            "xsi:schemaLocation" = "http://www.imsglobal.org/xsd/imsqti_v2p1 http://www.imsglobal.org/xsd/qti/qtiv2p1/imsqti_v2p1.xsd",
            "identifier" = "choice",
            "title" = "Some example of QTI-based task",
            "adaptive" =  "false",
            "timeDependent" = "false")
    doc <- xml2::xml_new_document()
    doc <- xml2::xml_new_root("assessmentItem")
    xml2::xml_attrs(doc) <- ns
    create_responseDeclaration(doc, "RESPONSE")
    create_outcomeDeclaration(doc, "SCORE")
    create_itemBody(doc, listOfdesc)
    create_responceProcessing(doc)
    write_xml(doc, fileName)
    print(paste("see the file ", fileName, " in your work directory"))
}

create_responseDeclaration <- function(doc, id, cardinality="single", baseType="identifier") {
    root <- xml2::xml_add_child(doc, "responseDeclaration")
    xml2::xml_attrs(root) <- c("identifier" = id, "cardinality"=cardinality, baseType=baseType)
    #xml2::xml_attrs(root) <- c("identifier" = id, "cardinality"=cardinality, baseType="string")
    item <- xml2::xml_add_child(root, "correctResponse")
    subitem <- xml2::xml_add_child(item, "value")
    return(doc)
}

create_outcomeDeclaration <- function(doc, id, cardinality="single", baseType="float") {
    root <- xml2::xml_add_child(doc, "outcomeDeclaration")
    xml2::xml_attrs(root) <- c("identifier"=id, "cardinality"=cardinality, "baseType"=baseType)
    item <- xml2::xml_add_child(root, "defaultValue")
    subitem <- xml2::xml_add_child(item, "value")
    xml2::xml_text(subitem) <- "1"
    return(doc)
}

create_responceProcessing <- function(doc) {
    root <- xml2::xml_add_child(doc, "responseProcessing")
    return(doc)
}

create_itemBody <- function(doc, listOfdesc) {
    root <- xml2::xml_add_child(doc, "itemBody")
    item <- xml2::xml_add_child(root, "p")
    tq =  listOfdesc$metainfo$type
    if (tq == "schoice") {
        xml2::xml_text(item) <- listOfdesc$question
        print("this is a single choice type of the task")
        create_choiceInteraction(root, listOfdesc, doc)
    } else if (tq == "string") {
        print("this is a string type of the task")
        create_textEntryInteraction(item, listOfdesc$question)
        #xml2::xml_text(item) <- newQuestion
    }
    return(doc)
}

create_choiceInteraction <- function(node, choices, doc, shuffle="true", maxChoices=1, minChoices=0, orientatioin){
    root <- xml2::xml_add_child(node, "choiceInteraction")
    xml2::xml_attrs(root) <- c("responseIdentifier"="RESPONSE", "shuffle" = shuffle, maxChoices=maxChoices, minChoices=minChoices)
    ids <- make_test_ids(choices$metainfo$length, type = "item")
    indexTrueAnswer =  which(choices$metainfo$solution)
    for (i in 1:choices$metainfo$length) {
        create_simpleChoice(root, ids[i], choices$questionlist[i])
        if (i == indexTrueAnswer) {
            vNode <- xml2::xml_find_first(doc, ".//value")
            xml2::xml_text(vNode) <- ids[i]
        }
    }
    return(root)
}

create_simpleChoice <- function(doc, id, cont) {
    root <- xml2::xml_add_child(doc, "simpleChoice")
    xml2::xml_attrs(root) <- c("identifier" = id)
    xml2::xml_text(root) <- cont
    return(root)
}

create_textEntryInteraction <- function(node, question) {
    parseQuestion <- strsplit(question, " ")[[1]]
    gaps <- stringr::str_which(parseQuestion, "<<>>")
    lbord <- 1
    for (i in gaps) {
        hbord <- i-1
        beforeGap <- paste(parseQuestion[lbord:hbord], collapse = " ")
        lbord <- i + 1
        item <- xml2::xml_add_child(node, "span")
        xml2::xml_text(item) <- beforeGap
        sibitem <- xml2::xml_add_sibling(item, "textEntryInteraction")
        xml2::xml_attrs(sibitem) <- c("responseIdentifier"="RESPONSE")
    }
    afterGap <- paste(tail(parseQuestion, -lbord+1), collapse = " ")
    item <- xml2::xml_add_child(node, "span")
    xml2::xml_text(item) <- afterGap
    question <- paste(parseQuestion, collapse = " ")
    return(node)
}

make_test_ids <- function(n, type = c("test", "section", "item"))
{
    switch(type,
           "test" = paste(name, make_id(9), sep = "_"),
           paste(type, formatC(1:n, flag = "0", width = nchar(n)), sep = "_")
    )
}
