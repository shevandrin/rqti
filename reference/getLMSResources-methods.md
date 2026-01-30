# Get records of all current user's resources on LMS

This method retrieves data about all resources associated with the
current user on the Learning Management System (LMS). If no LMS
connection object is provided, it attempts to guess the connection using
default settings (e.g., environment variables). If the connection cannot
be established, an error is thrown.

## Usage

``` r
getLMSResources(object, ...)

# S4 method for class 'missing'
getLMSResources(object)

# S4 method for class 'Opal'
getLMSResources(object)
```

## Arguments

- object:

  An S4 object of class
  [Opal](https://shevandrin.github.io/rqti/reference/Opal-class.md) that
  represents a connection to the LMS.

- ...:

  Additional arguments to be passed to the method, if applicable.

## Value

A dataframe with attributes of user's resources.
