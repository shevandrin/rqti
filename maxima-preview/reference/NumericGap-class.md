# Class "NumericGap"

Class `NumericGap` is responsible for creating instances of input fields
with numeric type of answers in question
[Entry](https://shevandrin.github.io/rqti/maxima-preview/reference/Entry-class.md)
type assessment tasks according to the QTI 2.1 standard.

## Slots

- `response_identifier`:

  A character value representing an identifier for the answer. By
  default, it is generated as 'id_gap_dddd', where dddd represents
  random digits.

- `points`:

  A numeric value, optional, representing the number of points for this
  gap. Default is `1`.

- `placeholder`:

  A character value, optional, used to place helpful text in the text
  input field in the content delivery engine.

- `expected_length`:

  A numeric value, optional, used to set the size of the text input
  field in the content delivery engine.

- `solution`:

  A numeric value containing the correct answer for this numeric entry.
  Leave empty when using `solution_variable`.

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

- `solution_variable`:

  An optional QTI identifier of an `integer` or `float` template
  variable used as the correct answer. Defaults to
  [`character()`](https://rdrr.io/r/base/character.html). Cannot be
  combined with a non-empty `solution`. The containing item must declare
  this variable. Dynamic gaps default to an expected length of 10 unless
  explicitly provided. OPAL-style assignment during response processing
  requires the extended rqti schema. Use
  [`numericGap()`](https://shevandrin.github.io/rqti/maxima-preview/reference/numericGap_doc.md)
  or `new()` to create dynamic gaps.

## See also

[Entry](https://shevandrin.github.io/rqti/maxima-preview/reference/Entry-class.md),
[TextGap](https://shevandrin.github.io/rqti/maxima-preview/reference/TextGap-class.md),
[TextGapOpal](https://shevandrin.github.io/rqti/maxima-preview/reference/TextGapOpal-class.md)
and
[InlineChoice](https://shevandrin.github.io/rqti/maxima-preview/reference/InlineChoice-class.md).

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
dynamic_gap <- new("NumericGap", response_identifier = "answer",
                   solution_variable = "c")
variables <- new("MaximaVariables", code = "string(['c = 3]);",
                 variables = c(c = "integer"))
item <- new("Entry", content = list("<p>Answer: ", dynamic_gap, "</p>"),
            template = list(variables))
createTemplateProcessing(item)
#> <templateProcessing>
#>   <setTemplateValue identifier="all">
#>     <customOperator definition="MAXIMA" value="string([&amp;#x27;c = 3]);"></customOperator>
#>   </setTemplateValue>
#>   <setTemplateValue identifier="c">
#>     <customOperator definition="MAXIMA" value="assoc(c,$(1));">
#>       <variable identifier="all"></variable>
#>     </customOperator>
#>   </setTemplateValue>
#>   <setCorrectResponse identifier="answer">
#>     <variable identifier="c"></variable>
#>   </setCorrectResponse>
#> </templateProcessing>
```
