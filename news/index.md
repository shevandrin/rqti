# Changelog

## rqti (development version)

## rqti 1.0.0

CRAN release: 2025-03-05

#### New features

- Major API Refactor: The API functionality has been refactored to
  require creating an Opal object for establishing a connection. Methods
  are now called on this object for interacting with the LMS API,
  replacing the previous function-based approach.

- Added a
  [`verify_qti()`](https://shevandrin.github.io/rqti/reference/verify_qti.md)
  function to validate XML documents against the QTI v2.1 schema. Two
  schema versions are supported: the original IMS Global schema and an
  extended version that permits additional HTML tags.

- Added new constructor functions
  [`assessmentTest()`](https://shevandrin.github.io/rqti/reference/assessmentTest.md),
  [`assessmentTestOpal()`](https://shevandrin.github.io/rqti/reference/assessmentTestOpal.md),
  [`assessmentSection()`](https://shevandrin.github.io/rqti/reference/assessmentSection.md).

- The default values of the “academic_grading” parameter/slot have been
  updated in the functions
  [`assessmentTest()`](https://shevandrin.github.io/rqti/reference/assessmentTest.md),
  [`assessmentTestOpal()`](https://shevandrin.github.io/rqti/reference/assessmentTestOpal.md),
  [`test()`](https://shevandrin.github.io/rqti/reference/test.md), and
  in the classes `AssessmentTest` and `AssessmentTestOpal`. This
  parameter/slot is a named numeric vector that defines the grade table
  shown to candidates as feedback at the end of the test. The updated
  default follows the German grading system: gt \<- c(“1.0” = 0.95,
  “1.3” = 0.9, “1.7” = 0.85, “2.0” = 0.8, “2.3” = 0.75, “2.7” = 0.7,
  “3.0” = 0.65, “3.3” = 0.6, “3.7” = 0.55, “4.0” = 0.5, “5.0” = 0),
  where each grade corresponds to the minimum percentage score required
  to achieve it. To disable the grading table at the end of the test,
  set this parameter to NA_real\_.

- Generic functions are now exported to allow advanced users to extend
  the functionality of S4 classes `(createItemBody()`,
  [`createResponseDeclaration()`](https://shevandrin.github.io/rqti/reference/createResponseDeclaration-methods.md),
  [`createOutcomeDeclaration()`](https://shevandrin.github.io/rqti/reference/createOutcomeDeclaration-methods.md),
  [`createResponseProcessing()`](https://shevandrin.github.io/rqti/reference/createResponseProcessing-methods.md),
  [`createText()`](https://shevandrin.github.io/rqti/reference/createText-methods.md)).

- Added support for the `preview_feedback` option within ‘params’ in the
  YAML section of R Markdown files.

- Renamed the service name in the keyring system credential storage to
  “rqtiopal”.

- Renamed the “contributor” slot in `QtiContributor` to ‘name’.

#### Improvements

- QTIJS rendering (`DirectedPair` type, round Score and Maxscore
  values).

- Added a ‘\<div\>’ tag as a root child within the ‘itemBody’ element
  for `Entry` type tasks to ensure compatibility with the LMS OpenOlat.

- The functions
  [`qti_metadata()`](https://shevandrin.github.io/rqti/reference/qti_metadata.md)
  and
  [`qti_contributor()`](https://shevandrin.github.io/rqti/reference/qti_contributor.md)
  have been deprecated. Use
  [`qtiMetadata()`](https://shevandrin.github.io/rqti/reference/qtiMetadata.md)
  and
  [`qtiContributor()`](https://shevandrin.github.io/rqti/reference/qtiContributor.md)
  instead.

- The ‘question_type’ column has been removed from the data frame
  returned by `extract_result(level = "item")`.

## rqti 0.3.0

CRAN release: 2024-07-19

#### Bug fixes

- Fix parsing R Markdown files with tables according the latest pandoc
  version.

- Fix `extract_results(level="items")` for `Ordering` type, when
  candidate response is not given.

- Fix error at `createQtitask(obj, zip=TRUE)`.

#### New features

- New API OPAL function `get_course_elements()` returns dataframe with
  elements of the course by course id.

- New API OPAL function `get_course_results()` returns an xml with data
  about results by course id and node id.

- New API OPAL function `publish_courses()` for publishing a course by
  Resource ID.

#### Improvements

- QTIJS rendering.

## rqti 0.2.1

CRAN release: 2024-05-26

#### Bug fixes

- In metadata default value for the slot “contribution_date” is assigned
  to Date(0).

#### New features

- method
  [`createQtiTask()`](https://shevandrin.github.io/rqti/reference/createQtiTask-methods.md)
  can create XML or zip files, to control this use parameter zip=TRUE.

- QTIJS rendering shows feedback and score for tasks.

## rqti 0.2.0

CRAN release: 2024-05-08

#### Bug fixes

- Handle problem with xsd scheme for xml validation.

- Handle some problems with html and mathml entities.

#### New features

- Improved the appearance of the tasks in QTIJS viewer.

- Added constructor functions for task classes:
  [`singleChoice()`](https://shevandrin.github.io/rqti/reference/singleChoice.md),
  [`multipleChoice()`](https://shevandrin.github.io/rqti/reference/multipleChoice.md),
  [`essay()`](https://shevandrin.github.io/rqti/reference/essay.md),
  [`ordering()`](https://shevandrin.github.io/rqti/reference/ordering.md),
  [`entry()`](https://shevandrin.github.io/rqti/reference/entry.md),
  [`directedPair()`](https://shevandrin.github.io/rqti/reference/directedPair.md),
  [`oneInColTable()`](https://shevandrin.github.io/rqti/reference/oneInColTable.md),
  [`oneInRowTable()`](https://shevandrin.github.io/rqti/reference/oneInRowTable.md),
  `myltipleChoiceTable()`.

- Added constructor functions for content of Entry class:
  [`numericGap()`](https://shevandrin.github.io/rqti/reference/numericGap_doc.md),
  [`textGap()`](https://shevandrin.github.io/rqti/reference/textGap_doc.md),
  [`textGapOpal()`](https://shevandrin.github.io/rqti/reference/textGapOpal_doc.md),
  [`inlineChoice()`](https://shevandrin.github.io/rqti/reference/inlineChoice.md).

- Added constructor functions for the feedback objects:
  [`modalFeedback()`](https://shevandrin.github.io/rqti/reference/modalFeedback.md),
  [`correctFeedback()`](https://shevandrin.github.io/rqti/reference/correctFeedback.md),
  [`wrongFeedback()`](https://shevandrin.github.io/rqti/reference/wrongFeedback.md).

- Added the ability to upload SURVEY resource type to Opal using the
  API. The
  [`upload2opal()`](https://shevandrin.github.io/rqti/reference/upload2opal.md)
  function now includes a new parameter, “as_survey”, which allows you
  to specify the resource type. Set “as_survey = TRUE” to upload as a
  SURVEY resource type.

- Added the ability to put metadata in the manifest file for tests. To
  store metadata information `AssessmentItem` and `AssessmentTest` use
  slot “@metadata” that takes `QtiMetadata` (and `QtiContributor`
  inside) classes as type. Two construction functions have been added to
  create objects:
  [`qti_metadata()`](https://shevandrin.github.io/rqti/reference/qti_metadata.md)
  and
  [`qti_contributor()`](https://shevandrin.github.io/rqti/reference/qti_contributor.md).

## rqti 0.1.1

CRAN release: 2024-03-21

#### Bug fixes

- Added the missing qti.js for rendering Rmd-files with tasks.

- Added processing of the pandoc –embed-resources parameter for pandoc
  versions \< 2.19.

#### New features

- Identifiers of `AssessmentItem`, `AssessmentSection` and
  `AssessmentTest` objects are checked for compliance with QTI
  requirements.

## rqti 0.1.0

CRAN release: 2024-03-19

- Initial CRAN submission.
