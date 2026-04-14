#' @slot solution A numeric value, optional. Represents the index of the correct
#'   answer in the `choices` slot. By default, the first item in the `choices`
#'   slot is considered the correct answer. Default is `1`.
#' @slot scoring_scheme A character value, optional, defining how response
#'   options are scored. Possible values:
#'   * "standard" - the correct answer receives full points and incorrect
#'   answers receive 0. This is used by default.
#'   * "penalty" - the correct answer receives full points and incorrect
#'   answers receive a negative score of -1/(k-1), where k is the number of
#'   response options.
