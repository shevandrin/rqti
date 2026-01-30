# Get and process a piece of question content

Generic function to get and process a different types of question
content (text with instances of gaps or dropdown lists) for XML document
of specification the question following the QTI schema v2.1

## Usage

``` r
getResponse(object)

# S4 method for class 'InlineChoice'
getResponse(object)

# S4 method for class 'NumericGap'
getResponse(object)

# S4 method for class 'TextGap'
getResponse(object)

# S4 method for class 'character'
getResponse(object)
```

## Arguments

- object:

  an instance of the S4 object (NumericGap, TextGap, InlineChoice,
  character)
