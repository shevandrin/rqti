# define class Entry for building a text gap question
setClass("Entry", contains = "AssessmentItem")


#' @rdname createItemBody-methods
#' @aliases createItemBody,Entry
setMethod("createItemBody", signature(object = "Entry"),
          function(object) {
              create_item_body_text_entry(object)
          })

#' @rdname createResponseDeclaration-methods
#' @aliases createResponseDeclaration,Entry
setMethod("createResponseDeclaration", signature(object = "Entry"),
          function(object) {
              create_response_declaration_entry(object)
          })

#' @rdname createOutcomeDeclaration-methods
#' @aliases createOutcomeDeclaration,Entry
setMethod("createOutcomeDeclaration", signature(object = "Entry"),
          function(object) {
              create_outcome_declaration_entry(object)
          })

#' @rdname createResponseProcessing-methods
#' @aliases createResponseProcessing,Entry
setMethod("createResponseProcessing", signature(object = "Entry"),
          function(object) {
              create_response_processing_entry(object)
          })

#' Compose a set of html elements to display question in qti-xml document
#'
#' Generic function for creating a set of html elements to display question for
#' XML document of specification the question following the QTI schema v2.1
#'
#' @param object an instance of the S4 object (Gap, InlineChoice, character)
#' @docType methods
#' @rdname createText-methods
#'
#' @export
setGeneric("createText", function(object) {
    standardGeneric("createText")
})

#' @rdname createText-methods
#' @aliases createText,character
setMethod("createText", "character", function(object) {
    HTML(object)
})

create_item_body_text_entry <- function(object) {
    create_item_body_entry(object)
}

create_response_declaration_entry <- function(object) {
    answers <- Map(getResponse, object@content)
    answers[sapply(answers, is.null)] <- NULL
    Map(createResponseDeclaration, answers)
}

create_response_processing_entry <- function(object) {
    answers <- Map(getResponse, object@content)
    answers[sapply(answers, is.null)] <- NULL
    processing <- Map(createResponseProcessing, answers)
    tag("responseProcessing", processing)
}

create_outcome_declaration_entry <- function(object) {
    answers <- Map(getResponse, object@content)
    answers[sapply(answers, is.null)] <- NULL
    Map(createOutcomeDeclaration, answers)
}
