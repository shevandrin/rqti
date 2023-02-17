#define general class choice (at some point should contain a more abstract class
#"exercise") ' @include AssessmentItem.R '
setClass("Choice", contains = "AssessmentItem",
         slots = c(choices = "character", shuffle = "logical",
                   choice_identifiers = "character",
                   orientation = "character"),
         prototype = prototype(shuffle = TRUE,
                               orientation = NA_character_,
                               choice_identifiers = NA_character_))

# constructor
setMethod("initialize", "Choice", function(.Object, ...) {
    .Object <- callNextMethod()
    ids <- .Object@choice_identifiers
    # if (identical(ids, character(0))) {
    if (length(ids) < 2) {
        .Object@choice_identifiers <- paste0("Choice",
                                             LETTERS[seq(.Object@choices)])
    }
    if (is.na(.Object@orientation)) {
        .Object@orientation = "vertical"}
    validObject(.Object)
    .Object
})

#' @rdname createResponseProcessing-methods
#' @aliases createResponseProcessing,Choice
setMethod("createResponseProcessing",  "Choice", function(object) {

})
