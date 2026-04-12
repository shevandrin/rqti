# Get users from a group

This method retrieves users from a group on the Learning Management
System (LMS) by its group id. It returns a data frame with all
accessible attributes of the group members. If no LMS connection object
is provided, it attempts to guess the connection using default settings
(e.g., environment variables). If the connection cannot be established,
an error is thrown.

This method retrieves users from a group on LMS Opal by its group id. It
returns a data frame with user attributes obtained from the LMS,
including user id, login, first name, last name, email, and additional
properties (e.g., status). If no Opal connection object is provided, it
attempts to guess the connection using default settings (e.g.,
environment variables). If the connection cannot be established, an
error is thrown.

## Usage

``` r
getGroupUsers(object, group_id)

# S4 method for class 'missing'
getGroupUsers(object, group_id)

# S4 method for class 'Opal'
getGroupUsers(object, group_id)
```

## Arguments

- object:

  An S4 object of class
  [Opal](https://shevandrin.github.io/rqti/reference/Opal-class.md) that
  represents a connection to the LMS.

- group_id:

  A character vector specifying the group id.

## Value

A data frame with all accessible attributes of the group members.

A data frame with group users and their attributes. Each row represents
a user and may include the following columns:

- key:

  Unique user id.

- login:

  User login name.

- firstName:

  User first name.

- lastName:

  User last name.

- email:

  User email address.

- status:

  User status (e.g., `STATUS_ACTIVE`).

## Examples

``` r
if (FALSE) { # interactive()
groups <- getGroupUsers("89068111333293")
}
if (FALSE) { # interactive()
users <- getGroupUsers("89068111333293")
}
```
