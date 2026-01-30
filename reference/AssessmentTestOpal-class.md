# Class "AssessmentTestOpal"

Class `AssessmentTestOpal` is responsible for creating XML exam files
according to the QTI 2.1 standard for LMS Opal.

## Details

Test consists of one or more sections. Each section can have one or more
questions/tasks and/or one or more sub sections.

## Slots

- `identifier`:

  A character representing the unique identifier of the assessment test.
  By default, it is generated as 'id_test_dddd', where dddd represents
  random digits.

- `title`:

  A character representing the title of the test. By default, it takes
  the value of the identifier.

- `points`:

  Do not use directly; the maximum number of points for the exam/test.
  It is calculated automatically as a sum of points of included tasks.

- `test_part_identifier`:

  A character representing the identifier of the test part.

- `navigation_mode`:

  A character value, optional, determining the general paths that the
  candidate may have during the exam. Possible values:

  - "linear" - candidate is not allowed to return to the previous
    questions.

  - "nonlinear" - candidate is free to navigate. This is used by
    default.

- `submission_mode`:

  A character value, optional, determining when the candidate's
  responses are submitted for response processing. Possible values:

  - "individual" - submit candidates' responses on an item-by-item
    basis. This is used by default.

  - "simultaneous" - candidates' responses are submitted all together by
    the end of the test.

- `section`:

  A list containing one or more
  [AssessmentSection](https://shevandrin.github.io/rqti/reference/AssessmentSection-class.md)
  objects.

- `time_limit`:

  A numeric value, optional, controlling the amount of time in minutes
  which a candidate is allowed for this part of the test.

- `max_attempts`:

  A numeric value, optional, enabling the maximum number of attempts
  that a candidate is allowed to pass.

- `allow_comment`:

  A boolean value, optional, enabling to allow candidates to leave
  comments in each question.

- `rebuild_variables`:

  A boolean value, optional, enabling to recalculate variables and
  reshuffle the order of choices for each item-attempt.

- `academic_grading`:

  A named numeric vector that defines the grade table shown to the
  candidate as feedback at the end of the test. The default is the
  German grading system: gt \<- c("1.0" = 0.95, "1.3" = 0.9, "1.7" =
  0.85, "2.0" = 0.8, "2.3" = 0.75, "2.7" = 0.7, "3.0" = 0.65, "3.3" =
  0.6, "3.7" = 0.55, "4.0" = 0.5, "5.0" = 0) Each grade corresponds to a
  minimum percentage score required to achieve it. To hide the grading
  table at the end of the test, set this parameter to NA_real\_.

- `grade_label`:

  A character value, optional, representing a short message to display
  with a grade in the final feedback. For multilingual usage, it hat to
  be a named vector with two-letter ISO language codes as names (e.g.,
  c(en="Grade", de="Note")); during test creation, it takes the value
  for the language of the operating system. Default is c(en="Grade",
  de="Note").

- `table_label`:

  A character value, optional, representing a concise message to display
  as the column title of the grading table in the final feedback. For
  multilingual usage, it hat to be a named vector with two-letter ISO
  language codes as names (e.g., c(en="Grade", de="Note")); during test
  creation, it takes the value for the language of the operating system.
  Default is c(en="Grade", de="Note").

- `metadata`:

  An object of class
  [QtiMetadata](https://shevandrin.github.io/rqti/reference/QtiMetadata-class.md)
  that holds metadata information about the test.

- `show_test_time`:

  A boolean value, optional, determining whether to show the candidate
  elapsed processing time without time limit. Default is `FALSE`.

- `calculator`:

  A character value, optional, determining whether to show a calculator
  to the candidate. Possible values:

  - "simple"

  - "scientific".

- `mark_items`:

  A boolean value, optional, determining whether to allow candidate
  marking of questions. Default is `TRUE`.

- `keep_responses`:

  A boolean value, optional, determining whether to save candidate's
  answers from the previous attempt. Default is `FALSE`.

- `files`:

  A character vector, optional, containing paths to files that will be
  accessible to the candidate during the test/exam.

## See also

[AssessmentSection](https://shevandrin.github.io/rqti/reference/AssessmentSection-class.md),
[AssessmentTest](https://shevandrin.github.io/rqti/reference/AssessmentTest-class.md),
[`test()`](https://shevandrin.github.io/rqti/reference/test.md),
[`test4opal()`](https://shevandrin.github.io/rqti/reference/test4opal.md),
[`section()`](https://shevandrin.github.io/rqti/reference/section.md).

## Examples

``` r
# This example creates test 'exam' with one section 'exam_section' which
# consists of two questions/tasks: essay and single choice types
task1 <- new("Essay", prompt = "Test task", title = "Essay",
             identifier = "q1")
task2 <- new("SingleChoice", prompt = "Test task", title = "SingleChoice",
             choices = c("A", "B", "C"), identifier = "q2")
exam_section <- new("AssessmentSection", identifier = "sec_id",
                    title = "section", assessment_item = list(task1, task2))
exam <- new("AssessmentTestOpal",
            identifier = "id_test_1234",
            title = "Example of Exam",
            navigation_mode = "linear",
            submission_mode = "individual",
            section = list(exam_section),
            time_limit = 90,
            max_attempts = 1,
            grade_label = "Preliminary grade",
            show_test_time = TRUE,
            calculator = "scientific-calculator",
            mark_items = TRUE,
            files = "text_book.pdf")
```
