# Create object [Ordering](https://shevandrin.github.io/rqti/reference/Ordering-class.md)

Create object
[Ordering](https://shevandrin.github.io/rqti/reference/Ordering-class.md)

## Usage

``` r
ordering(
  identifier = generate_id(),
  title = identifier,
  choices,
  choices_identifiers = paste0("Choice", LETTERS[seq(choices)]),
  content = list(),
  prompt = "",
  points = 1,
  points_per_answer = TRUE,
  shuffle = TRUE,
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

- choices:

  A character vector containing the answers. The order of answers in the
  vector represents the correct response for the task.

- choices_identifiers:

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

  A numeric value, optional, representing the number of points for the
  entire task. Default is 1.

- points_per_answer:

  A boolean value indicating the scoring method. If `TRUE`, each
  selected answer will be scored individually. If `FALSE`, only fully
  correct answers will be scored with the maximum score. Default is
  `TRUE`.

- shuffle:

  A boolean value indicating whether to randomize the order in which the
  choices are initially presented to the candidate. Default is `TRUE`.

- feedback:

  A list containing feedback messages for candidates. Each element of
  the list should be an instance of either
  [ModalFeedback](https://shevandrin.github.io/rqti/reference/ModalFeedback-class.md),
  [CorrectFeedback](https://shevandrin.github.io/rqti/reference/CorrectFeedback-class.md),
  or
  [WrongFeedback](https://shevandrin.github.io/rqti/reference/WrongFeedback-class.md)
  class.

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
[Ordering](https://shevandrin.github.io/rqti/reference/Ordering-class.md)

## Examples

``` r
ord_min <- ordering(prompt = "Set the right order:",
                       choices = c("Step1", "Step2", "Step3"))

ord <- ordering(identifier = "id_task_1234",
             title = "Order Task",
             choices = c("Step1", "Step2", "Step3"),
             choices_identifiers = c("a", "b", "c"),
             content = "<p>Set the right order</p>",
             prompt = "Plain text, can be used instead of content",
             points = 2,
             points_per_answer = FALSE,
             shuffle = FALSE,
             feedback = list(new("WrongFeedback",
                                   content = list("Wrong answer"))),
             calculator = "scientific-calculator",
             files = "text_book.pdf")
```
