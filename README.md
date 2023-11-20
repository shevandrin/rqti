
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![R-CMD-check](https://github.com/shevandrin/qti/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/shevandrin/qti/actions/workflows/R-CMD-check.yaml)
[![test-coverage](https://github.com/shevandrin/qti/actions/workflows/test-coverage.yaml/badge.svg)](https://github.com/shevandrin/qti/actions/workflows/test-coverage.yaml)
[![Codecov test
coverage](https://codecov.io/gh/shevandrin/qti/branch/main/graph/badge.svg)](https://app.codecov.io/gh/shevandrin/qti?branch=main)
[![Project Status: WIP - Initial development is in progress, but there
has not yet been a stable, usable release suitable for the
public.](https://www.repostatus.org/badges/latest/wip.svg)](https://www.repostatus.org/#wip)
<!-- badges: end -->

# qti

Note: this is work in progress, a stable release can be expected in Q4
2023.

The goal of `qti` is to provide a clean and independent R library for
creating exercises and exams according to the [QTI
v2.1](https://www.imsglobal.org/question/qtiv2p1/imsqti_implv2p1.html)
standard directly from R. You can render the exercises locally (qtijs)
or to the learning management system OPAL. Our target audience is
instructors who teach research methods and statistics and want to take
full advantage of the power of R, while conforming with the QTI
standard. Instructors who use OPAL will benefit most because OPAL offers
a good API and our package takes advantage of that.

## Documentation

The documentation (including installation instructions, quick start,
example usage, functionality documentation) is available at
<https://shevandrin.github.io/qti/>

## Testing

We aim for a high test coverage with automated tests (see folder tests).

## Support and bug reports

Feel free to [let us know via e-mail](mailto://shevandrin@gmail.com)
which features your are missing or directly [open an issue on
GitHub](https://github.com/shevandrin/qti/issues). Support will be
available until the funding of the project ends (September 2024). After
that we will maintain a stable, usable version, whereas support/new
features will be provided as time allows.

## Contribute

If you would like to contribute to this package, clone the repo, add
your feature and make a pull request. Please conform with the tidyverse
style and the general package guidelines at <https://r-pkgs.org>.

<!-- Why do we need another package for creating exams when there is already the `exams`-package? The philosophy of `exams` is **one for all**, whereas `qti` follows the Unix-philosophy: **do one thing and do it well**. tldr: -->
<!-- - `qti` has more (QTI) features (e.g. exercise type) than `exams` -->
<!-- - `qti` uses OOP (S4), the system is easy to extend (LMS specific needs) -->
<!-- - the Rmd-interface is cleaner as it just focues on QTI -->
<!-- - low-level functions can be used flexibly to create exercises -->
<!-- - `qti` puts a premium on testing, with currently over 100 tests -->
<!-- - rendering of QTI files in the browser (or viewer pane of RStudio) directly from R -->
<!-- - functions to upload files via REST API to LMS (for us OPAL, but you can implement your own) -->
<!-- If you just use QTI-exercises, you should check out our package. If you need different formats next to QTI, e.g. print, LMS that do not support QTI stick to `exams`. -->
<!-- Just focusing on QTI gives us more time to support great features of the QTI standard that are missing in `exams`. For instance, `qti` offers dropdown-inputs, ordering-exercises, and match-tables. -->
<!-- ## Installation -->
<!-- ```{r eval=FALSE} -->
<!-- install.packages("librarian") # skip if you have librarian already -->
<!-- librarian::shelf(shevandrin/qti) -->
<!-- ``` -->
<!-- ##  -->
<!-- ## What is not possible -->
<!-- - Composites (several exercise types in one task) are not implemented because they do not work in our LMS (OPAL); several gaps do work, though -->
<!-- - Associates are not implemented because they does not work in OPAL -->
<!-- ## Comparison between exams and qti -->
<!-- The `exams` package uses templates and pastes strings together to create qti files. This has some disadvantages: it is error prone, not easy to maintain and difficult to extend. If for instance, a new exercise type needs to be added, many locations have to be changed. `qti` is supposed to make life easier by providing some standard functions to create all parts of the QTI xml file. -->
<!-- Extending exams is just a matter of composing the correct `qti` functions. Testing small `qti` functions is easy, whereas the main function of `exams` `make_item_body` consists of 736 lines. Indeed, this function has grown substantially over time (todo: provide evidence). -->
<!-- Based on qti one can also develop new interfaces for creating exercises. -->
