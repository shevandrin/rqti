# Create a section as part of a test content

Create an AssessmentSection `rqti`-object as part of a test content

## Usage

``` r
section(
  content,
  n_variants = 1L,
  seed_number = NULL,
  id = NULL,
  by = "variants",
  selection = NULL,
  title = character(0),
  time_limits = NA_integer_,
  visible = TRUE,
  shuffle = FALSE,
  max_attempts = NA_integer_,
  allow_comment = TRUE
)
```

## Arguments

- content:

  A character vector of Rmd, md, xml files, task- or section-objects.

- n_variants:

  An integer value indicating the number of task variants to create from
  Rmd files. Default is `1`.

- seed_number:

  An integer vector, optional, specifying seed numbers to reproduce the
  result of calculations.

- id:

  A character value, optional, serving as the identifier of the
  assessment section.

- by:

  A character with two possible values: "variants" or "files",
  indicating the type of the test structure. Default is "variants".

- selection:

  An integer value, optional, defining how many children of the section
  are delivered in the test. Default is `NULL`, meaning "no selection".

- title:

  A character value, optional, representing the title of the section. If
  not provided, it defaults to `identifier`.

- time_limits:

  An integer value, optional, controlling the amount of time a candidate
  is allowed for this part of the test.

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

[`test()`](https://shevandrin.github.io/rqti/reference/test.md),
[`test4opal()`](https://shevandrin.github.io/rqti/reference/test4opal.md)

## Examples

``` r
sc <- new("SingleChoice", prompt = "Question", choices = c("A", "B", "C"))
es <- new("Essay", prompt = "Question")
# Since ready-made S4 "AssessmentItem" objects are taken, in this example a
#permanent section consisting of two tasks is created.
s <- section(c(sc, es), title = "Section with nonrandomized tasks")

# Since Rmd files with randomization of internal variables are taken,
#in this example 2 variants are created with a different seed number for each.
path <- system.file("rmarkdown/templates/", package='rqti')
file1 <- file.path(path, "singlechoice-simple/skeleton/skeleton.Rmd")
file2 <- file.path(path, "singlechoice-complex/skeleton/skeleton.Rmd")
s <- section(c(file1, file2), n_variants = 2,
title = "Section with two variants of tasks")
```
