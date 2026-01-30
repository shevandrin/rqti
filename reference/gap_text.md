# Create YAML string for TextGap object

Create YAML string for TextGap object

## Usage

``` r
gap_text(
  solution,
  tolerance = NULL,
  case_sensitive = FALSE,
  points = 1,
  response_identifier = NULL,
  expected_length = size_gap(solution),
  placeholder = NULL
)
```

## Arguments

- solution:

  A character vector containing values considered as correct answers.

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
  the content delivery engine.

- placeholder:

  A character string, optional; places helpful text in the text input
  field in the content delivery engine.

## Value

A character string mapped as yaml.

## See also

[`gap_numeric()`](https://shevandrin.github.io/rqti/reference/gap_numeric.md),
[`dropdown()`](https://shevandrin.github.io/rqti/reference/dropdown.md),
[`mdlist()`](https://shevandrin.github.io/rqti/reference/mdlist.md)

## Examples

``` r
gap_text(c("Solution", "Solutions"), tolerance = 2)
#> [1] "<gap>{solution: [Solution,Solutions], tolerance: 2.0, case_sensitive: no, points: 1.0, expected_length: 7.0, type: text_opal}</gap>"
```
