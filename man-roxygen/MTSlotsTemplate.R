#' @slot rows string vector; set answer options as row names in table or the
#'   firsts elements in couples in directed pairs
#' @slot rows_identifiers string vector; set identifiers for answer options
#'   defined in rows of table or identifiers of the firsts elements in couples
#'   in directed pairs
#' @slot cols string vector; set answer options as cols headers in table or the
#'   seconds elements in couples in directed pairs
#' @slot cols_identifiers string vector; set identifiers for answer options
#'   defined in cols of table or identifiers of the seconds elements in couples
#'   in directed pairs
#' @slot answers_identifiers string vector; set couples of identifiers that
#'   combine the right answers
#' @slot answers_scores numeric vector, optional; each number in this vector
#'   determines the number of points that will be awarded to a candidate if he
#'   selects the corresponding answer; if nothing assign as answers_scores, the
#'   individual values for right answers calculates from task points and number
#'   of right options
#' @slot shuffle boolean, optional; is responsible to randomize the order in
#'   which the choices are initially presented to the candidate; default `TRUE`
