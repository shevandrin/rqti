#' @slot points numeric vector, required; each number in this vector determines
#'   the number of points that will be awarded to a candidate if he selects the
#'   corresponding answer; the order of the scores must follow the order of the
#'   `choices`; it is possible to assign negative values to incorrect answers;
#'   all answers with a positive score are considered correct
