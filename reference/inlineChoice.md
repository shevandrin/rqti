# Create object [InlineChoice](https://shevandrin.github.io/rqti/reference/InlineChoice-class.md)

Create object
[InlineChoice](https://shevandrin.github.io/rqti/reference/InlineChoice-class.md)

## Usage

``` r
inlineChoice(
  choices,
  solution_index = 1,
  response_identifier = generate_id(type = "gap"),
  choices_identifiers = paste0("Choice", LETTERS[seq(choices)]),
  points = 1,
  shuffle = TRUE,
  placeholder = "",
  expected_length = size_gap(choices)
)
```

## Arguments

- choices:

  A character vector containing the answers shown in the dropdown list.

- solution_index:

  A numeric value, optional, representing the index of the correct
  answer in the options vector. Default is 1.

- response_identifier:

  A character value representing an identifier for the answer. By
  default, it is generated as 'id_gap_dddd', where dddd represents
  random digits.

- choices_identifiers:

  A character vector, optional, containing a set of identifiers for
  answers. By default, identifiers are generated automatically according
  to the template "OptionD", where D is a letter representing the
  alphabetical order of the answer in the list.

- points:

  A numeric value, optional, representing the number of points for this
  gap. Default is 1

- shuffle:

  A boolean value, optional, determining whether to randomize the order
  in which the choices are initially presented to the candidate. Default
  is `TRUE`.

- placeholder:

  A character value, optional, responsible for placing helpful text in
  the text input field in the content delivery engine. Default is "".

- expected_length:

  A numeric value, optional, responsible for setting the size of the
  text input field in the content delivery engine. Default value is
  adjusted by the first choice size.

## Value

An object of class
[InlineChoice](https://shevandrin.github.io/rqti/reference/InlineChoice-class.md)

## See also

\[entry()\]\[numericGap()\]\[textGap()\]\[textGapOpal()\]

## Examples

``` r
dd_min <- inlineChoice(c("answer1", "answer2", "answer3"))

dd <- inlineChoice(choices = c("answer1", "answer2", "answer3"),
                  solution_index = 2,
                  response_identifier  = "id_gap_1234",
                  choices_identifiers = c("a", "b", "c"),
                  points = 2,
                  shuffle = FALSE,
                  placeholder = "answers",
                  expected_length = 10)
```
