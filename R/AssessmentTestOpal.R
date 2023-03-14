#' Class "AssessmentTestOpal"
#'
#' Abstract class `AssessmentTestOpal` is responsible for creating xml exam file
#' according to QTI 2.1. for Opal
#' @template ATSlotsTemplate
#' @template ATOSlotsTemplate
#' @name AssessmentTestOpal-class
#' @rdname AssessmentTestOpal-class
#' @aliases AssessmentTestOpal
#' @exportClass AssessmentTestOpal
#' @include AssessmentTest.R
setClass("AssessmentTestOpal", contains = "AssessmentTest",
         slots = list(show_test_time = "logical",
                      calculator = "character",
                      mark_items = "logical",
                      keep_responses = 'logical',
                      files = "character"),
         prototype = prototype(show_test_time = FALSE,
                               calculator = NA_character_,
                               mark_items = FALSE,
                               keep_responses = FALSE))

# constructor
setMethod("initialize", "AssessmentTestOpal", function(.Object, ...) {
    .Object <- callNextMethod()
    validObject(.Object)
    .Object
})
