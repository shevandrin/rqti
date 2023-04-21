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
                               case_sensitive = FALSE))

#' @rdname createResponseProcessing-methods
#' @aliases createResponseProcessing,TextGapOpal
setMethod("createResponseProcessing", "TextGapOpal", function(object) {
    create_response_processing_text_entry_opal(object)
})
