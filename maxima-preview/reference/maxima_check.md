# Check a Maxima program locally

Runs a program in a fresh Maxima process. Syntax or runtime failures
stop with the original diagnostic. This checks one execution of
randomized code; it does not prove every variant works on the target
ONYX installation. The ONYX statistics libraries `distrib`,
`descriptive`, and `stats` are loaded by default. Supply `libraries` to
include others, such as `draw`. No R interface package for Maxima is
required.

## Usage

``` r
maxima_check(
  code,
  executable = maxima_default_executable(),
  timeout = getOption("rqti.maxima_timeout", 120),
  file = NULL,
  chunk = NULL,
  libraries = c("distrib", "descriptive", "stats"),
  outputs = FALSE
)
```

## Arguments

- code:

  A non-empty Maxima program.

- executable:

  Path to the Maxima command-line executable or Windows `.bat`/`.cmd`
  launcher, defaulting to option `rqti.maxima`, the choice inherited
  from
  [`start_server()`](https://shevandrin.github.io/rqti/maxima-preview/reference/start_server.md)
  in an RStudio Knit session, or PATH. Explicit paths may contain spaces
  and Unicode; do not add shell quotes.

- timeout:

  Maximum execution time in seconds. Defaults to option
  `rqti.maxima_timeout`, or 120 seconds (including library startup).

- file, chunk:

  Optional source filename and chunk label for diagnostics.

- libraries:

  Character vector of Maxima libraries to load first.

- outputs:

  If `TRUE`, inspect the program's final `string([...])` return value
  and return its named output types. Unsupported types are marked
  `"unsupported"`;
  [`maxima_variables()`](https://shevandrin.github.io/rqti/maxima-preview/reference/maxima_variables.md)
  requires explicit declarations for them.

## Value

Invisibly, `TRUE` on success, or a named type vector if `outputs=TRUE`.

## Compiled library cache

Compiled libraries are shared with the local preview server across R
sessions. On R \>= 4.0, the cache is stored under
`tools::R_user_dir("rqti", "cache")`. Set
`options(rqti.maxima_cache_dir = "/path/to/cache")` to choose a
directory, or `options(rqti.maxima_cache_dir = FALSE)` for a
session-only cache. Earlier R versions use a session-only cache.
Creation is lazy, when libraries are needed. Each calculation still uses
a fresh process and temporary programs and results. Build-specific
caches are protected by a cross-process lock; preview jobs wait
asynchronously. Old builds and caches unused for 30 days are removed,
and caches exceeding 64 MiB are discarded after use. Interrupted library
loading discards the incomplete cache.
