# Maxima template calculation

Stores a Maxima program and the types of its named outputs. The program
is not executed in R. Template XML is generated when the containing
assessment item is exported. Rmd Maxima chunks are additionally checked
locally.

## Slots

- `code`:

  A single non-empty string containing the Maxima program.

- `variables`:

  A non-empty named character vector of output types: `integer`,
  `float`, or `string`. Each output has single cardinality. Names must
  start with an ASCII letter and contain only ASCII letters, digits, or
  underscores, so they can be used as Maxima symbols.

- `identifier`:

  A single QTI identifier for the intermediate string result. Defaults
  to `"all"`; must differ from all output names.

## Examples

``` r
variables <- new("MaximaVariables",
                 code = "string(['a = 1]);",
                 variables = c(a = "integer"))
item <- new("Essay", template = list(variables))
```
