# Render an Rmd/md/xml file or rqti-object as qti xml with qtijs.

Generates the qti xml file via rmd2xml. The xml is copied into the qtijs
folder which transforms the xml into HTML. Finally, the HTML is
displayed and the user sees a preview of the exercise or test.

## Usage

``` r
render_qtijs(
  input,
  preview_feedback = FALSE,
  qtijs_path = qtijs_preview_path(),
  ...
)
```

## Arguments

- input:

  The path to the input Rmd/md/xml document or an
  [AssessmentItem](https://shevandrin.github.io/rqti/maxima-preview/reference/AssessmentItem-class.md),
  [AssessmentTest](https://shevandrin.github.io/rqti/maxima-preview/reference/AssessmentTest-class.md),
  [AssessmentTestOpal](https://shevandrin.github.io/rqti/maxima-preview/reference/AssessmentTestOpal-class.md),
  [AssessmentSection](https://shevandrin.github.io/rqti/maxima-preview/reference/AssessmentSection-class.md)
  object.

- preview_feedback:

  A boolean value; optional. Set `TRUE` value to always display feedback
  (for example, as a modal answer). Default is `FALSE`.

- qtijs_path:

  The path to the qtijs renderer (qti.js), which will be served by the
  local preview server and to which xml files will be copied. Default is
  the folder used by the running preview server, or the installed
  package's QTIJS folder when no server is running. Knit sessions
  inherit the server's folder even when RStudio uses a development
  checkout.

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
file <- system.file(
    "rmarkdown/templates/singlechoice-simple/skeleton/skeleton.Rmd",
    package='rqti'
)
render_qtijs(file)
}
```
