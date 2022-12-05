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
        createResponseDeclaration(object),
        createOutcomeDeclaration(object),
        createItemBody(object),
        createResponseProcessing(object))
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

create_item_body_entry <- function(object) {
    tag("itemBody", list(Map(createText, object@text@content)))
}

create_item_body_choice <- function(object, max_choices) {
    tag("itemBody", list(Map(createText, object@text@content),
                         make_choice_interaction(object, max_choices)))
}

create_item_body_order <- function(object) {
    choices <- Map(make_choice, "simpleChoice", object@choices_identifiers, object@choices)
    order_interactioin <- tag("orderInteraction", list("responseIdentifier" = "RESPONSE", "shuffle" = object@shuffle, choices))
    tag("itemBody", list(Map(createText, object@text@content), order_interactioin))
}

create_item_body_match_table <- function(object,  row_associations, col_associations) {
    rows <- Map(make_associable_choice, object@rows_identifiers, object@rows, row_associations)
    rows_match <- tag("simpleMatchSet", list(rows))
    cols <- Map(make_associable_choice, object@cols_identifiers, object@cols, col_associations)
    cols_match <- tag("simpleMatchSet", list(cols))
    match_interactioin <- tag("matchInteraction",
                              list("responseIdentifier" = "RESPONSE",
                                   "shuffle" = object@shuffle,
                                   tagList(rows_match, cols_match)))
    tag("itemBody", list(Map(createText, object@text@content), match_interactioin))
}


make_associable_choice <- function(id, text, match_max = 1) {
    tag("simpleAssociableChoice", list(identifier =  id,
                                       matchMax = match_max,
                                       text))
}

make_choice_interaction <- function(object, max_choices) {
    simple_choices <- Map(make_choice, "simpleChoice", object@choice_identifiers, object@choices)
    choice_interaction <- tag("choiceInteraction",
                              list(shuffle = object@shuffle,
                                   maxChoices = max_choices,
                                   responseIdentifier = "RESPONSE",
                                   simple_choices))
    tagList(choice_interaction)
}

make_inline_choice_interaction <- function(object) {
    inline_choices <- Map(make_choice, "inlineChoice",
                          object@options_identifiers,
                          object@options)
    inline_choice_interaction <- tag("inlineChoiceInteraction",
                              list(shuffle = object@shuffle,
                                   responseIdentifier = object@response_identifier,
                                   inline_choices))
    tagList(inline_choice_interaction)
}

make_choice <- function(type_choice, identifier, text) {
    tag(type_choice, list(identifier = identifier, text))
}


create_mapping <- function(object) {
    map_entries <- purrr::imap(object@mapping, create_map_entry)
    tag("mapping", list(lowerBound = object@lower_bound, upperBound = object@upper_bound,
                        defaultValue = object@default_value, map_entries)
    )
}

create_mapping_gap <- function(object) {
    map_keys <- c(object@response, object@alternatives)
    map_enrties <- Map(create_map_entry, object@score, map_keys)
    tag("mapping", list(map_enrties))
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
                                   baseType = base_type, create_default_value(value)))
}

create_default_value <- function(value) {
    tag("defaultValue", list(tag("value", value)))
}

#' @export
create_qti_task <- function(object) {
    content <- create_assessment_item(object)
    print(content)
    doc <- xml2::read_xml(as.character(content))
    path <- paste0("results/", object@title, ".xml")
    xml2::write_xml(doc, path)
    print(paste("see:", path))
}
