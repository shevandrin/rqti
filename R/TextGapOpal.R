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
#'           solution = c("answer","answerr", "aanswer"),
#'           placeholder = "do not put special characters",
#'           tolerance = 1)
#' @name TextGapOpal-class
#' @rdname TextGapOpal-class
#' @aliases TextGapOpal
#' @include Gap.R TextGap.R
#' @importFrom htmltools tag p span tagList tagAppendChildren
setClass("TextGapOpal", contains = "TextGap",
         slots = c(tolerance = "numeric"),
         prototype = prototype(tolerance = 0,
                               case_sensitive = FALSE))

#' @rdname createResponseProcessing-methods
#' @aliases createResponseProcessing,TextGapOpal
setMethod("createResponseProcessing", "TextGapOpal", function(object) {
    create_response_processing_text_entry_opal(object)
})
