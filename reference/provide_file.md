# Embed a local file as a downloadable hyperlink in R Markdown

Designed for inline use in R Markdown, e.g. "r
provide_file("attachment.pdf")"

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
tag with a data: URI. This allows the file to be embedded directly into
the rendered output instead of being referenced externally.
