# Embed a local file as a downloadable hyperlink in R Markdown

Designed for inline use in R Markdown, e.g.
`` `r provide_file("attachment.pdf")` ``.

## Usage

``` r
provide_file(
  path,
  label = basename(path),
  mime = NULL,
  download = TRUE,
  warn_size_mb = 5
)
```

## Arguments

- path:

  Path to the local file.

- label:

  Text shown to the user. Defaults to the file name.

- mime:

  MIME type. If NULL, it is guessed from the extension.

- download:

  Logical. If TRUE, adds the HTML download attribute.

- warn_size_mb:

  Warn if file is larger than this many MB.

## Value

knitr_asis object with an HTML hyperlink.

## Details

The function reads a local file, encodes it as Base64, and returns an
HTML anchor tag with a data: URI. This allows the file to be embedded
directly into the rendered output instead of being referenced
externally.

The default HTML5 `download` attribute requests a download and suggests
a file name. It is accepted by `verify_qti(..., schema = "extended")`,
but is outside the standard QTI 2.1 schema. Set `download = FALSE` to
omit it; the browser may then display the resource instead of
downloading it, and the suggested file name is lost. In either case, the
target LMS and browser must support embedded data URIs. Schema
validation does not establish this support.
