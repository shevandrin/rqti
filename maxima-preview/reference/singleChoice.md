# Create object [SingleChoice](https://shevandrin.github.io/rqti/maxima-preview/reference/SingleChoice-class.md)

Create object
[SingleChoice](https://shevandrin.github.io/rqti/maxima-preview/reference/SingleChoice-class.md)

## Usage

``` r
singleChoice(
  identifier = generate_id(),
  title = identifier,
  choices,
  choice_identifiers = paste0("Choice", LETTERS[seq(choices)]),
  solution = 1,
  content = list(),
  prompt = "",
  points = 1,
  feedback = list(),
  orientation = "vertical",
  shuffle = TRUE,
  calculator = NA_character_,
  files = NA_character_,
  scoring_scheme = "standard",
  template = list()
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

- choices:

  A character vector defining a set of answer options in the question.

- choice_identifiers:

  A character vector, optional, containing a set of identifiers for
  answers. By default, identifiers are generated automatically according
  to the template "ChoiceD", where D is a letter representing the
  alphabetical order of the answer in the list.

- solution:

  A numeric value, optional. Represents the index of the correct answer
  in the choices slot. By default, the first item in the choices slot is
  considered the correct answer. Default is 1.

- content:

  A character string or a list of character strings to form the text of
  the question, which may include HTML tags.

- prompt:

  An optional character representing a simple question text, consisting
  of one paragraph. This can supplement or replace content in the task.
  Default is "".

- points:

  A numeric value, optional, representing the number of points for the
  entire task. Default is 1.

- feedback:

  A list containing feedback messages for candidates. Each element of
  the list should be an instance of either
  [ModalFeedback](https://shevandrin.github.io/rqti/maxima-preview/reference/ModalFeedback-class.md),
  [CorrectFeedback](https://shevandrin.github.io/rqti/maxima-preview/reference/CorrectFeedback-class.md),
  or
  [WrongFeedback](https://shevandrin.github.io/rqti/maxima-preview/reference/WrongFeedback-class.md)
  class.

- orientation:

  A character, determining whether to place answers in vertical or
  horizontal mode. Possible values:

  - "vertical" - Default,

  - "horizontal".

- shuffle:

  A boolean value indicating whether to randomize the order in which the
  choices are initially presented to the candidate. Default is `TRUE.`

- calculator:

  A character, optional, determining whether to show a calculator to the
  candidate. Possible values:

  - "simple"

  - "scientific".

- files:

  A character vector, optional, containing paths to files that will be
  accessible to the candidate during the test/exam.

- scoring_scheme:

  A character value, optional, defining how response options are scored.
  Possible values:

  - "standard" - the correct answer receives full points and incorrect
    answers receive 0. This is used by default.

  - "penalty" - the correct answer receives full points and incorrect
    answers receive a negative score of -points/(k-1), where k is the
    number of response options.

- template:

  A list of
  [MaximaVariables](https://shevandrin.github.io/rqti/maxima-preview/reference/MaximaVariables-class.md)
  objects, for example created with
  [`maxima_variables()`](https://shevandrin.github.io/rqti/maxima-preview/reference/maxima_variables.md).
  Defaults to an empty list. Blocks run in list order when the exported
  item is delivered by a player supporting MAXIMA.

## Value

An object of class
[SingleChoice](https://shevandrin.github.io/rqti/maxima-preview/reference/SingleChoice-class.md)

## Examples

``` r
sc_min <- singleChoice(prompt = "Question?",
                       choices = c("Answer1", "Answer2", "Answer3"))

sc <- singleChoice(identifier = "id_task_1234",
                   title = "Single Choice Task",
                   content = "<p>Pick up the right option</p>",
                   prompt = "Plain text, can be used instead of content",
                   points = 2,
                   feedback = list(new("WrongFeedback",
                                   content = list("Wrong answer"))),
                   calculator = "scientific-calculator",
                   files = "text_book.pdf",
                   choices = c("option 1", "option 2", "option 3"),
                   choice_identifiers = c("ChoiceA", "ChoiceB", "ChoiceC"),
                   shuffle = TRUE,
                   orientation = "vertical",
                   solution = 2)
```
