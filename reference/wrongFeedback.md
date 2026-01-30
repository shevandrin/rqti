# Create object [WrongFeedback](https://shevandrin.github.io/rqti/reference/WrongFeedback-class.md)

Create object
[WrongFeedback](https://shevandrin.github.io/rqti/reference/WrongFeedback-class.md)

## Usage

``` r
wrongFeedback(content = list(), title = character(0), show = TRUE)
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
[WrongFeedback](https://shevandrin.github.io/rqti/reference/WrongFeedback-class.md)

## Examples

``` r
wfb <- wrongFeedback(content = "Some comments", title = "Feedback")
```
