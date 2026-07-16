# Create a group in a course

This method creates a group in a course on the Learning Management
System (LMS). If no LMS connection object is provided, it attempts to
guess the connection using default settings (e.g., environment
variables). If the connection cannot be established, an error is thrown.

This method creates a learning group in an LMS Opal course using OPAL's
`GroupVO` XML representation. The group name must be unique within the
course. `invitationEnabled` controls whether new group members receive
an invitation that has to be accepted; `signoutEnabled` controls whether
members may leave the group themselves.

## Usage

``` r
createCourseGroup(object, course_id, name, ...)

# S4 method for class 'missing'
createCourseGroup(object, course_id, name, ...)

# S4 method for class 'Opal'
createCourseGroup(
  object,
  course_id,
  name,
  description = "",
  minParticipants = 0,
  maxParticipants = 0,
  invitationEnabled = TRUE,
  signoutEnabled = TRUE
)
```

## Arguments

- object:

  An S4 object of class
  [Opal](https://shevandrin.github.io/rqti/reference/Opal-class.md) that
  represents a connection to the LMS.

- course_id:

  A character vector of length one specifying the course resource ID.
  Note that this is not the course ID shown in the URL, but a longer
  identifier available via the "Show more information" option within the
  course.

- name:

  A character vector of length one with the group name.

- ...:

  Additional arguments to be passed to the method, if applicable.

- description:

  A character vector of length one with the group description. Defaults
  to an empty string.

- minParticipants:

  A numeric value with the minimum number of participants. Defaults to
  `0`.

- maxParticipants:

  A numeric value with the maximum number of participants. Defaults to
  `0`.

- invitationEnabled:

  A boolean value. If `TRUE`, invitations are enabled for new group
  members. Defaults to `TRUE`.

- signoutEnabled:

  A boolean value. If `TRUE`, members may leave the group themselves.
  Defaults to `TRUE`.

## Value

A data frame with the created group attributes.

A one-row data frame with the created group attributes, or `NULL` when
OPAL rejects the request.

## Examples

``` r
if (FALSE) { # interactive()
group <- createCourseGroup("89068111333293", "Topic 5")
}
if (FALSE) { # interactive()
group <- createCourseGroup(
    "89068111333293",
    "Topic 5",
    description = "Group for topic 5",
    minParticipants = 1,
    maxParticipants = 1,
    invitationEnabled = FALSE,
    signoutEnabled = FALSE
)
}
```
