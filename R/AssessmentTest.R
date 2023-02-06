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
                                     qti_version = "character",
                                     time_limits = "numeric",
                                     show_test_time = "logical",
                                     calculator = "character",
                                     mark_items = "logical",
                                     keep_responses = 'logical',
                                     files = "character",
                                     max_attempts = "numeric",
                                     allow_comment = "logical",
                                     rebuild_variables = "logical"),
         prototype = prototype(identifier = paste0("test_", ids::adjective_animal()),
                               navigation_mode = "nonlinear",
                               submission_mode = "individual",
                               test_part_identifier = "test_part",
                               qti_version = "v2p1",
                               time_limits = NA_integer_,
                               show_test_time = FALSE,
                               calculator = NA_character_,
                               mark_items = FALSE,
                               keep_responses = FALSE,
                               # files = NA_character_,
                               max_attempts = NA_integer_,
                               allow_comment = NA,
                               rebuild_variables = NA
         ))
# TODO verification procedure for calculator values: they must be from factor:scientific-calculator/simple-calculator
# TODO verification of files slot
# TODO verification procedure for navigation mode values: they must be from factor: linear/nonlinear
# TODO verification procedure for submission mode values: they must be from factor: individual/simultaneous
# TODO there is a conflict between keep_responses and rebuild_variables, if the second one is true - the first one will be ignored

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
              tagList(make_outcome_declaration("SCORE", value = 0),
                      make_outcome_declaration("MAXSCORE",
                                               value = object@points))
          })

#' @rdname createTestPart-methods
#' @aliases createTestPart,AssessmentTest
setMethod("createTestPart", signature(object = "AssessmentTest"),
          function(object) {

          })
