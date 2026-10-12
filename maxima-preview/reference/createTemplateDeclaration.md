# Create QTI template declarations

Create QTI template declarations

## Usage

``` r
createTemplateDeclaration(object)

# S4 method for class 'MaximaVariables'
createTemplateDeclaration(object)

# S4 method for class 'AssessmentItem'
createTemplateDeclaration(object)
```

## Arguments

- object:

  A
  [MaximaVariables](https://shevandrin.github.io/rqti/maxima-preview/reference/MaximaVariables-class.md)
  or
  [AssessmentItem](https://shevandrin.github.io/rqti/maxima-preview/reference/AssessmentItem-class.md)
  object.

## Value

An `htmltools` tag list, or `NULL` for an item without templates.
