# Create an element assessmentTest of a qti-xml document for test

Generic function for creating assessmentTest element for XML document of
specification the test following the QTI schema v2.1

## Usage

``` r
createAssessmentTest(object, folder, verify = FALSE)

# S4 method for class 'AssessmentTest'
createAssessmentTest(object, folder, verify = FALSE)

# S4 method for class 'AssessmentTestOpal'
createAssessmentTest(object, folder, verify = FALSE)
```

## Arguments

- object:

  an instance of the S4 object
  [AssessmentTest](https://shevandrin.github.io/rqti/reference/AssessmentTest-class.md)
  or
  [AssessmentTestOpal](https://shevandrin.github.io/rqti/reference/AssessmentTestOpal-class.md)

- folder:

  string, optional; a folder to store xml file; working directory by
  default

- verify:

  boolean, optional; to check validity of xml file, default `FALSE`
