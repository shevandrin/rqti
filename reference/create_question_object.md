# Create rqti S4 [AssessmentItem](https://shevandrin.github.io/rqti/reference/AssessmentItem-class.md) Object from Rmd

Generates an rqti S4 AssessmentItem object
([SingleChoice](https://shevandrin.github.io/rqti/reference/SingleChoice-class.md),
[MultipleChoice](https://shevandrin.github.io/rqti/reference/MultipleChoice-class.md),
[Essay](https://shevandrin.github.io/rqti/reference/Essay-class.md),
[Entry](https://shevandrin.github.io/rqti/reference/Entry-class.md),
[Ordering](https://shevandrin.github.io/rqti/reference/Ordering-class.md),
[OneInRowTable](https://shevandrin.github.io/rqti/reference/OneInRowTable-class.md),
[OneInColTable](https://shevandrin.github.io/rqti/reference/OneInColTable-class.md),
[MultipleChoiceTable](https://shevandrin.github.io/rqti/reference/MultipleChoiceTable-class.md),
[DirectedPair](https://shevandrin.github.io/rqti/reference/DirectedPair-class.md))
from an Rmd file.

## Usage

``` r
create_question_object(file)
```

## Arguments

- file:

  A string representing the path to an Rmd file.

## Value

One of the rqti S4 AssessmentItem objects:
[SingleChoice](https://shevandrin.github.io/rqti/reference/SingleChoice-class.md),
[MultipleChoice](https://shevandrin.github.io/rqti/reference/MultipleChoice-class.md),
[Essay](https://shevandrin.github.io/rqti/reference/Essay-class.md),
[Entry](https://shevandrin.github.io/rqti/reference/Entry-class.md),
[Ordering](https://shevandrin.github.io/rqti/reference/Ordering-class.md),
[OneInRowTable](https://shevandrin.github.io/rqti/reference/OneInRowTable-class.md),
[OneInColTable](https://shevandrin.github.io/rqti/reference/OneInColTable-class.md),
[MultipleChoiceTable](https://shevandrin.github.io/rqti/reference/MultipleChoiceTable-class.md),
or
[DirectedPair](https://shevandrin.github.io/rqti/reference/DirectedPair-class.md).

## Examples

``` r
if (FALSE) { # interactive()
create_question_object("file.Rmd")
}
```
