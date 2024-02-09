#' @slot rows A character vector specifying answer options as row names in the
#'   table or the first elements in couples in [DirectedPair].
#' @slot rows_identifiers A character vector, optional, specifying identifiers
#'   for answer options defined in rows of the table or identifiers of the first
#'   elements in couples in [DirectedPair].
#' @slot cols A character vector specifying answer options as column headers in
#'   the table or the second elements in couples in [DirectedPair].
#' @slot cols_identifiers A character vector, optional, specifying identifiers
#'   for answer options defined in columns of the table or identifiers of the
#'   second elements in couples in [DirectedPair].
#' @slot answers_identifiers A character vector specifying couples of
#'   identifiers that combine the correct answers.
#' @slot answers_scores A numeric vector, optional, where each number determines
#'   the number of points awarded to a candidate if they select the
#'   corresponding answer. If not assigned, the individual values for correct
#'   answers are calculated from the task points and the number of correct
#'   options.
#' @slot shuffle A boolean value, optional, determining whether to randomize the
#'   order in which the choices are initially presented to the candidate.
#'   Default is `TRUE`.
#' @slot shuffle_rows A boolean value, optional, determining whether to
#'   randomize the order of the choices only in rows. Default is `TRUE`.
#' @slot shuffle_cols A boolean value, optional, determining whether to
#'   randomize the order of the choices only in columns. Default is `TRUE`.
