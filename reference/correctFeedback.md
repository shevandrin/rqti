# Create object [CorrectFeedback](https://shevandrin.github.io/rqti/reference/CorrectFeedback-class.md)

Create object
[CorrectFeedback](https://shevandrin.github.io/rqti/reference/CorrectFeedback-class.md)

## Usage

``` r
correctFeedback(content = list(), title = character(0), show = TRUE)
```

## Arguments

- content:

  A character string or a list of character strings to form the text of
  the question, which may include HTML tags.

- title:

  A character value, optional, representing the title of the feedback
  window.

- show:

  A boolean value, optional, determining whether to show (`TRUE`) or
  hide (`FALSE`) the feedback. Default is `TRUE`.

## Value

An object of class
[CorrectFeedback](https://shevandrin.github.io/rqti/reference/CorrectFeedback-class.md)

## Examples

``` r
cfb <- correctFeedback(content = "Some comments", title = "Feedback")
```
