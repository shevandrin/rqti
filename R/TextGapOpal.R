#' Class TextGapOpal
#'
#' Abstract class `TextGapOpal` is responsible for creating instances of input
#' fields with text type of answer in question Entry type assessment task
#' according to QTI 2.1. for LMS Opal
#' @template GapSlotsTemplate
#' @template TextGapSlotsTemplate
#' @template TextGapOpalSlotsTemplate
#' @examples
#' tgo <- new("TextGapOpal",
#'           response = "answer",
#'           alternatives = c("answerr", "aanswer"),
#'           placeholder = "do not put special characters",
#'           value_precision = 1)
#' @name TextGapOpal-class
#' @rdname TextGapOpal-class
#' @aliases TextGapOpal
#' @include Gap.R TextGap.R
#' @importFrom htmltools tag p span tagList tagAppendChildren
setClass("TextGapOpal", contains = "TextGap",
         slots = c(value_precision = "numeric"),
         prototype = prototype(value_precision = 0,
                               case_sensitive = FALSE,
                               score = 1))
#' @export
TextGapOpal <- function(response_identifier = character(),
                        score = numeric(), placeholder = character(),
                        expected_length = numeric(),
                        response = character(), alternatives = character(),
                        case_sensitive = logical(),
                        value_precision = numeric()
                        ){
    new("TextGapOpal", response_identifier = response_identifier,
        score = score, placeholder = placeholder,
        expected_length = expected_length,
        response = response, alternatives = alternatives,
        case_sensitive = case_sensitive,
        value_precision = value_precision
)}
#' @rdname createResponseProcessing-methods
#' @aliases createResponseProcessing,TextGapOpal
setMethod("createResponseProcessing", "TextGapOpal", function(object) {
    create_response_processing_text_entry_opal(object)
})

create_response_processing_text_entry_opal <- function(object) {
    child <- tagList(tag("variable",
                         list(identifier = object@response_identifier)),
                     tag("correct",
                         list(identifier = object@response_identifier)))
    equal_tag <- tag("equal", list(toleranceMode = "absolute",
                                   tolerance = object@value_precision,
                                   child))
    var_outcome <- tag("variable",
                       list(identifier = paste0("MAXSCORE_",
                                                object@response_identifier)))
    outcome_tag <- tag("setOutcomeValue",
                       list(identifier = paste0("SCORE_",
                                                object@response_identifier),
                            var_outcome))
    if_tag <- tag("responseIf", list(equal_tag, outcome_tag))
    tag("responseCondition", list(if_tag))
}
