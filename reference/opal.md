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

  An optional name for the credential set. By default, rqti derives the
  credential service from `endpoint`, while retaining the legacy
  `rqtiopal` service as a fallback. `RQTI_API_CREDENTIAL_ID` or an
  explicit value overrides automatic endpoint-based naming.

## Value

An object of class `Opal`, inheriting from `LMS`, which can be used to
interact with the Opal LMS API.

## Details

Interactive first-time setup still prompts for a username and password
when neither endpoint-specific nor legacy credentials exist. A legacy
`rqtiopal` entry is otherwise used as a fallback. Use
[`set_opal_credentials()`](https://shevandrin.github.io/rqti/reference/set_opal_credentials.md)
when an endpoint needs a different password.
