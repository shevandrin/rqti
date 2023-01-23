#' Root element assessmentTest for xml task description
#'
#' Root element assessmentTest for xml task description according to QTI 2.1
#'
#' @importFrom ids adjective_animal
#'
#' @slot identifier test file id
#' @slot title Title of the file
#' @slot qti_version qti information model version
#' @name AssessmentTest-class
#' @rdname AssessmentTest-class
#' @include AssessmentSection.R
setClass("AssessmentTest", slots = c(identifier = "character",
                                     title = "character",
                                     points = "numeric",
                                     test_part_identifier = "character",
                                     navigation_mode = "character",
                                     submission_mode = "character",
                                     section = "list",
                                     qti_version = "character"),
         prototype = prototype(identifier = ids::adjective_animal(),
                               navigation_mode = "nonlinear",
                               submission_mode = "individual",
                               qti_version = "v2p1"
         ))

#' Create an element assessmentTest of a qti-xml document for test
#'
#' Generic function for creating assessmentTest element for XML document of
#' specification the test following the QTI schema v2.1
#'
#' @param object an instance of the S4 object (AssessmentTest)
#' @docType methods
#' @rdname createAssessmentTest-methods
#'
#' @export
setGeneric("createAssessmentTest", function(object) {
    standardGeneric("createAssessmentTest")
})

#' Create an element testPart of a qti-xml document for test
#'
#' Generic function for creating testPart element for XML document of
#' specification the test following the QTI schema v2.1
#'
#' @param object an instance of the S4 object (AssessmentTest)
#' @docType methods
#' @rdname createTestPart-methods
#'
#' @export
setGeneric("createTestPart", function(object) {
    standardGeneric("createTestPart")
})

#' @rdname createOutcomeDeclaration-methods
#' @aliases createOutcomeDeclaration,AssessmentTest
setMethod("createOutcomeDeclaration", signature(object = "AssessmentTest"),
          function(object) {
              tagList(make_outcome_declaration("SCORE", value = object@points),
                      make_outcome_declaration("MAXSCORE",
                                               value = object@points))
          })

#' @rdname createTestPart-methods
#' @aliases createTestPart,AssessmentTest
setMethod("createTestPart", signature(object = "AssessmentTest"),
          function(object) {

          })
