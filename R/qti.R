#' create assessment item
#'
#' @importFrom htmltools tag p tagList tagAppendChildren
#'
#'
#'
create_assessment_item <- function(object) {
    assessment_attributes <- create_assessment_attributes(object)
    assesment_item <- tag("assessmentItem", assessment_attributes)
    assesment_item <- tagAppendChildren(
        assesment_item,
        # create_outcome_declaration("MAXSCORE", children = create_default_value(object@points)),
        # create_outcome_declaration("MINSCORE"),
        createResponseDeclaration(object),
        createOutcomeDeclaration(object),
        createItemBody(object))
    #assesment_item <- tagAppendChildren(create_item_body(object))
}

create_correct_response <- function(values) {
    tags_value <- lapply(values, create_value)
    tag("correctResponse", tags_value)
}

create_assessment_attributes <- function(object) {
    c("xmlns" = "http://www.imsglobal.org/xsd/imsqti_v2p1",
      "xmlns:xsi" = "http://www.w3.org/2001/XMLSchema-instance",
      "xsi:schemaLocation" = "http://www.imsglobal.org/xsd/imsqti_v2p1 http://www.imsglobal.org/xsd/qti/qtiv2p1/imsqti_v2p1.xsd",
      "identifier" = object@identifier,
      "title" = paste(object@title),
      "adaptive" =  "false",
      "timeDependent" = "false")
}

create_score_mpc <- function(object) {
  correct_response <- create_correct_response(object@solution)
  mapping <- create_mapping(object@points)
  create_response_declaration(cardinality = "multiple", children = mapping)
}

create_value <- function(value) {
    tag("value", value)
}

create_item_body_choice <- function(object, max_choices) {
    tag("itemBody", list(p(object@text),
                         make_choice_interaction(object, max_choices)))
}

make_choice_interaction <- function(object, max_choices) {
    simple_choices <- Map(make_simple_choice, object@choice_identifiers, object@choices)
    choice_interaction <- tag("choiceInteraction",
                              list(shuffle = object@shuffle,
                                   maxChoices = max_choices,
                                   responseIdentifier = "RESPONSE",
                                   simple_choices))
    tagList(tag("prompt", list(object@prompt)), choice_interaction)
}

make_simple_choice <- function(identifier, text) {
    tag("simpleChoice", list(identifier = identifier, text))
}

create_mapping <- function(object) {
    map_entries <- purrr::imap(object@mapping, create_map_entry)
    tag("mapping", list(lowerBound = object@lower_bound, upperBound = object@upper_bound,
                        defaultValue = object@default_value, map_entries)
    )
}

create_map_entry <- function(value, key) {
    tag("mapEntry", list(mapKey = key, mappedValue = value))
}

make_outcome_declaration <- function(identifier,
                                       cardinality = "single",
                                       base_type = "float",
                                       value = 0) {
    tag("outcomeDeclaration", list(identifier = identifier,
                                   cardinality = cardinality,
                                   baseType=base_type, create_default_value(value)))
}

create_default_value <- function(value) {
    tag("defaultValue", list(tag("value", value)))
}

#' @export
create_qti_task <- function(object) {
    content <- create_assessment_item(object)
    doc <- xml2::read_xml(as.character(content))
    path <- paste0("results/", object@title, ".xml")
    xml2::write_xml(doc, path)
}
