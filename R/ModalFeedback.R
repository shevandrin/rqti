#' Class "ModalFeedback"
#'
#' Class `ModalFeedback` is responsible for delivering feedback
#' messages to the candidate, regardless of whether the answer was correct or
#' incorrect.
#' @template ModalFeedbackSlotsTemplate
#' @slot identifier A character value representing the identifier of the modal
#'   feedback item. Default is "modal_feedback".
#' @examples
#' fb <- new("ModalFeedback",
#'           title = "Possible solution",
#'           content = list("<b>Some explanation</b>"))
#' @name ModalFeedback-class
#' @rdname ModalFeedback-class
#' @aliases ModalFeedback
#' @export
setClass("ModalFeedback", slots = list(outcome_identifier = "character",
                                       show = "logical",
                                       identifier = "character",
                                       title = "character",
                                       content = "list"),
         prototype = list(show = TRUE,
                          outcome_identifier = "FEEDBACKMODAL",
                          identifier = "modal_feedback"))

setMethod("initialize", "ModalFeedback", function(.Object, ...) {
    .Object <- callNextMethod()
    if (length(.Object@show) == 0) .Object@show <- TRUE
    if (length(.Object@outcome_identifier) == 0)
        .Object@outcome_identifier <- "FEEDBACKMODAL"
    validObject(.Object)
    .Object
})

#' Create object [ModalFeedback]
#'
#' @param content A list of character content to form the text of the modal
#'   feedback, which can include HTML tags.
#' @param title A character value, optional, representing the title of the modal
#'   feedback window.
#' @param show A boolean value, optional, determining whether to show (`TRUE`) or
#'   hide (`FALSE`) the modal feedback. Default is `TRUE`.
#' @return An object of class [ModalFeedback]
#' @examples
#' fb <- modalFeedback(content = list("Model answer"), title = "Feedback")
#' @export
modalFeedback <- function(content = list(),
                       title = character(0),
                       show = TRUE) {
    params <- as.list(environment())
    params$Class <- "ModalFeedback"
    obj <- do.call("new", params)
    return(obj)
}

setGeneric("createModalFeedback",
           function(object) standardGeneric("createModalFeedback"))

setGeneric("createResponseCondition",
           function(object) standardGeneric("createResponseCondition"))

setMethod("createModalFeedback", signature(object = "ModalFeedback"),
          function(object) {
              content <- list(Map(createText, object@content))
              show_hide <- ifelse(object@show, "show", "hide")
              tag("modalFeedback",
                  list(identifier = object@identifier,
                       outcomeIdentifier = object@outcome_identifier,
                       showHide = show_hide,
                       title = object@title,
                       content))
          })

setMethod("createResponseCondition", signature(object = "ModalFeedback"),
          function(object) {
              tag_var <- tag("variable", list(identifier = "SCORE"))
              tag_bv <- tag("baseValue", list(baseType = "float", 0))
              tag_gte <- tag("gte", list(tag_var, tag_bv))
              tag_and <- tag("and", list(tag_gte))
              tag_var <- tag("variable", list(identifier = "FEEDBACKMODAL"))
              tag_bv <- tag("baseValue", list(baseType = "identifier",
                                              object@identifier))
              tag_mult <- tag("multiple", list(tag_var, tag_bv))
              set_ov <- tag("setOutcomeValue",
                            list(identifier = "FEEDBACKMODAL",
                                 tag_mult))
              resp_if <- tag("responseIf", list(tag_and, set_ov))
              resp_cond <- tag("responseCondition", list(resp_if))
              return(resp_cond)
          })
