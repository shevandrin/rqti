# Class Opal

The `Opal` class represents a specific implementation of a Learning
Management System (LMS) that extends the abstract `LMS` class. This
class is designed to facilitate interactions with the Opal LMS API.

## Slots

- `name`:

  A character string representing the name/identifier of the LMS.
  Defaults to `"Opal"`.

- `api_user`:

  A character string specifying the API username for authentication.

- `endpoint`:

  A character string containing the API endpoint of the Opal LMS. This
  can be set using the environment variable `RQTI_API_ENDPOINT` with
  `Sys.setenv(RQTI_API_ENDPOINT='xxxxxxxxxxxxxxx')` or placed in the
  `.Renviron` file.

## See also

[LMS-class](https://shevandrin.github.io/rqti/reference/LMS-class.md)
for the parent class.
