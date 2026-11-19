# Prepare qtijs renderer.

Starts server for qtijs, returns path of qtijs and the url of the
server.

## Usage

``` r
prepare_renderer(qtijs_path = qtijs_preview_path())
```

## Arguments

- qtijs_path:

  The path to the qtijs renderer (qti.js), which will be served by the
  local preview server and to which xml files will be copied. Default is
  the folder used by the running preview server, or the installed
  package's QTIJS folder when no server is running. Knit sessions
  inherit the server's folder even when RStudio uses a development
  checkout.
