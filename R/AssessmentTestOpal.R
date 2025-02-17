#' Class "AssessmentTestOpal"
#'
#' Class `AssessmentTestOpal` is responsible for creating XML exam files
#' according to the QTI 2.1 standard for LMS Opal.
#' @details
#' Test consists of one or more sections. Each section can have one or more
#'  questions/tasks and/or one or more sub sections.
#' @template ATSlotsTemplate
#' @template ATOSlotsTemplate
#' @seealso [AssessmentSection], [AssessmentTest], [test()], [test4opal()],
#'   [section()].
#' @examples
#' # This example creates test 'exam' with one section 'exam_section' which
#' # consists of two questions/tasks: essay and single choice types
#' task1 <- new("Essay", prompt = "Test task", title = "Essay",
#'              identifier = "q1")
#' task2 <- new("SingleChoice", prompt = "Test task", title = "SingleChoice",
#'              choices = c("A", "B", "C"), identifier = "q2")
#' exam_section <- new("AssessmentSection", identifier = "sec_id",
#'                     title = "section", assessment_item = list(task1, task2))
#' exam <- new("AssessmentTestOpal",
#'             identifier = "id_test_1234",
#'             title = "Example of Exam",
#'             navigation_mode = "linear",
#'             submission_mode = "individual",
#'             section = list(exam_section),
#'             time_limit = 90,
#'             max_attempts = 1,
#'             academic_grading = TRUE,
#'             grade_label = "Preliminary grade",
#'             show_test_time = TRUE,
#'             calculator = "scientific-calculator",
#'             mark_items = TRUE,
#'             files = "text_book.pdf")
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
         prototype = prototype(show_test_time = TRUE,
                               calculator = NA_character_,
                               mark_items = TRUE,
                               keep_responses = FALSE))

setMethod("initialize", "AssessmentTestOpal", function(.Object, ...) {
    .Object <- callNextMethod()

    found_files <- c(sapply(.Object@section, getFiles, USE.NAMES = FALSE))
    .Object@files <- c(.Object@files, unique(unlist(found_files)))

    if (is.na(.Object@calculator)) {
        found_calc <- c(sapply(.Object@section, getCalculator, USE.NAMES = FALSE))
        if (any(c("simple", "simple-calculator") %in% found_calc)) {
            .Object@calculator = "simple"
        }
        if (any(c("scientific", "scientific-calculator") %in% found_calc)) {
            .Object@calculator = "scientific"
        }
    }

    validObject(.Object)
    .Object
})

