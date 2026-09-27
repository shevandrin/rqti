## Release 1.3.0 summary

## New features

* Added `read_qti()` as an alias for `extract_results()`.

* Added OPAL API functions `createCourseGroup()` for creating course groups,
  `addGroupUser()` for adding users to groups, and `removeGroupUser()` for
  removing users from groups.

* `extract_results(level = "item")` now includes task-level
  `candidate_comment` and `scorer_comment` columns for each item row.

* Added `provide_audio()` helper to embed local audio files directly into
  QTI/HTML content using Base64 encoding. The function supports both
  `<object>` and `<audio>` rendering methods and
  self-contained audio embedding for portable assessment items.
  
## Improvements

* Changed the preferred R Markdown YAML configuration for `preview_feedback`. 
The option should now be specified as a top-level YAML field instead of inside 
`params`. The previous syntax within `params` is deprecated and will be removed 
in a future release.
  
## Bug fixes

* Dropdown items (dropdown()) can now include commas and other punctuation 
without breaking YAML parsing.

* Updated OPAL authentication to use the current REST login endpoint and
  header-based credentials.
  
* Fixed grade feedback score ranges so that rounding to two decimal places no
  longer leaves gaps between adjacent grade intervals.

## R CMD check results

0 errors | 0 warnings | 0 notes

