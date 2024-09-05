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

#' Create object [WrongFeedback]
#'
#' @param content A character string or a list of character strings to form the
#'   text of the question, which may include HTML tags.
#' @param title A character value, optional, representing the title of the
#'   feedback window.
#' @param show A boolean value, optional, determining whether to show (`TRUE`)
#'   or hide (`FALSE`) the feedback. Default is `TRUE`.
#' @return An object of class [WrongFeedback]
#' @examples
#' wfb <- wrongFeedback(content = "Some comments", title = "Feedback")
#' @export
wrongFeedback <- function(content = list(),
                          title = character(0),
                          show = TRUE) {
    params <- as.list(environment())
    if (is.character(params$content)) params$content <- list(params$content)
    params$Class <- "WrongFeedback"
    obj <- do.call("new", params)
    return(obj)
}

setMethod("createResponseCondition", signature(object = "WrongFeedback"),
          function(object) {
              create_resp_cond_set_feedback(object)
          })
