# Class QtiMetadata

This class stores metadata information such as contributors,
description, rights and version for QTI-compliant tasks or tests.

## Slots

- `contributor`:

  A list of objects
  [QtiContributor](https://shevandrin.github.io/rqti/reference/QtiContributor-class.md)-type
  that holds metadata information about the authors.

- `description`:

  A character string providing a textual description of the content of
  this learning object.

- `rights`:

  A character string describing the intellectual property rights and
  conditions of use for this learning object. By default it takes value
  from environment variable 'RQTI_RIGHTS'.

- `version`:

  A character string representing the edition/version of this learning
  object.
