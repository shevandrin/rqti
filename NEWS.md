# rqti (development version)

## Improvements

* QTIJS rendering for DirectedPair.

# rqti 0.3.0

## Bug fixes

* Fix parsing R Markdown files with tables according the latest pandoc version.
* Fix extract_results(level="items") for Ordering type, when candidate response
is not given
* Fix error at createQtitask(obj, zip=TRUE)

## New features

* New API OPAL function get_course_elements() returns dataframe with elements of 
the course by course id.

* New API OPAL function get_course_results() returns an xml with data about 
results by course id and node id.

* New API OPAL function publish_courses() for publishing a course by Resource ID.

## Improvements

* QTIJS rendering.

# rqti 0.2.1

## Bug fixes

* In metadata default value for the slot contribution date is assigned to 
Date(0). 

## New features

* method createQtiTask() can create XML or zip files, to control this use 
parameter zip=TRUE.

* QTIJS rendering shows feedback and score for tasks.

# rqti 0.2.0

## Bug fixes

* Handle problem with xsd scheme for xml validation.

* Handle some problems with html and mathml entities.

## New features

* Improved the appearance of the tasks in QTIJS viewer.

* Added constructor functions for task classes: singleChoice(), multipleChoice(),
essay(), ordering(), entry(), directedPair(), oneInColTable(), oneInRowTable(),
myltipleChoiceTable().

* Added constructor functions for content of Entry class: numericGap(), textGap(),
textGapOpal(), inlineChoice().

* Added constructor functions for the feedback objects: modalFeedback(),
correctFeedback(), wrongFeedback().

* Added the ability to upload SURVEY resource type to Opal using the API. The upload2opal() function now includes a new parameter, as_survey, which allows you to specify the resource type. Set as_survey = TRUE to upload as a SURVEY 
resource type.

* Added the ability to put metadata in the manifest file for tests. To store metadata information AssessmentItem and AssessmentTest use slot @metadata that takes QtiMetadata (and QtiContributor inside) classes as type. Two construction functions have been added to create objects: qti_metadata() and qti_contributor().

# rqti 0.1.1

## Bug fixes

* Added the missing qti.js for rendering Rmd-files with tasks.

* Added processing of the pandoc --embed-resources parameter for pandoc versions < 2.19.

## New features

* Identifiers of AssessmentItem, AssessmentSection and AssessmentTest objects are checked for compliance with QTI requirements.

# rqti 0.1.0

* Initial CRAN submission.
