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
setClass("ModalFeedback", slots = list(outcomeIdentifier = "character",
                                       show = "logical",
                                       identifier = "character",
                                       title = "character",
                                       content = "list"))
