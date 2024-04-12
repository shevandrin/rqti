# rqti (development version)

## Bug fixes

* Handle some problems with html and mathml entities.

## New features

* Added constructor functions for task classes: singleChoice(), multipleChoice(),
essay(), order_rqti(), entry(), directedPair(), oneInColTable(), oneInRowTable(),
myltipleChoiceTable().

* Added constructor functions for content of Entry class: numericGap(), textGap(),
textGapOpal(), inlineChoice().

* Added constructor function for the feedback objects: modalFeedback(),
correctFeedback(), wrongFeedback().

# rqti 0.1.1

## Bug fixes

* Added the missing qti.js for rendering Rmd-files with tasks.

* Added processing of the pandoc --embed-resources parameter for pandoc versions < 2.19.

## New features

* Identifiers of AssessmentItem, AssessmentSection and AssessmentTest objects are checked for compliance with QTI requirements.

# rqti 0.1.0

* Initial CRAN submission.