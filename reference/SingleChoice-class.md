# Class "SingleChoice"

Class `SingleChoice` is responsible for creating single-choice
assessment tasks according to the QTI 2.1 standard.

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

- `solution`:

  A numeric value, optional. Represents the index of the correct answer
  in the `choices` slot. By default, the first item in the `choices`
  slot is considered the correct answer. Default is `1`.

## Examples

``` r
sc <- new("SingleChoice",
          identifier = "id_task_1234",
          title = "Single Choice Task",
          content = list("<p>Pick up the right option</p>"),
          prompt = "Plain text, can be used instead of content",
          points = 2,
          feedback = list(new("WrongFeedback", content = list("Wrong answer"))),
          calculator = "scientific-calculator",
          files = "text_book.pdf",
          choices = c("option 1", "option 2", "option 3", "option 4"),
          choice_identifiers = c("ChoiceA", "ChoiceB", "ChoiceC", "ChoiceD"),
          shuffle = TRUE,
          orientation = "vertical",
          solution = 2)
```
