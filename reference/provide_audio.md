# Embed an audio file directly into HTML/XML using Base64 encoding

Designed for inline use in R Markdown, e.g.
`` `r provide_audio("media/klammer.wav")` ``.

## Usage

``` r
provide_audio(
  path,
  mime = NULL,
  method = c("object", "audio"),
  warn_size_mb = 5
)
```

## Arguments

- path:

  Path to the local audio file.

- mime:

  MIME type. If NULL, it is guessed from the extension.

- method:

  Rendering method:

  - "object" (default)

  - "audio"

- warn_size_mb:

  Warn if file is larger than this many MB.

## Value

knitr_asis object containing embedded audio HTML.

## Details

The function reads a local audio file, encodes it as Base64, and returns
either:

- an HTML tag

- or an HTML tag

This makes the final XML/HTML fully self-contained.
