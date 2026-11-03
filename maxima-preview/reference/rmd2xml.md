# Create qti-XML task file from Rmd (md) description

Create XML file for question specification from Rmd (md) description
according to qti 2.1 information model When `path` is a directory, the
XML filename uses the source filename without its extension, preserving
both hyphens and underscores independently of the YAML `identifier`.
Knit saves its XML copy beside the source with the same name. Supply an
explicit `.xml` path to choose a different export filename.

## Usage

``` r
rmd2xml(file, path = getwd(), verification = FALSE, task_names = NULL)
```

## Arguments

- file:

  A string of path to file with markdown description of question.

- path:

  A string, optional; a folder to store xml file. Default is working
  directory.

- verification:

  A boolean value, optional; enable validation of the xml file. Default
  is `FALSE`.

- task_names:

  Display naming policy: `"title"`, `"filename"`, `"both"`, or
  `"hidden"`. `NULL` uses option `rqti.task_names`, falling back to
  `"title"`. See
  [task_names](https://shevandrin.github.io/rqti/maxima-preview/reference/task_names.md).

## Value

The path string to the xml file.

## Examples

``` r
if (FALSE) { # \dontrun{
# creates folder with xml (side effect)
rmd2xml("task.Rmd", "target_folder", TRUE)
} # }
```
