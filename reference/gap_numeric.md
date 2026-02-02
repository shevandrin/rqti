# Create YAML string for NumericGap object

Create YAML string for NumericGap object

## Usage

``` r
gap_numeric(
  solution,
  tolerance = 0,
  tolerance_type = "absolute",
  points = 1,
  response_identifier = NULL,
  include_lower_bound = TRUE,
  include_upper_bound = TRUE,
  expected_length = size_gap(solution),
  placeholder = NULL
)
```

## Arguments

- solution:

  A numeric value; contains right answer for this numeric entry.

- tolerance:

  A numeric value, optional; specifies the value for up and low
  boundaries of tolerance rate for candidate answer. Default is 0.

- tolerance_type:

  A character string, optional; specifies tolerance mode; possible
  values:"exact", "absolute" (by default), "relative".

- points:

  A numeric value, optional; the number of points for this gap. Default
  is 1.

- response_identifier:

  A character string, optional; an identifier for the answer.

- include_lower_bound:

  A boolean, optional; specifies whether or not the lower bound is
  included in tolerance rate.

- include_upper_bound:

  A boolean, optional; specifies whether or not the upper bound is
  included in tolerance rate.

- expected_length:

  An integer value, optional; is responsible to set a size of text input
  field in content delivery engine.

- placeholder:

  A character string, optional; is responsible to place some helpful
  text in text input field in content delivery engine.

## Value

A character string mapped as yaml.

## See also

[`gap_text()`](https://shevandrin.github.io/rqti/reference/gap_text.md),
[`dropdown()`](https://shevandrin.github.io/rqti/reference/dropdown.md),
[`mdlist()`](https://shevandrin.github.io/rqti/reference/mdlist.md)

## Examples

``` r
gap_numeric(5.0, tolerance = 10, tolerance_type = "relative")
#> [1] "<gap>{solution: 5, tolerance: 10, tolerance_type: relative, points: 1, include_lower_bound: yes, include_upper_bound: yes, expected_length: 1, type: numeric}</gap>"
```
