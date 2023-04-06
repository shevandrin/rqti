#' Class ModalFeedback
#'
#' Abstract class `ModalFeedback` is never to be generated, only derived classes
#' [CorrectFeedback-class] and [WrongFeedback-class] are
#' meaningful
#' @template ModalFeedbackSlotsTemplate
#' @name ModalFeedback-class
#' @rdname ModalFeedback-class
#' @aliases ModalFeedback
#' @export
setClass("ModalFeedback", slots = list(outcome_identifier = "character",
                                       show = "logical",
                                       identifier = "character",
                                       title = "character",
                                       content = "list"),
                          prototype = list(show = TRUE))

setMethod("initialize", "ModalFeedback", function(.Object, ...) {
    .Object <- callNextMethod()
    if (length(.Object@show) == 0) .Object@show <- TRUE
    validObject(.Object)
    .Object
})

setGeneric("createModalFeedback", function(object) {
    standardGeneric("createModalFeedback")
})

setMethod("createModalFeedback", signature(object = "ModalFeedback"),
          function(object) {
            content <- list(Map(createText, object@content))
            showHide <- ifelse(object@show, "show", "hide")
            tag("modalFeedback", list(identifier = object@identifier,
                                      outcomeIdentifier = object@outcome_identifier,
                                      showHide = showHide,
                                      title = object@title,
                                      content))
          })
