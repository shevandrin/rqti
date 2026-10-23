# Start qtijs renderer as a local server.

This function starts an http server with the qtijs renderer. The
renderer performs the conversion of qti.xml into HTML.

## Usage

``` r
start_server(qtijs_path = qtijs_pkg_path(), daemon = T)
```

## Arguments

- qtijs_path:

  The path to the qtijs renderer (qti.js), which will be served by the
  local preview server and to which xml files will be copied. Default is
  the folder used by the running preview server, or the installed
  package's QTIJS folder when no server is running. Knit sessions
  inherit the server's folder even when RStudio uses a development
  checkout.

- daemon:

  Run the server in the background. Use TRUE (the default) in RStudio.
  FALSE keeps serving until the R process exits, for example in tests.

## Value

The URL string of the qtijs server.

## Details

The server has to be started manually by the user, otherwise the
Knit-Button will not work. The Knit-Button starts a new session and
invoking a server there does not work. You can automatically start the
server via an .RProfile file on start up.

Maxima previews use locally installed Maxima through the R server and
work in both the RStudio Viewer and an external browser. Set
`options(rqti.maxima = "/path/to/maxima")` before starting the server to
pass that executable to RStudio's separate Knit session. On Windows, use
the command-line launcher, for example
`"C:/Program Files/Maxima/bin/maxima.bat"`, without shell quotes.

## Examples

``` r
if (FALSE) { # \dontrun{
start_server()
} # }
```
