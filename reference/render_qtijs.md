# Render an Rmd/md/xml file or rqti-object as qti xml with qtijs.

Generates the qti xml file via rmd2xml. The xml is copied into the qtijs
folder which transforms the xml into HTML. Finally, the HTML is
displayed and the user sees a preview of the exercise or test.

## Usage

``` r
render_qtijs(
  input,
  preview_feedback = FALSE,
  qtijs_path = qtijs_pkg_path(),
  ...
)
```

## Arguments

- input:

  The path to the input Rmd/md/xml document or an
  [AssessmentItem](https://shevandrin.github.io/rqti/reference/AssessmentItem-class.md),
  [AssessmentTest](https://shevandrin.github.io/rqti/reference/AssessmentTest-class.md),
  [AssessmentTestOpal](https://shevandrin.github.io/rqti/reference/AssessmentTestOpal-class.md),
  [AssessmentSection](https://shevandrin.github.io/rqti/reference/AssessmentSection-class.md)
  object.

- preview_feedback:

  A boolean value; optional. Set `TRUE` value to always display feedback
  (for example, as a modal answer). Default is `FALSE`.

- qtijs_path:

  The path to the qtijs renderer (qti.js), which will be started with
  servr::httw and to which xml files will be copied. Default is the
  QTIJS folder in the R package rqti local installation via the helper
  qtijs_pkg_path().

- ...:

  required for passing arguments when knitting

## Value

An URL of the corresponding local server to display the rendering
result.

## Details

Requires a running qtijs server, which can be started with
start_server().

The preview is automatically loaded into the RStudio viewer pane if run
in RStudio. Alternatively you can just open the browser at the
corresponding local server url which is displayed after rendering is
finished. Since the function is supposed to be called via the
Knit-Button in RStudio, it defaults to the RStudio viewer pane.

Customize knit function in the Rmd file using the following YAML setting
after the word knit `knit: rqti::render_qtijs`.

## Examples

``` r
if (FALSE) { # interactive()
  file <- system.file("exercises/sc1.Rmd", package = 'rqti')
  render_qtijs(file)
}
```
