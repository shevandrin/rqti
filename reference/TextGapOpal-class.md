# Class "TextGapOpal"

Class `TextGapOpal` is responsible for creating instances of input
fields with text type of answers in question
[Entry](https://shevandrin.github.io/rqti/reference/Entry-class.md) type
assessment tasks according to the QTI 2.1 standard for LMS Opal.

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

  A character vector containing the values considered as correct
  answers.

- `case_sensitive`:

  A boolean value, determining whether the evaluation of the correct
  answer is case sensitive. Default is `FALSE`.

- `tolerance`:

  A numeric value defining how many characters will be taken into
  account to tolerate spelling mistakes in the evaluation of candidate
  answers. Default is `0`.

## See also

[Entry](https://shevandrin.github.io/rqti/reference/Entry-class.md),
[NumericGap](https://shevandrin.github.io/rqti/reference/NumericGap-class.md),
[TextGap](https://shevandrin.github.io/rqti/reference/TextGap-class.md)
and
[InlineChoice](https://shevandrin.github.io/rqti/reference/InlineChoice-class.md).

## Examples

``` r
tgo <- new("TextGapOpal",
          response_identifier = "id_gap_1234",
          points = 2,
          placeholder = "do not put special characters",
          expected_length = 20,
          solution = "answer",
          case_sensitive = FALSE,
          tolerance = 1)
```
