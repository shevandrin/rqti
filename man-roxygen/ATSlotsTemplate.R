#' @slot identifier string; identifier of the xml test file
#' @slot title string; file title
#' @slot points numeric; maximum number of points for the exam/test
#' @slot test_part_identifier string; identifier of the test part
#' @slot navigation_mode string, optional; determines the general paths that the
#'   candidate may have during exam; two mode options are possible:
#'   * "linear" - candidate is not allowed to return to the previous questions
#'   * "nonlinear" - candidate if free to navigate, used by **default**
#' @slot submission_mode string, optional; determines when the candidate's
#'   responses are submitted for response processing; two mode options are
#'   possible:
#'   * "individual" - submit candidates' responses on an item-by-idem
#'   basis, used by **default**
#'   * "simultaneous - candidates' responses are submitted all together by the
#'   end of the test
#' @slot section list; list of [AssessmentSection-class] objects
#' @slot qti_version string, optional; qti information model version, default
#'   'v2p1'
#' @slot time_limits numeric, optional;  controls the amount of time *in
#'   minutes* a candidate is allowed for this part of the test
#' @slot max_attempts numeric, optional; enables the maximum number of attempts,
#'   that candidate is allowed to pass
#' @slot allow_comment boolean, optional; enables to allow candidate to leave
#'   comments in each question
#' @slot rebuild_variables boolean, optional; enables to recalculate variables
#'   and reshuffle the order of choices for each item-attempt
#' @slot academic_grading boolean, optional; enables to show to candidate at the
#'   end of the testing a grade according to 5-point academic grade system as a
#'   feedback; `FALSE` by default
#' @slot grade_label character, optional; a short message that shows with a
#'   grade in the final feedback
