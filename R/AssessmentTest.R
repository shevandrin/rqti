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
                                     rebuild_variables = "logical",
                                     academic_grading = "logical"),
         prototype = prototype(identifier = paste0("test_", ids::adjective_animal()),
                               navigation_mode = "nonlinear",
                               submission_mode = "individual",
                               test_part_identifier = "test_part",
                               qti_version = "v2p1",
                               time_limits = NA_integer_,
                               max_attempts = NA_integer_,
                               allow_comment = TRUE,
                               rebuild_variables = NA,
                               academic_grading = FALSE
         ))

setValidity("AssessmentTest", function(object) {
    # nav_mode <- c("linear", "nonlinear")
    # print(object@identifier)
    # if (!(object@navigation_mode %in% nav_mode)) {
    #     stop("'navigation_mode' has to be 'linear' or 'nonlinear'",
    #          call. = FALSE)
    # }

    # sbms_mode <- c("individual", "simultaneous")
    # if (!(object@submission_mode %in% sbms_mode)) {
    #     stop("'submission_mode' has to be 'individual' or 'simultaneolus'",
    #          call. = FALSE)
    # }
})

setMethod("initialize", "AssessmentTest", function(.Object, ...) {
    .Object <- callNextMethod()
    # us identifier as a title
    if (length(.Object@title) == 0) .Object@title <- .Object@identifier

    # assign points
    points <- sum(sapply(.Object@section, getPoints))
    .Object@points <- points

    # check identifiers
    ids <- sapply(.Object@section, getIdentifier)
    if (length(ids) != length(unique(ids))) {
        ids <- paste(ids, collapse = ", ")
        warning("Identifiers of test sections contain non-unique values: ", ids,
                call. = FALSE)
    }

    # check time limits
    if (!is.na(.Object@time_limits)) {
        if (.Object@time_limits > 180 | .Object@time_limits < 0.01) {
            warning("Value of time_limits does not seem plausible.",
                    call. = FALSE)
            }
    }

    validObject(.Object)
    .Object
})

#' Create XML file for exam test specification
#'
#' @usage createQtiTest(object, dir = NULL, verification = FALSE, zip_only =
#'   FALSE)
#' @param object an instance of the [AssessmentTest] or [AssessmentTestOpal] S4
#'   object
#' @param dir string, optional; a folder to store xml file; working directory by
#'   default
#' @param verification boolean, optional; to check validity of xml file, default
#'   `FALSE`
#' @param zip_only boolean, optional; returns only zip file in case of TRUE or
#'   zip, xml and downloads files in case of FALSE value; FALSE by default
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
setGeneric("createQtiTest", function(object, dir = NULL, verification = FALSE,
                                     zip_only = FALSE) {
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
setGeneric("createAssessmentTest", function(object, folder) {
    standardGeneric("createAssessmentTest")
})

#' Create an Zip archive of QTI test
#'
#' Generic function for creating zip archive with set of XML documents of
#' specification the test following the QTI schema v2.1
#'
#' @param object an instance of the S4 object [AssessmentTest] or
#'   [AssessmentTestOpal]
#' @param input string, optional; a source folder with xml files
#' @param output string, optional; a folder to store zip and xml files; working
#'   directory by default
#' @param file_name string, optional; file name of zip archive
#' @param zip_only boolean, optional; returns only zip file in case of TRUE or
#'   zip, xml and downloads files in case of FALSE value
#' @docType methods
#' @rdname createZip-methods
#' @aliases createZip
setGeneric("createZip", function(object, input, output, file_name, zip_only) {
    StandartGeneric("createZip")
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
          function(object, dir = getwd(), verification = FALSE,
                   zip_only = FALSE) {
              create_qti_test(object, dir, verification, zip_only)
          })

#' @rdname createOutcomeDeclaration-methods
#' @aliases createOutcomeDeclaration,AssessmentTest
setMethod("createOutcomeDeclaration", signature(object = "AssessmentTest"),
          function(object) {
              feedback <- NULL
              if (object@academic_grading) {
                  feedback <- make_outcome_declaration("FEEDBACKMODAL",
                                                       "multiple",
                                                       "identifier",
                                                       value = NULL,
                                                       view = "testConstructor")
              }
              tagList(make_outcome_declaration("SCORE", value = 0),
                      feedback,
                      make_outcome_declaration("MAXSCORE",
                                               value = object@points),
                      make_outcome_declaration("MINSCORE", value = 0))
          })

#' @rdname createZip-methods
#' @aliases createZip,AssessmentTest
setMethod("createZip", signature(object = "AssessmentTest"),
          function(object, input, output, file_name, zip_only) {
              if (is.null(file_name)) file_name <- object@identifier
              zip_wrapper(file_name, input, output, NULL, zip_only)
          })
