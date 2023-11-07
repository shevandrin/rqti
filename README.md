
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
creating exercises and exams according to the
[QTI](https://www.imsglobal.org/question/qtiv2p1/imsqti_implv2p1.html)
standard directly from R. You can render the exercises locally (qtijs)
or to the learning management system Opal.

## Installation

The `qti` package is still in development. The only way to install it at
the moment is from GitHub:

``` r
#install.pacakges("librarian") # install librarian if you do not have it yet
librarian::shelf(shevandrin/qti)
```

<!-- `qti` have not published yet on CRAN. After publishing it will be possible to install package as follows: -->
<!-- ```{r eval=FALSE} -->
<!-- install.packages("qti") -->
<!-- ``` -->

After installation, load the package:

``` r
library(qti)
```

Note that this will start a qtijs server, which will be used for
previewing exercises. If you do not need this, turn it off with the
environment variable: QTI_AUTOSTART_SERVER=FALSE (in your .Rprofile or
in .Renviron).

## Quick start

Using RStudio, create a new Rmarkdown file, select **from Template** and
choose one of the templates starting with **QTI: …**. The *simple* ones
include the minimum, the *complex* ones have more parameters. Click the
Knit-Button and you should see a rendered exercise in the Viewer pane.
The templates are self-explanatory, but more details about the exercise
types can be found in the other articles:

- [Single choice](singlechoice.html)
- [Multiple choice](multiplechoice.html)
- [Essay](essay.html)
- [Gap](gap.html)
- [Dropdown](dropdown.html)
- [Order](html)
- [Directed pairs](directedpairs.html)
- [Tables](table.html)

To combine different exercises into a test, read: [Sections and
Tests](section.html)

If you are using the learning management system Opal, please check out
[Opal API](api_opal.html)

## General workflow

The basic workflow with the `qti` package can be described as follows:

1.  Create exercise files.
    1.  Create an Rmd document. You can start from scratch (specify
        `type` in the yaml section) or use Rmd templates starting with
        the prefix `QTI`.
    2.  Write a section titled `# question` and create your interactions
        (gaps, choices, etc.). Use qti helper functions where needed.
    3.  Set additional attributes in the yaml section. All types are
        explained in detail in the **Articles** menu on this website
        (top).
    4.  Choose a previewer: Either qtijs (`knit: qti::render_qtijs`),
        which will render your exercise locally or the learning
        management system Opal (`knit: qti::render_opal`). Note that
        using Opal requires you to set it up first: [Opal
        API](api_opal.html).
    5.  Check if your task looks as desired. Modify until your are
        satisfied.
2.  Create sections and tests based on your exercise files.
3.  Write test (xml) to disk according to QTI standard and upload test
    file to your learning management system.
4.  Download results data from your learning management system and read
    it in with the qti package for statistical analysis.

Each step includes certain `qti` functions, the most useful of them are
shown in the following diagram:

<figure>
<img src="workflow1.png" style="width:60.0%"
alt="Basic workflow to create exercises and tests with qti" />
<figcaption aria-hidden="true">Basic workflow to create exercises and
tests with qti</figcaption>
</figure>

The best way to learn the workflow is to create a simple exercise, such
as “Single Choice”, as presented [in this article.](singlechoice.html)

Each exercise type is described in a separate article:

- [Single choice](singlechoice.html)
- [Multiple choice](multiplechoice.html)
- [Essay](essay.html)
- [Gap](gap.html)
- [Dropdown](dropdown.html)
- [Order](html)
- [Directed pairs](directedpairs.html)
- [Tables](table.html)

## Feedback and bug reports

Feel free to [let us know](mailto://shevandrin@gmail.com) which features
your are missing or directly [open an issue on
GitHub.](https://github.com/shevandrin/qti/issues)

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
