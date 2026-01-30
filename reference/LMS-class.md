# LMS Class

The `LMS` class is an abstract representation of a Learning Management
System (LMS). It provides a foundation for defining LMS-specific
implementations.

## Slots

- `name`:

  A character string representing the name or identifier of the LMS.

- `api_user`:

  A character string containing the username for authentication.

- `endpoint`:

  A character string specifying the LMS API endpoint. By default, this
  value is retrieved from the environment variable `RQTI_API_ENDPOINT`.
  To set this variable globally, use:
  `Sys.setenv(RQTI_API_ENDPOINT = 'your_endpoint')`, or add it to your
  `.Renviron` file for persistence across sessions.
