# Validate QTI XML

S4 generic for validating QTI documents in various formats.

## Usage

``` r
verify_qti(
  doc,
  extended_schema = FALSE,
  ctx = 40,
  color = TRUE,
  engine = c("auto", "xml2", "xmllint"),
  ignore_import = TRUE,
  print = TRUE,
  schema = NULL
)

# S4 method for class 'character'
verify_qti(
  doc,
  extended_schema = FALSE,
  ctx = 40,
  color = TRUE,
  engine = c("auto", "xml2", "xmllint"),
  ignore_import = TRUE,
  print = TRUE,
  schema = NULL
)

# S4 method for class 'xml_document'
verify_qti(
  doc,
  extended_schema = FALSE,
  ctx = 40,
  color = TRUE,
  engine = c("auto", "xml2", "xmllint"),
  ignore_import = TRUE,
  print = TRUE,
  schema = NULL
)

# S4 method for class 'AssessmentItem'
verify_qti(
  doc,
  extended_schema = FALSE,
  ctx = 40,
  color = TRUE,
  engine = c("auto", "xml2", "xmllint"),
  ignore_import = TRUE,
  print = TRUE,
  schema = NULL
)

# S4 method for class 'AssessmentTest'
verify_qti(
  doc,
  extended_schema = FALSE,
  ctx = 40,
  color = TRUE,
  engine = c("auto", "xml2", "xmllint"),
  ignore_import = TRUE,
  print = TRUE,
  schema = NULL
)
```

## Arguments

- doc:

  A QTI document (file path, character string, xml_document, or S4
  object)

- extended_schema:

  Logical. Use extended rqti schema?

- ctx:

  Integer. Context characters for error snippets.

- color:

  Logical. Use ANSI colors?

- engine:

  Character. Validation backend ("auto", "xml2", "xmllint").

- ignore_import:

  Logical. Ignore import warnings?

- print:

  Logical. Print results?

- schema:

  Character string or `NULL`. Schema selector or custom XSD path.
  Supported selectors are `"qti21"`, `"extended"`, and `"qti22"`.
  Defaults to `NULL`, which uses the legacy `extended_schema` flag.

## Value

A `qti_validation_result` or `qti_validation_results_list` object.

## Functions

- `verify_qti(character)`: Validate character input (file path or XML
  string)

- `verify_qti(xml_document)`: Validate xml_document objects

- `verify_qti(AssessmentItem)`: Validate assessmentItem objects

- `verify_qti(AssessmentTest)`: Validate assessmentTest objects
