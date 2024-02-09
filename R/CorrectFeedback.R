#' Class "CorrectFeedback"
#'
#' Class `CorrectFeedback` is responsible for delivering feedback messages to
#' the candidate in case of a correct answer on the entire exercise.
#' @template ModalFeedbackSlotsTemplate
#' @slot identifier A character value representing the identifier of the modal
#'   feedback item. Default is "correct".
#' cfb <- new("CorrectFeedback",
#'           title = "Right answer",
#'           content = list("<b>Some demonstration</b>"))
#' @name CorrectFeedback-class
#' @rdname CorrectFeedback-class
#' @aliases CorrectFeedback
#' @include ModalFeedback.R
#' @export
setClass("CorrectFeedback", contains = "ModalFeedback",
         prototype = list(identifier = "correct"))

setMethod("initialize", "CorrectFeedback", function(.Object, ...) {
    .Object <- callNextMethod()
    .Object@identifier <- "correct"
    validObject(.Object)
    .Object
})

setMethod("createResponseCondition", signature(object = "CorrectFeedback"),
          function(object) {
              create_resp_cond_set_feedback(object)
          })
