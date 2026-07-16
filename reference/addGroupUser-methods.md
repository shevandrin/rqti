# Add a user to a group

This method adds a user to a group on the Learning Management System
(LMS). If no LMS connection object is provided, it attempts to guess the
connection using default settings (e.g., environment variables). If the
connection cannot be established, an error is thrown.

This method adds a user to a learning group in LMS Opal by group id and
user id.

## Usage

``` r
addGroupUser(object, group_id, user_id)

# S4 method for class 'missing'
addGroupUser(object, group_id, user_id)

# S4 method for class 'Opal'
addGroupUser(object, group_id, user_id)
```

## Arguments

- object:

  An S4 object of class
  [Opal](https://shevandrin.github.io/rqti/reference/Opal-class.md) that
  represents a connection to the LMS.

- group_id:

  A character vector of length one specifying the group ID.

- user_id:

  A character vector of length one specifying the user ID.

## Value

Status code of the HTTP request.

Status code `200` if the user was added successfully, or `NULL` when
OPAL rejects the request.

## Examples

``` r
if (FALSE) { # interactive()
addGroupUser("442662912", "196610")
}
if (FALSE) { # interactive()
addGroupUser("442662912", "196610")
}
```
