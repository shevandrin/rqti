## Release 1.1.0 summary

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

## R CMD check results

0 errors | 0 warnings | 0 note
