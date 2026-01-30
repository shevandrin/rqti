# Constructor function for class QtiContributor

Creates object of
[QtiContributor](https://shevandrin.github.io/rqti/reference/QtiContributor-class.md)-class

## Usage

``` r
qtiContributor(
  name = Sys.getenv("RQTI_AUTHOR"),
  role = "author",
  contribution_date = ifelse(name != "", Sys.Date(), NA_Date_)
)
```

## Arguments

- name:

  A character string representing the name of the author.

- role:

  A character string kind of contribution. Possible values: author,
  publisher, unknown, initiator, terminator, validator, editor,
  graphical designer, technical implementer, content provider, technical
  validator, educational validator, script writer, instructional
  designer, subject matter expert. Default is "author".

- contribution_date:

  A character string representing date of the contribution. Default is
  the current system date, when contributor is assigned.

## Examples

``` r
creator= qtiContributor("Max Mustermann", "technical validator")
```
