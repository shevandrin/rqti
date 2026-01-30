# Get zip with course results by resource id and node id

This method retrieves zip with course results by its resource id and
node id on Learning Management System (LMS). If no LMS connection object
is provided, it attempts to guess the connection using default settings
(e.g., environment variables). If the connection cannot be established,
an error is thrown.

## Usage

``` r
getCourseResult(object, resource_id, node_id, path_outcome = ".", ...)

# S4 method for class 'missing'
getCourseResult(object, resource_id, node_id, path_outcome = ".", ...)

# S4 method for class 'Opal'
getCourseResult(
  object,
  resource_id,
  node_id,
  path_outcome = ".",
  rename = TRUE
)
```

## Arguments

- object:

  An S4 object of class
  [Opal](https://shevandrin.github.io/rqti/reference/Opal-class.md) that
  represents a connection to the LMS.

- resource_id:

  A length one character vector with resource id.

- node_id:

  A length one character vector with node id (test).

- path_outcome:

  A length one character vector with path, where the zip should be
  stored. Default is working directory.

- ...:

  Additional arguments to be passed to the method, if applicable.

- rename:

  A boolean value; optional; Set `TRUE` value to take the short name of
  the course element for naming zip (results_shortName.zip). `FALSE`
  combines in zip name course id and node id. Default is `TRUE`.

## Value

It downloads a zip and return a character string with path.

## Examples

``` r
if (FALSE) { # interactive()
zip_file <- getCourseResult("89068111333293", "1617337826161777006")
}
```
