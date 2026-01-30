# Create object [MultipleChoice](https://shevandrin.github.io/rqti/reference/MultipleChoice-class.md)

Create object
[MultipleChoice](https://shevandrin.github.io/rqti/reference/MultipleChoice-class.md)

## Usage

``` r
multipleChoice(
  identifier = generate_id(),
  title = identifier,
  choices,
  choice_identifiers = paste0("Choice", LETTERS[seq(choices)]),
  content = list(),
  prompt = "",
  points = 1,
  feedback = list(),
  orientation = "vertical",
  shuffle = TRUE,
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

- choices:

  A character vector defining a set of answer options in the question.

- choice_identifiers:

  A character vector, optional, containing a set of identifiers for
  answers. By default, identifiers are generated automatically according
  to the template "ChoiceD", where D is a letter representing the
  alphabetical order of the answer in the list.

- content:

  A character string or a list of character strings to form the text of
  the question, which may include HTML tags.

- prompt:

  An optional character representing a simple question text, consisting
  of one paragraph. This can supplement or replace content in the task.
  Default is "".

- points:

  A numeric vector, required. Each number in this vector determines the
  number of points that will be awarded to a candidate if they select
  the corresponding answer. The order of the scores must match the order
  of the choices. It is possible to assign negative values to incorrect
  answers. All answers with a positive score are considered correct.

- feedback:

  A list containing feedback messages for candidates. Each element of
  the list should be an instance of either
  [ModalFeedback](https://shevandrin.github.io/rqti/reference/ModalFeedback-class.md),
  [CorrectFeedback](https://shevandrin.github.io/rqti/reference/CorrectFeedback-class.md),
  or
  [WrongFeedback](https://shevandrin.github.io/rqti/reference/WrongFeedback-class.md)
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

## Value

An object of class
[MultipleChoice](https://shevandrin.github.io/rqti/reference/MultipleChoice-class.md)

## Examples

``` r
mc_min <- multipleChoice(choices = c("option1", "option2", "option3"),
                        points = c(0, 0.5, 0.5))

mc <- multipleChoice(identifier = "id_task_1234",
                   title = "Multiple Choice Task",
                   content = "<p>Pick up the right options</p>",
                   prompt = "Plain text, can be used instead of content",
                   points = c(0, 0.5, 0.5),
                   feedback = list(new("WrongFeedback",
                                   content = list("Wrong answer"))),
                   calculator = "scientific-calculator",
                   files = "text_book.pdf",
                   choices = c("option 1", "option 2", "option 3"),
                   choice_identifiers = c("ChoiceA", "ChoiceB", "ChoiceC"),
                   shuffle = TRUE,
                   orientation = "vertical")
```
