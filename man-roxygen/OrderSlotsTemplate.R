#' @slot choices A character vector containing the answers. The order of answers
#'   in the vector represents the correct response for the task.
#' @slot choices_identifiers A character vector, optional, containing a set of
#'   identifiers for answers. By default, identifiers are generated
#'   automatically. By default, identifiers are generated automatically
#'   according to the template "ChoiceL", where L is a letter representing the
#'   alphabetical order of the answer in the list.
#' @slot shuffle A boolean value indicating whether to randomize the order in which
#'   the choices are initially presented to the candidate. Default is TRUE.
#' @slot points_per_answer A boolean value indicating the scoring method.
#'   If `TRUE`, each selected answer will be scored individually.
#'   If `FALSE`, only fully correct answers will be scored with the maximum score.
#'   Default is `TRUE`.
