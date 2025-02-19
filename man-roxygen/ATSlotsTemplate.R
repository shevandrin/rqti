#' @slot identifier A character representing the unique identifier of the
#'   assessment test. By default, it is generated as 'id_test_dddd', where dddd
#'   represents random digits.
#' @slot title A character representing the title of the test. By default, it
#'   takes the value of the identifier.
#' @slot points Do not use directly; the maximum number of points for the
#'   exam/test. It is calculated automatically as a sum of points of included
#'   tasks.
#' @slot test_part_identifier A character representing the identifier of the
#'   test part.
#' @slot navigation_mode A character value, optional, determining the general
#'   paths that the candidate may have during the exam. Possible values:
#'   * "linear" - candidate is not allowed to return to the previous questions.
#'   * "nonlinear" - candidate is free to navigate. This is used by default.
#' @slot submission_mode A character value, optional, determining when the
#'   candidate's responses are submitted for response processing. Possible
#'   values:
#'   * "individual" - submit candidates' responses on an item-by-item basis. This is
#'   used by default.
#'   * "simultaneous" - candidates' responses are submitted all together by the end of
#'   the test.
#' @slot section A list containing one or more [AssessmentSection] objects.
#' @slot time_limit A numeric value, optional, controlling the amount of time in
#'   minutes which a candidate is allowed for this part of the test.
#' @slot max_attempts A numeric value, optional, enabling the maximum number of
#'   attempts that a candidate is allowed to pass.
#' @slot allow_comment A boolean value, optional, enabling to allow candidates
#'   to leave comments in each question.
#' @slot rebuild_variables A boolean value, optional, enabling to recalculate
#'   variables and reshuffle the order of choices for each item-attempt.
#' @slot academic_grading A named numeric vector that defines the grade table shown to the candidate as feedback at the end of the test. The default is the German grading system:
#' gt <- c("1.0" = 0.95, "1.3" = 0.9, "1.7" = 0.85, "2.0" = 0.8, "2.3" = 0.75, "2.7" = 0.7, "3.0" = 0.65, "3.3" = 0.6, "3.7" = 0.55, "4.0" = 0.5, "5.0" = 0)
#' Each grade corresponds to a minimum percentage score required to achieve it.
#' To hide the grading table at the end of the test, set this parameter to NA_real_.
#' @slot grade_label A character value, optional, representing a short message
#'   to display with a grade in the final feedback. For multilingual usage, it
#'   hat to be a named vector with two-letter ISO language codes as names (e.g.,
#'   c(en="Grade", de="Note")); during test creation, it takes the value for the
#'   language of the operating system. Default is c(en="Grade", de="Note").
#' @slot table_label A character value, optional, representing a concise message
#'   to display as the column title of the grading table in the final feedback.
#'   For multilingual usage, it hat to be a named vector with two-letter ISO
#'   language codes as names (e.g., c(en="Grade", de="Note")); during test
#'   creation, it takes the value for the language of the operating system.
#'   Default is c(en="Grade", de="Note").
#' @slot metadata An object of class [QtiMetadata] that holds metadata information
#' about the test.

