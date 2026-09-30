## Release 1.3.1 summary

This is a follow-up release to rqti 1.3.0.
This addresses the errors observed in the CRAN macOS checks for version 1.3.0.

## New features

* `opal()` and `upload2opal()` now accept an optional `credential_id`, allowing
  the same username to use different passwords on different OPAL installations.
  When it is omitted, rqti continues to use the existing `rqtiopal` credential
  service, preserving the behavior of existing code and saved credentials.

## Bug fixes

* `extract_results(level = "item")` now supports integer responses and labels
  them as `NumericGap`. Missing or unsupported response base types now produce
  an error identifying the affected item.

* Fixed Pandoc compatibility by using the appropriate option to disable syntax
  highlighting based on the capabilities of the installed Pandoc version.

## R CMD check results

0 errors | 0 warnings | 0 notes

