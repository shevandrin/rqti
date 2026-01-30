# Render Rmd directly in Opal via API

Render Rmd directly in Opal via API

## Usage

``` r
render_opal(input, ...)
```

## Arguments

- input:

  (the path to the input Rmd document)

- ...:

  required for passing arguments when knitting

## Value

A list with the key, display name, and URL of the resource in Opal.

## Details

Customize knit function in the Rmd file using the following YAML setting
after the word knit `knit: rqti::render_opal`.

## Examples

``` r
if (FALSE) { # interactive()
  file <- system.file("exercises/sc1.Rmd", package = 'rqti')
  render_opal(file)
}
```
