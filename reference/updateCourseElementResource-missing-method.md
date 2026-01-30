# Update the referenced learning resource of a course element in the LMS

This method updates the learning resource by its course id on Learning
Management System (LMS). If no LMS connection object is provided, it
attempts to guess the connection using default settings (e.g.,
environment variables). If the connection cannot be established, an
error is thrown.

## Usage

``` r
# S4 method for class 'missing'
updateCourseElementResource(object, course_id, ...)
```

## Arguments

- object:

  An S4 object of class
  [LMS](https://shevandrin.github.io/rqti/reference/LMS-class.md) that
  represents a connection to the LMS.

- course_id:

  A character string with course id in the LMS.

- ...:

  Additional arguments to be passed to the method, if applicable.

## Value

Response of the HTTP request.
