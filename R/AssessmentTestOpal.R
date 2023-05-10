#' Class "AssessmentTestOpal"
#'
#' Abstract class `AssessmentTestOpal` is responsible for creating xml exam file
#' according to QTI 2.1. for LMS Opal
#' \if{html}{\out{<div style="text-align:center">}\figure{assessmentTest.png}
#' \out{</div>}}
#' @details
#' Test consists of one or more sections. Each section can have one or more
#'  questions/tasks and/or one or more sub sections.
#' @template ATSlotsTemplate
#' @template ATOSlotsTemplate
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

#' #' @rdname createQtiTest-methods
#' #' @aliases createQtiTest,AssessmentTestOpal
#' setMethod("createQtiTest", signature(object = "AssessmentTestOpal"),
#'           function(object, dir = NULL, verification = FALSE) {
#'               create_qti_test(object, dir, verification)
#'           })

#' @rdname createAssessmentTest-methods
#' @aliases createAssessmentTest,AssessmentTestOpal
setMethod("createAssessmentTest", signature(object = "AssessmentTestOpal"),
          function(object, folder) {
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
                  data_features <- paste(object@calculator, data_features,
                                         sep = ";")
              }
              if (object@mark_items) {
                  data_features <- paste("mark-items", data_features,
                                         sep = ";")
              }
              if (object@keep_responses) {
                  data_features <- paste("keep-responses", data_features,
                                         sep = ";")
              }

              create_assessment_test(object, folder, data_downloads,
                                     data_features)
          })

#' @rdname createZip-methods
#' @aliases createZip,AssessmentTestOpal
setMethod("createZip", signature(object = "AssessmentTestOpal"),
          function(object, folder) {
              zip_wrapper(object@identifier, object@files, folder)
          })
