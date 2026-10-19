#' Configure multiple-choice scoring
#'
#' Create a scoring specification for [multipleChoice()] or a multiple-choice
#' Rmd item. These items permit several selected options. For one-answer items,
#' see [single_choice_scoring()]. Both this helper and the multiple-choice item
#' default to `"standard"`: balanced partial credit equivalent to Youden's J
#' with a zero floor for the usual automatically balanced weights.
#'
#' @param method A multiple-choice method. See the table below. The default is
#'   `"standard"`. Single-choice penalties and the `kanzow_*` presets are not
#'   accepted by this helper.
#' @param ... Settings for the selected method. `weights` and `plus_minus`
#'   accept `lower_bound` (default 0), a nonpositive fraction of the maximum.
#'   `all_or_nothing` accepts `incorrect` (default 0) and `omitted` (default 0),
#'   also fractions of the maximum. `exams` accepts `partial` (default TRUE),
#'   `negative` (default FALSE), and `rule` (`false2`, `false`, `true`, `all`,
#'   or `none`), reproducing [exams::exams_eval()] for multiple-choice items.
#' @return A named list for `scoring_scheme` in [multipleChoice()]. Passing it
#'   to [singleChoice()] is an error. Plain YAML mappings are interpreted
#'   using the item's type.
#' @section Methods:
#' Positive entries in the item's `points` identify correct options, and their
#' sum is the maximum score P. C is the number of correct options and W the
#' number of incorrect options.
#'
#' | Method | Rule |
#' |:-------|:-----|
#' | `standard` | Default balanced (Youden's J) weights and zero floor; explicit weights are preserved |
#' | `weights` | Preserve all supplied weights, including explicit zeros; use the chosen floor |
#' | `all_or_nothing` | Full credit only for selecting exactly the correct set |
#' | `plus_minus` | Each selected correct option adds P/C; each selected incorrect option subtracts P/C |
#' | `subset` | Selected correct options earn P/C each, only if no incorrect option is selected |
#' | `ripkey` | Selected correct options earn P/C each, unless more than C options are selected |
#' | `true_false` | Each correctly classified option earns P/(C+W), including unchecked incorrect options |
#' | `exams` | Use the selected R/exams weighting, partial-credit setting and score floor |
#'
#' The five literature methods are described by Betts et al. Their raw scores
#' are scaled here to the item maximum P. Those five methods and `exams` use
#' the correct-option set and its total points, rather than the relative
#' magnitudes of positive option weights. `standard` and `weights` preserve
#' individual contributions, with the zero-weight handling described above.
#' @section Default: balanced scoring and Youden's J:
#' With C > 0 correct options, W > 0 incorrect options, equal correct-option
#' weights, and automatically balanced incorrect-option penalties, the raw
#' normalized score is Youden's J:
#' \deqn{J = \frac{\#\mathrm{correct\ options\ selected}}{C} -
#'             \frac{\#\mathrm{incorrect\ options\ selected}}{W}.}
#' The awarded score is \eqn{P\max(0,J)}. Each selected correct option adds
#' P/C and each selected incorrect option subtracts P/W; unchecked options
#' contribute zero. This is the ordinary Rmd default when its correct options
#' share the points equally. The raw J has zero expectation under independent
#' random selection; flooring it at zero does not preserve that expectation.
#' `standard` also preserves explicit negative option weights. If the positive
#' or negative weights differ from those balanced contributions, the resulting
#' custom weighting is not necessarily Youden's J. `standard` is the method
#' identifier; Youden's J describes its ordinary balanced special case.
#'
#' @section Empty responses and bounds:
#' `true_false` treats an unchecked option as a false decision, so an empty
#' selection can earn P*W/(C+W). Checkboxes cannot distinguish a deliberate
#' nonselection from an omitted decision. An explicit true/false/omission
#' interaction is a different format. The other methods score an empty response
#' as zero unless otherwise configured. By default negative totals are floored
#' at zero; `weights`, `plus_minus`, `all_or_nothing`, and `exams` can allow
#' negative scores through their documented settings. Scores never exceed P.
#' @section Rmd/YAML:
#' ```yaml
#' scoring_scheme:
#'   method: exams
#'   partial: true
#'   negative: -0.25
#'   rule: "false2"
#' ```
#' Or use a preset string, for example `scoring_scheme: plus_minus`.
#' The YAML list is interpreted from `type: mpc` (or another supported
#' multiple-choice type alias); no function call is needed inside YAML.
#' @references
#' Betts J, Muntean W, Kim D, Kao S (2022). Evaluating Different Scoring Methods
#' for Multiple Response Items Providing Partial Credit. Educational and
#' Psychological Measurement, 82(1), 151--176.
#' \href{https://doi.org/10.1177/0013164421994636}{doi:10.1177/0013164421994636}.
#' @seealso [multipleChoice()], [single_choice_scoring()]
#' @examples
#' multipleChoice(choices = c("A", "B", "C"), points = c(0.5, 0, 0.5),
#'   scoring_scheme = multiple_choice_scoring("plus_minus"))
#' multipleChoice(choices = c("A", "B", "C"), points = c(0.5, 0, 0.5),
#'   scoring_scheme = multiple_choice_scoring("exams", rule = "none"))
#' @export
multiple_choice_scoring <- function(method = "standard", ...) {
    new_choice_scoring_spec(method, ..., item_type = "multiple")
}
