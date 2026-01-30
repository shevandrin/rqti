# Class "Entry"

Class `Entry` is responsible for creating assessment tasks according to
the QTI 2.1 standard. These tasks include one or more instances of text
input fields (with numeric or text answers) or dropdown lists.

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
  can include HTML tags. For tasks of the Entry type, it must also
  contain at least one instance of Gap objects, such as
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

  - For tasks of the Entry type, it is calculated as the sum of the gap
    points by default.

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

## See also

[NumericGap](https://shevandrin.github.io/rqti/reference/NumericGap-class.md),
[TextGap](https://shevandrin.github.io/rqti/reference/TextGap-class.md),
[TextGapOpal](https://shevandrin.github.io/rqti/reference/TextGapOpal-class.md),
[InlineChoice](https://shevandrin.github.io/rqti/reference/InlineChoice-class.md)

## Examples

``` r
entry_gaps <- new("Entry", content = list("<p>In mathematics, the common
logarithm is the logarithm with base", new("NumericGap",
                                           response_identifier = "numeric_1",
                                           solution = 10,
                                           placeholder = "it is a number"),
". It is also known as the decimal", new("TextGap",
                                         response_identifier = "text_1",
                                         solution = "logarithm",
                                         placeholder = "it is a text"),
 ".</p>"),
                   title = "entry with number and text in answers",
                   identifier = "entry_example")
entry_dropdown <- new("Entry", content = list("<p>In mathematics, the common
logarithm is the logarithm with base", new("InlineChoice",
                                           response_identifier = "numeric_1",
                                           choices = c("10", "7", "11")),
". It is also known as the decimal", new("InlineChoice",
                                         response_identifier = "text_1",
                                         choices = c("logarithm", "limit")),
 ".</p>"),
                   title = "entry with dropdown lists for answers",
                   identifier = "entry_example")
```
