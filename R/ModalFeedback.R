#' Class ModalFeedback
#'
#' Abstract class `ModalFeedback` is never to be generated, only derived classes
#' [CorrectFeedback-class] and [WrongFeedback-class] are meaningful
#' @template ModalFeedbackSlotsTemplate
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
                                           outcome_identifier = "FEEDBACK"))

setMethod("initialize", "ModalFeedback", function(.Object, ...) {
    .Object <- callNextMethod()
    if (length(.Object@show) == 0) .Object@show <- TRUE
    if (length(.Object@outcome_identifier) == 0)
        .Object@outcome_identifier = "FEEDBACK"
    validObject(.Object)
    .Object
})

setGeneric("createModalFeedback", function(object) {
    standardGeneric("createModalFeedback")
})

setGeneric("createResponseCondition", function(object) {
    standardGeneric("createResponseCondition")
})

setMethod("createModalFeedback", signature(object = "ModalFeedback"),
          function(object) {
            content <- list(Map(createText, object@content))
            showHide <- ifelse(object@show, "show", "hide")
            tag("modalFeedback",
                list(identifier = object@identifier,
                     outcomeIdentifier = object@outcome_identifier,
                     showHide = showHide,
                     title = object@title,
                     content))
          })

setMethod("createResponseCondition", signature(object = "ModalFeedback"),
          function(object) {

              variab <- tag("variable", list(identifier = "FEEDBACKMODAL"))
              base_value <- tag("baseValue", list(baseType = "identifier",
                                object@identifier))
              multiple <- tag("multiple", list(variab, base_value))

              tag_mt_var <- tag("variable", list(identifier = "FEEDBACKBASIC"))
              tag_match <- tag("match", list(base_value, tag_mt_var))
              tag_and <- tag("and", list(tag_match))
              set_out_value <- tag("setOutcomeValue",
                  list(identifier = object@outcome_identifier, multiple))
              tag_resp_if <- tag("responseIf", list(tag_and, set_out_value))
              tag_resp_cond <- tag("responseCondition", list(tag_resp_if))
              return(tag_resp_cond)
          })
