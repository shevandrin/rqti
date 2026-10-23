# Get an item's or interaction's score bounds

Get an item's or interaction's score bounds

## Usage

``` r
getScoreBounds(object)

# S4 method for class 'AssessmentItem'
getScoreBounds(object)

# S4 method for class 'Choice'
getScoreBounds(object)

# S4 method for class 'Entry'
getScoreBounds(object)

# S4 method for class 'Gap'
getScoreBounds(object)
```

## Arguments

- object:

  An assessment item or a gap interaction.

## Value

A numeric vector named `minimum` and `maximum`, in score points. These
are the bounds declared in QTI, not the current score or a guarantee
that both endpoints are attainable. Manual grading may leave a score
unset.

## Details

Choice bounds account for the selected scoring scheme. Entry bounds
combine its gap interactions. Extensions can define methods without
generating or parsing XML.

## Examples

``` r
getScoreBounds(singleChoice(choices = c("A", "B", "C"),
    points = 2, scoring_scheme = "penalty"))
#> minimum maximum 
#>      -1       2 
getScoreBounds(numericGap(12, points = 2, incorrect = -0.5))
#> minimum maximum 
#>    -0.5     2.0 
```
