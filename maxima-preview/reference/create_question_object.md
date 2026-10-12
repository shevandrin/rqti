# Create rqti S4 [AssessmentItem](https://shevandrin.github.io/rqti/maxima-preview/reference/AssessmentItem-class.md) Object from Rmd

Generates an rqti S4 AssessmentItem object
([SingleChoice](https://shevandrin.github.io/rqti/maxima-preview/reference/SingleChoice-class.md),
[MultipleChoice](https://shevandrin.github.io/rqti/maxima-preview/reference/MultipleChoice-class.md),
[Essay](https://shevandrin.github.io/rqti/maxima-preview/reference/Essay-class.md),
[Entry](https://shevandrin.github.io/rqti/maxima-preview/reference/Entry-class.md),
[Ordering](https://shevandrin.github.io/rqti/maxima-preview/reference/Ordering-class.md),
[OneInRowTable](https://shevandrin.github.io/rqti/maxima-preview/reference/OneInRowTable-class.md),
[OneInColTable](https://shevandrin.github.io/rqti/maxima-preview/reference/OneInColTable-class.md),
[MultipleChoiceTable](https://shevandrin.github.io/rqti/maxima-preview/reference/MultipleChoiceTable-class.md),
[DirectedPair](https://shevandrin.github.io/rqti/maxima-preview/reference/DirectedPair-class.md))
from an Rmd file.

## Usage

``` r
create_question_object(file)
```

## Arguments

- file:

  A string representing the path to an Rmd file.

## Value

One of the rqti S4 AssessmentItem objects:
[SingleChoice](https://shevandrin.github.io/rqti/maxima-preview/reference/SingleChoice-class.md),
[MultipleChoice](https://shevandrin.github.io/rqti/maxima-preview/reference/MultipleChoice-class.md),
[Essay](https://shevandrin.github.io/rqti/maxima-preview/reference/Essay-class.md),
[Entry](https://shevandrin.github.io/rqti/maxima-preview/reference/Entry-class.md),
[Ordering](https://shevandrin.github.io/rqti/maxima-preview/reference/Ordering-class.md),
[OneInRowTable](https://shevandrin.github.io/rqti/maxima-preview/reference/OneInRowTable-class.md),
[OneInColTable](https://shevandrin.github.io/rqti/maxima-preview/reference/OneInColTable-class.md),
[MultipleChoiceTable](https://shevandrin.github.io/rqti/maxima-preview/reference/MultipleChoiceTable-class.md),
or
[DirectedPair](https://shevandrin.github.io/rqti/maxima-preview/reference/DirectedPair-class.md).

## CSS in YAML

Use `stylesheet_path: styles.css` for a CSS file (or a YAML sequence of
files). Relative paths are resolved against the Rmd file's directory.
Use a YAML literal block `css: |` for CSS text. When both are supplied,
files are linked in the supplied order, followed by the CSS text.
Stylesheets are linked from the assessment item and included in QTI ZIPs
and their manifests. Standalone XML exports write CSS beside the XML in
a `styles/items/` subdirectory; keep that directory with the XML. These
fields do not convert inline HTML `style` attributes to classes. CSS
references such as `url(...)` and `@import` are not collected or
rewritten; use self-contained stylesheets. Rendering depends on the
delivery platform's CSS support.

## Maxima chunks

A `{maxima}` chunk stores its program in the item's template and
executes it locally using
[`maxima_check()`](https://shevandrin.github.io/rqti/maxima-preview/reference/maxima_check.md)
before conversion. Maxima must be installed; no R interface package is
required. Names and types are inferred from the program's returned
`string([...])` association list. Override this with explicit output
declarations using the chunk option
`variables = c(a = "integer", answer = "float")`. Supported types are
`integer`, `float`, and `string`; rational numbers and real numeric
constants map to `float`. Unsupported values require explicit types (for
example, `string` to display a list). Inference observes one random
variant, so use explicit types if output types can vary. Declared
outputs must exist in the returned list and have compatible types in the
checked variant. Use inline `template_value("a")` to display an output
and `gap_numeric(solution_variable = "answer")` to bind a numeric
correct answer. Displayed references are supported in the question body,
not in choices. Only one Maxima chunk is supported per Rmd exercise.
Combine all calculations in that chunk and return all named outputs
together. Its intermediate identifier is derived from the chunk label;
set `maxima_identifier` to override it. Template chunks must be
evaluated and uncached; errors stop export and upload. QTIJS previews
evaluate these programs through the local Maxima server. See
`inst/extdata/maxima-addition.Rmd` for a complete example.

## Examples

``` r
if (FALSE) { # interactive()
create_question_object("file.Rmd")
}
```
