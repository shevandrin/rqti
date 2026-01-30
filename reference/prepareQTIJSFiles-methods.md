# Prepare files to render them with QTIJS

Prepare files to render them with QTIJS

## Usage

``` r
prepareQTIJSFiles(object, dir = NULL)

# S4 method for class 'AssessmentItem'
prepareQTIJSFiles(object, dir = "")

# S4 method for class 'AssessmentSection'
prepareQTIJSFiles(object, dir = NULL)

# S4 method for class 'AssessmentTest'
prepareQTIJSFiles(object, dir = NULL)

# S4 method for class 'character'
prepareQTIJSFiles(object, dir = NULL)
```

## Arguments

- object:

  an instance of
  [AssessmentItem](https://shevandrin.github.io/rqti/reference/AssessmentItem-class.md),
  [AssessmentTest](https://shevandrin.github.io/rqti/reference/AssessmentTest-class.md),
  [AssessmentTestOpal](https://shevandrin.github.io/rqti/reference/AssessmentTestOpal-class.md),
  [AssessmentSection](https://shevandrin.github.io/rqti/reference/AssessmentSection-class.md),
  or string path to xml, rmd or md files

- dir:

  QTIJS path
