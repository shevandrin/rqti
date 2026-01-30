# Upload a resource on OPAL

Function `upload2opal()` takes full prepared zip archive of QTI-test or
QTI-task and uploads it to the OPAL.

## Usage

``` r
upload2opal(
  test,
  display_name = NULL,
  access = 4,
  overwrite = TRUE,
  endpoint = NULL,
  open_in_browser = TRUE,
  as_survey = FALSE,
  api_user = NULL
)
```

## Arguments

- test:

  A length one character vector of
  [AssessmentTest](https://shevandrin.github.io/rqti/reference/AssessmentTest-class.md),
  [AssessmentTestOpal](https://shevandrin.github.io/rqti/reference/AssessmentTestOpal-class.md)
  or
  [AssessmentItem](https://shevandrin.github.io/rqti/reference/AssessmentItem-class.md)
  objects, Rmd/md or XML files; required.

- display_name:

  A length one character vector to entitle file in OPAL; file name
  without extension by default; optional.

- access:

  An integer value, optional; it is responsible for publication status,
  where 1 - only those responsible for this learning resource; 2 -
  responsible and other authors; 3 - all registered users; 4 -
  registered users and guests. Default is 4.

- overwrite:

  A boolean value; if the value is `TRUE`, if only one file with the
  specified display name is found, it will be overwritten. Default is
  `TRUE`.

- endpoint:

  A string of endpoint of LMS Opal; by default it is got from
  environment variable `RQTI_API_ENDPOINT`. To set a global environment
  variable, you need to call
  `Sys.setenv(RQTI_API_ENDPOINT='xxxxxxxxxxxxxxx')` or you can put these
  command into .Renviron.

- open_in_browser:

  A boolean value; optional; it controls whether to open a URL in
  default browser. Default is `TRUE.`

- as_survey:

  A boolean value; optional; it controls resource type (test r survey).
  Default is `FALSE`.

- api_user:

  A character value of the username in the OPAL.

## Value

A list with the key, display name, and URL of the resource in Opal.

## Examples

``` r
if (FALSE) { # interactive()
file <- system.file("exercises/sc1.Rmd", package='rqti')
upload2opal(file, "task 1", open_in_browser = FALSE)
}
```
