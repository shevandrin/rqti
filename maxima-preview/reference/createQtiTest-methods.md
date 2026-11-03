# Create zip-archive of the qti test specification

Create zip-archive of the qti test specification

## Usage

``` r
createQtiTest(object, dir = NULL, verification = FALSE, zip_only =
  FALSE, task_names = NULL)

# S4 method for class 'AssessmentItem'
createQtiTest(
  object,
  dir = ".",
  verification = FALSE,
  zip_only = FALSE,
  task_names = NULL
)

# S4 method for class 'AssessmentTest'
createQtiTest(
  object,
  dir = getwd(),
  verification = FALSE,
  zip_only = FALSE,
  task_names = NULL
)

# S4 method for class 'character'
createQtiTest(
  object,
  dir = getwd(),
  verification = FALSE,
  zip_only = FALSE,
  task_names = NULL
)
```

## Arguments

- object:

  An instance of the
  [AssessmentTest](https://shevandrin.github.io/rqti/maxima-preview/reference/AssessmentTest-class.md),
  [AssessmentTestOpal](https://shevandrin.github.io/rqti/maxima-preview/reference/AssessmentTestOpal-class.md)
  or
  [AssessmentItem](https://shevandrin.github.io/rqti/maxima-preview/reference/AssessmentItem-class.md)
  S4 object.

- dir:

  A character value, optional; a folder to store xml file; working
  directory is used by default.

- verification:

  A boolean value, optional; checks the validity of XML files. Default
  is `FALSE`.

- zip_only:

  A boolean value, optional; if `TRUE`, returns only the zip file. If
  `FALSE`, returns the zip, XML, and download files. Default is `FALSE`.

- task_names:

  Display naming policy: `"title"`, `"filename"`, `"both"`, or
  `"hidden"`. `NULL` uses option `rqti.task_names`, falling back to
  `"title"`. See
  [task_names](https://shevandrin.github.io/rqti/maxima-preview/reference/task_names.md).

## Value

A path to zip and xml files.

## Examples

``` r
essay <- new("Essay", prompt = "Test task", title = "Essay",
             identifier = "q1")
sc <- new("SingleChoice", prompt = "Test task", title = "SingleChoice",
          choices = c("A", "B", "C"), identifier = "q2")
exam_section <- new("AssessmentSection", identifier = "sec_id",
                   title = "section", assessment_item = list(essay, sc))
exam <- new("AssessmentTestOpal", identifier = "id_test",
           title = "some title", section = list(exam_section))
if (FALSE) { # \dontrun{
# creates folder with zip (side effect)
createQtiTest(exam, "exam_folder", "TRUE")
} # }
```
