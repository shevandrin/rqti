#' @slot choices string vector; contains the answers; the order of answers in
#'   the vector is a right response for the task
#' @slot choices_identifiers string vector, optional; a set of identifiers for
#'   answers; by default identifiers are generated automatically
#' @slot shuffle boolean, optional; is responsible to randomize the order in
#'   which the choices are initially presented to the candidate; default `TRUE`
#' @slot points_per_answer boolean, optional; in case of `TRUE` each selected
#'   answer will be scored individually, in case of `FALSE` only answer wich is
#'   fully correct will be scored with maximum score; `TRUE` by default
