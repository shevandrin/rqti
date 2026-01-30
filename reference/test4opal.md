# Create a test for LMS OPAL

Create an AssessmentTestOpal `rqti`-object.

## Usage

``` r
test4opal(
  content,
  identifier = "test_identifier",
  title = "Test Title",
  time_limit = 90L,
  max_attempts = 1L,
  files = NULL,
  calculator = NULL,
  academic_grading = c(`1.0` = 0.95, `1.3` = 0.9, `1.7` = 0.85, `2.0` = 0.8, `2.3` =
    0.75, `2.7` = 0.7, `3.0` = 0.65, `3.3` = 0.6, `3.7` = 0.55, `4.0` = 0.5, `5.0` = 0),
  grade_label = c(en = "Grade", de = "Note"),
  table_label = c(en = "Grade", de = "Note"),
  navigation_mode = "nonlinear",
  submission_mode = "individual",
  allow_comment = TRUE,
  rebuild_variables = TRUE,
  show_test_time = TRUE,
  mark_items = TRUE,
  keep_responses = FALSE,
  contributor = list(),
  description = "",
  rights = Sys.getenv("RQTI_RIGHTS"),
  version = "0.0.9"
)
```

## Arguments

- content:

  A list containing
  [AssessmentSection](https://shevandrin.github.io/rqti/reference/AssessmentSection-class.md)
  objects.

- identifier:

  A character value indicating the identifier of the test file. Default
  is 'test_identifier'.

- title:

  A character value, optional, representing the file title. Default is
  'Test Title'.

- time_limit:

  An integer value, optional, controlling the time given to a candidate
  for the test in minutes. Default is 90 minutes.

- max_attempts:

  An integer value, optional, indicating the maximum number of attempts
  allowed for the candidate. Default is 1.

- files:

  A character vector, optional; paths to files that will be accessible
  to the candidate during the test/exam.

- calculator:

  A character, optional; determines whether to show a calculator to the
  candidate. Possible values:

  - 'simple'

  - 'scientific'. Default is `NULL`.

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

- mark_items:

  A boolean, optional, determining whether to allow candidate marking of
  questions. Default is `TRUE`.

- keep_responses:

  A boolean, optional, determining whether to save the candidate's
  answers from the previous attempt. Default is `FALSE`.

- contributor:

  A list of objects
  [QtiContributor](https://shevandrin.github.io/rqti/reference/QtiContributor-class.md)-type
  that holds metadata information about the authors.

- description:

  A character string providing a textual description of the content of
  this learning object.

- rights:

  A character string describing the intellectual property rights and
  conditions of use for this learning object. By default it takes value
  from environment variable 'RQTI_RIGHTS'.

- version:

  A character string representing the edition/version of this learning
  object.

## Value

An
[AssessmentTestOpal](https://shevandrin.github.io/rqti/reference/AssessmentTestOpal-class.md)
object

## See also

[`test()`](https://shevandrin.github.io/rqti/reference/test.md),
[`section()`](https://shevandrin.github.io/rqti/reference/section.md),
[AssessmentTestOpal](https://shevandrin.github.io/rqti/reference/AssessmentTestOpal-class.md),
[AssessmentSection](https://shevandrin.github.io/rqti/reference/AssessmentSection-class.md)

## Examples

``` r
sc <- new("SingleChoice", prompt = "Question", choices = c("A", "B", "C"))
es <- new("Essay", prompt = "Question")
s <- section(c(sc, es), title = "Section with nonrandomized tasks")
t <- test4opal(s, title = "Example of the Exam",
show_test_time = FALSE)
#> Authors are found in exercises and added as contributors:  (author).
```
