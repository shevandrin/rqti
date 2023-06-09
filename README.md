
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![R-CMD-check](https://github.com/shevandrin/qti/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/shevandrin/qti/actions/workflows/R-CMD-check.yaml)
[![test-coverage](https://github.com/shevandrin/qti/actions/workflows/test-coverage.yaml/badge.svg)](https://github.com/shevandrin/qti/actions/workflows/test-coverage.yaml)
[![Codecov test
coverage](https://codecov.io/gh/shevandrin/qti/branch/main/graph/badge.svg)](https://app.codecov.io/gh/shevandrin/qti?branch=main)
[![Project Status: WIP - Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
<!-- badges: end -->

# qti

Note: this is work in progress, a stable release can be expected in Q4
2023.

The goal of `qti` is to provide a clean and independent library for
creating exercises and exams according to the
[QTI](https://www.imsglobal.org/question/qtiv2p1/imsqti_implv2p1.html)
standard directly from R.

Why do we need another package for creating exams when there is already
the `exams`-package? The philosophy of `exams` is **one for all**,
whereas `qti` follows the Unix-philosophy: **do one thing and do it
well**. tldr:

- `qti` has more (QTI) features (e.g. exercise type) than `exams`
- `qti` uses OOP (S4), the system is easy to extend (LMS specific needs)
- the Rmd-interface is cleaner as it just focues on QTI
- low-level functions can be used flexibly to create exercises
- `qti` puts a premium on testing, with currently over 100 tests
- rendering of QTI files in the browser (or viewer pane of RStudio)
  directly from R
- functions to upload files via REST API to LMS (for us OPAL, but you
  can implement your own)

If you just use QTI-exercises, you should check out our package. If you
need different formats next to QTI, e.g. print, LMS that do not support
QTI stick to `exams`.

<!-- Just focusing on QTI gives us more time to support great features of the QTI standard that are missing in `exams`. For instance, `qti` offers dropdown-inputs, ordering-exercises, and match-tables. -->

## Installation

``` r
install.packages("librarian") # skip if you have librarian already
#> Installing package into '/home/jt/R/x86_64-pc-linux-gnu-library/4.3'
#> (as 'lib' is unspecified)
librarian::shelf(shevandrin/qti)
```

## Supported Exercise Types

| Types                                                              | Notes                 | S4 Class name       |
|--------------------------------------------------------------------|-----------------------|---------------------|
| singlechoice                                                       | partially implemented | SingleChoice        |
| multiplechoice                                                     | partially implemented | MultipleChoice      |
| text entry                                                         | partially implemented | TextEntry           |
| numbers entry                                                      | in progress           | NumericEntry        |
| dropdown list                                                      | partially implemented | InlineChoice        |
| order                                                              | partially implemented | Order               |
| match (directed pair)                                              | partially implemented | DirectedPair        |
| match (table, one right answer in a row)                           | partially implemented | OneInRowTable       |
| match (table, one right answer in a column)                        | partially implemented | OneInColTable       |
| match (table, many right answers in columns and rows are possible) | partially implemented | MultipleChoiceTable |
| essay                                                              | partially implemented | Essay               |

## S4 Class diagramm

<figure>
<img src="man/figures/README-S4_classes_diagramm.jpg"
alt="Class diagramm S4." />
<figcaption aria-hidden="true">Class diagramm S4.</figcaption>
</figure>

## What is not possible

- Composites (several exercise types in one task) are not implemented
  because they do not work in our LMS (OPAL); several gaps do work,
  though
- Associates are not implemented because they does not work in OPAL

## making gaps

for gaps with text:  
- Simply use <code>\<\<\>\></code> for a gap, example:  
*Some text, and now the gap <code>\<\<Right answer\>\>\></code>*  
- or use YAML description inside \<\<\>\> to add more attributes:  
*Some Text, and then the gap: <code>\<\<{type: text, response: Right
answer, alternatives: \[Right answer, right answer, answer\],
case_sensitive: false, lenghth: 10, placeholder: some text\>\></code>
Some more text.*

#### List of attributes for YAML description of a gap with text content

| attribute      | type                    | description                                                                                                                                                      |
|----------------|-------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| type           | text                    | “type” attribute should assign “text” for gap with text content                                                                                                  |
| response       | text                    | string value that is a right response for the gap                                                                                                                |
| alternatives   | vector of string values | provides a set of alternative values that are considered as a right answer for the gap; the set of alternatives must not include the value of the correct answer |
| case_sensitive | logical                 | controls whether or not the candidate answer is case sensitive. In case of omission, “true” is assigned                                                          |
| length         | integer                 | sets the size of the text field                                                                                                                                  |
| placeholder    | string                  | provides placeholder text in the text field, can be used to show some pattern of answer                                                                          |
| score          | integer                 | mark for the correct answer to the question                                                                                                                      |

for gaps with numbers:

#### List of attributes for YAML description of a gap with numeric content

| attribute       | type    | description                                                                                                     |
|-----------------|---------|-----------------------------------------------------------------------------------------------------------------|
| type            | text    | “type” attribute should assign “numeric” for gap with numeric content                                           |
| response        | numeric | numeric value that is a right response for the gap                                                              |
| value_precision | numeric | number to indicate the upper and lower bounds within which the candidate’s answer is considered correct         |
| type_precision  | string  | can be "exact", "absolute", or "relative" only                                                                  |
| lower_bound     | logical | controls whether or not the lower bound is included in tolerance range. In case of omission, “true” is assigned |
| upper_bound     | logical | controls whether or not the upper bound is included in tolerance range. In case of omission, “true” is assigned |
| length          | integer | sets the size of the text field                                                                                 |
| placeholder     | string  | provides placeholder text in the text field, can be used to show some pattern of answer                         |
| score           | integer | mark for the correct answer to the question                                                                     |

for combination:

## Comparison between exams and qti

The `exams` package uses templates and pastes strings together to create
qti files. This has some disadvantages: it is error prone, not easy to
maintain and difficult to extend. If for instance, a new exercise type
needs to be added, many locations have to be changed. `qti` is supposed
to make life easier by providing some standard functions to create all
parts of the QTI xml file.

Extending exams is just a matter of composing the correct `qti`
functions. Testing small `qti` functions is easy, whereas the main
function of `exams` `make_item_body` consists of 736 lines. Indeed, this
function has grown substantially over time (todo: provide evidence).

Based on qti one can also develop new interfaces for creating exercises.
