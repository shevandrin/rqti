# Create YAML string for TextGap object

Create YAML string for TextGap object

## Usage

``` r
gap_text(
  solution = NULL,
  tolerance = NULL,
  case_sensitive = FALSE,
  points = 1,
  response_identifier = NULL,
  expected_length = if (length(solution_variable)) 10 else size_gap(solution),
  placeholder = NULL,
  solution_variable = NULL
)
```

## Arguments

- solution:

  A character vector containing values considered as correct answers.
  Omit when using `solution_variable`.

- tolerance:

  An integer value, optional; defines the number of characters to
  tolerate spelling mistakes in evaluating candidate answers.

- case_sensitive:

  A boolean, optional; determines whether the evaluation of the correct
  answer is case sensitive. Default is `FALSE`.

- points:

  A numeric value, optional; the number of points for this gap. Default
  is 1.

- response_identifier:

  A character string (optional) representing an identifier for the
  answer.

- expected_length:

  An integer value, optional; sets the size of the text input field in
  the content delivery engine. Defaults to 10 for a dynamic answer,
  otherwise to the solution's size.

- placeholder:

  A character string, optional; places helpful text in the text input
  field in the content delivery engine.

- solution_variable:

  A `string` template variable used as the correct answer instead of
  `solution`. Dynamic answers do not support spelling tolerance; omit
  `tolerance` or set it to zero.

## Value

A character string mapped as YAML.

## See also

[`gap_numeric()`](https://shevandrin.github.io/rqti/maxima-preview/reference/gap_numeric.md),
[`dropdown()`](https://shevandrin.github.io/rqti/maxima-preview/reference/dropdown.md),
[`mdlist()`](https://shevandrin.github.io/rqti/maxima-preview/reference/mdlist.md)

## Examples

``` r
gap_text(c("Solution", "Solutions"), tolerance = 2)
#> [1] "<gap>{solution: ['Solution', 'Solutions'], tolerance: 2, case_sensitive: false, points: 1, expected_length: 7, type: 'text_opal'}</gap>"
gap_text(solution_variable = "answer")
#> [1] "<gap>{case_sensitive: false, points: 1, expected_length: 10, solution_variable: 'answer', type: 'text'}</gap>"
```
