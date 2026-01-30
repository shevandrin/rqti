# Create qti-XML task file from Rmd (md) description

Create XML file for question specification from Rmd (md) description
according to qti 2.1 infromation model

## Usage

``` r
rmd2xml(file, path = getwd(), verification = FALSE)
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

The path string to the xml file.

## Examples

``` r
if (FALSE) { # \dontrun{
# creates folder with xml (side effect)
rmd2xml("task.Rmd", "target_folder", TRUE)
} # }
```
