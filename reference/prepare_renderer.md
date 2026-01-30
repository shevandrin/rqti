# Prepare qtijs renderer.

Starts server for qtijs, returns path of qtijs and the url of the
server.

## Usage

``` r
prepare_renderer(qtijs_path = qtijs_pkg_path())
```

## Arguments

- qtijs_path:

  The path to the qtijs renderer (qti.js), which will be started with
  servr::httw and to which xml files will be copied. Default is the
  QTIJS folder in the R package rqti local installation via the helper
  qtijs_pkg_path().
