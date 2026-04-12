# Get groups from a course

This method retrieves groups from a course on the Learning Management
System (LMS) by its course id. It returns a data frame with all
accessible attributes of the groups. If no LMS connection object is
provided, it attempts to guess the connection using default settings
(e.g., environment variables). If the connection cannot be established,
an error is thrown.

This method retrieves groups from a course on LMS Opal by its course id.
The groups are returned as a data frame with all accessible attributes,
such as group id, name, description, participant limits, and group
settings. If no Opal connection object is provided, it attempts to guess
the connection using default settings (e.g., environment variables). If
the connection cannot be established, an error is thrown.

## Usage

``` r
getCourseGroups(object, course_id)

# S4 method for class 'missing'
getCourseGroups(object, course_id)

# S4 method for class 'Opal'
getCourseGroups(object, course_id)
```

## Arguments

- object:

  An S4 object of class
  [Opal](https://shevandrin.github.io/rqti/reference/Opal-class.md) that
  represents a connection to the LMS.

- course_id:

  A length one character vector specifying the course id.

## Value

A data frame with all accessible attributes of the course groups.

A data frame with course groups and their attributes.

## Examples

``` r
if (FALSE) { # interactive()
groups <- getCourseGroups("89068111333293")
}
if (FALSE) { # interactive()
groups <- getCourseGroups("89068111333293")
}
```
