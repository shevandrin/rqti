# Display a template variable in question content

Creates a
[TemplateVariableRef](https://shevandrin.github.io/rqti/maxima-preview/reference/TemplateVariableRef-class.md)
rendered as QTI `printedVariable`. Use it within an item's `content`
list or inline in an rqti Rmd document. The item must declare the
referenced variable in its `template` list when exported. This function
does not evaluate the variable or create an answer field.

## Usage

``` r
template_value(identifier)
```

## Arguments

- identifier:

  A single valid QTI identifier of the template variable.

## Value

A
[TemplateVariableRef](https://shevandrin.github.io/rqti/maxima-preview/reference/TemplateVariableRef-class.md)
object.

## See also

[`maxima_variables()`](https://shevandrin.github.io/rqti/maxima-preview/reference/maxima_variables.md),
[`entry()`](https://shevandrin.github.io/rqti/maxima-preview/reference/entry.md)

## Examples

``` r
reference <- template_value("a")
createText(reference)
#> <printedVariable identifier="a"></printedVariable>
```
