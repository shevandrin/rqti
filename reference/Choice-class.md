# Class "Choice"

Abstract class `Choice` is not meant to be instantiated directly;
instead, it serves as a base for derived classes
[SingleChoice](https://shevandrin.github.io/rqti/reference/SingleChoice-class.md)
and
[MultipleChoice](https://shevandrin.github.io/rqti/reference/MultipleChoice-class.md).

## Slots

- `choices`:

  A character vector defining a set of answer options in the question.

- `choice_identifiers`:

  A character vector, optional, containing a set of identifiers for
  answers. By default, identifiers are generated automatically according
  to the template "ChoiceD", where D is a letter representing the
  alphabetical order of the answer in the list.

- `shuffle`:

  A boolean value indicating whether to randomize the order in which the
  choices are initially presented to the candidate. Default is `TRUE`.

- `orientation`:

  A character, determining whether to place answers in vertical or
  horizontal mode. Possible values:

  - "vertical" - Default.

  - "horizontal"
