## Release 1.0.0 summary

## New features

* Major API Refactor: The API functionality has been refactored to require creating an Opal object for establishing a connection. Methods are now called on this object for interacting with the LMS API, replacing the previous function-based approach.

* Added a `verify_qti()` function to validate XML documents against the QTI v2.1 schema. Two schema versions are supported: the original IMS Global schema and an extended version that permits additional HTML tags.

* Added new constructor functions `assessmentTest()`, `assessmentTestOpal()`, `assessmentSection()`.

* The default values of the "academic_grading" parameter/slot have been updated in the functions `assessmentTest()`, `assessmentTestOpal()`, `test()`, and in the classes `AssessmentTest` and `AssessmentTestOpal`. This parameter/slot is a named numeric vector that defines the grade table shown to candidates as feedback at the end of the test. The updated default follows the German grading system: gt <- c("1.0" = 0.95, "1.3" = 0.9, "1.7" = 0.85, "2.0" = 0.8, "2.3" = 0.75, "2.7" = 0.7, "3.0" = 0.65, "3.3" = 0.6, "3.7" = 0.55, "4.0" = 0.5, "5.0" = 0), where each grade corresponds to the minimum percentage score required to achieve it. To disable the grading table at the end of the test, set this parameter to NA_real_.

* Generic functions are now exported to allow advanced users to extend the functionality of S4 classes `(createItemBody()`, `createResponseDeclaration()`, `createOutcomeDeclaration()`, `createResponseProcessing()`, `createText()`).

* Added support for the `preview_feedback` option within 'params' in the YAML section of R Markdown files.

* Renamed the service name in the keyring system credential storage to "rqtiopal".

* Renamed the "contributor" slot in `QtiContributor` to 'name'.

## Improvements

* QTIJS rendering (`DirectedPair` type, round Score and Maxscore values).

* Added a '\<div\>' tag as a root child within the 'itemBody' element for `Entry` type tasks to ensure compatibility with the LMS OpenOlat.

* The functions `qti_metadata()` and `qti_contributor()` have been deprecated. Use `qtiMetadata()` and `qtiContributor()` instead.

* The 'question_type' column has been removed from the data frame returned by `extract_result(level = "item")`.


## R CMD check results

0 errors | 0 warnings | 0 note
