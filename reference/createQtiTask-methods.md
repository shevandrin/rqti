# Create XML or zip file for question specification

Create XML or zip file for question specification

## Usage

``` r
createQtiTask(object, dir = ".", verification = FALSE, zip = FALSE)

# S4 method for class 'AssessmentItem'
createQtiTask(object, dir = ".", verification = FALSE, zip = FALSE)

# S4 method for class 'character'
createQtiTask(object, dir = getwd())
```

## Arguments

- object:

  An instance of the S4 object
  ([SingleChoice](https://shevandrin.github.io/rqti/reference/SingleChoice-class.md),
  [MultipleChoice](https://shevandrin.github.io/rqti/reference/MultipleChoice-class.md),
  [Essay](https://shevandrin.github.io/rqti/reference/Essay-class.md),
  [Entry](https://shevandrin.github.io/rqti/reference/Entry-class.md),
  [Ordering](https://shevandrin.github.io/rqti/reference/Ordering-class.md),
  [OneInRowTable](https://shevandrin.github.io/rqti/reference/OneInRowTable-class.md),
  [OneInColTable](https://shevandrin.github.io/rqti/reference/OneInColTable-class.md),
  [MultipleChoiceTable](https://shevandrin.github.io/rqti/reference/MultipleChoiceTable-class.md),
  [DirectedPair](https://shevandrin.github.io/rqti/reference/DirectedPair-class.md)).

- dir:

  A character value, optional; a folder to store xml file; working
  directory is used by default.

- verification:

  A boolean value, optional; to check validity of xml file. Default is
  `FALSE`.

- zip:

  A boolean value, optional; the `TRUE` value allows to create a zip
  archive with the manifest and task files inside. Default is `FALSE`.

## Value

A path to xml or zip file.

## Examples

``` r
essay <- new("Essay", prompt = "Test task", title = "Essay")
if (FALSE) { # \dontrun{
# creates folder with XML (side effect)
createQtiTask(essay, "result")
# creates folder with zip (side effect)
createQtiTask(essay, "result", zip = TRUE)
} # }
```
