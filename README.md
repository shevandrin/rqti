
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->
<!-- badges: end -->

# qti

Note: this is work in progress, at the moment you cannot actually use
this package.

The goal of `qti` is to provide a clean and independent library for
creating xml files according to the qti standard.

At the moment the exams package uses templates and pastes strings
together to create qti files. This has some disadvantages: it is error
prone, hard to maintain and extend. If for instance, a new exercise type
needs to be added, many locations have to be changed. `qti` is supposed
to make life easier by providing some standard functions to create all
parts of the xml file. It uses xml2, so is more readable and less error
prone.

An initial idea was to have something like htmltools for qti. (Maybe the
qti-standard is too complex for that.)

Extending exams is just a matter of composing the correct `qti`
functions. Testing small `qti` functions is easy, whereas the main
function of `exams` `make_item_body` consists of 736 lines. Indeed, this
function has grown substantially over time (todo: provide evidence).

Based on qti one can also develop new interfaces for creating exercises.
Our companion package `rex` is based on `exams` but provides new inputs
such as:

-   multiple gaps and dropdowns in between text
-   order exercises
-   matching exercises

Specifically, adding multiple gaps or dropdowns in between text is
rather difficult to do within the existing exams package.

## features of rex

should be moved to rex

-   rendering of qti files in in the browser (or viewer pane)
-   functions to upload files via REST API to LMS (for us OPAL, but you
    can implement your own)

## Installation

## Supported Exercise Types

| Types                 | Notes                 | S4 Class name  |
|-----------------------|-----------------------|----------------|
| singlechoice          | partially implemented | SingleChoice   |
| multiplechoice        | partially implemented | MultipleChoice |
| text entry            | partially implemented |                |
| numbers entry         | in progress           |                |
| dropdown list         | partially implemented |                |
| order                 | partially implemented |                |
| match (directed pair) | partially implemented |                |
| match (table)         | partially implemented |                |
| essay                 | partially implemented |                |

## What is not possible

-   Composites are not implemented because they do not work in our LMS
    (OPAL); several gaps do work, though
-   Associates are not implemented because they does not work in OPAL

## create rmd for

<https://www.imsglobal.org/question/qtiv2p1/imsqti_implv2p1.html>

types of tasks (items):

-   singlechoice
-   multiplechoice
-   text entry
-   numbers entry
-   clozes at the end
-   dropdown,
-   associate (!doesnt work in Opal),
-   order,
-   match (directed pair)
-   match (matchMax\>1, table)
-   essay (extended_text in qti)

be creative: clozes in between text, dropdowns in between text -\>
implement some yaml for input

## making gaps

Simply use \<\<\>\> for a gap, example:

Some Text, and now the gap: \<\<extype:num, solution:10, length:3\>\>
Some more text.

## making dropdowns
