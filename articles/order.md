# Order tasks

In this type of task, the candidate has to bring a list of items in the
correct order.

## Minimum version

A minimum template is automatically created when you initiate an rqti
project through RStudio. Alternatively, it can be added by clicking on
`New file -> R Markdown -> From Template`. The `rqti` templates end with
[rqti](https://github.com/shevandrin/rqti). Here we look at the
templates `order (simple)` and `order (complex)`.

The minimum you need to provide is the `type: order` in the yaml-section
and a list with at least two elements in a section called
**\#question**:

    ---
    type: order
    knit: rqti::render_qtijs
    ---

    # question

    What is the structure of an exam in QTI terms, starting from the top (the exam)
    to the bottom (individual questions).

    - test
    - section
    - item
    - interaction

    # feedback

    For order exercises it is usually clear why the given order is correct, but you
    might still want to provide a detailed feedback.

Knitting via the Knit-Button to qtijs, this task renders as:

![Simple order task rendered in qtijs](images/xml/order-simple.jpg)

Simple order task rendered in qtijs

Alternatively, change the knit parameter to `knit: rqti::render_opal`
(see article [Working with the OPAL
API](https://shevandrin.github.io/rqti/articles/api_opal.md)) to upload
to OPAL directly, producing:

![Simple order task rendered in OPAL](images/order-simple.jpg)

Simple order task rendered in OPAL

The order of the items in the Rmd-list is considered to be the correct
one.

Note that in this example, a feedback section was provided. The feedback
is optional, but usually it is a good idea to give some explanation for
students.

## More control

If you want to have more fine-grained control, consider the Rmd template
`order (complex)`, which uses more yaml attributes.

    ---
    type: order
    knit: rqti::render_qtijs
    identifier: order001 # think twice about this id for later data analysis!
    title: A meaningful title that can be displayed in the LMS
    # defines the scoring method, `false` means the correct order must be restored 
    # completely by the candidate in order to get points
    points_per_answer: false 
    points: 2
    ---

    # question

    What is the structure of an exam in QTI terms, starting from the top (the exam)
    to the bottom (individual questions).

    - test
    - section
    - item
    - interaction

    # feedback

    For order exercises it is usually clear why the given order is correct, but you
    might still want to provide a detailed feedback.

    <!-- If you prefer specific feedback for correct and incorrect solution, delete
    the general feedback section and uncomment everything starting from this line:

    # feedback+

    Nice. (Only displayed when the solution is correct.)

    # feedback-

    Try again. (Only displayed if the solution is not correct.)
    -->

Which on OPAL renders as:

![More complex order task rendered in OPAL](images/order-complex.jpg)

More complex order task rendered in OPAL

## yaml attributes

### type

Has to be `order`.

### identifier

This is the ID of the task, useful for later data analysis of results.
The default is the file name. If you are doing extensive data analysis
later on it makes sense to specify a meaningful identifier. In all other
cases, the file name should be fine.

### title

Title of the task. Can be displayed to students depending on the
learning management system settings. Default is the file name.

### points

How many points are given for the whole task. Default is $0.25n$, where
$n$ is the length of the list.

### points_per_answer

Defines the scoring method. If `true` each selected answer will be
scored individually (according to the absolute position of the element
in the list), if `false` the whole task will be scored and a single
error leads to 0 points. Default is `true`.

## Feedback

Feedback can be provided with the section

- **\# feedback** (general feedback, displayed every time, without
  conditions)
- **\# feedback+** (only provided if student reaches all points)
- **\# feedback-** (only provided if student does not reach all points)

## List of answers as a variable

For more complex tasks the list of answers is sometimes available as a
variable. In this case you can use the helper function `mdlist` to
convert the vector into a markdown list:

``` r
mdlist(c("Test", "Section", "Item", "Interaction"))
[1] "- Test\n- Section\n- Item\n- Interaction"
```

## Some advice on order tasks

Typically, order tasks tend to emphasize memorization of procedural
steps, a facet of knowledge that may not always be critically important.
In practice, even professionals often rely on checklists or cheatsheets
for such scenarios. Additionally, grading order tasks can be intricate
since the absolute position of an item is often less crucial than its
relative placement within a sequence. We advise to use order tasks with
caution.
