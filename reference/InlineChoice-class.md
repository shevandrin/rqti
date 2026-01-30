# Class "InlineChoice"

Class `InlineChoice` is responsible for creating instances of dropdown
lists as answer options in
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

- `choices`:

  A character vector containing the answers shown in the dropdown list.

- `solution_index`:

  A numeric value, optional, representing the index of the correct
  answer in the options vector. Default is `1`.

- `choices_identifiers`:

  A character vector, optional, containing a set of identifiers for
  answers. By default, identifiers are generated automatically according
  to the template "OptionD", where D is a letter representing the
  alphabetical order of the answer in the list.

- `shuffle`:

  A boolean value, optional, determining whether to randomize the order
  in which the choices are initially presented to the candidate. Default
  is `TRUE`.

## See also

[Entry](https://shevandrin.github.io/rqti/reference/Entry-class.md),
[NumericGap](https://shevandrin.github.io/rqti/reference/NumericGap-class.md),
[TextGap](https://shevandrin.github.io/rqti/reference/TextGap-class.md),
[TextGapOpal](https://shevandrin.github.io/rqti/reference/TextGapOpal-class.md)

## Examples

``` r
dd <- new("InlineChoice",
          response_identifier = "id_gap_1234",
          points = 1,
          choices =  c("answer1", "answer2", "answer3"),
          solution_index = 1,
          choices_identifiers = c("OptionA", "OptionB", "OptionC"),
          shuffle = TRUE)
```
