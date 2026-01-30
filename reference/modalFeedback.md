# Create object [ModalFeedback](https://shevandrin.github.io/rqti/reference/ModalFeedback-class.md)

Create object
[ModalFeedback](https://shevandrin.github.io/rqti/reference/ModalFeedback-class.md)

## Usage

``` r
modalFeedback(content = list(), title = character(0), show = TRUE)
```

## Arguments

- content:

  A character string or a list of character strings to form the text of
  the question, which may include HTML tags.

- title:

  A character value, optional, representing the title of the modal
  feedback window.

- show:

  A boolean value, optional, determining whether to show (`TRUE`) or
  hide (`FALSE`) the modal feedback. Default is `TRUE`.

## Value

An object of class
[ModalFeedback](https://shevandrin.github.io/rqti/reference/ModalFeedback-class.md)

## Examples

``` r
fb <- modalFeedback(content = "Model answer", title = "Feedback")
```
