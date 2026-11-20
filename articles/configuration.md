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
exercises](https://shevandrin.github.io/rqti/articles/maxima.md) for
authoring and preview instructions.

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
[`help("task_names", package = "rqti")`](https://shevandrin.github.io/rqti/reference/task_names.md)
for details.

### QTI version

rqti exports QTI 2.1 by default. Set `rqti.qti_version` to `"2.2"` to
export items, tests and content packages in the QTI 2.2 namespace:

``` r

options(rqti.qti_version = "2.2")
```

A function’s `qti_version` argument overrides the option for that call,
for example to export one test in both versions:

``` r

createQtiTest(exam, dir = "qti21", qti_version = "2.1")
createQtiTest(exam, dir = "qti22", qti_version = "2.2")
```

[`verify_qti()`](https://shevandrin.github.io/rqti/reference/verify_qti.md)
then validates the exported documents against the bundled QTI 2.2
schema. Check that your LMS imports QTI 2.2 before switching.
LMS-specific extensions, such as OPAL’s tolerant text gaps
([`textGapOpal()`](https://shevandrin.github.io/rqti/reference/textGapOpal_doc.md)),
Maxima templates and `rebuildVariables`, are defined for QTI 2.1 and are
not valid QTI 2.2 either.

Set `rqti.maxima`, `rqti.task_names` and `rqti.qti_version` in the
RStudio console; subsequent Knit calls read these settings from the
running preview server without a restart.

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
API](https://shevandrin.github.io/rqti/articles/api_opal.md) for
details. Preview connection variables are managed by rqti automatically.
