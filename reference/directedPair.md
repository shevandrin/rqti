# Create object [DirectedPair](https://shevandrin.github.io/rqti/reference/DirectedPair-class.md)

Create object
[DirectedPair](https://shevandrin.github.io/rqti/reference/DirectedPair-class.md)

## Usage

``` r
directedPair(
  identifier = generate_id(),
  title = identifier,
  content = list(),
  prompt = "",
  points = 1,
  rows,
  rows_identifiers,
  cols,
  cols_identifiers,
  answers_identifiers,
  answers_scores = NA_real_,
  shuffle = TRUE,
  shuffle_rows = TRUE,
  shuffle_cols = TRUE,
  feedback = list(),
  orientation = "vertical",
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

  A character string or a list of character strings to form the text of
  the question, which may include HTML tags.

- prompt:

  An optional character representing a simple question text, consisting
  of one paragraph. This can supplement or replace content in the task.
  Default is "".

- points:

  A numeric value, optional, representing the number of points for the
  entire task. If not provided, the default is calculated as 0.5 points
  per pair.

- rows:

  A character vector specifying answer options as the first elements in
  couples.

- rows_identifiers:

  A character vector, optional, specifies identifiers of the first
  elements in couples.

- cols:

  A character vector specifying answer options as the second elements in
  couples.

- cols_identifiers:

  A character vector, optional, specifies identifiers of the second
  elements in couples.

- answers_identifiers:

  A character vector specifying couples of identifiers that combine the
  correct answers.

- answers_scores:

  A numeric vector, optional, where each number determines the number of
  points awarded to a candidate if they select the corresponding answer.
  If not assigned, the individual values for correct answers are
  calculated from the task points and the number of correct options.

- shuffle:

  A boolean value, optional, determining whether to randomize the order
  in which the choices are initially presented to the candidate. Default
  is `TRUE.`

- shuffle_rows:

  A boolean value, optional, determining whether to randomize the order
  of the choices only for the first elements of the answer tuples.
  Default is `TRUE.`

- shuffle_cols:

  A boolean value, optional, determining whether to randomize the order
  of the choices only for the second elements of the answer tuples.
  Default is `TRUE.`

- feedback:

  A list containing feedback message-object
  [ModalFeedback](https://shevandrin.github.io/rqti/reference/ModalFeedback-class.md)
  for candidates.

- orientation:

  A character, optional, determining whether to place answers in
  vertical or horizontal mode. Possible values:

  - "vertical" - Default.

  - "horizontal".

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
[DirectedPair](https://shevandrin.github.io/rqti/reference/DirectedPair-class.md)

## Examples

``` r
dp_min <- directedPair(content = "<p>\"Directed pairs\" task</p>",
                       rows = c("alfa", "beta", "gamma"),
                       rows_identifiers = c("a", "b", "g"),
                       cols = c("A", "B", "G;"),
                       cols_identifiers = c("as", "bs", "gs"),
                       answers_identifiers = c("a as", "b bs", 'g gs'))

dp <- directedPair(identifier = "id_task_1234",
                   title = "Directed Pair Task",
                   content = "<p>\"Directed pairs\" task</p>",
                   prompt = "Plain text, can be used instead of the content",
                   rows = c("alfa", "beta", "gamma"),
                   rows_identifiers = c("a", "b", "g"),
                   cols = c("A", "B", "G"),
                   cols_identifiers = c("as", "bs", "gs"),
                   answers_identifiers = c("a as", "b bs", "g gs"),
                   answers_scores = c(1, 0.5, 0.1),
                   shuffle_rows = FALSE,
                   shuffle_cols = TRUE,
                   orientation = "horizontal")
#> Total points for the task have been recalculated as the sum of individual answers.
```
