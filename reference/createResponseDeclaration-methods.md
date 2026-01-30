# Create an element responseDeclaration of a qti-xml document

Generic function for creating responseDeclaration element for XML
document of specification the question following the QTI schema v2.1

## Usage

``` r
createResponseDeclaration(object)

# S4 method for class 'AssessmentItem'
createResponseDeclaration(object)

# S4 method for class 'MatchTable'
createResponseDeclaration(object)

# S4 method for class 'Entry'
createResponseDeclaration(object)

# S4 method for class 'Essay'
createResponseDeclaration(object)

# S4 method for class 'InlineChoice'
createResponseDeclaration(object)

# S4 method for class 'MultipleChoice'
createResponseDeclaration(object)

# S4 method for class 'MultipleChoiceTable'
createResponseDeclaration(object)

# S4 method for class 'NumericGap'
createResponseDeclaration(object)

# S4 method for class 'Ordering'
createResponseDeclaration(object)

# S4 method for class 'SingleChoice'
createResponseDeclaration(object)

# S4 method for class 'TextGap'
createResponseDeclaration(object)
```

## Arguments

- object:

  an instance of the S4 object
  ([SingleChoice](https://shevandrin.github.io/rqti/reference/SingleChoice-class.md),
  [MultipleChoice](https://shevandrin.github.io/rqti/reference/MultipleChoice-class.md),
  [Entry](https://shevandrin.github.io/rqti/reference/Entry-class.md),
  [Ordering](https://shevandrin.github.io/rqti/reference/Ordering-class.md),
  [OneInRowTable](https://shevandrin.github.io/rqti/reference/OneInRowTable-class.md),
  [OneInColTable](https://shevandrin.github.io/rqti/reference/OneInColTable-class.md),
  [MultipleChoiceTable](https://shevandrin.github.io/rqti/reference/MultipleChoiceTable-class.md),
  [DirectedPair](https://shevandrin.github.io/rqti/reference/DirectedPair-class.md),
  [TextGap](https://shevandrin.github.io/rqti/reference/TextGap-class.md),
  [NumericGap](https://shevandrin.github.io/rqti/reference/NumericGap-class.md),
  [InlineChoice](https://shevandrin.github.io/rqti/reference/InlineChoice-class.md))
