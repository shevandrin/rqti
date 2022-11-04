#' create assessment item
#'
#' @importFrom htmltools tag p tagList
#'
create_assessment_item <- function(object) {
    assessment_attributes <- create_assessment_attributes(object)
    assesment_item <- tag("assessmentItem", ns)
    assesment_item <- tagAppendChildren(
        assesment_item,
        create_outcome_declaration("SCORE"),
        # create_outcome_declaration("MAXSCORE", children = create_default_value(object@points)),
        # create_outcome_declaration("MINSCORE"),
        create_response_declaration(object))
    assesment_item <- tagAppendChildren(create_item_body(object))
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
    tag("value", value)b
}


create_item_body_choice <- function(object, max_choices) {
    tag("itemBody", list(shuffle = object@shuffle,
                         maxChoices = max_choices,
                         p(object@text),
                         make_choice_interaction(object@choices, object@prompt)))
}

make_choice_interaction <- function(choices, prompt = "") {
    simple_choices <- Map(make_simple_choice, LETTERS[1:length(choices)], choices)
    tagList(tag("prompt", list(prompt)), simple_choices)
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

create_outcome_declaration <- function(identifier,
                                       cardinality = "single",
                                       base_type = "float",
                                       children = create_default_value(0)) {
    tag("outcomeDeclaration", list(identifier = identifier,
                                   cardinality = cardinality,
                                   baseType=base_type, children))
}


create_default_value <- function(value) {
    tag("defaultValue", list(tag("value", value)))
}
