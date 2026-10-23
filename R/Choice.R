#' Class "Choice"
#'
#' Abstract class `Choice` is not meant to be instantiated directly; instead, it
#' serves as a base for derived classes [SingleChoice-class] and
#' [MultipleChoice-class].
#' @template ChoiceSlotsTemplate
#' @name Choice-class
#' @rdname Choice-class
#' @aliases Choice
#' @include AssessmentItem.R
setClassUnion("characterOrScoring", c("character", "list"))

setClass("Choice", contains = "AssessmentItem",
         slots = c(choices = "character",
                   choice_identifiers = "character",
                   response_identifier = "character",
                   shuffle = "logical",
                   orientation = "character"),
         prototype = prototype(shuffle = TRUE,
                               choice_identifiers = NA_character_,
                               response_identifier = "RESPONSE",
                               orientation = "vertical"),
         validity = function(object) {
             error <- validate_response_identifier(object@response_identifier)
             if (is.null(error)) TRUE else error
         })

setMethod("initialize", "Choice", function(.Object, ...) {
    .Object <- callNextMethod()
    ids <- .Object@choice_identifiers
    if (length(ids) < 2L) {
        .Object@choice_identifiers <- paste0("Choice",
                                             LETTERS[seq(.Object@choices)])
    }
    validObject(.Object)
    .Object
})

#' @rdname getScoreBounds
setMethod("getScoreBounds", "Choice", function(object) {
    spec <- resolve_choice_scoring(object)
    c(minimum = unname(spec$minimum), maximum = unname(spec$maximum))
})
