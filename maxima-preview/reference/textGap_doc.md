# Create object [TextGap](https://shevandrin.github.io/rqti/maxima-preview/reference/TextGap-class.md)

Create object
[TextGap](https://shevandrin.github.io/rqti/maxima-preview/reference/TextGap-class.md)

## Usage

``` r
textGap(
  solution = character(),
  response_identifier = generate_id(type = "gap"),
  points = 1,
  placeholder = "",
  expected_length = if (length(solution_variable)) 10 else size_gap(solution),
  case_sensitive = FALSE,
  solution_variable = character()
)

gapText(
  solution = character(),
  response_identifier = generate_id(type = "gap"),
  points = 1,
  placeholder = "",
  expected_length = if (length(solution_variable)) 10 else size_gap(solution),
  case_sensitive = FALSE,
  solution_variable = character()
)
```

## Arguments

- solution:

  A character vector containing the values considered as correct
  answers. Omit when using `solution_variable`.

- response_identifier:

  A character value representing an identifier for the answer. By
  default, it is generated as 'id_gap_dddd', where dddd represents
  random digits.

- points:

  A numeric value, optional, representing the number of points for this
  gap. Default is 1

- placeholder:

  A character value, optional, used to place helpful text in the text
  input field in the content delivery engine. Default is "".

- expected_length:

  A numeric value, optional, used to set the size of the text input
  field in the content delivery engine. Default value is adjusted by
  solution size, or 10 for a dynamic answer.

- case_sensitive:

  A boolean value, determining whether the evaluation of the correct
  answer is case sensitive. Default is `FALSE`.

- solution_variable:

  An optional QTI identifier of a `string` template variable used as the
  correct answer. Cannot be combined with `solution`.

## Value

An object of class
[TextGap](https://shevandrin.github.io/rqti/maxima-preview/reference/TextGap-class.md)

## See also

\[entry()\]\[numericGap()\]\[textGapOpal()\]

## Examples

``` r
tg_min <- textGap("answer")
dynamic_gap <- textGap(solution_variable = "answer")

tg <- textGap(solution = "answer",
             response_identifier  = "id_gap_1234",
             points = 2,
             placeholder = "put your answer here",
             expected_length = 20,
             case_sensitive = TRUE)
```
