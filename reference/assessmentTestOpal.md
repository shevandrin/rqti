# Create an object [AssessmentTestOpal](https://shevandrin.github.io/rqti/reference/AssessmentTestOpal-class.md)

Create an AssessmentTestOpal `rqti`-object.

## Usage

``` r
assessmentTestOpal(
  section,
  identifier = generate_id(type = "test"),
  title = identifier,
  time_limit = 90L,
  max_attempts = 1L,
  academic_grading = c(`1.0` = 0.95, `1.3` = 0.9, `1.7` = 0.85, `2.0` = 0.8, `2.3` =
    0.75, `2.7` = 0.7, `3.0` = 0.65, `3.3` = 0.6, `3.7` = 0.55, `4.0` = 0.5, `5.0` = 0),
  grade_label = c(en = "Grade", de = "Note"),
  table_label = c(en = "Grade", de = "Note"),
  navigation_mode = "nonlinear",
  submission_mode = "individual",
  allow_comment = TRUE,
  rebuild_variables = TRUE,
  show_test_time = TRUE,
  calculator = NA_character_,
  mark_items = TRUE,
  keep_responses = FALSE,
  metadata = qtiMetadata(),
  points = NA_real_
)
```

## Arguments

- section:

  A list containing
  [AssessmentSection](https://shevandrin.github.io/rqti/reference/AssessmentSection-class.md)
  objects.

- identifier:

  A character value indicating the identifier of the test file. By
  default, it is generated as 'id_test_dddd', where dddd represents
  random digits.

- title:

  A character value, optional, representing the file title. By default,
  it takes the value of the identifier.

- time_limit:

  An integer value, optional, controlling the time given to a candidate
  for the test in minutes. Default is 90 minutes.

- max_attempts:

  An integer value, optional, indicating the maximum number of attempts
  allowed for the candidate. Default is 1.

- academic_grading:

  A named numeric vector that defines the grade table shown to the
  candidate as feedback at the end of the test. The default is the
  German grading system: gt \<- c("1.0" = 0.95, "1.3" = 0.9, "1.7" =
  0.85, "2.0" = 0.8, "2.3" = 0.75, "2.7" = 0.7, "3.0" = 0.65, "3.3" =
  0.6, "3.7" = 0.55, "4.0" = 0.5, "5.0" = 0) Each grade corresponds to a
  minimum percentage score required to achieve it. To hide the grading
  table at the end of the test, set this parameter to NA_real\_.

- grade_label:

  A character value, optional; a short message that shows with a grade
  in the final feedback; for multilingual use, it can be a named vector
  with two-letter ISO language codes as names (e.g., c(en="Grade",
  de="Note")); during test creation, it takes the value for the language
  of the operating system; c(en="Grade", de="Note")is default.

- table_label:

  A character value, optional; a concise message to display as the
  column title of the grading table in the final feedback; for
  multilingual use, it can be a named vector with two-letter ISO
  language codes as names (e.g., c(en="Grade", de="Note")); during test
  creation, it takes the value for the language of the operating system;
  c(en="Grade", de="Note")is default.

- navigation_mode:

  A character value, optional, determining the general paths that the
  candidate may have during the exam. Two mode options are possible: -
  'linear': Candidate is not allowed to return to previous questions. -
  'nonlinear': Candidate is free to navigate; used by default.

- submission_mode:

  A character value, optional, determining when the candidate's
  responses are submitted for response processing. One of two mode
  options is possible: - 'individual': Submit candidates' responses on
  an item-by-item basis; used by default. - 'simultaneous': Candidates'
  responses are submitted all together by the end of the test.

- allow_comment:

  A boolean, optional, enabling the candidate to leave comments in each
  question. Default is `TRUE.`

- rebuild_variables:

  A boolean, optional, enabling the recalculation of variables and
  reshuffling the order of choices for each item-attempt. Default is
  `TRUE`.

- show_test_time:

  A boolean, optional, determining whether to show candidate elapsed
  processing time without a time limit. Default is `TRUE`.

- calculator:

  A character value, optional, determining whether to show a calculator
  to the candidate. Possible values: - "simple" - "scientific".

- mark_items:

  A boolean, optional, determining whether to allow candidate marking of
  questions. Default is `TRUE`.

- keep_responses:

  A boolean, optional, determining whether to save the candidate's
  answers from the previous attempt. Default is `FALSE`.

- metadata:

  An object of class
  [QtiMetadata](https://shevandrin.github.io/rqti/reference/QtiMetadata-class.md)
  that holds metadata information about the test. By default it creates
  [QtiMetadata](https://shevandrin.github.io/rqti/reference/QtiMetadata-class.md)
  object. See
  [`qtiMetadata()`](https://shevandrin.github.io/rqti/reference/qtiMetadata.md).

- points:

  Do not use directly; the maximum number of points for the exam/test.
  It is calculated automatically as a sum of points of included tasks.

## Value

An
[AssessmentTestOpal](https://shevandrin.github.io/rqti/reference/AssessmentTestOpal-class.md)
object.

## See also

[`test()`](https://shevandrin.github.io/rqti/reference/test.md),
[`test4opal()`](https://shevandrin.github.io/rqti/reference/test4opal.md),
[`section()`](https://shevandrin.github.io/rqti/reference/section.md),
[`assessmentTest()`](https://shevandrin.github.io/rqti/reference/assessmentTest.md),
[AssessmentTest](https://shevandrin.github.io/rqti/reference/AssessmentTest-class.md),
[AssessmentSection](https://shevandrin.github.io/rqti/reference/AssessmentSection-class.md)

## Examples

``` r
sc <- sc <- singleChoice(prompt = "Question", choices = c("A", "B", "C"))
es <- new("Essay", prompt = "Question")
s <- section(c(sc, es), title = "Section with nonrandomized tasks")
t <- assessmentTest(list(s), title = "Example of the Exam")
```
