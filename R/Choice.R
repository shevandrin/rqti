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
setClass("Choice", contains = "AssessmentItem",
         slots = c(choices = "character",
                   choice_identifiers = "character",
                   shuffle = "logical",
                   orientation = "character"),
         prototype = prototype(shuffle = TRUE,
                               choice_identifiers = NA_character_,
                               orientation = "vertical"))

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
