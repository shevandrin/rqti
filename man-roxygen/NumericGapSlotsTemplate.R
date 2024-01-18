#' @slot solution numeric; contains right answer for this numeric entry
#' @slot tolerance numeric, optional; specifies the value for up and low
#'   boundaries of tolerance rate for candidate answer; default is 0
#' @slot tolerance_type string, optional; specifies tolerance mode; possible
#'   values:
#'   * "exact"
#'   * "absolute" by default
#'   * "relative"
#' @slot include_lower_bound boolean, optional; specifies whether or not the
#' lower bound is included in tolerance rate
#' @slot include_upper_bound boolean, optional; specifies whether or not the
#' upper bound is included in tolerance rate
