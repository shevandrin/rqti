# rqti 1.2.1

## Bug fixes

* Replaced platform-specific external SHA1 commands in tests with an R-native
hash implementation to improve portability across operating systems.

* Fixed MathJax rendering for dynamically loaded referent content in QTI.JS.

# rqti 1.2.0

## New features

* Added support for OpenOlat via a new class `AssessmentTestOpenOlat`.
It introduced OpenOlat-specific configuration options (e.g., navigation behavior,
visibility settings, number of attempts) as slots and corresponding arguments in
`assessmentTestOpenOlat()`.

* Added `fallback_titles` argument to `test()` and `test4opal()` to control how
section and item titles are assigned when not explicitly provided. Supported
values are "filename" and "generic". The `AssessmentTest` class now includes a
`fallback_titles` slot.

* Added a new slot `scoring_scheme` to the `SingleChoice` class to control how 
response options are scored. Supported values are "standard" (default) and 
"penalty". Introduced penalty-based scoring for single-choice tasks. When 
`scoring_scheme = "penalty"`, incorrect answers receive a negative score of
-points/(k-1), where k is the number of response options. This ensures 
that random guessing yields an expected score of zero.

* Added a new `stylesheet_path` slot to `AssessmentTest` objects, allowing users to 
include custom CSS stylesheets at the assessment test level. When 
academic_grading is enabled, the default styles/rqti.css stylesheet is included
automatically, and custom styles can be added to override the default appearance.

* Added `german_grading()`, a helper function that returns a predefined German 
grading scale for the `academic_grading` argument in `test()` and `test4opal()`, 
avoiding the need to manually define grading vectors. This grading scheme can 
also be stored directly in the `academic_grading` slot of `AssessmentTest` objects.

* Added helper `provide_file()` to embed local files directly into .Rmd tasks as #
Base64-encoded hyperlinks for downloadable attachments.

* `section()` now supports Rmd files created with the `exams` package.
Such files are automatically detected and converted to QTI 2.1 XML via 
`exams::exams2qti21()`, so they can be used directly without additional wrapping.

* Added `exams_task()` helper for explicit control over exams-based tasks.
While `section()` can handle exams .Rmd files automatically, `exams_task()` 
can be used when additional control is needed, e.g., to assign a custom title.
The function converts the Rmd file and returns the path to the generated XML 
file in a temporary directory, allowing combination with native rqti items.

* Enhanced LMS Opal API with new functions `getCourseGroups()` and 
`getGroupUsers()` for retrieving course groups and group users as data frames.

## Improvements

* Enhanced `verify_qti()` to support different input types, provide more 
informative validation messages, and use both `xmllint` and `xml2` backends
for XML validation.

* `extract_results(level = "task")` now includes an additional column 
containing `scorerComment` for manually scored item results.

* Images referenced in external XML files are now automatically embedded as 
Base64. This ensures that tasks are fully self-contained and do not depend on
  external image files.
  
* Changed the default `time_limit` for `AssessmentTest` and `AssessmentTestOpal`
objects (and for all related helper functions) to NULL, so time limits are no 
longer set at the test level by default.

* Changed the default value of `allow_paste` in `Essay` items to TRUE.

## Bug fixes

* Fixed handling of consecutive gaps in .Rmd tasks.

* Fixed identifier validation regex to correctly allow hyphens in valid 
identifiers.

* Fixed `test()` and `test4opal()` to correctly handle input provided as a list 
containing a single section.

# rqti 1.1.0

## New features

* Added support for the `RQTI_API_USER` environment variable. If `api_user` is not provided explicitly, its value is now read from the environment.

## Bug fixes

* Fixed an issue in `upload2opal()` where arguments `open_in_browser` and `as_survey` were not forwarded to `upload2LMS()`.

* Fixed problems in auto-generated scripts via RStudio template.

* Fixed parameter serialization in `dropdown()` to preserve long values, normalize numeric and logical formatting, and ensure stable, test-consistent gap interaction output.

## Improvements

* Rendering functions (`render_qtijs()`, `render_xml()`, and `render_zip()`) now accept a `qtijs_path` argument (defaulting to `qtijs_pkg_path()`), allowing explicit control over the qtijs installation path.

* Added a `daemon` argument to `start_server()` for improved server control.

* Exported the `qtijs_pkg_path()` helper function for accessing the qtijs installation path.

* Improved error and warning messages for duplicate identifiers.

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
