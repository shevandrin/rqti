# rqti 1.0.0

### New features

* Major API Refactor: The API functionality has been refactored to require creating an Opal object for establishing a connection. Methods are now called on this object for interacting with the LMS API, replacing the previous function-based approach.

* Added a `verify_qti()` function to validate XML documents against the QTI v2.1 schema. Two schema versions are supported: the original IMS Global schema and an extended version that permits additional HTML tags.

* Added new constructor functions `assessmentTest()`, `assessmentTestOpal()`, `assessmentSection()`.

* The default values of the "academic_grading" parameter/slot have been updated in the functions `assessmentTest()`, `assessmentTestOpal()`, `test()`, and in the classes `AssessmentTest` and `AssessmentTestOpal`. This parameter/slot is a named numeric vector that defines the grade table shown to candidates as feedback at the end of the test. The updated default follows the German grading system: gt <- c("1.0" = 0.95, "1.3" = 0.9, "1.7" = 0.85, "2.0" = 0.8, "2.3" = 0.75, "2.7" = 0.7, "3.0" = 0.65, "3.3" = 0.6, "3.7" = 0.55, "4.0" = 0.5, "5.0" = 0), where each grade corresponds to the minimum percentage score required to achieve it. To disable the grading table at the end of the test, set this parameter to NA_real_.

* Generic functions are now exported to allow advanced users to extend the functionality of S4 classes `(createItemBody()`, `createResponseDeclaration()`, `createOutcomeDeclaration()`, `createResponseProcessing()`, `createText()`).

* Added support for the `preview_feedback` option within 'params' in the YAML section of R Markdown files.

* Renamed the service name in the keyring system credential storage to "rqtiopal".

* Renamed the "contributor" slot in `QtiContributor` to 'name'.

### Improvements

* QTIJS rendering (`DirectedPair` type, round Score and Maxscore values).

* Added a '\<div\>' tag as a root child within the 'itemBody' element for `Entry` type tasks to ensure compatibility with the LMS OpenOlat.

* The functions `qti_metadata()` and `qti_contributor()` have been deprecated. Use `qtiMetadata()` and `qtiContributor()` instead.

* The 'question_type' column has been removed from the data frame returned by `extract_result(level = "item")`.


# rqti 0.3.0

### Bug fixes

* Fix parsing R Markdown files with tables according the latest pandoc version.

* Fix `extract_results(level="items")` for `Ordering` type, when candidate response
is not given.

* Fix error at `createQtitask(obj, zip=TRUE)`.

### New features

* New API OPAL function `get_course_elements()` returns dataframe with elements of 
the course by course id.

* New API OPAL function `get_course_results()` returns an xml with data about 
results by course id and node id.

* New API OPAL function `publish_courses()` for publishing a course by Resource ID.

### Improvements

* QTIJS rendering.

# rqti 0.2.1

### Bug fixes

* In metadata default value for the slot "contribution_date" is assigned to 
Date(0). 

### New features

* method `createQtiTask()` can create XML or zip files, to control this use 
parameter zip=TRUE.

* QTIJS rendering shows feedback and score for tasks.

# rqti 0.2.0

### Bug fixes

* Handle problem with xsd scheme for xml validation.

* Handle some problems with html and mathml entities.

### New features

* Improved the appearance of the tasks in QTIJS viewer.

* Added constructor functions for task classes: `singleChoice()`, `multipleChoice()`,
`essay()`, `ordering()`, `entry()`, `directedPair()`, `oneInColTable()`, `oneInRowTable()`, `myltipleChoiceTable()`.

* Added constructor functions for content of Entry class: `numericGap()`, `textGap()`,
`textGapOpal()`, `inlineChoice()`.

* Added constructor functions for the feedback objects: `modalFeedback()`,
`correctFeedback()`, `wrongFeedback()`.

* Added the ability to upload SURVEY resource type to Opal using the API. The `upload2opal()` function now includes a new parameter, "as_survey", which allows you to specify the resource type. Set "as_survey = TRUE" to upload as a SURVEY 
resource type.

* Added the ability to put metadata in the manifest file for tests. To store metadata information `AssessmentItem` and `AssessmentTest` use slot "@metadata" that takes `QtiMetadata` (and `QtiContributor` inside) classes as type. Two construction functions have been added to create objects: `qti_metadata()` and `qti_contributor()`.

# rqti 0.1.1

### Bug fixes

* Added the missing qti.js for rendering Rmd-files with tasks.

* Added processing of the pandoc --embed-resources parameter for pandoc versions < 2.19.

### New features

* Identifiers of `AssessmentItem`, `AssessmentSection` and `AssessmentTest` objects are checked for compliance with QTI requirements.

# rqti 0.1.0

* Initial CRAN submission.
