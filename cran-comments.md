## Release 0.2.0 summary

### Bug fixes

* Handle problem with xsd scheme for xml validation. Due to this reason the CRAN tests failed.

* Handle some problems with html and mathml entities.

### New features

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

## R CMD check results

0 errors | 0 warnings | 1 note

* This is a new release.
