# Multiple Choice tasks

This is just a normal multiple choice task.

## Minimum version

A minimum template is automatically created when you initiate an rqti
project through RStudio. Alternatively, it can be added by clicking on
`New file -> R Markdown -> From Template`. The `rqti` templates end with
[rqti](https://github.com/shevandrin/rqti). Here we look at the
templates `multiplechoice (simple)` and `multiplechoice (complex)`.

The minimum you need to provide is the `type: mpc` (or the equivalent
`type: multiplechoice` or `type: mchoice`) in the yaml-section and a
list with at least two elements in a section called **\# question**:

    ---
    type: mpc
    knit: rqti::render_qtijs
    ---

    # question

    Which exercise types are supported by the R package rqti?

    - *dropdown list*
    - *gaps*
    - programming language evaluation
    - drawing

    # feedback

    All basic types of QTI are supported, including dropdown list. More advanced
    exercises (as available in OPAL/ONYX) are not yet supported because they are LMS
    specific.

Note that in this example, a feedback section was also provided. This is
optional, but usually it is a good idea to give some explanation for
students.

Further note that the `knit` parameter is set to the custom `rqti` knit
function, which will handle the preview. Clicking the Knit button in
RStudio produces:

![Multiple choice task rendered in
qtijs](images/xml/multiplechoice-simple.jpg)

Multiple choice task rendered in qtijs

You can also use the OPAL (set it up before, see article [Working with
the OPAL API](https://shevandrin.github.io/rqti/articles/api_opal.md))
render function (`knit: rqti::render_opal`), which should produce:

![Multiple choice task rendered in
OPAL](images/multiplechoice-simple.jpg)

Multiple choice task rendered in OPAL

Multiple-choice tasks function similarly to single-choice tasks, with
the key difference being that multiple (or no) answers can be correct.
To indicate the correct options, surround them with asterisks (using
markdown for italics). If you need to use italics within the choices
themselves, enclose the entire question in `<em></em>` tags to avoid
conflicts.

By default, the total points available for a question are calculated as
$0.5n$, where $n$ is the number of answer choices. For example, if there
are 4 choices, the maximum score for the question is 2 points. Correct
selections earn 0.5 points each, while incorrect selections deduct 0.5
points. Regardless of how points are calculated, the minimum score you
can receive is 0.

Among various grading options, we find this to be the most intuitive,
especially when considering the element of guessing. Given our
inclination against forced-choice tasks, we do not see significant value
in introducing different grading alternatives. Rather, we recommend
directing attention towards better task types like gaps for a more
effective assessment approach. See also the section [Some advice on
multiple choice tasks](#some-advice-on-multiple-choice-tasks).

## More control

If you want to have more fine-grained control, consider the available
attributes for the yaml section in the RMD template
`multiple-choice (complex)`.

    ---
    type: multiplechoice # equivalent to mpc
    knit: rqti::render_qtijs # if you do not want our preview renderer, remove this
    identifier: mpc001 # think twice about this id for later data analysis!
    title: A meaningful title that can be displayed in the LMS
    shuffle: true # random order of choices
    orientation: vertical # OR horizontal
    points: 2
    ---

    # question

    Which exercise types are supported by the R package rqti?

    - *match pair (pair several elements)*
    - *match tables (single choice or multiple choice tables)*
    - drawing
    - graphical match (drag selection to specific position)

    # feedback

    All basic types of QTI are supported. More advanced exercises (as available in
    OPAL/ONYX) are not yet supported because they are LMS specific.

Which renders in OPAL as:

![More complex multiple choice task rendered in
OPAL](images/multiplechoice-complex.jpg)

More complex multiple choice task rendered in OPAL

## yaml attributes

### type

Has to be `multiplechoice` or `mpc` or `mchoice` (compatible with
`exams` package).

### identifier

This is the ID of the task, useful for later data analysis of results.
The default is the file name. If you are doing extensive data analysis
later on, it makes sense to specify a meaningful identifier. In all
other cases, the file name should be fine.

### title

Title of the task. Can be displayed to students depending on the
learning management system settings. The default is the file name.

### shuffle

If `true`, randomizes the order of the choices. Defaults to `true`. Only
in rare occasions it makes sense to have a strict order of choices
(setting shuffle to `false`).

### orientation

Should the items be displayed in `vertical` or `horizontal` mode?
Default is `vertical`.

### points

How many points are given for the whole task. Default is the number of
choices times 0.5. Note that rqti usess *partial balanced scoring* for
multiple choice questions.

In *partial balanced scoring*, the number of correctly selected options
is rewarded, and the number of incorrectly selected options is penalized
in proportion to the total number of correct and incorrect options.

For a question with $n$ total options and $c$ correct options, the score
is

$$\text{Score} = \frac{\#\text{correctly selected}}{c} - \frac{\#\text{incorrectly selected}}{n - c}$$

This approach ensures that random guessing yields an expected score of
zero, while allowing partial credit for partial knowledge and
discouraging the selection of options that the examinee is unsure about.
We do not offer other scoring schemes as we believe this is the best
option.

## Feedback

Feedback can be provided with the section

- **\# feedback** (general feedback, displayed every time, without
  conditions)
- **\# feedback+** (only provided if student reaches all points)
- **\# feedback-** (only provided if student does not reach all points)

## List of answers as a variable

For more complex tasks the list of answers is often just available as a
variable. In this case you can use the helper function `mdlist` to
convert the vector into a markdown list:

``` r
mdlist(c("dropdown list", "programming language evaluation", "numeric gap"), 
       solutions = c(1, 3))
[1] "- *dropdown list*\n- programming language evaluation\n- *numeric gap*"
```

## Some advice on multiple choice tasks

A multiple-choice task can always be converted into multiple
single-choice questions with true/false or yes/no options. From a
psychometric standpoint, both types of tasks share the same drawbacks,
primarily due to the potential for guessing. Consequently, they should
be avoided when possible. Generally, their psychometric properties are
inferior to those of numeric or string-based gap tasks that assess
similar content.

However, there are scenarios where forced-choice tasks are necessary.
For example, presenting several statistical analyses and asking students
to determine whether the results are statistically significant is a
valuable task. Even in such cases, a multiple-choice format may not be
the best option. Better alternatives include single-choice questions,
dropdowns, or match tables. A multiple-choice question can often be
restructured into several single-choice or dropdown questions with
yes/no options. This may be cumbersome for longer multiple-choice lists,
for which a match table with yes/no options can be a more convenient
solution.

The main advantage of these alternative formats is that they require
students to make explicit choices. In a multiple-choice task where all
options are incorrect, a student could earn full points simply by not
making any selections—effectively getting credit without engaging with
the question. To avoid this, multiple-choice tasks must balance the
distribution of correct and incorrect options, which is not necessary
for single-choice, dropdown, or match table formats.

While multiple-choice tasks are supported, we strongly advise against
using them whenever possible in favor of more robust alternatives.
