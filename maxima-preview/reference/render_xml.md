# Render a single xml file with qtijs.

Uses qtijs to render a single xml file in the RStudio viewer pane with a
local server.

## Usage

``` r
render_xml(input, qtijs_path = qtijs_preview_path())
```

## Arguments

- input:

  The path to the input Rmd/md/xml document or an
  [AssessmentItem](https://shevandrin.github.io/rqti/maxima-preview/reference/AssessmentItem-class.md),
  [AssessmentTest](https://shevandrin.github.io/rqti/maxima-preview/reference/AssessmentTest-class.md),
  [AssessmentTestOpal](https://shevandrin.github.io/rqti/maxima-preview/reference/AssessmentTestOpal-class.md),
  [AssessmentSection](https://shevandrin.github.io/rqti/maxima-preview/reference/AssessmentSection-class.md)
  object.

- qtijs_path:

  The path to the qtijs renderer (qti.js), which will be served by the
  local preview server and to which xml files will be copied. Default is
  the folder used by the running preview server, or the installed
  package's QTIJS folder when no server is running. Knit sessions
  inherit the server's folder even when RStudio uses a development
  checkout.

## Value

nothing, has side effects

## Examples

``` r
if (FALSE) { # interactive()
  file <- system.file("extdata", "sc1d.xml", package = 'rqti')
  render_qtijs(file)
}
```
