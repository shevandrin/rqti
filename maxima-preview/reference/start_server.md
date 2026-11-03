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
work in both the RStudio Viewer and an external browser. Select a
command name, for example `options(rqti.maxima = "maxima")`, or the full
path to an executable/launcher. A directory alone is invalid. On Windows
the launcher may be `maxima.bat`; `Sys.which("maxima")` may also resolve
it without the suffix. Use the name/path that works locally. The server
and separate Knit sessions read current console options; changing
`rqti.maxima` or `rqti.task_names` does not require a server restart.
These are R options, not environment variables. Set them with
[`options()`](https://rdrr.io/r/base/options.html); use `.Rprofile` to
persist them. Internal process-connection variables are managed by rqti.

## Examples

``` r
if (FALSE) { # \dontrun{
start_server()
} # }
```
