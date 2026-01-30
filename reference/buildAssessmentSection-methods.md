# Build tags for AssessmentSection in assessmentTest

Generic function for tags that contains assessementSection in
assessnetTest

## Usage

``` r
buildAssessmentSection(object, folder = NULL, verify = FALSE)

# S4 method for class 'AssessmentItem'
buildAssessmentSection(object, folder)

# S4 method for class 'AssessmentSection'
buildAssessmentSection(object, folder = NULL, verify = FALSE)

# S4 method for class 'character'
buildAssessmentSection(object, folder = NULL, verify = FALSE)
```

## Arguments

- object:

  an instance of the S4 object
  ([AssessmentSection](https://shevandrin.github.io/rqti/reference/AssessmentSection-class.md)
  and all types of
  [AssessmentItem](https://shevandrin.github.io/rqti/reference/AssessmentItem-class.md))

- folder:

  string; a folder to store xml file

- verify:

  boolean, optional; check validity of xml file, default `FALSE`
