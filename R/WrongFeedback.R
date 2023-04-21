#' Class WrongFeedback
#'
#' Abstract class `WrongFeedback` is responsible to deliver feedback messages
#' to candidate in case of incorrect answer on the whole exercise
#' @template ModalFeedbackSlotsTemplate
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
