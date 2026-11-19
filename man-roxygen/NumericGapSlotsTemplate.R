#' @slot solution A numeric value containing the correct answer for this numeric
#'   entry. Leave empty when using `solution_variable`.
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
#' @slot solution_variable An optional QTI identifier of an `integer` or `float`
#'   template variable used as the correct answer. Defaults to `character()`.
#'   Cannot be combined with a non-empty `solution`. The containing item must
#'   declare this variable. Dynamic gaps default to an expected length of 10
#'   unless explicitly provided. OPAL-style assignment during response processing
#'   requires the extended rqti schema. Use [numericGap()] or `new()` to create
#'   dynamic gaps.
