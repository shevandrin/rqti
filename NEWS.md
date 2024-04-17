# rqti (development version)

## Bug fixes

* Handle some problems with html and mathml entities.

## New features

* Added constructor functions for task classes: singleChoice(), multipleChoice(),
essay(), ordering(), entry(), directedPair(), oneInColTable(), oneInRowTable(),
myltipleChoiceTable().

* Added constructor functions for content of Entry class: numericGap(), textGap(),
textGapOpal(), inlineChoice().

* Added constructor function for the feedback objects: modalFeedback(),
correctFeedback(), wrongFeedback().

* Added the ability to upload SURVEY resource type to Opal using the API. The upload2opal() function now includes a new parameter, as_survey, which allows you
to specify the resource type. Set as_survey = TRUE to upload as a SURVEY 
resource type.

# rqti 0.1.1

## Bug fixes

* Added the missing qti.js for rendering Rmd-files with tasks.

* Added processing of the pandoc --embed-resources parameter for pandoc versions < 2.19.

## New features

* Identifiers of AssessmentItem, AssessmentSection and AssessmentTest objects are checked for compliance with QTI requirements.

# rqti 0.1.0

* Initial CRAN submission.
