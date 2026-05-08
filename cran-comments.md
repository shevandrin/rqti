## Release 1.2.0 summary

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

* Fixed test() and test4opal() to correctly handle input provided as a list 
containing a single section.

## R CMD check results

0 errors | 0 warnings | 0 note
