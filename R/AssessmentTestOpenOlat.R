#' Class "AssessmentTestOpenOlat"
#'
#' Class `AssessmentTestOpenOlat` is responsible for creating XML exam files
#' according to the QTI 2.1 standard for LMS OpenOlat.
#' @details
#' Test consists of one or more sections. Each section can have one or more
#'  questions/tasks and/or one or more sub sections.
#' @template ATSlotsTemplate
#' @template ATOOSlotsTemplate
#' @seealso [AssessmentSection], [AssessmentTest], [section()].
#' @examples
#' # This example creates test 'exam' with one section 'exam_section' which
#' # consists of two questions/tasks: essay and single choice types
#' task1 <- new("Essay", prompt = "Test task", title = "Essay",
#'              identifier = "q1")
#' task2 <- new("SingleChoice", prompt = "Test task", title = "SingleChoice",
#'              choices = c("A", "B", "C"), identifier = "q2")
#' exam_section <- new("AssessmentSection", identifier = "sec_id",
#'                     title = "section", assessment_item = list(task1, task2))
#' exam <- new("AssessmentTestOpenOlat",
#'             identifier = "id_test_1234",
#'             title = "Example of Exam",
#'             navigation_mode = "linear",
#'             submission_mode = "individual",
#'             section = list(exam_section),
#'             time_limit = 90,
#'             max_attempts = 1,
#'             grade_label = "Preliminary grade")
#' @name AssessmentTestOpenOlat-class
#' @rdname AssessmentTestOpenOlat-class
#' @aliases AssessmentTestOpenOlat
#' @exportClass AssessmentTestOpenOlat
#' @include AssessmentTest.R
setClass("AssessmentTestOpenOlat", contains = "AssessmentTest",
         slots = c(
             cancel = "logical",
             suspend = "logical",
             scoreprogress = "logical",
             questionprogress = "logical",
             maxscoreitem = "logical",
             menu = "logical",
             titles = "logical",
             notes = "logical",
             hidelms = "logical",
             hidefeedbacks = "logical",
             blockaftersuccess = "logical",
             attempts = "integer",
             anonym = "logical",
             manualcorrect = "logical"
         ),
         prototype = list(
             cancel = FALSE,
             suspend = FALSE,
             scoreprogress = FALSE,
             questionprogress = FALSE,
             maxscoreitem = TRUE,
             menu = TRUE,
             titles = TRUE,
             notes = FALSE,
             hidelms = TRUE,
             hidefeedbacks = FALSE,
             blockaftersuccess = FALSE,
             attempts = 1L,
             anonym = FALSE,
             manualcorrect = FALSE
         ))

setMethod("initialize", "AssessmentTestOpenOlat", function(.Object, ...) {
    .Object <- callNextMethod()

    validObject(.Object)
    .Object
})

