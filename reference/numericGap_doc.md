# Create object [NumericGap](https://shevandrin.github.io/rqti/reference/NumericGap-class.md)

Create object
[NumericGap](https://shevandrin.github.io/rqti/reference/NumericGap-class.md)

## Usage

``` r
numericGap(
  solution,
  response_identifier = generate_id(type = "gap"),
  points = 1,
  placeholder = "",
  expected_length = size_gap(solution),
  tolerance = 0,
  tolerance_type = "absolute",
  include_lower_bound = TRUE,
  include_upper_bound = TRUE
)

gapNumeric(
  solution,
  response_identifier = generate_id(type = "gap"),
  points = 1,
  placeholder = "",
  expected_length = size_gap(solution),
  tolerance = 0,
  tolerance_type = "absolute",
  include_lower_bound = TRUE,
  include_upper_bound = TRUE
)
```

## Arguments

- solution:

  A numeric value containing the correct answer for this numeric entry.

- response_identifier:

  A character value representing an identifier for the answer. By
  default, it is generated as 'id_gap_dddd', where dddd represents
  random digits.

- points:

  A numeric value, optional, representing the number of points for this
  gap. Default is 1

- placeholder:

  A character value, optional, responsible for placing helpful text in
  the text input field in the content delivery engine. Default is "".

- expected_length:

  A numeric value, optional, responsible for setting the size of the
  text input field in the content delivery engine. Default value is
  adjusted by solution size.

- tolerance:

  A numeric value, optional, specifying the value for the upper and
  lower boundaries of the tolerance rate for candidate answers. Default
  is 0.

- tolerance_type:

  A character value, optional, specifying the tolerance mode. Possible
  values:

  - "exact"

  - "absolute" - Default.

  - "relative"

- include_lower_bound:

  A boolean value, optional, specifying whether the lower bound is
  included in the tolerance rate. Default is `TRUE`.

- include_upper_bound:

  A boolean value, optional, specifying whether the upper bound is
  included in the tolerance rate. Default is `TRUE`.

## Value

An object of class
[NumericGap](https://shevandrin.github.io/rqti/reference/NumericGap-class.md)

## See also

\[entry()\]\[textGap()\]\[textGapOpal()\]

## Examples

``` r
ng_min <- numericGap(5.1)

ng <- numericGap(solution = 5.1,
                response_identifier  = "id_gap_1234",
                points = 2,
                placeholder = "put your answer here",
                expected_length = 4,
                tolerance = 5,
                tolerance_type = "relative")
```
