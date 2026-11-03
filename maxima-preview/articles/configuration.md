# Configuration

## R options

Set rqti options with
[`options()`](https://rdrr.io/r/base/options.html). Put the same calls
in `.Rprofile` to apply them in future R sessions.

### Maxima executable

If Maxima is not on PATH, set the full path to its executable or
launcher:

``` r

options(rqti.maxima = "/usr/bin/maxima")
# Windows example: use your installation's actual path
options(rqti.maxima = "C:/maxima-5.44.0/bin/maxima.bat")
```

See [Maxima
exercises](https://shevandrin.github.io/rqti/maxima-preview/articles/maxima.md)
for authoring and preview instructions.

### Exercise display names

`rqti.task_names` controls exercise names in previews, XML/ZIP exports,
and LMS uploads. Choose one of these values:

| Value | Display name |
|:---|:---|
| `"title"` (default) | Exercise title; source filename if the title is missing |
| `"filename"` | Source filename without its extension |
| `"both"` | `Title (filename)` |
| `"hidden"` | Generic labels such as `Task 1.1` |

``` r

options(rqti.task_names = "hidden")
```

A function’s `task_names` argument overrides the option for that call:

``` r

rqti::rmd2zip("exercise.Rmd", task_names = "both")
```

Display names do not change identifiers or exported filenames. See
[`help("task_names", package = "rqti")`](https://shevandrin.github.io/rqti/maxima-preview/reference/task_names.md)
for details.

Set `rqti.maxima` and `rqti.task_names` in the RStudio console;
subsequent Knit calls read these settings from the running preview
server without a restart.

## Environment variables

Environment variables use
[`Sys.setenv()`](https://rdrr.io/r/base/Sys.setenv.html) instead of
[`options()`](https://rdrr.io/r/base/options.html). For example, select
an OPAL instance with:

``` r

Sys.setenv(RQTI_API_ENDPOINT = "https://bildungsportal.sachsen.de/opal/")
```

For persistence, put
`RQTI_API_ENDPOINT=https://bildungsportal.sachsen.de/opal/` in
`.Renviron`. See [Workflow with the OPAL
API](https://shevandrin.github.io/rqti/maxima-preview/articles/api_opal.md)
for details. Preview connection variables are managed by rqti
automatically.
