# Update the referenced learning resource of a course element in the LMS Opal

Update the referenced learning resource of a course element in the LMS
Opal

## Usage

``` r
# S4 method for class 'Opal'
updateCourseElementResource(
  object,
  course_id,
  node_id,
  resource_id,
  publish = TRUE
)
```

## Arguments

- object:

  An S4 object of class
  [LMS](https://shevandrin.github.io/rqti/reference/LMS-class.md) that
  represents a connection to the LMS.

- course_id:

  A character string with the course ID. You can find this in the
  course's details (Resource ID) in the LMS.

- node_id:

  A character string with the course element ID. This can be found, for
  example, in the course editor under the "Title and Description" tab of
  the respective course element in the LMS Opal.

- resource_id:

  A character string wiht the ID of the resource. This can be found in
  the details view of the desired resource within the LMS.

- publish:

  A boolean value that determines whether the course should be published
  after the resource is updated. If `TRUE` (default), the course will be
  published immediately after the update. If `FALSE`, the course will
  not be published automatically, leaving it in an unpublished state
  until manual publication.

## Value

The response of the HTTP request made to update the resource. If the
course is published, an additional message about the publishing status
is returned.
