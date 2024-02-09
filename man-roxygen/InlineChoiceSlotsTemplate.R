#' @slot choices A character vector containing the answers shown in the dropdown
#'   list.
#' @slot solution_index A numeric value, optional, representing the index of the
#'   correct answer in the options vector. Default is `1`.
#' @slot choices_identifiers A character vector, optional, containing a set of
#'   identifiers for answers.  By default, identifiers are generated
#'   automatically according to the template "OptionD", where D is a letter
#'   representing the alphabetical order of the answer in the list.
#' @slot shuffle A boolean value, optional, determining whether to randomize the
#'   order in which the choices are initially presented to the candidate.
#'   Default is `TRUE`.
