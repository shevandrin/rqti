# Start qtijs renderer as a local server.

This function starts an http server with the qtijs renderer. The
renderer performs the conversion of qti.xml into HTML.

## Usage

``` r
start_server(qtijs_path = qtijs_pkg_path(), daemon = T)
```

## Arguments

- qtijs_path:

  The path to the qtijs renderer (qti.js), which will be started with
  servr::httw and to which xml files will be copied. Default is the
  QTIJS folder in the R package rqti local installation via the helper
  qtijs_pkg_path().

- daemon:

  This parameter is forwarded to
  [`servr::httw`](https://rdrr.io/pkg/servr/man/httd.html) and should
  always be TRUE (the default). FALSE is only used for testing purposes
  when called via `callr::bg()`

## Value

The URL string of the qtijs server.

## Details

The server has to be started manually by the user, otherwise the
Knit-Button will not work. The Knit-Button starts a new session and
invoking a server there does not work. You can automatically start the
server via an .RProfile file on start up.

## Examples

``` r
if (FALSE) { # \dontrun{
start_server()
} # }
```
