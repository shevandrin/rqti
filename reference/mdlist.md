# Create a markdown list for answer options

Create a markdown list for answer options

## Usage

``` r
mdlist(vect, solutions = NULL, gaps = NULL)
```

## Arguments

- vect:

  A string or numeric vector of answer options for single/multiple
  choice task.

- solutions:

  An integer value, optional; indexes of right answer options in `vect`.

- gaps:

  numeric or string vector, optional; provides primitive gap description
  if there is a need to build a list of gaps.

## Value

A markdown list.

## See also

[`gap_text()`](https://shevandrin.github.io/rqti/reference/gap_text.md),
[`gap_numeric()`](https://shevandrin.github.io/rqti/reference/gap_numeric.md),
[`dropdown()`](https://shevandrin.github.io/rqti/reference/dropdown.md)

## Examples

``` r
#list for multiple choice task
mdlist(c("A", "B", "C"), c(2, 3))
#> [1] "- A\n- *B*\n- *C*"
# it returns:
#- A
#- *B*
#- *C*
#list of gaps
mdlist(c("A", "B", "C"), c(2, 3), c(1, 2, 3))
#> [1] "- A <gap>1</gap>\n- *B* <gap>2</gap>\n- *C* <gap>3</gap>"
# it returns:
#- A <gap>1</gap>
#- *B* <gap>2</gap>
#- *C* <gap>3</gap>
```
