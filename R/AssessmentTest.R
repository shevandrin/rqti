#' Class "AssessmentTest"
#'
#' Class `AssessmentTest` is responsible for creating XML exam files according
#' to the QTI 2.1 standard.
#' \if{html}{\out{<div style="text-align:center">}\figure{assessmentTest.png}
#' \out{</div>}}
#' @details Test consists of one or more sections. Each section can have one or
#' more questions/tasks and/or one or more sub sections.
#' @template ATSlotsTemplate
#' @seealso [AssessmentSection], [AssessmentTestOpal], [test()], [test4opal()],
#'   [section()].
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
#' exam <- new("AssessmentTest",
#'             identifier = "id_test_1234",
#'             title = "Example of Exam",
#'             navigation_mode = "linear",
#'             submission_mode = "individual",
#'             section = list(exam_section),
#'             time_limit = 90,
#'             max_attempts = 1,
#'             academic_grading = TRUE,
#'             grade_label = "Preliminary grade")
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
                                     time_limit = "numeric",
                                     max_attempts = "numeric",
                                     allow_comment = "logical",
                                     rebuild_variables = "logical",
                                     academic_grading = "logical",
                                     grade_label = "character",
                                     table_label = "character"),
         prototype = prototype(identifier = generate_id(type = "test"),
                               navigation_mode = "nonlinear",
                               submission_mode = "individual",
                               test_part_identifier = "test_part",
                               qti_version = "v2p1",
                               time_limit = NA_integer_,
                               max_attempts = NA_integer_,
                               allow_comment = TRUE,
                               rebuild_variables = NA,
                               academic_grading = FALSE,
                               grade_label = c(en="Grade", de="Note"),
                               table_label = c(en="Grade", de="Note")
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
    ids <- unlist(lapply(.Object@section, getIdentifier))
    if (length(ids) != length(unique(ids))) {
        ids <- paste(ids, collapse = ", ")
        warning("Identifiers of test sections contain non-unique values: ", ids,
                call. = FALSE)
    }

    # check time limits
    if (!is.na(.Object@time_limit)) {
        if (.Object@time_limit > 180 | .Object@time_limit < 0.01) {
            warning("Value of time_limits does not seem plausible.",
                    call. = FALSE)
            }
    }

    validObject(.Object)
    .Object
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
#' @param verify boolean, optional; to check validity of xml file, default
#'   `FALSE`
#' @docType methods
#' @rdname createAssessmentTest-methods
#' @aliases createAssessmentTest
setGeneric("createAssessmentTest", function(object, folder, verify = FALSE) {
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
          function(object, folder, verify) {
              create_assessment_test(object, folder, verify)
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
              feedback_grade <- NULL
              feedback_grade_table <- NULL
              if (object@academic_grading) {
                  feedback_grade <- make_outcome_declaration("FEEDBACKMODAL",
                                                       "multiple",
                                                       "identifier",
                                                       value = NULL,
                                                       view = "testConstructor")
                  feedback_grade_table <- make_outcome_declaration(
                      "FEEDBACKTABLE", "multiple", "identifier",
                      value = NULL, view = "testConstructor")
              }
              tagList(make_outcome_declaration("SCORE", value = 0),
                      feedback_grade, feedback_grade_table,
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

#' @rdname prepareQTIJSFiles-methods
#' @aliases prepareQTIJSFiles,AssessmentTest
setMethod("prepareQTIJSFiles", signature(object = "AssessmentTest"),
          function(object, dir) {
              zip_file <- createQtiTest(object, dir, TRUE)
              unzip(zip_file, exdir = dir)
              unlink(zip_file)
              return(NULL)
          })
