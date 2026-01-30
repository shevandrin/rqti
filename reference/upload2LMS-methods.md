# Upload content to LMS

This is a generic function that handles the process of uploading content
to a Learning Management System (LMS). The content can be in the form of
an `AssessmentTest`, `AssessmentTestOpal`, `AssessmentItem` object, or a
file in Rmd, Markdown, zip or XML format.

This is a method that handles the process of uploading content to a
Learning Management System (LMS). The content can be in the form of an
`AssessmentTest`, `AssessmentTestOpal`, `AssessmentItem` object, or a
file in Rmd, Markdown, zip or XML format.

This is a generic function that handles the process of uploading content
to LMS Opal. The content can be in the form of an `AssessmentTest`,
`AssessmentTestOpal`, `AssessmentItem` object, or a file in Rmd,
Markdown, zip or XML format.

## Usage

``` r
upload2LMS(object, test, ...)

# S4 method for class 'LMS'
upload2LMS(object, test, ...)

# S4 method for class 'Opal'
upload2LMS(
  object,
  test,
  display_name = NULL,
  access = 4,
  overwrite = TRUE,
  open_in_browser = TRUE,
  as_survey = FALSE
)
```

## Arguments

- object:

  An S4 object representing the LMS, such as an instance of the
  [Opal](https://shevandrin.github.io/rqti/reference/Opal-class.md)
  class.

- test:

  An
  [AssessmentTest](https://shevandrin.github.io/rqti/reference/AssessmentTest-class.md),
  [AssessmentTestOpal](https://shevandrin.github.io/rqti/reference/AssessmentTestOpal-class.md)
  or
  [AssessmentItem](https://shevandrin.github.io/rqti/reference/AssessmentItem-class.md)
  objects, or a character string with path to Rmd/md, zip or XML files.

- ...:

  Additional arguments to be passed to the method, if applicable.

- display_name:

  A length one character vector to entitle resource in OPAL; file name
  without extension or identifier of the object by default; optional.

- access:

  An integer value, optional; it is responsible for publication status,
  where 1 - only those responsible for this learning resource; 2 -
  responsible and other authors; 3 - all registered users; 4 -
  registered users and guests. Default is 4.

- overwrite:

  A boolean value. If `TRUE`, and a file with the specified display name
  already exists, it will be overwritten. Default is `TRUE`.

- open_in_browser:

  A boolean value; optional; it controls whether to open a URL in
  default browser. Default is `TRUE.`

- as_survey:

  A boolean value, optional. If `TRUE`, the resource will be treated as
  a survey; if `FALSE`, as a test. Default is `FALSE`.
