# define class TextEntry for building a text gap question
setClass("TextEntry", contains = "AssessmentItem")

setMethod("createItemBody", signature(object = "TextEntry"),
          function(object) {
              create_item_body_text_entry(object)
          })

setMethod("createResponseDeclaration", signature(object = "TextEntry"),
          function(object) {
              create_response_declaration_text_entry(object)
        })

setMethod("createOutcomeDeclaration", signature(object = "TextEntry"),
          function(object) {

          })

create_item_body_text_entry <- function(object) {
    create_item_body_entry(object)
}

create_response_declaration_text_entry <- function(object) {
    answers <- Map(getResponse, object@text@content)
    answers[sapply(answers, is.null)] <- NULL
    Map(build_response_declaration_for_gap, answers)
}

build_response_declaration_for_gap <- function(object) {
    response <- create_correct_response(object@response)
    mapping <- create_mapping_gap(object)
    children <- tagList(response, mapping)
    tag("responseDeclaration", list(identifier = object@response_identifier,
                                    cardinality = "single",
                                    baseType = "string", children))
}

