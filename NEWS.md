# rqti (development version)

## Bug fixes

* Add doctype description for handling mathml entities.

## New features

* Added constructor functions for task classes: singleChoice(), multipleChoice(),
essay(), order(), entry(), directedPair(), oneInColTable(), oneInRowTable(),
myltipleChoiceTable().

* Added constructor functions for content of Entry class: numericGap(), textGap(),
textGapOpal(), inlineChoice().

# rqti 0.1.1

## Bug fixes

* Added the missing qti.js for rendering Rmd-files with tasks.

* Added processing of the pandoc --embed-resources parameter for pandoc versions < 2.19.

## New features

* Identifiers of AssessmentItem, AssessmentSection and AssessmentTest objects are checked for compliance with QTI requirements.

# rqti 0.1.0

* Initial CRAN submission.
