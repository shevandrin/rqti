# Get elements of the course by courseId from LMS

This method gets elements of the user's course by its courseId on
Learning Management System (LMS). If no LMS connection object is
provided, it attempts to guess the connection using default settings
(e.g., environment variables). If the connection cannot be established,
an error is thrown.

## Usage

``` r
getCourseElements(object, course_id)

# S4 method for class 'missing'
getCourseElements(object, course_id)

# S4 method for class 'Opal'
getCourseElements(object, course_id)
```

## Arguments

- object:

  An S4 object of class
  [Opal](https://shevandrin.github.io/rqti/reference/Opal-class.md) that
  represents a connection to the LMS.

- course_id:

  A length one character vector with course id.

## Value

A data frame with the elements of the course.

A data frame with the data of the elements of the course (fields:
nodeId, shortTitle, shortName, longTitle) on LMS Opal.
