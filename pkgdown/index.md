
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![R-CMD-check](https://github.com/shevandrin/rqti/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/shevandrin/rqti/actions/workflows/R-CMD-check.yaml)
[![test-coverage](https://github.com/shevandrin/rqti/actions/workflows/test-coverage.yaml/badge.svg)](https://github.com/shevandrin/rqti/actions/workflows/test-coverage.yaml)
[![Codecov test
coverage](https://codecov.io/gh/shevandrin/rqti/branch/main/graph/badge.svg)](https://app.codecov.io/gh/shevandrin/rqti?branch=main)
[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
<!-- badges: end -->

# rqti

The objective of `rqti` is to establish a robust and stand-alone R
library tailored for crafting exercises and exams in adherence to the
[QTI
v2.1](https://www.imsglobal.org/question/qtiv2p1/imsqti_implv2p1.html)
standard directly from R. Users have the flexibility to render the
exercises either locally (using qtijs) or integrate them seamlessly into
the OPAL learning management system. Our primary audience comprises
instructors specializing in research methods and statistics who seek to
harness the full capabilities of R while aligning with the QTI standard.
In particular, instructors utilizing OPAL will find our package
especially advantageous, as it capitalizes on OPAL’s robust API.

## Installation

The `rqti` package is available on CRAN, ensuring easy installation and access to its features:

``` r
#install.pacakges("librarian") # install librarian if you do not have it yet
librarian::shelf(shevandrin/rqti)
```

<!-- `rqti` have not published yet on CRAN. After publishing it will be possible to install package as follows: -->
<!-- ```{r eval=FALSE} -->
<!-- install.packages("rqti") -->
<!-- ``` -->
<!-- Note that this will start a qtijs server, which will be used for previewing exercises. If you do not need this, turn it off with the environment variable: RQTI_AUTOSTART_SERVER=FALSE (in your .Rprofile or in .Renviron). -->

## Quick start

In RStudio, navigate to *File* -\> *New Project* and choose **rqti
Project** as the project type. Customize the settings as needed; select
‘YES’ for ‘Create Templates’ to generate Rmarkdown templates for various
task types. Once the project is created, open one of the templates
(e.g., `gap/gap.Rmd`) and click *Knit*. You should see a preview in the
RStudio viewer (or a new browser window if you are not using RStudio).
Experiment with other templates to explore supported features.

To comprehend how to create sections and tests, refer to the *main.R*
file in the working directory. More information on this topic can be
found here: [Sections and Tests](articles/section.html).

To incorporate additional templates, create a new RMarkdown file. Choose
*From Template* and select one that starts with *rqti: …*. The simple
templates include minimal parameters, while the complex ones demonstrate
how to use additional settings. Click the *Knit* button, and you should
observe a rendered exercise in the viewer pane. While the templates are
generally self-explanatory, refer to other articles for in-depth details
about specific exercise types:

- [Single choice](articles/singlechoice.html)
- [Multiple choice](articles/multiplechoice.html)
- [Essay](articles/essay.html)
- [Gap](articles/gap.html)
- [Dropdown](articles/dropdown.html)
- [Order](articles/order.html)
- [Directed pairs](articles/directedpairs.html)
- [Tables](articles/table.html)

To integrate various exercises into a test, refer to: [Sections and
Tests](articles/section.html)

For users of the learning management system Opal, explore the [Opal
API](articles/api_opal.html).

## General workflow

The fundamental workflow with the `rqti` package involves the following
steps:

1.  Create exercise files.
    1.  Start by generating an Rmd document. You can either initiate
        from scratch (specify `type` in the yaml section) or leverage
        Rmd templates beginning with the prefix `rqti`.
    2.  Develop a section titled `# question` and construct your
        interactions (gaps, choices, etc.). Utilize `rqti` helper
        functions where applicable.
    3.  Specify additional attributes in the yaml section. Detailed
        explanations for all types are available in the **Articles**
        menu on this website (top).
    4.  Choose a previewer: Either qtijs (`knit: rqti::render_qtijs`),
        for local rendering, or the learning management system Opal
        (`knit: rqti::render_opal`). Note that Opal usage requires prior
        setup: [Opal API](articles/api_opal.html).
    5.  Verify if your task appears as desired. Make adjustments until
        you are satisfied.
2.  Create sections and tests based on your exercise files.
3.  Write the test (xml) to disk according to the QTI standard and
    upload the test file to your learning management system.
4.  Download results data from your learning management system and
    analyze them with the `rqti` package for statistical insights.

Each step involves specific `rqti` functions, with the most useful ones
illustrated in the following diagram:

<figure>
<img src="vignettes/images/workflow.png" style="width:75.0%"
alt="Basic workflow to create exercises and tests with rqti" />
<figcaption aria-hidden="true">Basic workflow to create exercises and
tests with rqti</figcaption>
</figure>

The most effective way to grasp the workflow is to create a simple
exercise, such as “Single Choice,” as demonstrated [in this
article.](articles/singlechoice.html)

Individual articles provide detailed descriptions for each exercise
type:

- [Single choice](articles/singlechoice.html)
- [Multiple choice](articles/multiplechoice.html)
- [Essay](articles/essay.html)
- [Gap](articles/gap.html)
- [Dropdown](articles/dropdown.html)
- [Order](articles/order.html)
- [Directed pairs](articles/directedpairs.html)
- [Tables](articles/table.html)

## Support and Bug Reports

Should you find any missing features or encounter issues, please do not
hesitate to inform us via [email](mailto://shevandrin@gmail.com) or
[open an issue on GitHub](https://github.com/shevandrin/rqti/issues). We
will offer support until the project’s funding concludes in September
2024. Following that, we will maintain a stable, usable version, with
support for new features provided as time permits.

<!-- Why do we need another package for creating exams when there is already the `exams`-package? The philosophy of `exams` is **one for all**, whereas `rqti` follows the Unix-philosophy: **do one thing and do it well**. tldr: -->
<!-- - `rqti` has more (QTI) features (e.g. exercise type) than `exams` -->
<!-- - `rqti` uses OOP (S4), the system is easy to extend (LMS specific needs) -->
<!-- - the Rmd-interface is cleaner as it just focues on QTI -->
<!-- - low-level functions can be used flexibly to create exercises -->
<!-- - `rqti` puts a premium on testing, with currently over 100 tests -->
<!-- - rendering of QTI files in the browser (or viewer pane of RStudio) directly from R -->
<!-- - functions to upload files via REST API to LMS (for us OPAL, but you can implement your own) -->
<!-- If you just use QTI-exercises, you should check out our package. If you need different formats next to QTI, e.g. print, LMS that do not support QTI stick to `exams`. -->
<!-- Just focusing on QTI gives us more time to support great features of the QTI standard that are missing in `exams`. For instance, `rqti` offers dropdown-inputs, ordering-exercises, and match-tables. -->
<!-- ## Installation -->
<!-- ```{r eval=FALSE} -->
<!-- install.packages("librarian") # skip if you have librarian already -->
<!-- librarian::shelf(shevandrin/rqti) -->
<!-- ``` -->
<!-- ##  -->
<!-- ## What is not possible -->
<!-- - Composites (several exercise types in one task) are not implemented because they do not work in our LMS (OPAL); several gaps do work, though -->
<!-- - Associates are not implemented because they does not work in OPAL -->
<!-- ## Comparison between exams and rqti -->
<!-- The `exams` package uses templates and pastes strings together to create rqti files. This has some disadvantages: it is error prone, not easy to maintain and difficult to extend. If for instance, a new exercise type needs to be added, many locations have to be changed. `rqti` is supposed to make life easier by providing some standard functions to create all parts of the QTI xml file. -->
<!-- Extending exams is just a matter of composing the correct `rqti` functions. Testing small `rqti` functions is easy, whereas the main function of `exams` `make_item_body` consists of 736 lines. Indeed, this function has grown substantially over time (todo: provide evidence). -->
<!-- Based on rqti one can also develop new interfaces for creating exercises. -->