#'Create an object [AssessmentTestOpal]
#'
#'Create an AssessmentTestOpal `rqti`-object.
#'
#'@param section A list containing [AssessmentSection] objects.
#'@param identifier A character value indicating the identifier of the test
#'  file. By default, it is generated as 'id_test_dddd', where dddd represents
#'  random digits.
#'@param title A character value, optional, representing the file title. By
#'  default, it takes the value of the identifier.
#'@param time_limit An integer value, optional, controlling the time given to a
#'  candidate for the test in minutes. Default is 90 minutes.
#'@param max_attempts An integer value, optional, indicating the maximum number
#'  of attempts allowed for the candidate. Default is 1.
#'@param academic_grading A boolean, optional; enables showing a grade to the
#'  candidate at the end of the testing according to the 5-point academic grade
#'  system as feedback. Default is `FALSE.`
#'@param grade_label A character value, optional; a short message that shows
#'  with a grade in the final feedback; for multilingual use, it can be a named
#'  vector with two-letter ISO language codes as names (e.g., c(en="Grade",
#'  de="Note")); during test creation, it takes the value for the language of
#'  the operating system; c(en="Grade", de="Note")is default.
#'@param table_label A character value, optional; a concise message to display
#'  as the column title of the grading table in the final feedback; for
#'  multilingual use, it can be a named vector with two-letter ISO language
#'  codes as names (e.g., c(en="Grade", de="Note")); during test creation, it
#'  takes the value for the language of the operating system; c(en="Grade",
#'  de="Note")is default.
#'@param navigation_mode A character value, optional, determining the general
#'  paths that the candidate may have during the exam. Two mode options are
#'  possible:
#'     - 'linear': Candidate is not allowed to return to previous questions.
#'     - 'nonlinear': Candidate is free to navigate; used by default.
#'@param submission_mode A character value, optional, determining when the
#'  candidate's responses are submitted for response processing. One of two mode
#'  options is possible:
#'     - 'individual': Submit candidates' responses on an item-by-item basis; used by default.
#'     - 'simultaneous': Candidates' responses are submitted all together by the end of the test.
#'@param allow_comment A boolean, optional, enabling the candidate to leave
#'  comments in each question. Default is `TRUE.`
#'@param rebuild_variables A boolean, optional, enabling the recalculation of
#'  variables and reshuffling the order of choices for each item-attempt.
#'  Default is `TRUE`.
#'@param show_test_time A boolean, optional, determining whether to show
#'  candidate elapsed processing time without a time limit. Default is `TRUE`.
#'@param calculator A character value, optional, determining whether to show a
#'  calculator to the candidate. Possible values:
#'      - "simple"
#'      - "scientific".
#' @param mark_items A boolean, optional, determining whether to allow candidate
#'   marking of questions. Default is `TRUE`.
#' @param keep_responses A boolean, optional, determining whether to save the
#'   candidate's answers from the previous attempt. Default is `FALSE`.
#'@param metadata An object of class [QtiMetadata] that holds metadata
#'  information about the test. By default it creates [QtiMetadata] object. See
#'  [qtiMetadata()].
#'@param points Do not use directly; the maximum number of points for the
#'  exam/test. It is calculated automatically as a sum of points of included
#'  tasks.
#'@return An [AssessmentTestOpal] object.
#'@seealso [test()], [test4opal()], [section()], [assessmentTest()], [AssessmentTest],
#'  [AssessmentSection]
#' @examples
#' sc <- sc <- singleChoice(prompt = "Question", choices = c("A", "B", "C"))
#' es <- new("Essay", prompt = "Question")
#' s <- section(c(sc, es), title = "Section with nonrandomized tasks")
#' t <- assessmentTest(list(s), title = "Example of the Exam")
#'
#'@export
assessmentTestOpal <- function(section, identifier = generate_id(type = "test"),
                           title = identifier, time_limit = 90L,
                           max_attempts = 1L, academic_grading = FALSE,
                           grade_label = c(en="Grade", de="Note"),
                           table_label = c(en="Grade", de="Note"),
                           navigation_mode = "nonlinear",
                           submission_mode = "individual",
                           allow_comment = TRUE, rebuild_variables = TRUE,
                           show_test_time = TRUE, calculator = NA_character_,
                           mark_items  = TRUE, keep_responses = FALSE,
                           metadata = qtiMetadata(), points = NA_real_) {
    params <- as.list(environment())
    params$Class <- "AssessmentTestOpal"
    obj <- do.call("new", params)
    return(obj)
}

#' @rdname createAssessmentTest-methods
#' @aliases createAssessmentTest,AssessmentTestOpal
setMethod("createAssessmentTest", signature(object = "AssessmentTestOpal"),
          function(object, folder, verify) {
              data_downloads <- NULL
              if (length(object@files) > 0) {
                  file_names <- basename(object@files)
                  files <- unlist(lapply("file://downloads/", paste0,
                                         file_names, ";"))
                  for (f in files) {
                      data_downloads <- paste0(f, data_downloads)
                  }
              }
              data_features <- NULL
              if (object@show_test_time) {
                  data_features <- paste("show-test-time", data_features,
                                         sep = ";")
              }
              if (!is.na(object@calculator)) {
                  calc_type <- NULL
                  if ("simple" %in% object@calculator) calc_type <- "simple-calculator"
                  if ("scientific" %in% object@calculator) calc_type <- "scientific-calculator"
                  data_features <- paste(calc_type, data_features, sep = ";")
              }
              if (object@mark_items) {
                  data_features <- paste("mark-items", data_features,
                                         sep = ";")
              }
              if (object@keep_responses) {
                  data_features <- paste("keep-responses", data_features,
                                         sep = ";")
              }

              create_assessment_test(object, folder, verify, data_downloads,
                                     data_features)
          })

#' @rdname createZip-methods
#' @aliases createZip,AssessmentTestOpal
setMethod("createZip", signature(object = "AssessmentTestOpal"),
          function(object, input, output, file_name, zip_only) {
              if (is.null(file_name)) file_name <- object@identifier
              zip_wrapper(file_name, input, output, object@files, zip_only)
          })
