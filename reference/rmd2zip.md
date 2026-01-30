# Create test zip file with one task xml file from Rmd (md) description

Create zip file with test, that contains one xml question specification
generated from Rmd (md) description according to qti 2.1 information
model

## Usage

``` r
rmd2zip(file, path = getwd(), verification = FALSE)
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

## Value

The path string to the zip file.

## Examples

``` r
if (FALSE) { # \dontrun{
# creates folder with zip (side effect)
rmd2zip("task.Rmd", "target_folder", TRUE)
} # }
```
