#' Class "WrongFeedback"
#'
#' Class `WrongFeedback` is responsible for delivering feedback messages
#' to the candidate in case of an incorrect answer on the entire exercise.
#' @template ModalFeedbackSlotsTemplate
#' @slot identifier A character value representing the identifier of the modal
#'   feedback item. Default is "incorrect".
#' @examples
#' wfb <- new("WrongFeedback",
#'           title = "Wrong answer",
#'           content = list("<b>Some demonstration</b>"))
#' @name WrongFeedback-class
#' @rdname WrongFeedback-class
#' @aliases WrongFeedback
#' @include ModalFeedback.R
#' @export
setClass("WrongFeedback", contains = "ModalFeedback",
         prototype = list(identifier = "incorrect"))

setMethod("initialize", "WrongFeedback", function(.Object, ...) {
    .Object <- callNextMethod()
    .Object@identifier <- "incorrect"
    validObject(.Object)
    .Object
})

setMethod("createResponseCondition", signature(object = "WrongFeedback"),
          function(object) {
              create_resp_cond_set_feedback(object)
          })
