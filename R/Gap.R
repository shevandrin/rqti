# define class Gap to built inline instances

setClass("Gap", slots = c(response_identifier = "character", score = "numeric",
                          placeholder = "character",
                          expected_length = "numeric"),
         prototype = prototype(score = NA_integer_))

#' Get and process a piece of question content
#'
#' Generic function to get and process a different types of question content
#' (text with instances of gaps or dropdown lists) for XML document of
#' specification the question following the QTI schema v2.1
#'
#' @param object an instance of the S4 object (NumericGap, TextGap,
#'   InlineChoice, character)
#' @docType methods
#' @rdname getResponse-methods
#'
#' @export
setGeneric("getResponse", function(object) {
    standardGeneric("getResponse")
})

#' @rdname getResponse-methods
#' @aliases getResponse,character
setMethod("getResponse", "character", function(object) {
})

#' @rdname createText-methods
#' @aliases createText,Gap
setMethod("createText", "Gap", function(object) {
    tag("textEntryInteraction",
        list(responseIdentifier = object@response_identifier,
             expectedLength = object@expected_length,
             placeholderText = object@placeholder))
})

#' @rdname createResponseProcessing-methods
#' @aliases createResponseProcessing,Gap
setMethod("createResponseProcessing", "Gap", function(object) {
})
