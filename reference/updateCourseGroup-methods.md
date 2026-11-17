# Update a group in a course

This method updates a learning group in a course on the Learning
Management System (LMS). Only the properties supplied via `...` are
changed. If no LMS connection object is provided, it attempts to guess
the connection using default settings (e.g., environment variables). If
the connection cannot be established, an error is thrown.

This method updates a learning group in an LMS Opal course using OPAL's
`groupVO` XML representation (available since OPAL 2026.10.2). Only the
properties supplied as arguments are included in the request; all other
properties remain unchanged. The group properties waiting list, auto
promotion, enrollment period and sign-out deadline cannot be changed via
the REST API.

## Usage

``` r
updateCourseGroup(object, course_id, group_id, ...)

# S4 method for class 'missing'
updateCourseGroup(object, course_id, group_id, ...)

# S4 method for class 'Opal'
updateCourseGroup(
  object,
  course_id,
  group_id,
  name = NULL,
  description = NULL,
  minParticipants = NULL,
  maxParticipants = NULL,
  invitationEnabled = NULL,
  signoutEnabled = NULL
)
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

- ...:

  Additional arguments to be passed to the method, if applicable.

- name:

  A character vector of length one with the new group name, or `NULL` to
  leave the name unchanged. Defaults to `NULL`.

- description:

  A character vector of length one with the new group description, `""`
  to clear it, or `NULL` to leave it unchanged. Defaults to `NULL`.

- minParticipants:

  A single finite, non-negative whole number with the new minimum number
  of participants, or `NULL` to leave it unchanged. Defaults to `NULL`.

- maxParticipants:

  A single finite, non-negative whole number with the new maximum number
  of participants, or `NULL` to leave it unchanged. Defaults to `NULL`.

- invitationEnabled:

  A boolean value. If `TRUE`, invitations are enabled for new group
  members, or `NULL` to leave it unchanged. Defaults to `NULL`.

- signoutEnabled:

  A boolean value. If `TRUE`, members may leave the group themselves, or
  `NULL` to leave it unchanged. Defaults to `NULL`.

## Value

A data frame with the updated group attributes, or the status code of
the HTTP request.

A one-row data frame with the updated group attributes when OPAL returns
a `groupVO`, otherwise the status code of the HTTP request. Returns
`NULL` when OPAL rejects the request.

## Details

Note that renaming a group does not update course conditions: when the
group name is used in visibility or access rules, these rules must be
checked and updated manually in the course editor afterwards.

## Examples

``` r
if (FALSE) { # interactive()
group <- updateCourseGroup(course_id = "89068111333293",
                           group_id = "2691760214", name = "Thema 5")
}
if (FALSE) { # interactive()
group <- updateCourseGroup(
    course_id = "89068111333293",
    group_id = "2691760214",
    name = "Thema 5",
    description = "Gruppe zur Bearbeitung des Thema 5",
    minParticipants = 1,
    maxParticipants = 10,
    invitationEnabled = FALSE,
    signoutEnabled = FALSE
)
}
```
