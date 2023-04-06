#' Class CorrectFeedback
#'
#' Abstract class `CorrectFeedback` is responsible to deliver feedback messages
#' to candidate in case of correct answer on the whole exercise
#' @template ModalFeedbackSlotsTemplate
#' @name CorrectFeedback-class
#' @rdname CorrectFeedback-class
#' @aliases CorrectFeedback
#' @include ModalFeedback.R
#' @export
setClass("CorrectFeedback", contains = "ModalFeedback",
         prototype = list(identifier = "correct"))
#' @export
CorrectFeedback <- function(outcome_identifier = character(), show = logical(),
                            identifier = character(), title = character(),
                            content = list()
        ) {
    new("CorrectFeedback", outcome_identifier = outcome_identifier, show = show,
        identifier = identifier, title = title, content = content)
}

setMethod("initialize", "CorrectFeedback", function(.Object, ...) {
    .Object <- callNextMethod()
    .Object@identifier <- "correct"
    validObject(.Object)
    .Object
})