#'Create an object [AssessmentTestOpenOlat]
#'
#'Create an AssessmentTestOpenOlat `rqti`-object.
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
#' @param fallback_titles A character value, optional, controlling how titles
#'   are assigned when no explicit title is provided. Possible values are
#'   "filename" (use filenames as titles) and "generic" (use generic labels
#'   such as "Section 1", "Section 1.2", or "Task 1.2.1"). Default is
#'   "generic".
#' @param academic_grading A named numeric vector that defines the grade table
#'   shown to the candidate as feedback at the end of the test.
#'
#'   Each grade corresponds to the minimum percentage score required to achieve it.
#'   A helper function \code{german_grading()} is available to generate a common
#'   German grading scheme.
#'
#'   The default is \code{NULL}, which means that no grading table is shown.
#'   To display a grading table, provide a named numeric vector or use
#'   \code{german_grading()}.
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
#'@param metadata An object of class [QtiMetadata] that holds metadata
#'  information about the test. By default it creates [QtiMetadata] object. See
#'  [qtiMetadata()].
#'@param points Do not use directly; the maximum number of points for the
#'  exam/test. It is calculated automatically as a sum of points of included
#'  tasks.
#'@param points Do not use directly; the maximum number of points for the
#'  exam/test. It is calculated automatically as a sum of points of included
#'  tasks.
#'@param cancel A logical value, optional, indicating whether participants are
#'  allowed to cancel an exam after starting it. Default is `FALSE`.
#'@param suspend A logical value, optional, indicating whether participants are
#'  allowed to suspend an exam after starting it and continue later. Default is
#'  `FALSE`.
#'@param scoreprogress A logical value, optional, indicating whether the
#'  progress of the score achieved so far should be displayed during the exam.
#'  Default is `FALSE`.
#'@param questionprogress A logical value, optional, indicating whether the
#'  number of solved questions should be displayed during the exam. Default is
#'  `FALSE`.
#'@param maxscoreitem A logical value, optional, indicating whether the maximum
#'  score of an item should be displayed. Default is `TRUE`.
#'@param menu A logical value, optional, indicating whether the menu should be
#'  displayed during the exam. Default is `TRUE`.
#'@param titles A logical value, optional, indicating whether question titles
#'  should be displayed during the exam. Default is `TRUE`.
#'@param notes A logical value, optional, indicating whether participants can
#'  take notes in OpenOlat during the exam. Default is `FALSE`.
#'@param hidelms A logical value, optional, indicating whether access to the
#'  OpenOlat learning management system should be hidden during the exam.
#'  Default is `TRUE`.
#'@param hidefeedbacks A logical value, optional, indicating whether feedback
#'  should be hidden. Default is `FALSE`.
#'@param blockaftersuccess A logical value, optional, indicating whether the
#'  exam should be blocked after successful completion. Default is `FALSE`.
#'@param attempts An integer value, optional, indicating how many attempts are
#'  allowed for the exam as a whole. Default is `1`.
#'@param anonym A logical value, optional, indicating whether anonymous users
#'  are allowed to take the exam. Default is `FALSE`.
#'@param manualcorrect A logical value, optional, indicating whether points and
#'  pass/fail status should be evaluated manually. Default is `FALSE`.
#'@return An [AssessmentTestOpenOlat] object.
#'@seealso [test()], [section()], [assessmentTest()], [AssessmentTest],
#'  [AssessmentSection]
#' @examples
#' sc <- sc <- singleChoice(prompt = "Question", choices = c("A", "B", "C"))
#' es <- new("Essay", prompt = "Question")
#' s <- section(c(sc, es), title = "Section with nonrandomized tasks")
#' t <- assessmentTestOpenOlat(list(s), title = "Example of the Exam")
#'
#'@export
assessmentTestOpenOlat <- function(section,
                                   identifier = generate_id(type = "test"),
                                   title = identifier,
                                   time_limit = NULL,
                                   max_attempts = 1L,
                                   fallback_titles = "generic",
                                   academic_grading = NULL,
                                   grade_label = c(en = "Grade", de = "Note"),
                                   table_label = c(en = "Grade", de = "Note"),
                                   navigation_mode = "nonlinear",
                                   submission_mode = "individual",
                                   allow_comment = TRUE,
                                   rebuild_variables = TRUE,
                                   metadata = qtiMetadata(),
                                   points = NA_real_,
                                   cancel = FALSE,
                                   suspend = FALSE,
                                   scoreprogress = FALSE,
                                   questionprogress = FALSE,
                                   maxscoreitem = TRUE,
                                   menu = TRUE,
                                   titles = TRUE,
                                   notes = FALSE,
                                   hidelms = TRUE,
                                   hidefeedbacks = FALSE,
                                   blockaftersuccess = FALSE,
                                   attempts = 1L,
                                   anonym = FALSE,
                                   manualcorrect = FALSE) {
    params <- as.list(environment())
    params$Class <- "AssessmentTestOpenOlat"
    params$time_limit <- ifelse(is.null(time_limit), NA_integer_, time_limit)
    obj <- do.call("new", params)
    return(obj)
}



#' @rdname createConfigurationFile-methods
#' @aliases createConfigurationFile,AssessmentTestOpenOlat
#' @importFrom exams openolat_config
setMethod("createConfigurationFile", signature(object = "AssessmentTestOpenOlat"),
          function(object, output) {

              args <- list(
                  cancel = object@cancel,
                  suspend = object@suspend,
                  scoreprogress = object@scoreprogress,
                  questionprogress = object@questionprogress,
                  maxscoreitem = object@maxscoreitem,
                  menu = object@menu,
                  titles = object@titles,
                  notes = object@notes,
                  hidelms = object@hidelms,
                  hidefeedbacks = object@hidefeedbacks,
                  blockaftersuccess = object@blockaftersuccess,
                  attempts = object@attempts,
                  anonym = object@anonym,
                  manualcorrect = object@manualcorrect
              )
              cfg <- do.call(exams::openolat_config, args)[["QTI21PackageConfig.xml"]]
              if (is.null(cfg)) {
                  warning("exams::openolat_config() did not return 'QTI21PackageConfig.xml'.",
                       call. = FALSE)
                  return(invisible(NULL))
              }
              dir.create(output, recursive = TRUE, showWarnings = FALSE)
              writeLines(
                  cfg,
                  con = file.path(output, "QTI21PackageConfig.xml")
              )
          })
