# Validate an XML document against the QTI schema

Validates an XML document against the QTI schema or the extended rqti
QTI schema. Input can be either a file path, a character string
containing XML, or an `xml2::xml_document`.

## Usage

``` r
verify_qti_impl(
  doc,
  extended_schema = FALSE,
  ctx = 40,
  color = TRUE,
  engine = c("auto", "xml2", "xmllint"),
  ignore_import = TRUE,
  print = TRUE
)
```

## Arguments

- doc:

  A QTI XML document. This can be a file path, a character string
  containing XML, or an `xml2::xml_document`.

- extended_schema:

  Logical. Should the extended rqti schema be used? Defaults to `FALSE`.

- ctx:

  Integer. Number of characters of context shown before and after the
  offending XML element in printed snippets. Defaults to `40`.

- color:

  Logical. Should ANSI colors be used in printed output? Defaults to
  `TRUE`.

- engine:

  Character string specifying the validation backend. One of `"auto"`,
  `"xml2"`, or `"xmllint"`. Defaults to `"auto"`.

- ignore_import:

  Logical. If `TRUE`, warnings related to `<import>` statements in the
  schema are ignored. Default is `TRUE` because rqti uses a locally
  saved schema instead of downloading from the internet.

- print:

  Logical. Should the validation result be printed before it is
  returned? Defaults to `TRUE`.

## Value

An object of class `"qti_validation_result"` with components:

- valid:

  Logical scalar.

- errors:

  A list of parsed validation errors.

- engine:

  The backend used for validation.

## Details

By default, the function chooses a validation backend automatically. If
`xmllint` is available, the input is a file path, and the platform is
not Windows, the `xmllint` backend is used. Otherwise, validation falls
back to `xml2`.

The function returns an object of class `"qti_validation_result"`. By
default, that object is also printed in a human-readable form.

## Examples

``` r
if (FALSE) { # \dontrun{
f <- system.file("exercises", "sc1d.xml", package = "rqti")

res <- verify_qti(f)
res$valid

x <- xml2::read_xml(f)
res2 <- verify_qti(x)

summary(res2)
} # }
```
