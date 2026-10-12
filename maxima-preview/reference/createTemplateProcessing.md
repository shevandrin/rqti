# Create QTI template processing

Programs run in the target Maxima-capable player, not in R. Programs are
serialized in list order; the player may schedule independent programs
in parallel. Each program stores a string result before its outputs are
extracted. The OPAL/ONYX `value` attribute requires rqti's extended
schema for XML validation (`schema = "extended"` in
[verify_qti](https://shevandrin.github.io/rqti/maxima-preview/reference/verify_qti.md)).
Live execution requires a player supporting the MAXIMA operator.

## Usage

``` r
createTemplateProcessing(object)

# S4 method for class 'AssessmentItem'
createTemplateProcessing(object)
```

## Arguments

- object:

  An
  [AssessmentItem](https://shevandrin.github.io/rqti/maxima-preview/reference/AssessmentItem-class.md)
  object.

## Value

A `templateProcessing` tag, or `NULL` for an item without templates.
