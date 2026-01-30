# Get select records about user resources by name.

This method retrieves data about a user's resource by its name on
Learning Management System (LMS). If no LMS connection object is
provided, it attempts to guess the connection using default settings
(e.g., environment variables). If the connection cannot be established,
an error is thrown.

## Usage

``` r
getLMSResourcesByName(object, ...)

# S4 method for class 'missing'
getLMSResourcesByName(object, display_name, rtype = NULL)

# S4 method for class 'Opal'
getLMSResourcesByName(object, display_name, rtype = NULL)
```

## Arguments

- object:

  An S4 object of class
  [Opal](https://shevandrin.github.io/rqti/reference/Opal-class.md) that
  represents a connection to the LMS.

- ...:

  Additional arguments to be passed to the method, if applicable.

- display_name:

  A string value withe the name of resource.

- rtype:

  A string value with the type of resource. Possible values:
  "FileResource.TEST", "FileResource.QUESTION", or
  "FileResource.SURVEY".

## Value

A dataframe with attributes of user's resources.

## Examples

``` r
if (FALSE) { # interactive()
df <- getLMSResourcesByName("task_name")
}
```
