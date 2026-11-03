# Render Rmd directly in Opal via API

Render Rmd directly in Opal via API

## Usage

``` r
render_opal(input, task_names = NULL, ...)
```

## Arguments

- input:

  (the path to the input Rmd document)

- task_names:

  Display naming policy: `"title"`, `"filename"`, `"both"`, or
  `"hidden"`. `NULL` uses option `rqti.task_names`, falling back to
  `"title"`. See
  [task_names](https://shevandrin.github.io/rqti/maxima-preview/reference/task_names.md).

- ...:

  Arguments supplied by the knitting frontend. Named `endpoint`,
  `api_user`, and `credential_id` arguments are forwarded to
  [`opal()`](https://shevandrin.github.io/rqti/maxima-preview/reference/opal.md).

## Value

A list with the key, display name, and URL of the resource in Opal.

## Details

Customize knit function in the Rmd file using the following YAML setting
after the word knit `knit: rqti::render_opal`.

## Examples

``` r
if (FALSE) { # interactive()
file <- system.file(
    "rmarkdown/templates/singlechoice-simple/skeleton/skeleton.Rmd",
    package='rqti'
)
render_opal(file)
}
```
