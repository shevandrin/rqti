# Create test zip file with one task xml file from Rmd (md) description

Create zip file with test, that contains one xml question specification
generated from Rmd (md) description according to qti 2.1 information
model Display names follow
[task_names](https://shevandrin.github.io/rqti/maxima-preview/reference/task_names.md):
the YAML title by default, or the source filename without its extension
when no title is supplied.

## Usage

``` r
rmd2zip(file, path = getwd(), verification = FALSE, task_names = NULL)
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

The path string to the zip file.

## Examples

``` r
if (FALSE) { # \dontrun{
# creates folder with zip (side effect)
rmd2zip("task.Rmd", "target_folder", TRUE)
} # }
```
