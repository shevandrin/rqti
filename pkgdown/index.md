
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![R-CMD-check](https://github.com/shevandrin/rqti/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/shevandrin/rqti/actions/workflows/R-CMD-check.yaml)
[![test-coverage](https://github.com/shevandrin/rqti/actions/workflows/test-coverage.yaml/badge.svg)](https://github.com/shevandrin/rqti/actions/workflows/test-coverage.yaml)
[![Codecov test
coverage](https://codecov.io/gh/shevandrin/rqti/branch/main/graph/badge.svg)](https://app.codecov.io/gh/shevandrin/rqti?branch=main)
[![Project Status: Active – The project has reached a stable, usable
state and is being actively
developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)
<!-- badges: end -->

# Introduction to rqti

The `rqti` package is designed to be a powerful, stand-alone R library
for creating exercises, exams, and questionnaires that fully comply with
the [QTI v2.1
standard](https://www.imsglobal.org/question/qtiv2p1/imsqti_implv2p1.html).
This tool empowers users to generate QTI-compliant content directly from
R, offering the flexibility to render tasks locally (using qtijs) or
seamlessly integrate them into learning management systems like OPAL.

Our primary target audience includes instructors specializing in
research methods and statistics who want to leverage R’s capabilities
while adhering to the QTI standard. In particular, those utilizing OPAL
will find `rqti` especially beneficial, as it fully leverages OPAL’s
robust API for smooth integration. However, the package is also suitable
for other learning management systems that support the QTI standard.

The versatility of QTI goes beyond exercises and exams; it also supports
the creation of comprehensive questionnaires, making `rqti` an
invaluable tool for a wide range of educational and research
applications.

## Installation

The `rqti` package is available on CRAN, ensuring easy installation and
access to its features:

``` r
install.packages("rqti")
```

<!-- `rqti` have not published yet on CRAN. After publishing it will be possible to install package as follows: -->
<!-- ```{r eval=FALSE} -->
<!-- install.packages("rqti") -->
<!-- ``` -->
<!-- Note that this will start a qtijs server, which will be used for previewing tasks. If you do not need this, turn it off with the environment variable: RQTI_AUTOSTART_SERVER=FALSE (in your .Rprofile or in .Renviron). -->

## Quick start

In RStudio, start by navigating to *File* -\> *New Project*, and then
select **rqti Project** as the project type. For a quick start, you can
proceed with the default settings. If you prefer to customize the
options, make sure to select *YES* for *Create Templates*—this will
generate RMarkdown templates tailored for different task types.

Once your project is created, open one of the templates from the working
directory (e.g., `gap/gap.Rmd`). To preview it, simply click *Knit*. The
output will be displayed in the RStudio Viewer or in a new browser
window if you are working outside of RStudio.

Explore the other templates to familiarize yourself with the various
features and task types that `rqti` supports. This will help you create
tasks that align with your specific needs.

To learn how to create sections and tests, start by reviewing the
*main.R* file in your working directory. This file provides a
foundational understanding of structuring your work. For more detailed
information, you can refer to the article [Sections and
Tests](articles/section.html).

To add more templates, create a new RMarkdown file. In RStudio, go to
*File* -\> *New File* -\> *R Markdown* -\> *From Template*, and choose
one that ends with {rqti}. The simpler templates focus on basic
parameters, while the more advanced templates showcase additional
settings and customization options. After selecting a template, click
the *Knit* button to render the task in the viewer pane.

While the templates are generally intuitive, you can refer to other
articles of the documentation for detailed guidance on specific task
types. This will help you fully utilize the features of `rqti` for your
projects. The following task types are available:

-  [Single-Choice tasks](articles/singlechoice.html)
-  [Multiple-Choice tasks](articles/multiplechoice.html)
-  [Essay tasks](articles/essay.html)
-  [Gap tasks](articles/gap.html)
-  [Dropdown tasks](articles/dropdown.html)
-  [Order tasks](articles/order.html)
-  [Directed Pair tasks](articles/directedpairs.html)
-  [Table tasks](articles/table.html)

To add metadata to your tasks, refer to the article [Adding
metadata](articles/adding_metadata.html). To integrate various tasks
into a test, refer to the article [Sections and
Tests](articles/section.html). For users of the learning management
system OPAL, explore the article [Working with the OPAL
API](articles/api_opal.html).

## General workflow

The fundamental workflow with the `rqti` package involves the following
steps:

1.  Create task files.
    - Start by generating an Rmd document. You can either start from
      scratch or leverage Rmd templates ending with the suffix `{rqti}`.
    - Create a section titled `# question` and construct your
      interactions (gaps, choices, etc.) Utilize `rqti` helper functions
      where applicable.
    - Specify additional attributes in the yaml section. Detailed
      explanations for all types are available in the **Articles** menu
      on this website (top).
    - Choose a previewer: Either qtijs (`knit: rqti::render_qtijs`), for
      local rendering, or the learning management system Opal
      (`knit: rqti::render_opal`). Note that Opal usage requires prior
      setup, which is explained in the article [Working with the Opal
      API](articles/api_opal.html).
    - Verify if your task appears as desired. Make adjustments until you
      are satisfied.
2.  Create sections and tests based on your task files.
3.  Write the test (xml) to disk according to the QTI standard and
    upload the test file to your learning management system.
4.  Download results data from your learning management system and
    import them with the `rqti` package for statistical analysis.

Each step involves specific `rqti` functions, with the most useful ones
illustrated in the following diagram:

<figure>
<img src="vignettes/images/workflow.png" style="width:100.0%"
alt="Basic workflow to create tasks and tests with rqti" />
<figcaption aria-hidden="true">Basic workflow to create tasks and tests
with rqti</figcaption>
</figure>

The most effective way to grasp the workflow is to create a simple task,
such as *Single-Choice* as demonstrated in the article [Single-Choice
tasks](articles/singlechoice.html). Once you have completed that,
explore the other task types discussed in the subsequent chapters.

## Support and Bug Reports

Should you find any missing features or encounter issues, please do not
hesitate to inform us via email (<shevandrin@gmail.com>) or open an
issue on GitHub (<https://github.com/shevandrin/rqti/issues>). We will
offer support until the project’s funding concludes in September 2024.
Following that, we will maintain a stable, usable version, with support
for new features provided as time permits.

<!-- Why do we need another package for creating exams when there is already the `exams`-package? The philosophy of `exams` is **one for all**, whereas `rqti` follows the Unix-philosophy: **do one thing and do it well**. tldr: -->
<!-- - `rqti` has more (QTI) features (e.g. task type) than `exams` -->
<!-- - `rqti` uses OOP (S4), the system is easy to extend (LMS specific needs) -->
<!-- - the Rmd-interface is cleaner as it just focues on QTI -->
<!-- - low-level functions can be used flexibly to create tasks -->
<!-- - `rqti` puts a premium on testing, with currently over 100 tests -->
<!-- - rendering of QTI files in the browser (or viewer pane of RStudio) directly from R -->
<!-- - functions to upload files via REST API to LMS (for us OPAL, but you can implement your own) -->
<!-- If you just use QTI-tasks, you should check out our package. If you need different formats next to QTI, e.g. print, LMS that do not support QTI stick to `exams`. -->
<!-- Just focusing on QTI gives us more time to support great features of the QTI standard that are missing in `exams`. For instance, `rqti` offers dropdown-inputs, ordering-tasks, and match-tables. -->
<!-- ## Installation -->
<!-- ```{r eval=FALSE} -->
<!-- install.packages("librarian") # skip if you have librarian already -->
<!-- librarian::shelf(shevandrin/rqti) -->
<!-- ``` -->
<!-- ##  -->
<!-- ## What is not possible -->
<!-- - Composites (several task types in one task) are not implemented because they do not work in our LMS (OPAL); several gaps do work, though -->
<!-- - Associates are not implemented because they does not work in OPAL -->
<!-- ## Comparison between exams and rqti -->
<!-- The `exams` package uses templates and pastes strings together to create rqti files. This has some disadvantages: it is error prone, not easy to maintain and difficult to extend. If for instance, a new task type needs to be added, many locations have to be changed. `rqti` is supposed to make life easier by providing some standard functions to create all parts of the QTI xml file. -->
<!-- Extending exams is just a matter of composing the correct `rqti` functions. Testing small `rqti` functions is easy, whereas the main function of `exams` `make_item_body` consists of 736 lines. Indeed, this function has grown substantially over time (todo: provide evidence). -->
<!-- Based on rqti one can also develop new interfaces for creating tasks. -->
