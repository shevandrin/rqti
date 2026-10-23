#' @slot solution A character vector containing the values considered as correct
#'   answers.
#' @slot solution_variable An optional QTI identifier of a `string` template
#'   variable used as the correct answer instead of `solution`. Dynamic text
#'   answers require zero spelling tolerance.
#' @slot case_sensitive A boolean value, determining whether the evaluation of
#'   the correct answer is case sensitive. Default is `FALSE`.
