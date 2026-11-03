# Create XML file for exam test specification

Create XML file for exam test specification

## Usage

``` r
create_qti_test(
  object,
  path = ".",
  verification = FALSE,
  zip_only = FALSE,
  task_names = NULL
)
```

## Arguments

- object:

  an instance of the
  [AssessmentTest](https://shevandrin.github.io/rqti/maxima-preview/reference/AssessmentTest-class.md)
  S4 object

- path:

  string, optional; a path to folder to store zip file with possible
  file name; working directory by default

- verification:

  boolean, optional; checks the validity of the XML file. Default is
  `FALSE`.

- zip_only:

  boolean, optional; if TRUE, returns only the zip file. If FALSE,
  returns the zip, XML, and download files.

- task_names:

  Display naming policy: `"title"`, `"filename"`, `"both"`, or
  `"hidden"`. `NULL` uses option `rqti.task_names`, falling back to
  `"title"`. See
  [task_names](https://shevandrin.github.io/rqti/maxima-preview/reference/task_names.md).

## Value

xml document.
