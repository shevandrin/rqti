#' @slot points numeric vector, required; each number in this vector determines
#'   the number of points that will be awarded to a candidate if he selects the
#'   corresponding answer; the order of the scores must follow the order of the
#'   `choices`; it is possible to assign negative values to incorrect answers;
#'   all answers with a positive score are considered correct
#' @slot mapping do not use; value initialize automatically; named numeric
#'   vector of points, where names are choice identifiers
#' @slot lower_bound numeric, optional; min number of options, that candidate
#'   has to choose; default `0`
#' @slot upper_bound do not use;value initialize automatically; define max
#'   number of right options in the answer set
#' @slot default_value do not use; the default value from the target set to be
#'   used when no explicit mapping for a source value is given; default `0`
#' @slot maxscore do not use; value initialize automatically as sum of positive
#'   points
