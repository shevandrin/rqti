# Get assessment scores for a course element

This method retrieves current assessment data for a course element on a
Learning Management System (LMS), including score, maximum score, passed
status, and attempts. If no LMS connection object is provided, it
attempts to guess the connection using default settings (e.g.,
environment variables). If the connection cannot be established, an
error is thrown.

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
  [LMS](https://shevandrin.github.io/rqti/reference/LMS-class.md) that
  represents a connection to the LMS.

- course_id:

  A length one character vector with course id.

- node_id:

  A length one character vector with course element id.

- user_id:

  A length one character vector with a user login name or email address.
  If `NULL`, assessments are returned for all users.

- ...:

  Additional arguments to be passed to the method, if applicable.

## Value

A data frame with assessment scores.

## Examples
