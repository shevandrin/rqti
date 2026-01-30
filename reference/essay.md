# Create object [Essay](https://shevandrin.github.io/rqti/reference/Essay-class.md)

Create object
[Essay](https://shevandrin.github.io/rqti/reference/Essay-class.md)

## Usage

``` r
essay(
  identifier = generate_id(),
  title = identifier,
  content = list(),
  prompt = "",
  points = 1,
  feedback = list(),
  expected_length = length_expected(feedback),
  expected_lines = lines_expected(feedback),
  words_max = max_words(feedback),
  words_min = NA_integer_,
  data_allow_paste = FALSE,
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
  entire task. Default is 1.

- feedback:

  A list containing feedback message-object
  [ModalFeedback](https://shevandrin.github.io/rqti/reference/ModalFeedback-class.md)
  for candidates.

- expected_length:

  A numeric, optional. Responsible for setting the size of the text
  input field in the content delivery engine. By default it will be
  calculated according to model answer in the slot `content` of
  `ModalFeedback`.

- expected_lines:

  A numeric, optional. Responsible for setting the number of rows of the
  text input field in the content delivery engine. By default it will be
  calculated according to model answer in the slot `content` of
  `ModalFeedback`.

- words_max:

  A numeric, optional. Responsible for setting the maximum number of
  words that a candidate can write in the text input field. By default
  it will be calculated according to model answer in the slot `content`
  of `ModalFeedback`.

- words_min:

  A numeric, optional. Responsible for setting the minimum number of
  words that a candidate should write in the text input field.

- data_allow_paste:

  A boolean, optional. Determines whether it is possible for a candidate
  to copy text into the text input field. Default is FALSE.

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
[Essay](https://shevandrin.github.io/rqti/reference/Essay-class.md)

## Examples

``` r
es_min <- essay(content = list("<h2>Open question</h2>", "Write your answer here"))

es <- essay(identifier = "id_task_1234",
           title = "Essay Task",
           content = "<h2>Open question</h2> Write your answer here",
           prompt = "Plain text, can be used instead of content",
           points = 2,
           expected_length = 100,
           expected_lines = 5,
           words_max = 100,
           words_min = 1,
           data_allow_paste = TRUE,
           feedback = list(new("ModalFeedback",
                            content = list("Model answer"))),
           calculator = "scientific-calculator",
           files = "text_book.pdf")
```
