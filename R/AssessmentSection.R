#' Class AssessmentSection
#'
#' Class `AssessmentSection` is responsible for forming a section in test xml
#' specification according to QTI 2.1
#'
#' @importFrom ids adjective_animal
#' @slot identifier section id
#' @slot title title of the section
#' @slot visible show or not to show for student
#' @examples
#' essay <- new("Essay", prompt = "Test task", title = "Essay",
#'              identifier = "q1")
#' sc <- new("SingleChoice", prompt = "Test task", title = "SingleChoice",
#'           choices = c("A", "B", "C"), identifier = "q2")
#' exam_section <- new("AssessmentSection", identifier = "sec_id",
#'                    title = "section", assessment_item = list(essay, sc))
#' @name AssessmentSection-class
#' @rdname AssessmentSection-class
#' @aliases AssessmentSection
setClass("AssessmentSection", slots = c(identifier = "character",
                                     title = "character",
                                     time_limits = "numeric",
                                     visible = "logical",
                                     assessment_item = "list",
                                     shuffle = "logical",
                                     selection = "numeric",
                                     max_attempts = "numeric",
                                     allow_comment = "logical"),
         prototype = prototype(identifier = ids::adjective_animal(),
                               visible = TRUE,
                               time_limits = NA_integer_,
                               shuffle = FALSE,
                               selection = NA_integer_,
                               max_attempts = NA_integer_,
                               allow_comment = NA
         ))

#' Get list of AssessmentItems for AssessmentSection
#'
#' Generic function for
#'
#' @param object an instance of the S4 object (AssessmentSection)
#' @docType methods
#' @rdname getAssessmentItems-methods
#'
#' @export
setGeneric("getAssessmentItems", function(object) {
    standardGeneric("getAssessmentItems")
})

#' Build tags for AssessmentSection in assessmentTest
#'
#' Generic function for tags that contains assessementSection in assessnetTest
#'
#' @param object an instance of the S4 object ([AssessmentSection],
#' [AssessmentItemRef] and all types of [AssessmentItem])
#' @param folder a character string; name of folder to store the xml files
#' @docType methods
#' @rdname buildAssessmentSection-methods
#'
#' @export
setGeneric("buildAssessmentSection", function(object, folder = NULL) {
    standardGeneric("buildAssessmentSection")
})

#' @rdname getAssessmentItems-methods
#' @aliases getAssessmentItems,AssessmentSection
setMethod("getAssessmentItems", signature(object = "AssessmentSection"),
          function(object) {
              Map(getAssessmentItems, object@assessment_item)
          })

#' @rdname buildAssessmentSection-methods
#' @aliases buildAssessmentSection,AssessmentSection
setMethod("buildAssessmentSection", signature(object = "AssessmentSection"),
          function(object) {
              create_section_test(object)
          })
