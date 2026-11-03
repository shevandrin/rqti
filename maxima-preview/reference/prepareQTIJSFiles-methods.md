# Prepare files to render them with QTIJS

Prepare files to render them with QTIJS

## Usage

``` r
prepareQTIJSFiles(object, dir = NULL, task_names = NULL)

# S4 method for class 'AssessmentItem'
prepareQTIJSFiles(object, dir = "", task_names = NULL)

# S4 method for class 'AssessmentSection'
prepareQTIJSFiles(object, dir = NULL, task_names = NULL)

# S4 method for class 'AssessmentTest'
prepareQTIJSFiles(object, dir = NULL, task_names = NULL)

# S4 method for class 'character'
prepareQTIJSFiles(object, dir = NULL, task_names = NULL)
```

## Arguments

- object:

  an instance of
  [AssessmentItem](https://shevandrin.github.io/rqti/maxima-preview/reference/AssessmentItem-class.md),
  [AssessmentTest](https://shevandrin.github.io/rqti/maxima-preview/reference/AssessmentTest-class.md),
  [AssessmentTestOpal](https://shevandrin.github.io/rqti/maxima-preview/reference/AssessmentTestOpal-class.md),
  [AssessmentSection](https://shevandrin.github.io/rqti/maxima-preview/reference/AssessmentSection-class.md),
  or string path to xml, rmd or md files

- dir:

  QTIJS path

- task_names:

  Display naming policy: `"title"`, `"filename"`, `"both"`, or
  `"hidden"`. `NULL` uses option `rqti.task_names`, falling back to
  `"title"`. See
  [task_names](https://shevandrin.github.io/rqti/maxima-preview/reference/task_names.md).
