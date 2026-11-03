# Exercise display names in previews and exports

`options(rqti.task_names = "title")` selects a shared naming policy for
qti.js previews, XML/ZIP conversion and LMS uploads. The default, when
no option is set, is `"title"`. A helper's `task_names` argument
overrides the global option for that call.

## Details

The available policies are:

- `"title"`: the exercise title, falling back to its source filename.

- `"filename"`: the source filename without its extension.

- `"both"`: `Title (filename)`, omitting the duplicate when they match.

- `"hidden"`: generic labels such as `Task 1.1`, `Section 1`, and
  `Test`.

Objects created from Rmd retain the source basename so that later export
can use it. For programmatically constructed objects with no source
file, filename mode uses the identifier. Existing XML/ZIP inputs use
their embedded titles and XML filenames; a title lost before import
cannot be recovered. This changes display names, not identifiers, file
paths or access settings.

Set the global option in the RStudio console; separate Knit sessions
read current console settings from the running preview server without a
restart. For a persistent preference, set the option in `.Rprofile`.
This is an R option ([`options()`](https://rdrr.io/r/base/options.html)
/ [`getOption()`](https://rdrr.io/r/base/options.html)), not an
environment variable
([`Sys.setenv()`](https://rdrr.io/r/base/Sys.setenv.html) /
[`Sys.getenv()`](https://rdrr.io/r/base/Sys.getenv.html)). Prefer
options for rqti settings; rqti manages the environment variables needed
to coordinate separate processes.

The older `fallback_titles` constructor argument remains supported:
`"generic"` selects hidden names and its historical `"filename"` value
keeps supplied titles. Its default, `"inherit"`, uses the global policy
at export. An explicit `task_names` argument overrides this constructor
setting too.

OPAL repository display names also use the selected exported title
unless `display_name` is supplied explicitly. Existing resources keep
their repository name when their content is replaced through the update
endpoint.

## See also

[`render_qtijs()`](https://shevandrin.github.io/rqti/maxima-preview/reference/render_qtijs.md),
[`rmd2xml()`](https://shevandrin.github.io/rqti/maxima-preview/reference/rmd2xml.md),
[`rmd2zip()`](https://shevandrin.github.io/rqti/maxima-preview/reference/rmd2zip.md),
[`upload2opal()`](https://shevandrin.github.io/rqti/maxima-preview/reference/upload2opal.md)
