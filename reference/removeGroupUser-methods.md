# Remove a user from a group

This method removes a user from a group on the Learning Management
System (LMS). If no LMS connection object is provided, it attempts to
guess the connection using default settings (e.g., environment
variables). If the connection cannot be established, an error is thrown.

This method removes a user from a learning group in LMS Opal by group id
and user id.

## Usage

``` r
removeGroupUser(object, group_id, user_id)

# S4 method for class 'missing'
removeGroupUser(object, group_id, user_id)

# S4 method for class 'Opal'
removeGroupUser(object, group_id, user_id)
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

Status code `200` if the user was removed successfully, or `NULL` when
OPAL rejects the request.

## Examples

``` r
if (FALSE) { # interactive()
removeGroupUser("442662912", "196610")
}
if (FALSE) { # interactive()
removeGroupUser("442662912", "196610")
}
```
