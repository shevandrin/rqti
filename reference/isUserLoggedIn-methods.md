# Check if User is Logged in LMS

This method checks whether a user is logged into an LMS (Learning
Management System) by sending a request to the LMS server and evaluating
the response.

This method checks whether a user is logged into an LMS Opal by sending
a request to the LMS server and evaluating the response.

## Usage

``` r
isUserLoggedIn(object)

# S4 method for class 'Opal'
isUserLoggedIn(object)
```

## Arguments

- object:

  An S4 object of class
  [Opal](https://shevandrin.github.io/rqti/reference/Opal-class.md) that
  represents a connection to the LMS.

## Value

A logical value (`TRUE` if the user is logged in, `FALSE` otherwise).

A logical value (`TRUE` if the user is logged in, `FALSE` otherwise).
