#' @slot solution A numeric value, optional. Represents the index of the correct
#'   answer in the `choices` slot. By default, the first item in the `choices`
#'   slot is considered the correct answer. Default is `1`.
#' @slot scoring_scheme A method name or named list from [single_choice_scoring()].
#'   Defaults to `"standard"`; `"penalty"` retains correction for guessing.
