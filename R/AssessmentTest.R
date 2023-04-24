#' Class AssessmentTest
#'
#' Abstract class `AssessmentTest` is responsible for creating xml exam file
#' according to QTI 2.1.
#' \if{html}{\out{<div style="text-align:center">}\figure{assessmentTest.png}
#' \out{</div>}}
#' @details
#' Test consists of one or more sections. Each section can have one or more
#'  questions/tasks and/or one or more sub sections.
#' @template ATSlotsTemplate
#' @seealso [AssessmentSection]
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
                               max_attempts = NA_integer_,
                               allow_comment = TRUE,
                               rebuild_variables = NA
         ))
# TODO verification procedure for calculator values: they must be from factor:scientific-calculator/simple-calculator
# TODO verification of files slot
# TODO verification procedure for navigation mode values: they must be from factor: linear/nonlinear
# TODO verification procedure for submission mode values: they must be from factor: individual/simultaneous
# TODO there is a conflict between keep_responses and rebuild_variables, if the second one is true - the first one will be ignored

#' Create XML file for exam test specification
#'
#' @usage createQtiTest(object, dir = NULL, verification = FALSE)
#' @param object an instance of the [AssessmentTest] or [AssessmentTestOpal] S4
#'   object
#' @param dir string, optional; a folder to store xml file; working directory by
#'   default
#' @param verification boolean, optional; to check validity of xml file, default
#'   `FALSE`
#' @return xml document.
#' @examples
#' \dontrun{
#' essay <- new("Essay", prompt = "Test task", title = "Essay",
#'              identifier = "q1")
#' sc <- new("SingleChoice", prompt = "Test task", title = "SingleChoice",
#'           choices = c("A", "B", "C"), identifier = "q2")
#' exam_section <- new("AssessmentSection", identifier = "sec_id",
#'                    title = "section", assessment_item = list(essay, sc))
#' exam <- new("AssessmentTestOpal", identifier = "id_test",
#'            title = "some title", section = list(exam_section))
#' createQtiTest(exam, "exam_folder", "TRUE")
#' }
#' @name createQtiTest-methods
#' @rdname createQtiTest-methods
#' @aliases createQtiTest
#' @docType methods
#' @export
setGeneric("createQtiTest", function(object, dir = NULL, verification = FALSE) {
    standardGeneric("createQtiTest")
})

#' Create an element assessmentTest of a qti-xml document for test
#'
#' Generic function for creating assessmentTest element for XML document of
#' specification the test following the QTI schema v2.1
#'
#' @param object an instance of the S4 object [AssessmentTest] or
#'   [AssessmentTestOpal]
#' @param folder string, optional; a folder to store xml file; working directory
#'   by default
#' @docType methods
#' @rdname createAssessmentTest-methods
#' @aliases createAssessmentTest
#'
#' @export
setGeneric("createAssessmentTest", function(object, folder) {
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

#' @rdname createAssessmentTest-methods
#' @aliases createAssessmentTest,AssessmentTest
setMethod("createAssessmentTest", signature(object = "AssessmentTest"),
          function(object, folder) {
              create_assessment_test(object, folder)
          })

#' @rdname createQtiTest-methods
#' @aliases createQtiTest,AssessmentTest
setMethod("createQtiTest", signature(object = "AssessmentTest"),
          function(object, dir = getwd(), verification = FALSE) {
              create_qti_test(object, dir, verification)
          })

#' @rdname createOutcomeDeclaration-methods
#' @aliases createOutcomeDeclaration,AssessmentTest
setMethod("createOutcomeDeclaration", signature(object = "AssessmentTest"),
          function(object) {
              tagList(make_outcome_declaration("SCORE", value = 0),
                      make_outcome_declaration("MAXSCORE",
                                               value = object@points),
                      make_outcome_declaration("MINSCORE", value = 0))
          })
