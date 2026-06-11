#' @slot show_test_time A boolean value, optional, determining whether to show
#'   the candidate's elapsed processing time without a time limit. Default is
#'   `FALSE`.
#' @slot calculator A character value, optional, determining whether to show a
#'   calculator to the candidate. Possible values:
#'   * "simple"
#'   * "scientific".
#' @slot mark_items A boolean value, optional, determining whether to allow
#'   candidates to mark questions. Default is `TRUE`.
#' @slot keep_responses A boolean value, optional, determining whether to save
#'   the candidate's answers from the previous attempt. Default is `FALSE`.
#' @slot files A character vector, optional, containing paths to files that will
#'   be accessible to the candidate during the test/exam.
