# Store credentials for an OPAL endpoint

Saves a password in the operating-system credential store. The service
name is derived automatically from `endpoint`, so separate OPAL
installations do not require a manually chosen credential ID. Existing
credentials stored under the legacy `rqtiopal` service remain available
as a fallback.

## Usage

``` r
set_opal_credentials(endpoint, api_user, credential_id = NA_character_)
```

## Arguments

- endpoint:

  A length-one character string containing the OPAL endpoint.

- api_user:

  A length-one character string containing the API username.

- credential_id:

  An optional explicit credential label. This is normally unnecessary
  and is retained for custom grouping and backward compatibility.

## Value

The derived keyring service name, invisibly.
