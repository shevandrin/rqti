#' @slot solution A numeric value containing the correct answer for this numeric
#'   entry.
#' @slot tolerance A numeric value, optional, specifying the value for the upper
#'   and lower boundaries of the tolerance rate for candidate answers. Default
#'   is 0.
#' @slot tolerance_type A character value, optional, specifying the tolerance
#'   mode. Possible values:
#'   * "exact"
#'   * "absolute" - Default.
#'   * "relative"
#' @slot include_lower_bound A boolean value, optional, specifying whether the
#'   lower bound is included in the tolerance rate. Default is `TRUE`.
#' @slot include_upper_bound A boolean value, optional, specifying whether the
#'   upper bound is included in the tolerance rate. Default is `TRUE`.
