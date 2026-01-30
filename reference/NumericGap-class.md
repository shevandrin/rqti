# Class "NumericGap"

Class `NumericGap` is responsible for creating instances of input fields
with numeric type of answers in question
[Entry](https://shevandrin.github.io/rqti/reference/Entry-class.md) type
assessment tasks according to the QTI 2.1 standard.

## Slots

- `response_identifier`:

  A character value representing an identifier for the answer. By
  default, it is generated as 'id_gap_dddd', where dddd represents
  random digits.

- `points`:

  A numeric value, optional, representing the number of points for this
  gap. Default is `1`.

- `placeholder`:

  A character value, optional, responsible for placing helpful text in
  the text input field in the content delivery engine.

- `expected_length`:

  A numeric value, optional, responsible for setting the size of the
  text input field in the content delivery engine.

- `solution`:

  A numeric value containing the correct answer for this numeric entry.

- `tolerance`:

  A numeric value, optional, specifying the value for the upper and
  lower boundaries of the tolerance rate for candidate answers. Default
  is 0.

- `tolerance_type`:

  A character value, optional, specifying the tolerance mode. Possible
  values:

  - "exact"

  - "absolute" - Default.

  - "relative"

- `include_lower_bound`:

  A boolean value, optional, specifying whether the lower bound is
  included in the tolerance rate. Default is `TRUE`.

- `include_upper_bound`:

  A boolean value, optional, specifying whether the upper bound is
  included in the tolerance rate. Default is `TRUE`.

## See also

[Entry](https://shevandrin.github.io/rqti/reference/Entry-class.md),
[TextGap](https://shevandrin.github.io/rqti/reference/TextGap-class.md),
[TextGapOpal](https://shevandrin.github.io/rqti/reference/TextGapOpal-class.md)
and
[InlineChoice](https://shevandrin.github.io/rqti/reference/InlineChoice-class.md).

## Examples

``` r
ng <- new("NumericGap",
          response_identifier = "id_gap_1234",
          points = 1,
          placeholder = "use this format xx.xxx",
          solution = 5,
          tolerance = 1,
          tolerance_type = "relative",
          include_lower_bound = TRUE,
          include_upper_bound = TRUE)
```
