# Class "Ordering"

Class `Ordering` is responsible for creating assessment task according
to QTI 2.1., where candidate has to place answers in a specific order

## Slots

- `identifier`:

  A character representing the unique identifier of the assessment task.
  By default, it is generated as 'id_task_dddd', where dddd represents
  random digits.

- `title`:

  A character representing the title of the XML file associated with the
  task. By default, it takes the value of the identifier.

- `content`:

  A list of character content to form the text of the question, which
  can include HTML tags. For tasks of the
  [Entry](https://shevandrin.github.io/rqti/reference/Entry-class.md)
  type, it must also contain at least one instance of Gap objects, such
  as
  [TextGap](https://shevandrin.github.io/rqti/reference/TextGap-class.md),
  [TextGapOpal](https://shevandrin.github.io/rqti/reference/TextGapOpal-class.md),
  [NumericGap](https://shevandrin.github.io/rqti/reference/NumericGap-class.md),
  or
  [InlineChoice](https://shevandrin.github.io/rqti/reference/InlineChoice-class.md).

- `prompt`:

  An optional character representing a simple question text, consisting
  of one paragraph. This can supplement or replace content in the task.
  Default is "".

- `points`:

  A numeric value, optional, representing the number of points for the
  entire task. Default is 1, but pay attention:

  - For tasks of the
    [Entry](https://shevandrin.github.io/rqti/reference/Entry-class.md)
    type, it is calculated as the sum of the gap points by default.

  - For tasks of the
    [DirectedPair](https://shevandrin.github.io/rqti/reference/DirectedPair-class.md),
    the default is calculated as 0.5 points per pair.

  - For tasks of the
    [MatchTable](https://shevandrin.github.io/rqti/reference/MatchTable-class.md)
    type, it can also be calculated as the sum of points for individual
    answers, when provided.

  - For tasks of the
    [MultipleChoice](https://shevandrin.github.io/rqti/reference/MultipleChoice-class.md)
    type, points is numeric vector and required. Each number in this
    vector determines the number of points that will be awarded to a
    candidate if they select the corresponding answer. The order of the
    scores must match the order of the `choices`. It is possible to
    assign negative values to incorrect answers. All answers with a
    positive score are considered correct.

- `feedback`:

  A list containing feedback messages for candidates. Each element of
  the list should be an instance of either
  [ModalFeedback](https://shevandrin.github.io/rqti/reference/ModalFeedback-class.md),
  [CorrectFeedback](https://shevandrin.github.io/rqti/reference/CorrectFeedback-class.md),
  or
  [WrongFeedback](https://shevandrin.github.io/rqti/reference/WrongFeedback-class.md)
  class.

- `calculator`:

  A character, optional, determining whether to show a calculator to the
  candidate. Possible values:

  - "simple"

  - "scientific"

- `files`:

  A character vector, optional, containing paths to files that will be
  accessible to the candidate during the test/exam.

- `metadata`:

  An object of class
  [QtiMetadata](https://shevandrin.github.io/rqti/reference/QtiMetadata-class.md)
  that holds metadata information about the task.

- `choices`:

  A character vector containing the answers. The order of answers in the
  vector represents the correct response for the task.

- `choices_identifiers`:

  A character vector, optional, containing a set of identifiers for
  answers. By default, identifiers are generated automatically. By
  default, identifiers are generated automatically according to the
  template "ChoiceL", where L is a letter representing the alphabetical
  order of the answer in the list.

- `shuffle`:

  A boolean value indicating whether to randomize the order in which the
  choices are initially presented to the candidate. Default is TRUE.

- `points_per_answer`:

  A boolean value indicating the scoring method. If `TRUE`, each
  selected answer will be scored individually. If `FALSE`, only fully
  correct answers will be scored with the maximum score. Default is
  `TRUE`.

## Examples

``` r
ord <- new("Ordering",
           identifier = "id_task_1234",
           title = "order",
           content = list("<p>Put these items in a right order</p>"),
           prompt = "",
           points = 2,
           feedback = list(),
           choices = c("first", "second", "third"),
           choices_identifiers = c("ChoiceA", "ChoiceB", "ChoiceC"),
           shuffle = TRUE,
           points_per_answer = TRUE)
```
