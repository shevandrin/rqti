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
