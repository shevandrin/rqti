# Reference to a template variable in item content

Use this object in an assessment item's `content` list to display a
template variable using QTI `printedVariable`. It does not define an
answer field or contribute points. When the complete item is exported,
the referenced name must be declared in its `template` list. Both named
outputs and intermediate result identifiers can be referenced. In Rmd,
use
[`template_value()`](https://shevandrin.github.io/rqti/maxima-preview/reference/template_value.md)
inline.

## Slots

- `identifier`:

  A single valid QTI identifier of the template variable.

## Examples

``` r
variables <- new("MaximaVariables", code = "string(['a = 1]);",
                 variables = c(a = "integer"))
reference <- new("TemplateVariableRef", identifier = "a")
item <- new("Entry", template = list(variables),
            content = list("<p>Enter ", reference, ": ",
                           numericGap(1), "</p>"))
createItemBody(item)
#> <itemBody>
#>   <div>
#>     <p>Enter 
#>     <printedVariable identifier="a"></printedVariable>
#>     : 
#>     <textEntryInteraction responseIdentifier="id_gap_0551" expectedLength="1" placeholderText=""></textEntryInteraction>
#>     </p>
#>   </div>
#> </itemBody>
```
