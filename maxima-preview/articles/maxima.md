# Maxima exercises

Maxima exercises calculate question values and correct answers when an
exercise is instantiated. One exported item can therefore produce many
random variants. You can write the calculations in a `{maxima}` chunk,
display their outputs with
[`template_value()`](https://shevandrin.github.io/rqti/maxima-preview/reference/template_value.md),
and bind a correct answer with `gap_numeric(solution_variable = ...)` or
`gap_text(solution_variable = ...)`.

This article describes the experimental `prototype/maxima-rmd` branch.
Install that version with R \>= 4.1, then restart your RStudio R
session:

``` r

remotes::install_github("shevandrin/rqti", ref = "prototype/maxima-rmd")
```

## Requirements

Install native Maxima separately and put its executable on PATH. In R,
`Sys.which("maxima")` should return a path. You can also set
`options(rqti.maxima = "/path/to/maxima")` to choose an executable
explicitly. No additional R interface package is required. Ordinary rqti
exercises do not require Maxima.

On Windows, choose the command-line launcher provided by your Maxima
installation. Its name and location depend on the installation; use a
path you have verified locally. Use forward slashes (or doubled
backslashes in an R string), without adding shell quotes around the
path. Explicit file paths are checked directly instead of being looked
up with [`Sys.which()`](https://rdrr.io/r/base/Sys.which.html).

Set the option **before** starting the server:
[`start_server()`](https://shevandrin.github.io/rqti/maxima-preview/reference/start_server.md)
passes that choice to RStudio’s separate Knit session. Restart the
server after changing it. Running
[`options()`](https://rdrr.io/r/base/options.html) in the console alone
does not set an option in a separate R session.

The [Windows configuration problem reported in issue
\#257](https://github.com/shevandrin/rqti/issues/257#issuecomment-6360719800)
has not yet been reproduced on Windows. An explicit launcher path is a
configuration option; it is not a confirmed workaround for that report.

rqti runs Maxima locally when checking Rmd chunks and generating
previews. An exported exercise needs a delivery platform that supports
the ONYX `MAXIMA` custom operator, such as ONYX/OPAL. The XML retains
the program; the sample values from the authoring check are not fixed
into the exported question.

## Write an Rmd exercise

Here is the complete addition example shipped with this branch:

```` markdown
---
type: gap
identifier: maxima_local_addition
title: "Maxima addition in RStudio"
knit: rqti::render_qtijs
---

<!-- In the RStudio console, run rqti::start_server()
     before clicking Knit. The preview opens in the RStudio Viewer. -->

```{r setup, include=FALSE}
library(rqti)
```

```{maxima addition}
block(
    [a, b, answer],
    a: random(100),
    b: random(100),
    answer: a + b,
    string(['a = a, 'b = b, 'answer = answer])
);
```

# question

What is **`r template_value("a")`** + **`r template_value("b")`**?

Answer: `r gap_numeric(solution_variable="answer", tolerance_type="exact", points=1)`
````

The Maxima block returns a string containing a named association list:
`string(['a = a, 'b = b, 'answer = answer])`. rqti reads the output
names and types from one local execution, creates the template
declarations, and keeps the calculation in the QTI template.
`template_value("a")` displays an output;
`gap_numeric(solution_variable = "answer")` uses the generated numeric
answer. `numericGap(solution_variable = ...)` provides the same binding
in the S4 API.

## Preview in RStudio

Start the preview server in the RStudio console before clicking
**Knit**. Copy the installed example to a writable location first:

``` r

library(rqti)
rqti::start_server()
example <- file.path(tempdir(), "maxima-addition.Rmd")
file.copy(
  system.file("extdata", "maxima-local-addition.Rmd", package = "rqti"),
  example,
  overwrite = TRUE
)
rstudioapi::navigateToFile(example)
```

Click **Knit**. The RStudio Viewer should show the addition exercise
with generated numbers. The preview also works in an external browser
using the URL printed by
[`start_server()`](https://shevandrin.github.io/rqti/maxima-preview/reference/start_server.md)
or
[`render_qtijs()`](https://shevandrin.github.io/rqti/maxima-preview/reference/render_qtijs.md).

qti.js sends the template calculation to the local R server, which runs
Maxima and returns typed outputs. Submitting an answer preserves the
current numbers; reload the preview page to generate another variant. A
failed preview shows the diagnostic and a **Retry** button. To stop the
server, use
[`rqti::stop_server()`](https://shevandrin.github.io/rqti/maxima-preview/reference/stop_server.md).

The Knit button uses a separate R session. rqti passes both the server
URL and its renderer folder to that session, including when the console
uses a development checkout and Knit loads the installed package.

## Output types and authoring checks

Supported output types are `integer`, `float`, and `string`. Rational
numbers and real numeric constants can be used as floating-point
outputs. Inference observes one random variant; specify types when they
may vary between variants:

For example, replace the addition chunk above with this explicitly typed
chunk:

```` markdown
```{maxima addition, variables = c(a = "integer", b = "integer", answer = "float", label = "string")}
block(
    [a, b, answer, label],
    a: random(100),
    b: random(100),
    answer: a + b,
    label: "Addition",
    string(['a = a, 'b = b, 'answer = answer, 'label = label])
);
```
````

The named `variables` vector sets the QTI types for the returned
outputs. `answer = "float"` accepts both integer and floating-point
results. The extra text output can be displayed with
`template_value("label")`. Explicit types do not bypass the local
execution check.

Lists and other structured values need an explicit `string` declaration
when used for display. This does not create a generated image.

### Text answers

Use `gap_text(solution_variable = "answer")` when the Maxima output is a
`string`. The output supplies one correct text answer for each attempt;
submitting an answer preserves the generated word. Matching ignores case
by default; set `case_sensitive = TRUE` to require matching
capitalization. The entire string must match, including spaces and
punctuation. Dynamic text answers do not support spelling tolerance or a
list of alternative answers. `textGap(solution_variable = "answer")`
provides the same binding in the S4 API.

This example can be previewed in qti.js and exported for ONYX/OPAL:

```` markdown
---
type: gap
identifier: maxima_text_answer
title: "Text answers from Maxima"
knit: rqti::render_qtijs
---

<!-- Run rqti::start_server() in the RStudio console before clicking Knit. -->

```{r setup, include=FALSE}
library(rqti)
```

```{maxima words}
block([answer],
    answer: ["Blue", "Green", "Orange"][random(3) + 1],
    string(['answer = answer])
);
```

# question

The generated word is **`r template_value("answer")`**.

Copy it here (capitalization does not matter):
`r gap_text(solution_variable = "answer", response_identifier = "insensitive")`

Copy it here again (capitalization must match):
`r gap_text(solution_variable = "answer", case_sensitive = TRUE, response_identifier = "sensitive")`
````

To try it, copy the installed example to a writable location, start the
preview server, and open the copy in RStudio:

``` r

example <- file.path(tempdir(), "maxima-text-answer.Rmd")
file.copy(
  system.file("extdata", "maxima-text-answer.Rmd", package = "rqti"),
  example,
  overwrite = TRUE
)
rqti::start_server()
rstudioapi::navigateToFile(example)
```

Click **Knit**. Copying the word in lowercase earns one point; copying
its capitalization exactly into both gaps earns two. Wrong or empty
answers earn zero. Submitting preserves the word; reloading generates
another variant. These cases have been tested with native Maxima in
qti.js, including Unicode, punctuation, and numeric-looking strings such
as `"0"` and `"01"`. The ONYX/OPAL export validates against the extended
schema; live OPAL scoring for generated text answers still needs
verification.

### Display LaTeX strings

Return LaTeX as a Maxima string. The following forms have been checked
in a fresh ONYX/OPAL attempt and after answer submission:

- Inline math: put `\\(` and `\\)` around the inline
  [`template_value()`](https://shevandrin.github.io/rqti/maxima-preview/reference/template_value.md)
  reference in Markdown (try 5 in the original example).
- Display math: put `$$` around the reference (try 6).
- Self-contained inline math: return a string including `\\(` and `\\)`
  in Maxima, then insert the reference directly (`tex_embedded`).

The [OPAL LaTeX
test](https://bildungsportal.sachsen.de/opal/auth/RepositoryEntry/56806965249)
contains the original tries. Tries 5, 6, and `tex_embedded` render
correctly; the local qti.js preview supports these forms too.

Backslashes in a literal **Maxima string** must be doubled:
`"\\mathbb{R}"` produces `\mathbb{R}`. The doubled backslashes in
Markdown’s `\\(...\\)` likewise preserve the math delimiters; a single
`\(` in Markdown loses its backslash during conversion.

The local preview typesets the completed Maxima output and preserves it
when answers are submitted. The exported XML keeps live
`printedVariable` references, including those inside math, rather than
the sample values from the local check. Rmd references are inserted
without an extra HTML span, so ONYX can substitute the values without
interrupting the surrounding formula. To put the delimiters inside the
generated value itself instead, use the `embedded` output below.

The complete example shows all three forms:

```` markdown
---
type: gap
identifier: maxima_latex
title: "LaTeX from Maxima"
knit: rqti::render_qtijs
---

<!-- Run rqti::start_server() in the RStudio console before clicking Knit. -->

```{r setup, include=FALSE}
library(rqti)
```

```{maxima latex}
block([],
    string([
        'number_set = "\\mathbb{R}",
        'embedded = "\\(\\mathbb{R}\\)"
    ])
);
```

# question

Inline math (try 5): \\(`r template_value("number_set")`\\).

Display math (try 6):

$$`r template_value("number_set")`$$

Math delimiters included in the returned string (`tex_embedded`):
`r template_value("embedded")`.

What is $1 + 0$? `r gap_numeric(1, tolerance_type="exact")`
````

rqti executes each Rmd Maxima chunk before export, including chunks with
explicit types. Syntax/runtime errors, missing outputs, incompatible
declared types, or missing template references stop export. Diagnostics
identify the source file, chunk label, and numbered code. Template
chunks must be evaluated and uncached. Only one Maxima chunk is allowed
per Rmd exercise. Return all the values needed by the question and its
answer from that chunk’s `string([...])` list. This follows the
all-in-one approach in [issue
\#257](https://github.com/shevandrin/rqti/issues/257): independent ONYX
calculations may run in parallel and give separate random calculations
the same seed. A single block keeps related calculations together.
Displayed references are supported in the question body.

### Check Maxima code directly

[`maxima_check()`](https://shevandrin.github.io/rqti/maxima-preview/reference/maxima_check.md)
takes one R character string containing Maxima code, including its
terminating semicolons or dollar signs. It runs that code in a fresh
local Maxima process and returns `TRUE` invisibly on success:

``` r

rqti::maxima_check("1 + 2;")
```

For a program returning the same `string([...])` associations used in an
Rmd chunk, set `outputs = TRUE` to obtain a named vector of inferred
types:

``` r

code <- "string(['a = 3, 'answer = 1/2, 'label = \"Addition\"]);"
types <- rqti::maxima_check(code, outputs = TRUE)
types
# c(a = "integer", answer = "float", label = "string")
```

A syntax or runtime failure raises an R error containing the Maxima
diagnostic and numbered source code. Rmd conversion calls this function
automatically; you do not need to call it separately before knitting.
Execution is bounded by `options(rqti.maxima_timeout = 120)` in seconds,
including library startup. The statistics libraries `distrib`,
`descriptive`, and `stats` load by default.

## Export and validate

``` r

xml <- rqti::rmd2xml(example, path = tempdir())
result <- rqti::verify_qti(xml, schema = "extended", ignore_import = FALSE)
stopifnot(result$valid)
rqti::rmd2zip(example, path = tempdir())
```

**Choose `schema = "extended"` for ONYX Maxima items.** The standard QTI
2.1 schema rejects ONYX’s `customOperator/@value` attribute and the
`setCorrectResponse` rule in response processing. The default
`verify_qti(xml)` therefore reports these items as invalid. rqti’s
extended schema accepts those extensions while still checking the XML
structure.

Schema validation does not execute the Maxima program or prove that
every random variant works. Rmd authoring checks run one variant
locally; preview scoring and an import into the target ONYX installation
provide further checks.

## Compiled library cache

The first calculation can take longer while Maxima compiles its
libraries. Authoring checks and previews share compiled libraries in
rqti’s managed user cache across R sessions. Each calculation still
starts a fresh Maxima process; programs, variables, and answers remain
independent and temporary.

Build changes invalidate the cache. Old builds, caches unused for 30
days, incomplete library loads, and caches exceeding 64 MiB are removed
automatically. Concurrent sessions coordinate through a lock. You can
choose another cache directory or keep the cache within the current R
session:

``` r

options(rqti.maxima_cache_dir = "/path/to/cache")
options(rqti.maxima_cache_dir = FALSE)
```
