# Dropdown tasks

In this type of task, the candidate has to select an element form a
dropdown-list. Note that our package implements dropdowns as
*entry*-objects because this is essentially what dropwdowns are. Several
dropdowns can be combined in a single task, but a combination with
numeric and text entries (gaps) is not possible; mainly due to
limitations on the site of learning managment systems.

## Minimum version

A minimum template is automatically created when you initiate an rqti
project through RStudio. Alternatively, it can be added by clicking on
`New file -> R Markdown -> From Template`. The `rqti` templates end with
[rqti](https://github.com/shevandrin/rqti). Here we look at the
templates `dropdown (simple)` and `dropdown (complex)`.

The minimum you need to provide is the `type: dropdown` (or the
equivalent `type: dd`) in the yaml-section and some text, where at least
one gap is formed as a dropdown-element, in a section called
**\#question**. Furthermore, when employing helper functions from the
rqti package, it is essential to ensure its prior loading.

    ---
    type: dropdown
    knit: rqti::render_qtijs
    ---

    ```{r echo=F}
    library(rqti)
    ```

    # question

    The philosophy of the rqti package is <<do one thing and do it well|one for
    all>>.

    Under the hood, the rqti package uses `r dropdown(c("S4 OOP", "S3 OOP", "no OOP", "R6 OOP"))`.

    # feedback

    The package `rqti` is specialized for producing xml rqti files so "do one thing
    and do it well" is more appropriate. Under the hood we use S4 OOP.

Knitting via the Knit-Button to qtijs, this task renders as:

![Simple dropdown task rendered in
qtijs](images/xml/dropdown-simple.jpg)

Simple dropdown task rendered in qtijs

Alternatively, change the knit parameter to `knit: rqti::render_opal`
(see article [Working with the OPAL
API](https://shevandrin.github.io/rqti/articles/api_opal.md)) to upload
to OPAL directly, producing:

![Simple dropdown task rendered in OPAL](images/dropdown-simple.jpg)

Simple dropdown task rendered in OPAL

There are two ways to specify a dropdown-element in Rmd content:

- Put the correct answer inside `<<` … `>>` (or the equivalent `<gap>` …
  `</gap>`). Example: `<<element1|element2|element3>>`
- use the helper function
  [`?dropdown`](https://shevandrin.github.io/rqti/reference/dropdown.md)
  (also see section [Helper function
  dropdown](#helper-function-dropdown))

By default, 1 point can be reached for each dropdown (specify `points`
to your needs). The total number of points for completing a task is
defined as the sum of points of all dropdowns.

Note that in this example, a feedback section was also provided. The
feedback is optional, but usually it is a good idea to give some
explanation for students. In dropdown tasks the feedback refers to the
whole task, not to a specific dropdown. Group your feedback into
appropriate sections, which can be opened/closed for better user
experience. A great way to do this is to use `<details>` and `<summary>`
html tags:

``` html
<details><summary>Question1</summary>
  Provide Feedback for Question 1
</details>
<details><summary>Question 2</summary>
  Provide Feedback for Question 2
</details>
```

will render as:

Question 1

Provide Feedback for Question 1

Question 2

Provide Feedback for Question 2

## More control

If you want to have more fine-grained control, consider the RMD template
`dropdown (complex)`, which uses more yaml attributes and a more complex
use of the helper function `dropdown`.

    ---
    type: dd # type of exercise
    knit: rqti::render_qtijs # if you do not want our preview renderer, remove this
    identifier: dd001 # think twice about this id for later data analysis!
    title: A meaningful title that can be displayed in the LMS
    ---

    ```{r echo=F}
    library(rqti)
    dropdown1 <- dropdown(c("no OOP" = "no OOP", "S4" = "S4 OOP", "S3" = "S3 OOP", 
                            "R6" = "R6 OOP"), solution_index = 2, points = 2, 
                          response_identifier = "OOP_task")
    ```

    # question

    The philosophy of the rqti package is <<do one thing and do it well|one for
    all>>.

    Under the hood, the rqti package uses `r dropdown1`.

    # feedback

    The package `rqti` is specialized for producing xml rqti files so "do one thing
    and do it well" is more appropriate. Under the hood we use S4 OOP.

Which renders in OPAL as :

![More complex dropdown task rendered in
OPAL](images/dropdown-complex.jpg)

More complex dropdown task rendered in OPAL

## yaml attributes

### type

Has to be `dropdown` or `dd`.

### identifier

This is the ID of the task, useful for later data analysis of results.
The default is the file name. If you are doing extensive data analysis
later on it makes sense to specify a meaningful identifier. In all other
cases, the file name should be fine.

### title

Title of the task. Can be displayed to students depending on the
learning management system settings. Default is the file name.

## Feedback

Feedback can be provided with the section

- **\# feedback** (general feedback, displayed every time, without
  conditions)
- **\# feedback+** (only provided if student reaches all points)
- **\# feedback-** (only provided if student does not reach all points)

## Helper function `dropdown`

This helper function is used to generate a formatted string describing a
dropdown in Rmd content:

``` r
choices <- c("s4" = "S4 OOP", "s3" = "S3 OOP", "none" = "no OOP", "r6" = "R6 OOP")
oop_task <- dropdown(choices = choices, solution = "S4 OOP",
                     response_identifier = "OOP_task")
oop_task
#> [1] "<gap>{choices: [S4 OOP,S3 OOP,no OOP,R6 OOP], solution_index: S4 OOP, points: 1.0, shuffle: yes, response_identifier: OOP_task, choices_identifiers: [s4,s3,none,r6], type: InlineChoice}</gap>"
```

The arguments of the `dropdown` function are:

### choices

Elements of dropdown. If you use a named vector, the names will be used
as identifiers. This is useful for later data analysis and is generally
adviced.

### solution_index

The index of the correct choice as a numeric. Default is 1, meaning that
you can simply put the correct element as the first one in the vector
`choices`.

### points

The number of points for the task. Default is 1.

### shuffle

If `TRUE`, randomizes the order of the choices. Defaults to `TRUE`. Only
in rare occasions it makes sense to have a strict order of choices
(setting shuffle to `FALSE`).

### response_identifier

This is the ID of the dropdown-element, useful for later data analysis
of results. The default has the format “response_1”, “response_2”,
…“response_n” for several dropdowns. If you are doing extensive data
analysis later on, it makes sense to specify a more meaningful
identifier.

## Some advice on dropdown tasks

Dropdown tasks are forced choice items, so are equivalent to single
choice tasks. The advantage is that they can be placed in between other
text and several of them can be used in a single task. Still, they
suffer from the same problems as [single choice
tasks](https://shevandrin.github.io/rqti/articles/singlechoice.md).
