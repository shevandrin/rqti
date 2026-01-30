# Create an URL using the resource's display name on LMS

This method creates an URL for user's resource by its name on Learning
Management System (LMS). If no LMS connection object is provided, it
attempts to guess the connection using default settings (e.g.,
environment variables). If the connection cannot be established, an
error is thrown.

## Usage

``` r
getLMSResourceURL(object, display_name)

# S4 method for class 'missing'
getLMSResourceURL(object, display_name)

# S4 method for class 'Opal'
getLMSResourceURL(object, display_name)
```

## Arguments

- object:

  An S4 object of class
  [Opal](https://shevandrin.github.io/rqti/reference/Opal-class.md) that
  represents a connection to the LMS.

- display_name:

  A length one character vector to entitle file in OPAL; it takes file
  name without extension by default; optional.

## Value

A string value of URL.
