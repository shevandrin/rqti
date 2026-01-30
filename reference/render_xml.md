# Render a single xml file with qtijs.

Uses qtijs to render a single xml file in the RStudio viewer pane with a
local server.

## Usage

``` r
render_xml(input, qtijs_path = qtijs_pkg_path())
```

## Arguments

- input:

  The path to the input Rmd/md/xml document or an
  [AssessmentItem](https://shevandrin.github.io/rqti/reference/AssessmentItem-class.md),
  [AssessmentTest](https://shevandrin.github.io/rqti/reference/AssessmentTest-class.md),
  [AssessmentTestOpal](https://shevandrin.github.io/rqti/reference/AssessmentTestOpal-class.md),
  [AssessmentSection](https://shevandrin.github.io/rqti/reference/AssessmentSection-class.md)
  object.

- qtijs_path:

  The path to the qtijs renderer (qti.js), which will be started with
  servr::httw and to which xml files will be copied. Default is the
  QTIJS folder in the R package rqti local installation via the helper
  qtijs_pkg_path().

## Value

nothing, has side effects

## Examples

``` r
if (FALSE) { # interactive()
  file <- system.file("exercises/sc1d.xml", package = 'rqti')
  render_qtijs(file)
}
```
