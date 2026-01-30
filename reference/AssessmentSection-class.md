# Class "AssessmentSection"

Class `AssessmentSection` is responsible for forming a section in the
test XML specification according to QTI 2.1.

## Slots

- `identifier`:

  A character representing the unique identifier of the assessment
  section. By default, it is generated as 'id_section_dddd', where dddd
  represents random digits.

- `title`:

  A character representing the title of the section in the test. By
  default, it takes the value of the identifier.

- `time_limit`:

  A numeric value, optional, controlling the amount of time *in munutes*
  a candidate is allowed for this part of the test.

- `visible`:

  A boolean value, optional. If TRUE, it shows this section in the
  hierarchy of the test structure. Default is `TRUE`.

- `assessment_item`:

  A list containing AssessmentSection and/or Assessment item objects,
  such as
  [SingleChoice](https://shevandrin.github.io/rqti/reference/SingleChoice-class.md),
  [MultipleChoice](https://shevandrin.github.io/rqti/reference/MultipleChoice-class.md),
  [Essay](https://shevandrin.github.io/rqti/reference/Essay-class.md),
  [Entry](https://shevandrin.github.io/rqti/reference/Entry-class.md),
  [Ordering](https://shevandrin.github.io/rqti/reference/Ordering-class.md),
  [OneInRowTable](https://shevandrin.github.io/rqti/reference/OneInRowTable-class.md),
  [OneInColTable](https://shevandrin.github.io/rqti/reference/OneInColTable-class.md),
  [MultipleChoiceTable](https://shevandrin.github.io/rqti/reference/MultipleChoiceTable-class.md),
  and
  [DirectedPair](https://shevandrin.github.io/rqti/reference/DirectedPair-class.md).

- `shuffle`:

  A boolean value, optional, responsible for randomizing the order in
  which the assessment items and subsections are initially presented to
  the candidate. Default is `FALSE`.

- `selection`:

  A numeric value, optional, defining how many children of the section
  are delivered in the test.

- `max_attempts`:

  A numeric value, optional, enabling the maximum number of attempts a
  candidate is allowed to pass in this section.

- `allow_comment`:

  A boolean value, optional, enabling to allow the candidate to leave
  comments in each question of the section. Defautl is `TRUE`.

## See also

[`section()`](https://shevandrin.github.io/rqti/reference/section.md),
[`test()`](https://shevandrin.github.io/rqti/reference/test.md),
[`test4opal()`](https://shevandrin.github.io/rqti/reference/test4opal.md),
[AssessmentTest](https://shevandrin.github.io/rqti/reference/AssessmentTest-class.md),
[AssessmentTestOpal](https://shevandrin.github.io/rqti/reference/AssessmentTestOpal-class.md).

## Examples

``` r
sc1 <- new("SingleChoice", prompt = "Example task 1", title = "SC1",
             identifier = "q1", choices = c("a", "b", "c"))
sc2 <- new("SingleChoice", prompt = "Example task 2", title = "SC2",
             identifier = "q2", choices = c("A", "B", "C"))
sc3 <- new("SingleChoice", prompt = "Example task 3", title = "SC3",
             identifier = "q3", choices = c("aa", "bb", "cc"))
exam_section <- new("AssessmentSection",
                    identifier = "sec_id",
                    title = "Section",
                    time_limit = 20,
                    visible = FALSE,
                    assessment_item = list(sc1, sc2, sc3),
                    shuffle = FALSE,
                    selection = 1,
                    max_attempts = 1,
                    allow_comment = FALSE)
```
