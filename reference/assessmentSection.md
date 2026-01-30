# Create an object [AssessmentSection](https://shevandrin.github.io/rqti/reference/AssessmentSection-class.md)

Create an
[AssessmentSection](https://shevandrin.github.io/rqti/reference/AssessmentSection-class.md)
`rqti`-object as part of a test content

## Usage

``` r
assessmentSection(
  assessment_item,
  identifier = generate_id(type = "section"),
  title = identifier,
  selection = NA_integer_,
  time_limit = NA_integer_,
  visible = TRUE,
  shuffle = FALSE,
  max_attempts = NA_integer_,
  allow_comment = TRUE
)
```

## Arguments

- assessment_item:

  A list containing
  [AssessmentSection](https://shevandrin.github.io/rqti/reference/AssessmentSection-class.md)
  and/or Assessment item objects, such as
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

- identifier:

  A character value indicating the identifier of the test file. By
  default, it is generated as 'id_section_dddd', where dddd represents
  random digits.

- title:

  A character value, optional, representing the file title. By default,
  it takes the value of the `identifier`.

- selection:

  An integer value, optional, defining how many children of the section
  are delivered in the test. Default is `NA_integer_`, meaning "no
  selection".

- time_limit:

  An integer value, optional, controlling the amount of time in munutes
  a candidate is allowed for this part of the test.

- visible:

  A boolean value, optional, indicating whether the title of this
  section is shown in the hierarchy of the test structure. Default is
  `TRUE`.

- shuffle:

  A boolean value, optional, responsible for randomizing the order in
  which the assessment items and subsections are initially presented to
  the candidate. Default is `FALSE`.

- max_attempts:

  An integer value, optional, enabling the maximum number of attempts
  allowed for a candidate to pass this section.

- allow_comment:

  A boolean value, optional, enabling candidates to leave comments on
  each question of the section. Default is `TRUE`.

## Value

An object of class
[AssessmentSection](https://shevandrin.github.io/rqti/reference/AssessmentSection-class.md).

## See also

[`section()`](https://shevandrin.github.io/rqti/reference/section.md),
[`test()`](https://shevandrin.github.io/rqti/reference/test.md),
[`test4opal()`](https://shevandrin.github.io/rqti/reference/test4opal.md)

## Examples

``` r
sc <- singleChoice(prompt = "Question", choices = c("A", "B", "C"))
es <- essay(prompt = "Question")
# Since ready-made S4 "AssessmentItem" objects are taken, in this example a
#permanent section consisting of two tasks is created.
s <- assessmentSection(list(sc, es), title = "Section with nonrandomized tasks")
```
