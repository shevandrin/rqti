# Describe a Maxima calculation and its outputs

Creates a
[MaximaVariables](https://shevandrin.github.io/rqti/maxima-preview/reference/MaximaVariables-class.md)
object for an assessment item's `template` list. With explicit types,
this function stores the program without executing it. Without types, it
runs the program locally to inspect the returned outputs. The exported
XML uses OPAL/ONYX MAXIMA operators; validation requires the extended
rqti schema. In rqti Rmd files, use a `{maxima}` chunk. Output types are
inferred from one local execution unless a named `variables` vector is
supplied. Its code is checked locally before item creation, including
declared names/types.

## Usage

``` r
maxima_variables(code, variables = NULL, identifier = "all")
```

## Arguments

- code:

  A single non-empty string containing the Maxima program. It must
  return a string representation of associations for the named outputs.

- variables:

  A non-empty named character vector of QTI output types: `integer`,
  `float`, or `string`. Names start with an ASCII letter and contain
  only ASCII letters, digits, or underscores. All outputs have single
  cardinality. If omitted, the code is executed locally and types are
  detected from one returned association list. Explicit types can be
  used for outputs whose type varies across random variants or for
  string display of lists.

- identifier:

  The QTI identifier for the intermediate string result. Defaults to
  `"all"`. Use distinct identifiers for multiple blocks.

## Value

A
[MaximaVariables](https://shevandrin.github.io/rqti/maxima-preview/reference/MaximaVariables-class.md)
object.

## See also

[`template_value()`](https://shevandrin.github.io/rqti/maxima-preview/reference/template_value.md),
[`numericGap()`](https://shevandrin.github.io/rqti/maxima-preview/reference/numericGap_doc.md),
[`entry()`](https://shevandrin.github.io/rqti/maxima-preview/reference/entry.md)

## Examples

``` r
calculation <- maxima_variables(
    code = "block([a,b,c], a: random(100), b: random(100),
             c: a + b, string(['a = a, 'b = b, 'c = c]));",
    variables = c(a = "integer", b = "integer", c = "integer")
)
item <- entry(
    identifier = "addition",
    template = list(calculation),
    content = list("<p>", template_value("a"), " + ", template_value("b"),
                   " = ", numericGap(solution_variable = "c"), "</p>")
)
createTemplateDeclaration(item)
#> <templateDeclaration identifier="all" cardinality="single" baseType="string"></templateDeclaration>
#> <templateDeclaration identifier="a" cardinality="single" baseType="integer"></templateDeclaration>
#> <templateDeclaration identifier="b" cardinality="single" baseType="integer"></templateDeclaration>
#> <templateDeclaration identifier="c" cardinality="single" baseType="integer"></templateDeclaration>
createTemplateProcessing(item)
#> <templateProcessing>
#>   <setTemplateValue identifier="all">
#>     <customOperator definition="MAXIMA" value="block([a,b,c], a: random(100), b: random(100),&amp;#xA;&amp;#xD;             c: a + b, string([&amp;#x27;a = a, &amp;#x27;b = b, &amp;#x27;c = c]));"></customOperator>
#>   </setTemplateValue>
#>   <setTemplateValue identifier="a">
#>     <customOperator definition="MAXIMA" value="assoc(a,$(1));">
#>       <variable identifier="all"></variable>
#>     </customOperator>
#>   </setTemplateValue>
#>   <setTemplateValue identifier="b">
#>     <customOperator definition="MAXIMA" value="assoc(b,$(1));">
#>       <variable identifier="all"></variable>
#>     </customOperator>
#>   </setTemplateValue>
#>   <setTemplateValue identifier="c">
#>     <customOperator definition="MAXIMA" value="assoc(c,$(1));">
#>       <variable identifier="all"></variable>
#>     </customOperator>
#>   </setTemplateValue>
#>   <setCorrectResponse identifier="id_gap_9686">
#>     <variable identifier="c"></variable>
#>   </setCorrectResponse>
#> </templateProcessing>
createItemBody(item)
#> <itemBody>
#>   <div>
#>     <p>
#>     <printedVariable identifier="a"></printedVariable>
#>      + 
#>     <printedVariable identifier="b"></printedVariable>
#>      = 
#>     <textEntryInteraction responseIdentifier="id_gap_9686" expectedLength="10" placeholderText=""></textEntryInteraction>
#>     </p>
#>   </div>
#> </itemBody>
```
