# Get assessment scores for a course element

This method retrieves current assessment data for a course element on a
Learning Management System (LMS), including score, maximum score, passed
status, and attempts. If no LMS connection object is provided, it
attempts to guess the connection using default settings (e.g.,
environment variables). If the connection cannot be established, an
error is thrown.

This method retrieves current assessment data for a course element on
LMS Opal by course id and course element id. It returns user metadata
together with score, maximum score, passed status, and attempts. If
`user_id` is supplied, the query is restricted to that user login name
or email address.

## Usage

``` r
getCourseAssessment(object, course_id, node_id, user_id = NULL, ...)

# S4 method for class 'missing'
getCourseAssessment(object, course_id, node_id, user_id = NULL, ...)

# S4 method for class 'Opal'
getCourseAssessment(object, course_id, node_id, user_id = NULL)
```

## Arguments

- object:

  An S4 object of class
  [Opal](https://shevandrin.github.io/rqti/reference/Opal-class.md) that
  represents a connection to the LMS.

- course_id:

  A character vector of length one specifying the course context ID.

- node_id:

  A character vector of length one specifying the course element ID.

- user_id:

  A character vector of length one specifying the user login name or
  email address. If `NULL`, assessments are returned for all users.

- ...:

  Additional arguments to be passed to the method, if applicable.

## Value

A data frame with assessment scores.

A data frame with assessment scores. Each row represents a user and
contains identity id, user id, user name/email, score, maximum score,
passed status, and attempts.

## Examples

``` r
if (FALSE) { # interactive()
assessment <- getCourseAssessment("89068111333293", "1617337826161777006")
}
if (FALSE) { # interactive()
assessment <- getCourseAssessment("89068111333293", "1617337826161777006")
}
```
