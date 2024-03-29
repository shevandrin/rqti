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

#' Create object [CorrectFeedback]
#'
#' @param content A list of character content to form the text of the feedback,
#'   which can include HTML tags.
#' @param title A character value, optional, representing the title of the
#'   feedback window.
#' @param show A boolean value, optional, determining whether to show (`TRUE`)
#'   or hide (`FALSE`) the feedback. Default is `TRUE`.
#' @return An object of class [CorrectFeedback]
#' @examples
#' cfb <- correctFeedback(content = list("Some comments"), title = "Feedback")
#' @export
correctFeedback <- function(content = list(),
                            title = character(0),
                            show = TRUE) {
    params <- as.list(environment())
    params$Class <- "CorrectFeedback"
    obj <- do.call("new", params)
    return(obj)
}

setMethod("createResponseCondition", signature(object = "CorrectFeedback"),
          function(object) {
              create_resp_cond_set_feedback(object)
          })
