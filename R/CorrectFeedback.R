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
