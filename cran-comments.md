## Release 1.2.1 summary

It is a patch due to the macOS portability fix.

## Bug fixes

* Replaced platform-specific external SHA1 commands in tests with an R-native
hash implementation to improve portability across operating systems.

* Fixed MathJax rendering for dynamically loaded referent content in QTI.JS.

## R CMD check results

0 errors | 0 warnings | 2 notes

* checking CRAN incoming feasibility ... NOTE
  Maintainer: Andrey Shevandrin <shevandrin@gmail.com>
  Days since last update: 3

  This is a patch submission shortly after the previous submission to fix a
  CRAN check failure on macOS.

* checking for future file timestamps ... NOTE
  unable to verify current time

  This appears to be a local check environment issue.
