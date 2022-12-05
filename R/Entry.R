# define class Entry for building a text gap question
setClass("Entry", contains = "AssessmentItem")

setMethod("createItemBody", signature(object = "Entry"),
          function(object) {
              create_item_body_text_entry(object)
          })

setMethod("createResponseDeclaration", signature(object = "Entry"),
          function(object) {
              create_response_declaration_entry(object)
          })

setMethod("createOutcomeDeclaration", signature(object = "Entry"),
          function(object) {
              create_outcome_declaration_entry(object)
          })

setMethod("createResponseProcessing", signature(object = "Entry"),
          function(object) {
              create_response_processing_entry(object)
          })

create_item_body_text_entry <- function(object) {
    create_item_body_entry(object)
}

create_response_declaration_entry <- function(object) {
    answers <- Map(getResponse, object@text@content)
    answers[sapply(answers, is.null)] <- NULL
    Map(createResponseDeclaration, answers)
}

create_response_processing_entry <- function(object) {
    answers <- Map(getResponse, object@text@content)
    answers[sapply(answers, is.null)] <- NULL
    processing <- Map(createResponseProcessing, answers)
    tag("responseProcessing", processing)
}

create_outcome_declaration_entry <- function(object) {
    answers <- Map(getResponse, object@text@content)
    answers[sapply(answers, is.null)] <- NULL
    Map(createOutcomeDeclaration, answers)
}
