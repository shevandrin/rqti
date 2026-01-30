# Create object [TextGapOpal](https://shevandrin.github.io/rqti/reference/TextGapOpal-class.md)

Create object
[TextGapOpal](https://shevandrin.github.io/rqti/reference/TextGapOpal-class.md)

## Usage

``` r
textGapOpal(
  solution,
  response_identifier = generate_id(type = "gap"),
  points = 1,
  placeholder = "",
  expected_length = size_gap(solution),
  case_sensitive = FALSE,
  tolerance = 0
)

gapTextOpal(
  solution,
  response_identifier = generate_id(type = "gap"),
  points = 1,
  placeholder = "",
  expected_length = size_gap(solution),
  case_sensitive = FALSE,
  tolerance = 0
)
```

## Arguments

- solution:

  A character vector containing the values considered as correct
  answers.

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

- case_sensitive:

  A boolean value, determining whether the evaluation of the correct
  answer is case sensitive. Default is `FALSE`.

- tolerance:

  A numeric value defining how many characters will be taken into
  account to tolerate spelling mistakes in the evaluation of candidate
  answers. Default is 0.

## Value

An object of class
[TextGapOpal](https://shevandrin.github.io/rqti/reference/TextGapOpal-class.md)

## See also

\[entry()\]\[numericGap()\]\[textGap()\]

## Examples

``` r
tgo_min <- textGapOpal("answer")

tgo <- textGapOpal(solution = "answer",
             response_identifier  = "id_gap_1234",
             points = 2,
             placeholder = "put your answer here",
             expected_length = 20,
             case_sensitive = TRUE,
             tolerance = 2)
```
