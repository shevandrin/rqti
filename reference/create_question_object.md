# Create rqti S4 [AssessmentItem](https://shevandrin.github.io/rqti/reference/AssessmentItem-class.md) Object from Rmd

Generates an rqti S4 AssessmentItem object
([SingleChoice](https://shevandrin.github.io/rqti/reference/SingleChoice-class.md),
[MultipleChoice](https://shevandrin.github.io/rqti/reference/MultipleChoice-class.md),
[Essay](https://shevandrin.github.io/rqti/reference/Essay-class.md),
[Entry](https://shevandrin.github.io/rqti/reference/Entry-class.md),
[Ordering](https://shevandrin.github.io/rqti/reference/Ordering-class.md),
[OneInRowTable](https://shevandrin.github.io/rqti/reference/OneInRowTable-class.md),
[OneInColTable](https://shevandrin.github.io/rqti/reference/OneInColTable-class.md),
[MultipleChoiceTable](https://shevandrin.github.io/rqti/reference/MultipleChoiceTable-class.md),
[DirectedPair](https://shevandrin.github.io/rqti/reference/DirectedPair-class.md))
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
[SingleChoice](https://shevandrin.github.io/rqti/reference/SingleChoice-class.md),
[MultipleChoice](https://shevandrin.github.io/rqti/reference/MultipleChoice-class.md),
[Essay](https://shevandrin.github.io/rqti/reference/Essay-class.md),
[Entry](https://shevandrin.github.io/rqti/reference/Entry-class.md),
[Ordering](https://shevandrin.github.io/rqti/reference/Ordering-class.md),
[OneInRowTable](https://shevandrin.github.io/rqti/reference/OneInRowTable-class.md),
[OneInColTable](https://shevandrin.github.io/rqti/reference/OneInColTable-class.md),
[MultipleChoiceTable](https://shevandrin.github.io/rqti/reference/MultipleChoiceTable-class.md),
or
[DirectedPair](https://shevandrin.github.io/rqti/reference/DirectedPair-class.md).

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

## Examples

``` r
if (FALSE) { # interactive()
create_question_object("file.Rmd")
}
```
