# Compose a set of html elements to display question in qti-xml document

Generic function for creating a set of html elements to display question
for XML document of specification the question following the QTI schema
v2.1

## Usage

``` r
createText(object)

# S4 method for class 'Gap'
createText(object)

# S4 method for class 'InlineChoice'
createText(object)

# S4 method for class 'TemplateVariableRef'
createText(object)

# S4 method for class 'character'
createText(object)
```

## Arguments

- object:

  A
  [Gap](https://shevandrin.github.io/rqti/maxima-preview/reference/Gap-class.md),
  [InlineChoice](https://shevandrin.github.io/rqti/maxima-preview/reference/InlineChoice-class.md),
  [TemplateVariableRef](https://shevandrin.github.io/rqti/maxima-preview/reference/TemplateVariableRef-class.md),
  or character content fragment.

## Value

An HTML/XML tag or a character fragment marked as HTML.
