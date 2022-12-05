# define class Gap to built inline instances

setClass("Gap", slots = c(response_identifier = "character", score = "numeric",
                          placeholder = "character",
                          expected_length = "numeric"),
         prototype = prototype(score = NA_integer_))

#' @export
setGeneric("getResponse", function(object) {
    standardGeneric("getResponse")
})

setMethod("getResponse", "character", function(object) {
})

setMethod("createText", "Gap", function(object) {
    tag("textEntryInteraction", list(responseIdentifier = object@response_identifier,
                                     expectedLength = object@expected_length,
                                     placeholderText = object@placeholder))
})

setMethod("createResponseProcessing", "Gap", function(object) {
})
