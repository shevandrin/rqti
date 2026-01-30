# Create zip-archive of the qti test specification

Create zip-archive of the qti test specification

## Usage

``` r
createQtiTest(object, dir = NULL, verification = FALSE, zip_only =
  FALSE)

# S4 method for class 'AssessmentItem'
createQtiTest(object, dir = ".", verification = FALSE, zip_only = FALSE)

# S4 method for class 'AssessmentTest'
createQtiTest(object, dir = getwd(), verification = FALSE, zip_only = FALSE)

# S4 method for class 'character'
createQtiTest(object, dir = getwd())
```

## Arguments

- object:

  An instance of the
  [AssessmentTest](https://shevandrin.github.io/rqti/reference/AssessmentTest-class.md),
  [AssessmentTestOpal](https://shevandrin.github.io/rqti/reference/AssessmentTestOpal-class.md)
  or
  [AssessmentItem](https://shevandrin.github.io/rqti/reference/AssessmentItem-class.md)
  S4 object.

- dir:

  A character value, optional; a folder to store xml file; working
  directory is used by default.

- verification:

  A boolean value, optional; to check validity of xml files. Default is
  `FALSE`.

- zip_only:

  A boolean value, optional; returns only zip file in case of `TRUE` or
  zip, xml and downloads files in case of `FALSE` value. Default is
  `FALSE`.

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
