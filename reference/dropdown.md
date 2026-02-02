# Create YAML string for InlineChoice object (dropdown list)

Create YAML string for InlineChoice object (dropdown list)

## Usage

``` r
dropdown(
  choices,
  solution_index = 1,
  points = 1,
  shuffle = TRUE,
  response_identifier = NULL
)
```

## Arguments

- choices:

  A numeric or character vector; contains values of possible answers. If
  you use a named vector, the names will be used as identifiers.

- solution_index:

  An integer value, optional; the number of right answer in the
  `choices` vector. Default is `1`.

- points:

  A numeric value, optional; the number of points for this gap. Default
  is `1`.

- shuffle:

  A boolean, optional; is responsible to randomize the order in which
  the choices are initially presented to the candidate. Default is
  `TRUE`.

- response_identifier:

  A character string, optional; an identifier for the answer.

## Value

A character string mapped as yaml.

## See also

[`gap_text()`](https://shevandrin.github.io/rqti/reference/gap_text.md),
[`gap_numeric()`](https://shevandrin.github.io/rqti/reference/gap_numeric.md),
[`mdlist()`](https://shevandrin.github.io/rqti/reference/mdlist.md)

## Examples

``` r
dropdown(c("Option A", "Option B"), response_identifier = "task_dd_list")
#> [1] "<gap>{choices: [Option A,Option B], solution_index: 1, points: 1, shuffle: yes, response_identifier: task_dd_list, type: InlineChoice}</gap>"
```
