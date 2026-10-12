# German grading scale

A helper function that returns a named numeric vector representing a
common German grading scheme. The names correspond to grades and the
values define the minimum proportion of points required to achieve the
respective grade.

## Usage

``` r
german_grading()
```

## Value

A named numeric vector with grades as names and minimum score
proportions as values.

## Examples

``` r
german_grading()
#>  1.0  1.3  1.7  2.0  2.3  2.7  3.0  3.3  3.7  4.0  5.0 
#> 0.95 0.90 0.85 0.80 0.75 0.70 0.65 0.60 0.55 0.50 0.00 

```
