#' Root element asssessmentSection for xml task description
#'
#' Root element assessmentSection for xml task description according to QTI 2.1
#'
#' @importFrom ids adjective_animal
#'
#' @slot identifier section id
#' @slot title title of the section
#' @slot visible show or not to show for student
#' @name AssessmentSection-class
#' @rdname AssessmentSection-class
setClass("AssessmentSection", slots = c(identifier = "character",
                                     title = "character",
                                     visible = "logical",
                                     assessment_item = "list"),
         prototype = prototype(identifier = ids::adjective_animal(),
                               visible = TRUE
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
#' @param object an instance of the S4 object (AssessmentSection, AssessmentItemRef)
#' @docType methods
#' @rdname buildAssessmentSection-methods
#'
#' @export
setGeneric("buildAssessmentSection", function(object) {
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
