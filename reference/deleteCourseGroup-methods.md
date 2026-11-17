# Delete a group from a course

This method removes a learning group from a course on the Learning
Management System (LMS). If no LMS connection object is provided, it
attempts to guess the connection using default settings (e.g.,
environment variables). If the connection cannot be established, an
error is thrown.

This method removes a learning group from an LMS Opal course (available
since OPAL 2026.10.2).

## Usage

``` r
deleteCourseGroup(object, course_id, group_id)

# S4 method for class 'missing'
deleteCourseGroup(object, course_id, group_id)

# S4 method for class 'Opal'
deleteCourseGroup(object, course_id, group_id)
```

## Arguments

- object:

  An S4 object of class
  [Opal](https://shevandrin.github.io/rqti/reference/Opal-class.md) that
  represents a connection to the LMS.

- course_id:

  A character vector of length one specifying the course context ID.

- group_id:

  A character vector of length one specifying the group ID.

## Value

Status code of the HTTP request.

Status code `200` if the group was deleted successfully, or `NULL` when
OPAL rejects the request.

## Examples

``` r
if (FALSE) { # interactive()
deleteCourseGroup(course_id = "12345678", group_id = "123456")
}
if (FALSE) { # interactive()
deleteCourseGroup(course_id = "12345678", group_id = "123456")
}
```
