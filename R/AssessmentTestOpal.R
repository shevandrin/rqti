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
         prototype = prototype(show_test_time = FALSE,
                               calculator = NA_character_,
                               mark_items = TRUE,
                               keep_responses = FALSE))

setMethod("initialize", "AssessmentTestOpal", function(.Object, ...) {
    .Object <- callNextMethod()

    found_files <- c(sapply(.Object@section, getFiles, USE.NAMES = FALSE))
    .Object@files <- c(.Object@files, unique(unlist(found_files)))

    found_calc <- c(sapply(.Object@section, getCalculator, USE.NAMES = FALSE))
    if (any(c("simple", "simple-calculator") %in% found_calc)) {
        .Object@calculator = "simple"
    }
    if (any(c("scientific", "scientific-calculator") %in% found_calc)) {
        .Object@calculator = "scientific"
    }

    validObject(.Object)
    .Object
})

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
