# Configure single-choice scoring

Create a scoring specification for
[`singleChoice()`](https://shevandrin.github.io/rqti/reference/singleChoice.md)
or a single-choice Rmd item.
[`multiple_choice_scoring()`](https://shevandrin.github.io/rqti/reference/multiple_choice_scoring.md)
documents the separate checkbox models. The
[`singleChoice()`](https://shevandrin.github.io/rqti/reference/singleChoice.md)
item default remains `scoring_scheme = "standard"`. This helper defaults
to `method = "custom"` for convenient calls such as
`single_choice_scoring(incorrect = -0.2)`. With no settings it produces
correct/incorrect/omitted coefficients of 1/0/0, matching standard
scoring.

## Usage

``` r
single_choice_scoring(method = "custom", ...)
```

## Arguments

- method:

  A single-choice method. The default `"custom"` accepts explicit
  credits. `"standard"` awards full points for the correct answer and
  zero otherwise; `"penalty"` deducts `points/(k-1)` for an incorrect
  answer, where k is the number of options, and awards zero for an
  omission. `"kanzow_01"` through `"kanzow_21"` use the coefficients
  below. Aliases `"number_right"`, `"fair_penalty"`,
  `"correction_for_guessing"`, and `"rights_minus_wrongs"` select
  methods 1, 3, 6, and 13. `"exams"` uses the R/exams single-choice
  penalty setting.

- ...:

  Settings for the selected method, expressed as fractions of the item's
  `points`. For `custom`: `correct` (default 1), `incorrect` (default
  0), and `omitted` (default 0). All must be finite; `correct` must be
  positive and at least as large as the other credits. For `exams`:
  `negative` (default FALSE), a logical or finite numeric penalty
  magnitude, following
  [`exams::exams_eval()`](https://rdrr.io/pkg/exams/man/exams_eval.html).
  `negative = FALSE` means no penalty, `TRUE` deducts the item's full
  points for an incorrect answer, and a numeric value d deducts
  `abs(d) * points`. Correct answers receive full points; omissions
  receive zero. Thus `single_choice_scoring("exams", negative = 0.25)`
  is equivalent to `single_choice_scoring("custom", incorrect = -0.25)`.
  This is an R/exams parameter convention, not another scoring formula.
  Unlike `"penalty"`, it does not automatically calculate `1/(k-1)`. The
  `partial` and `rule` settings belong to multiple-choice scoring and
  are not accepted here. For `kanzow_21`: the required logical
  `statement_truth`, explained below.

## Value

A named list for the `scoring_scheme` argument of
[`singleChoice()`](https://shevandrin.github.io/rqti/reference/singleChoice.md).
It is checked against the item type; passing it to
[`multipleChoice()`](https://shevandrin.github.io/rqti/reference/multipleChoice.md)
is an error. Plain YAML mappings are interpreted in the item's own
context.

## Rmd/YAML

The same settings can be supplied as a YAML mapping:

    scoring_scheme:
      method: custom
      correct: 1
      incorrect: -0.2
      omitted: 0

With `points: 2`, this awards 2, -0.4, and 0 points. A preset can also
be supplied as a string, for example `scoring_scheme: kanzow_05`. The
number of options is inferred from the item, not passed to this helper.

## Restrictions and score bounds

Methods 10, 12, 14, 15, 17, 18, and 20 require exactly two options.
Method 21 requires a single true/false statement with two answer
options. Invalid option counts raise errors when an item is constructed
or an Rmd file converted. Method 21 also requires `statement_truth`
immediately. `points` scales the published coefficients. Thus methods 4,
7, and 8 can have a maximum different from `points`;
[`getPoints()`](https://shevandrin.github.io/rqti/reference/getPoints-methods.md)
reports the actual maximum. Negative single-choice credits remain
negative, without a zero floor. Supporting a preset does not recommend
it for every assessment.

## What statement_truth means

Only `kanzow_21` needs this setting. `statement_truth = TRUE` means that
the assertion posed to the student is actually true, for example "2 + 2
= 4". `FALSE` means it is actually false, for example "2 + 2 = 5". It
does not describe the student's response or the position of the correct
option. For a one-point item, an incorrect response scores -62/38 for a
true assertion and -38/62 for a false assertion. Correct responses score
1; omissions score 0. Other single-choice methods do not need this
setting. The correct option is still identified by
`singleChoice(solution = ...)`. rqti does not infer truth from option
labels, which may be translated or contain HTML. The author must keep
`solution` and `statement_truth` consistent.

## Published coefficients

Published coefficients before multiplication by `points`:

|             |         |                                 |         |
|-------------|---------|---------------------------------|---------|
| Method      | Correct | Incorrect                       | Omitted |
| `kanzow_01` | 1       | 0                               | 0       |
| `kanzow_02` | 1       | 0                               | 1/k     |
| `kanzow_03` | 1       | 1 - 1/k                         | 0       |
| `kanzow_04` | 1/(k-1) | 0                               | 0       |
| `kanzow_05` | 1       | -1/(2(k-1))                     | 0       |
| `kanzow_06` | 1       | -1/(k-1)                        | 0       |
| `kanzow_07` | 1/(k-1) | -1/(k-1)                        | 0       |
| `kanzow_08` | (k-1)/k | -1/k                            | 0       |
| `kanzow_09` | 1       | -1/3                            | 0       |
| `kanzow_10` | 1       | -0.48                           | 0       |
| `kanzow_11` | 1       | -0.5                            | 0       |
| `kanzow_12` | 1       | -0.6                            | 0       |
| `kanzow_13` | 1       | -1                              | 0       |
| `kanzow_14` | 1       | -1                              | 0.7     |
| `kanzow_15` | 1       | -1.1                            | 0.7     |
| `kanzow_16` | 1       | -k/(k-1)                        | 0       |
| `kanzow_17` | 1       | -1.5                            | 0       |
| `kanzow_18` | 1       | -1.8                            | 0       |
| `kanzow_19` | 1       | -2/(k-1)                        | 0       |
| `kanzow_20` | 1       | -3                              | 0       |
| `kanzow_21` | 1       | -62/38 if true; -38/62 if false | 0       |

## References

Kanzow AF, Schmidt D, Kanzow P (2023). Scoring Single-Response
Multiple-Choice Items: Scoping Review and Comparison of Different
Scoring Methods. JMIR Medical Education, 9, e44084.
[doi:10.2196/44084](https://doi.org/10.2196/44084).

## See also

[`singleChoice()`](https://shevandrin.github.io/rqti/reference/singleChoice.md),
[`multiple_choice_scoring()`](https://shevandrin.github.io/rqti/reference/multiple_choice_scoring.md)

## Examples

``` r
singleChoice(choices = c("A", "B", "C"), points = 2,
  scoring_scheme = single_choice_scoring(incorrect = -0.2))
#> An object of class "SingleChoice"
#> Slot "solution":
#> [1] 1
#> 
#> Slot "scoring_scheme":
#> $method
#> [1] "custom"
#> 
#> $item_type
#> [1] "single"
#> 
#> $incorrect
#> [1] -0.2
#> 
#> 
#> Slot "choices":
#> [1] "A" "B" "C"
#> 
#> Slot "choice_identifiers":
#> [1] "ChoiceA" "ChoiceB" "ChoiceC"
#> 
#> Slot "response_identifier":
#> [1] "RESPONSE"
#> 
#> Slot "shuffle":
#> [1] TRUE
#> 
#> Slot "orientation":
#> [1] "vertical"
#> 
#> Slot "identifier":
#> [1] "id_task_7748"
#> 
#> Slot "title":
#> [1] "id_task_7748"
#> 
#> Slot "content":
#> list()
#> 
#> Slot "prompt":
#> [1] ""
#> 
#> Slot "points":
#> [1] 2
#> 
#> Slot "feedback":
#> list()
#> 
#> Slot "files":
#> [1] NA
#> 
#> Slot "stylesheet_path":
#> character(0)
#> 
#> Slot "css":
#> character(0)
#> 
#> Slot "calculator":
#> [1] NA
#> 
#> Slot "metadata":
#> An object of class "QtiMetadata"
#> Slot "contributor":
#> [[1]]
#> An object of class "QtiContributor"
#> Slot "name":
#> [1] ""
#> 
#> Slot "role":
#> [1] "author"
#> 
#> Slot "contribution_date":
#> Date of length 0
#> 
#> 
#> 
#> Slot "description":
#> [1] ""
#> 
#> Slot "rights":
#> [1] ""
#> 
#> Slot "version":
#> character(0)
#> 
#> 
singleChoice(prompt = "2 + 2 = 4", choices = c("False", "True"), solution = 2,
  scoring_scheme = single_choice_scoring("kanzow_21", statement_truth = TRUE))
#> An object of class "SingleChoice"
#> Slot "solution":
#> [1] 2
#> 
#> Slot "scoring_scheme":
#> $method
#> [1] "kanzow_21"
#> 
#> $item_type
#> [1] "single"
#> 
#> $statement_truth
#> [1] TRUE
#> 
#> 
#> Slot "choices":
#> [1] "False" "True" 
#> 
#> Slot "choice_identifiers":
#> [1] "ChoiceA" "ChoiceB"
#> 
#> Slot "response_identifier":
#> [1] "RESPONSE"
#> 
#> Slot "shuffle":
#> [1] TRUE
#> 
#> Slot "orientation":
#> [1] "vertical"
#> 
#> Slot "identifier":
#> [1] "id_task_0387"
#> 
#> Slot "title":
#> [1] "id_task_0387"
#> 
#> Slot "content":
#> list()
#> 
#> Slot "prompt":
#> [1] "2 + 2 = 4"
#> 
#> Slot "points":
#> [1] 1
#> 
#> Slot "feedback":
#> list()
#> 
#> Slot "files":
#> [1] NA
#> 
#> Slot "stylesheet_path":
#> character(0)
#> 
#> Slot "css":
#> character(0)
#> 
#> Slot "calculator":
#> [1] NA
#> 
#> Slot "metadata":
#> An object of class "QtiMetadata"
#> Slot "contributor":
#> [[1]]
#> An object of class "QtiContributor"
#> Slot "name":
#> [1] ""
#> 
#> Slot "role":
#> [1] "author"
#> 
#> Slot "contribution_date":
#> Date of length 0
#> 
#> 
#> 
#> Slot "description":
#> [1] ""
#> 
#> Slot "rights":
#> [1] ""
#> 
#> Slot "version":
#> character(0)
#> 
#> 
```
