# Constructor function for class QtiMetadata

Creates object of
[QtiMetadata](https://shevandrin.github.io/rqti/reference/QtiMetadata-class.md)-class

## Usage

``` r
qti_metadata(
  contributor = list(),
  description = "",
  rights = Sys.getenv("RQTI_RIGHTS"),
  version = NA_character_
)
```

## Arguments

- contributor:

  A list of objects
  [QtiContributor](https://shevandrin.github.io/rqti/reference/QtiContributor-class.md)-type
  that holds metadata information about the authors.

- description:

  A character string providing a textual description of the content of
  this learning object.

- rights:

  A character string describing the intellectual property rights and
  conditions of use for this learning object. By default it takes value
  from environment variable 'RQTI_RIGHTS'.

- version:

  A character string representing the edition/version of this learning
  object.

## Examples

``` r
creator= qti_metadata(qtiContributor("Max Mustermann"),
                      description = "Task description",
                      rights = "This file is Copyright (C) 2024 Max
                      Mustermann, all rights reserved.",
                      version = "1.0")
#> Warning: `qti_metadata()` was deprecated in rqti 0.3.1.
#> ℹ Please use `qtiMetadata()` instead.
```
