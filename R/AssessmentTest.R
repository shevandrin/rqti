#' Class AssessmentTest
#'
#' Abstract class `AssessmentTestOpal` is responsible for creating xml exam file
#' according to QTI 2.1. for Opal
#' \if{html}{\out{<div style="text-align:center">}\figure{assessmentTest.png}
#' \out{</div>}}
#' @details
#' Test consists of one or more sections. Each section can have one or more
#'  questions/tasks and/or one or more sub sections.
#' @template ATSlotsTemplate
#' @seealso [AssessmentSection]
#' @note use [create_qti_test()] to create an xml file for test specification
#' @examples
#' \dontrun{
#' This example creates test 'exam' with one section 'exam_section' which
#' consists of two questions/tasks: essay and single choice types
#' }
#' task1 <- new("Essay", prompt = "Test task", title = "Essay",
#'              identifier = "q1")
#' task2 <- new("SingleChoice", prompt = "Test task", title = "SingleChoice",
#'              choices = c("A", "B", "C"), identifier = "q2")
#' exam_section <- new("AssessmentSection", identifier = "sec_id",
#'                     title = "section", assessment_item = list(task1, task2))
#' exam <- new("AssessmentTestOpal", identifier = "id_test",
#'             title = "some title", section = list(exam_section))
#' @importFrom ids adjective_animal
#' @name AssessmentTest-class
#' @rdname AssessmentTest-class
#' @aliases AssessmentTest
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
                                     max_attempts = "numeric",
                                     allow_comment = "logical",
                                     rebuild_variables = "logical"),
         prototype = prototype(identifier = paste0("test_", ids::adjective_animal()),
                               navigation_mode = "nonlinear",
                               submission_mode = "individual",
                               test_part_identifier = "test_part",
                               qti_version = "v2p1",
                               time_limits = NA_integer_,
                               # files = NA_character_,
                               max_attempts = NA_integer_,
                               allow_comment = NA,
                               rebuild_variables = NA
         ))
#' @export
AssessmentTest <- function(identifier = character(),
                           title = character(), points = numeric(),
                           test_part_identifier = character(),
                           navigation_mode = character(),
                           submission_mode = character(),
                           section = list(),
                           time_limits = numeric(), max_attempts = numeric(),
                           allow_comment = logical(),
                           rebuild_variables = logical()
){
    new("AssessmentTest", identifier = identifier, title = title, points = points,
        test_part_identifier = test_part_identifier,
        navigation_mode = navigation_mode, submission_mode = submission_mode,
        section = section, time_limits = time_limits,
        max_attempts = max_attempts, allow_comment = lallow_comment,
        rebuild_variables = rebuild_variables)
}
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
