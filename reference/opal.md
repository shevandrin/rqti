# Create an Opal LMS Connection Object

This helper function initializes an `Opal` object, a subclass of `LMS`,
representing a connection to the Opal Learning Management System (LMS).

## Usage

``` r
opal(
  api_user = NA_character_,
  endpoint = NA_character_,
  credential_id = NA_character_
)
```

## Arguments

- api_user:

  A character string specifying the API username.

- endpoint:

  A character string specifying the API endpoint for the LMS.

- credential_id:

  An optional name for the credential set. By default, rqti continues to
  use the legacy `rqtiopal` service. Supply an ID to use a separate
  password for another OPAL installation.

## Value

An object of class `Opal`, inheriting from `LMS`, which can be used to
interact with the Opal LMS API.
