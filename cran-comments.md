## Release 0.3.0 summary

This submission relates to CRAN's request with deadline 19.07.2024.

## Bug fixes

* Fix parsing R Markdown files with tables according the latest pandoc version. Due to this problem tests on CRAN are failed.
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

## R CMD check results

0 errors | 0 warnings | 0 note
