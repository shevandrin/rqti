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
                               mark_items = FALSE,
                               keep_responses = FALSE))
#' @export
AssessmentTestOpal <- function(identifier = character(),
                           title = character(), points = numeric(),
                           test_part_identifier = character(),
                           navigation_mode = character(),
                           submission_mode = character(),
                           section = list(),
                           time_limits = numeric(), max_attempts = numeric(),
                           allow_comment = logical(),
                           rebuild_variables = logical(),
                           show_test_time = logical(),
                           calculator = character(), mark_items = logical(),
                           keep_responses = logical(),
                           files = character()
){
    new("AssessmentTestOpal", identifier = identifier, title = title,
        points = points,
        test_part_identifier = test_part_identifier,
        navigation_mode = navigation_mode, submission_mode = submission_mode,
        section = section, time_limits = time_limits,
        max_attempts = max_attempts, allow_comment = allow_comment,
        rebuild_variables = rebuild_variables, show_test_time = show_test_time,
        calculator = calculator, mark_items = mark_items,
        keep_responses = keep_responses, files = files)
}
