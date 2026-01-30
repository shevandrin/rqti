# Verify QTI XML against XSD Schema QTI v2.1

This function validates a QTI XML document against the IMS QTI v2.1.2
XSD schema.

## Usage

``` r
verify_qti(doc, extended_scheme = FALSE)
```

## Arguments

- doc:

  A character string representing the path to the XML file or an `xml2`
  document object.

- extended_scheme:

  A boolean value that controls the version of the XSD schema used for
  validation. If `TRUE`, the extended version is used, allowing
  additional tags in the XML (e.g., `details`). Default is `FALSE`.

## Value

A logical value indicating whether the XML document is valid according
to the schema. If invalid, returns an object detailing the validation
errors.

## Examples

``` r
if (FALSE) { # \dontrun{
# Validate an XML file
result <- verify_qti("path/to/your/qti.xml")
} # }
```
