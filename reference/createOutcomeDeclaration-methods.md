# Create an element outcomeDeclaration of a qti-xml document

Generic function for creating outcomeDeclaration element for XML
document of specification the question following the QTI schema v2.1

## Usage

``` r
createOutcomeDeclaration(object)

# S4 method for class 'AssessmentItem'
createOutcomeDeclaration(object)

# S4 method for class 'AssessmentTest'
createOutcomeDeclaration(object)

# S4 method for class 'Entry'
createOutcomeDeclaration(object)

# S4 method for class 'Gap'
createOutcomeDeclaration(object)
```

## Arguments

- object:

  an instance of the S4 object
  ([SingleChoice](https://shevandrin.github.io/rqti/reference/SingleChoice-class.md),
  [MultipleChoice](https://shevandrin.github.io/rqti/reference/MultipleChoice-class.md),
  [Essay](https://shevandrin.github.io/rqti/reference/Essay-class.md),
  [Entry](https://shevandrin.github.io/rqti/reference/Entry-class.md),
  [Ordering](https://shevandrin.github.io/rqti/reference/Ordering-class.md),
  [OneInRowTable](https://shevandrin.github.io/rqti/reference/OneInRowTable-class.md),
  [OneInColTable](https://shevandrin.github.io/rqti/reference/OneInColTable-class.md),
  [MultipleChoiceTable](https://shevandrin.github.io/rqti/reference/MultipleChoiceTable-class.md),
  [DirectedPair](https://shevandrin.github.io/rqti/reference/DirectedPair-class.md),
  [TextGap](https://shevandrin.github.io/rqti/reference/TextGap-class.md),
  [NumericGap](https://shevandrin.github.io/rqti/reference/NumericGap-class.md),
  [InlineChoice](https://shevandrin.github.io/rqti/reference/InlineChoice-class.md))
