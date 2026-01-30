# Class "MatchTable"

Abstract class `MatchTable` is not meant to be instantiated directly;
instead, it serves as a base for derived classes such as
[OneInRowTable](https://shevandrin.github.io/rqti/reference/OneInRowTable-class.md),
[OneInColTable](https://shevandrin.github.io/rqti/reference/OneInColTable-class.md),
[MultipleChoiceTable](https://shevandrin.github.io/rqti/reference/MultipleChoiceTable-class.md),
and
[DirectedPair](https://shevandrin.github.io/rqti/reference/DirectedPair-class.md).

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

  - For tasks of the MatchTable type, it can also be calculated as the
    sum of points for individual answers, when provided.

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

- `rows`:

  A character vector specifying answer options as row names in the table
  or the first elements in couples in
  [DirectedPair](https://shevandrin.github.io/rqti/reference/DirectedPair-class.md).

- `rows_identifiers`:

  A character vector, optional, specifying identifiers for answer
  options defined in rows of the table or identifiers of the first
  elements in couples in
  [DirectedPair](https://shevandrin.github.io/rqti/reference/DirectedPair-class.md).

- `cols`:

  A character vector specifying answer options as column headers in the
  table or the second elements in couples in
  [DirectedPair](https://shevandrin.github.io/rqti/reference/DirectedPair-class.md).

- `cols_identifiers`:

  A character vector, optional, specifying identifiers for answer
  options defined in columns of the table or identifiers of the second
  elements in couples in
  [DirectedPair](https://shevandrin.github.io/rqti/reference/DirectedPair-class.md).

- `answers_identifiers`:

  A character vector specifying couples of identifiers that combine the
  correct answers.

- `answers_scores`:

  A numeric vector, optional, where each number determines the number of
  points awarded to a candidate if they select the corresponding answer.
  If not assigned, the individual values for correct answers are
  calculated from the task points and the number of correct options.

- `shuffle`:

  A boolean value, optional, determining whether to randomize the order
  in which the choices are initially presented to the candidate. Default
  is `TRUE`.

- `shuffle_rows`:

  A boolean value, optional, determining whether to randomize the order
  of the choices only in rows. Default is `TRUE`.

- `shuffle_cols`:

  A boolean value, optional, determining whether to randomize the order
  of the choices only in columns. Default is `TRUE`.

## See also

[OneInRowTable](https://shevandrin.github.io/rqti/reference/OneInRowTable-class.md),
[OneInColTable](https://shevandrin.github.io/rqti/reference/OneInColTable-class.md),
[MultipleChoiceTable](https://shevandrin.github.io/rqti/reference/MultipleChoiceTable-class.md),
[DirectedPair](https://shevandrin.github.io/rqti/reference/DirectedPair-class.md)
