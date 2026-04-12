# Create an object [AssessmentTestOpenOlat](https://shevandrin.github.io/rqti/reference/AssessmentTestOpenOlat-class.md)

Create an AssessmentTestOpenOlat `rqti`-object.

## Usage

``` r
assessmentTestOpenOlat(
  section,
  identifier = generate_id(type = "test"),
  title = identifier,
  time_limit = NULL,
  max_attempts = 1L,
  fallback_titles = "generic",
  academic_grading = NULL,
  grade_label = c(en = "Grade", de = "Note"),
  table_label = c(en = "Grade", de = "Note"),
  navigation_mode = "nonlinear",
  submission_mode = "individual",
  allow_comment = TRUE,
  rebuild_variables = TRUE,
  metadata = qtiMetadata(),
  points = NA_real_,
  cancel = FALSE,
  suspend = FALSE,
  scoreprogress = FALSE,
  questionprogress = FALSE,
  maxscoreitem = TRUE,
  menu = TRUE,
  titles = TRUE,
  notes = FALSE,
  hidelms = TRUE,
  hidefeedbacks = FALSE,
  blockaftersuccess = FALSE,
  attempts = 1L,
  anonym = FALSE,
  manualcorrect = FALSE
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

- fallback_titles:

  A character value, optional, controlling how titles are assigned when
  no explicit title is provided. Possible values are "filename" (use
  filenames as titles) and "generic" (use generic labels such as
  "Section 1", "Section 1.2", or "Task 1.2.1"). Default is "generic".

- academic_grading:

  A named numeric vector that defines the grade table shown to the
  candidate as feedback at the end of the test.

  Each grade corresponds to the minimum percentage score required to
  achieve it. A helper function
  [`german_grading()`](https://shevandrin.github.io/rqti/reference/german_grading.md)
  is available to generate a common German grading scheme.

  The default is `NULL`, which means that no grading table is shown. To
  display a grading table, provide a named numeric vector or use
  [`german_grading()`](https://shevandrin.github.io/rqti/reference/german_grading.md).

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

- cancel:

  A logical value, optional, indicating whether participants are allowed
  to cancel an exam after starting it. Default is `FALSE`.

- suspend:

  A logical value, optional, indicating whether participants are allowed
  to suspend an exam after starting it and continue later. Default is
  `FALSE`.

- scoreprogress:

  A logical value, optional, indicating whether the progress of the
  score achieved so far should be displayed during the exam. Default is
  `FALSE`.

- questionprogress:

  A logical value, optional, indicating whether the number of solved
  questions should be displayed during the exam. Default is `FALSE`.

- maxscoreitem:

  A logical value, optional, indicating whether the maximum score of an
  item should be displayed. Default is `TRUE`.

- menu:

  A logical value, optional, indicating whether the menu should be
  displayed during the exam. Default is `TRUE`.

- titles:

  A logical value, optional, indicating whether question titles should
  be displayed during the exam. Default is `TRUE`.

- notes:

  A logical value, optional, indicating whether participants can take
  notes in OpenOlat during the exam. Default is `FALSE`.

- hidelms:

  A logical value, optional, indicating whether access to the OpenOlat
  learning management system should be hidden during the exam. Default
  is `TRUE`.

- hidefeedbacks:

  A logical value, optional, indicating whether feedback should be
  hidden. Default is `FALSE`.

- blockaftersuccess:

  A logical value, optional, indicating whether the exam should be
  blocked after successful completion. Default is `FALSE`.

- attempts:

  An integer value, optional, indicating how many attempts are allowed
  for the exam as a whole. Default is `1`.

- anonym:

  A logical value, optional, indicating whether anonymous users are
  allowed to take the exam. Default is `FALSE`.

- manualcorrect:

  A logical value, optional, indicating whether points and pass/fail
  status should be evaluated manually. Default is `FALSE`.

## Value

An
[AssessmentTestOpenOlat](https://shevandrin.github.io/rqti/reference/AssessmentTestOpenOlat-class.md)
object.

## See also

[`test()`](https://shevandrin.github.io/rqti/reference/test.md),
[`section()`](https://shevandrin.github.io/rqti/reference/section.md),
[`assessmentTest()`](https://shevandrin.github.io/rqti/reference/assessmentTest.md),
[AssessmentTest](https://shevandrin.github.io/rqti/reference/AssessmentTest-class.md),
[AssessmentSection](https://shevandrin.github.io/rqti/reference/AssessmentSection-class.md)

## Examples

``` r
sc <- sc <- singleChoice(prompt = "Question", choices = c("A", "B", "C"))
es <- new("Essay", prompt = "Question")
s <- section(c(sc, es), title = "Section with nonrandomized tasks")
t <- assessmentTestOpenOlat(list(s), title = "Example of the Exam")
```
