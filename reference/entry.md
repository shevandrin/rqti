# Create object [Entry](https://shevandrin.github.io/rqti/reference/Entry-class.md)

Create object
[Entry](https://shevandrin.github.io/rqti/reference/Entry-class.md)

## Usage

``` r
entry(
  identifier = generate_id(),
  title = identifier,
  content = list(),
  prompt = "",
  points = 1,
  feedback = list(),
  calculator = NA_character_,
  files = NA_character_
)
```

## Arguments

- identifier:

  A character representing the unique identifier of the assessment task.
  By default, it is generated as 'id_task_dddd', where dddd represents
  random digits.

- title:

  A character representing the title of the XML file associated with the
  task. By default, it takes the value of the identifier.

- content:

  A list of character content to form the text of the question, which
  can include HTML tags. For tasks of the Entry type, it must also
  contain at least one instance of Gap objects, such as `TextGap`,
  `TextGapOpal`, `NumericGap`, or `InlineChoice`.

- prompt:

  An optional character representing a simple question text, consisting
  of one paragraph. This can supplement or replace content in the task.
  Default is "".

- points:

  A numeric value, it is calculated as the sum of the gap points by
  default.

- feedback:

  A list containing feedback message-object
  [ModalFeedback](https://shevandrin.github.io/rqti/reference/ModalFeedback-class.md)
  for candidates.

- calculator:

  A character, optional, determining whether to show a calculator to the
  candidate. Possible values:

  - "simple"

  - "scientific".

- files:

  A character vector, optional, containing paths to files that will be
  accessible to the candidate during the test/exam.

## Value

An object of class
[Entry](https://shevandrin.github.io/rqti/reference/Entry-class.md)

## See also

\[textGap()\]\[numericGap()\]\[textGapOpal()\]

## Examples

``` r
gap_min <- entry(content = list("Question and Test Interoperability",
                               textGap("QTI")))

gap <- entry(identifier = "id_task_1234",
           title = "Essay Task",
                   content = list("Question and Test Interoperability:",
                                  textGap("QTI")),
                   prompt = "Plain text, can be used instead of content",
                   points = 2,
                   feedback = list(new("ModalFeedback",
                                   content = list("Model answer"))),
                   calculator = "scientific-calculator",
                   files = "text_book.pdf")
```
