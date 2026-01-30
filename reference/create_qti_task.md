# Create XML file for question specification

Create XML file for question specification

## Usage

``` r
create_qti_task(object, dir = NULL, verification = FALSE)
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
  [DirectedPair](https://shevandrin.github.io/rqti/reference/DirectedPair-class.md)).

- dir:

  string, optional; a folder to store xml file; working directory by
  default

- verification:

  boolean, optional; to check validity of xml file, default `FALSE`

## Value

xml document.
