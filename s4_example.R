## S4 example

library(qti)
library(markdown)
library(shiny)

# create SingleChoice object
sc <- new("SingleChoice",
          text = new("Text", content = list("<p>With SQL, how do you select <b>all the records</b> from a table named Persons where the value of the column FirstName is Peter?<br />SELECT * FROM <br/> this is the second line of text</p>")),
          choices = c("You must stay with your luggage at all times.", "Bb", "Cc", "Dd"),
          orientation = "horizontal",
          title = "single_choice_task",
          prompt = "this is a prompt",
          points = 2)
create_qti_task(sc)

# create MultipleChoice object
mpc <- new("MultipleChoice",
           text = new("Text", content = list("This is the mpc question")),
           choices = c("A", "B", "C", "D"),
           choice_identifiers = c("1", "2", "3", "4"),
           points = c(1, 0, -1, 1),
           title = "multiple_choice_task")
create_qti_task(mpc)

# task with TextGap
te <- new("Entry", text = new("Text", content = list("<h2>some markdown title1</h2><h1><b>Some title</b><br />svsdvsdvsd</h1><p>With <em>SQL</em>, how do you select <b>all the records</b> from a table named <em><strong>Persons</strong></em> where the value of the column <i>FirstName</i> is Peter?<br />SELECT * FROM",
                                                      new("TextGapOpal",
                                                          response = "Persons",
                                                          alternatives = "persons",
                                                          response_identifier = "response_1",
                                                          score = 1,
                                                          placeholder = "name of table",
                                                          expected_length = 13,
                                                          value_precision = 2,
                                                          case_sensitive = TRUE),
                                                      " <em>WHERE</em>",
                                                      new("TextGap",
                                                          response = "FirsName",
                                                          response_identifier = "response_2",
                                                          score = 1),
                                                      "=‘Peter’</p><h3>markdown title 2</h3><p>Put the right answers in the text field above.",
                                                      "</p>"

                                                      )
                               ),
           title = "text_gaps_task")
create_qti_task(te)

te_opal <- new("Entry", text = new("Text", content = list("es geht",
                                                          new("TextGapOpal",
                                                              response_identifier = "res1",
                                                              response = "um",
                                                              score = 0.5,
                                                              value_precision = 1),
                                                          "die neuen Produkte")),
               title = "preposition with gehen")
create_qti_task(te_opal)

# task with NumericGap
ne <- new("Entry", text = new("Text",
                              content = list("5 - ",
                                             new("NumericGap",
                                                 response_identifier = "numeric_1",
                                                 response = 7,
                                                 value_precision = 10,
                                                 expected_length = 1,
                                                 include_lower_bound = FALSE,
                                                 include_upper_bound = FALSE),
                                             " = -2")
                              ),
          title = "numeric_gaps_task")
create_qti_task(ne)


# task with combination of TextGap and NumericGap
com <- new("Entry", text = new("Text", content = list("5 ",
                                                            new("TextGap", response_identifier = "str_1", response = "+", score = 1, placeholder = "+ or -"),
                                                          " 2 = ",
                                                          new("NumericGap", response_identifier = "numeric_1", response = 7, value_precision = 1, expected_length = 11, placeholder = "here is number")
                                                      )),
           title = "complex_gap_task")
create_qti_task(com)

# task with dropdown list (InlineChoice)
dd1 <- new("Entry", text = new("Text", content = list("first line",
                                                     new("InlineChoice", response_identifier = "list_1", options = c("a", "b", "c")
                                                     ))),
          title = "dropdown1")
create_qti_task(dd1)

dd2 <- new("Entry", text = new("Text", content = list("first line <br/>",
                                                      "<h2>second line</h2>",
                                                     new("InlineChoice", response_identifier = "list_1", options = c("a", "b", "c")),
                                                         "<br/>third line",
                                                         new("InlineChoice", response_identifier = "list_2", options = c("answer1", "answer2", "answer3"), score = 2),
                                                     "end text."
                                                     )),
          title = "dropdown2")
create_qti_task(dd2)

# task with Order
# TODO parse text in choices
ord <- new("Order", text = new("Text", content = list("<p>put in a right order</p>")),
           identifier = "order_id", title = "order_task",
           choices = c("first", "second", "third"),
           choices_identifiers = c("a","b","c"),
           points = 5)
create_qti_task(ord)

# task with directed pairs
# TODO validation number of cols and rows
dp <- new("DirectedPair", text = new("Text",
                                   content = list("<h3>This is match table task</h3>",
                                                  "<i>table description</i>")),
        rows = c("row1", "row2", "row3"),
        rows_identifiers = c("a", "b", "c"),
        cols = c("alfa", "beta", "gamma"),
        cols_identifiers = c("k", "l", "m"),
        answers_identifiers = c("a k", "b l", "c m"),
        points = 5,
        title = "directed_pair",
        prompt = "this is a prompt"
)
create_qti_task(dp)

# task with match table with one right answer in a row
rt <- new("OneInRowTable", text = new("Text",
                                     content = list("<h3>This is match table task</h3>",
                                                    "<i>table description</i>")),
          rows = c("row1", "row2", "row3", "row4"),
          rows_identifiers = c("a", "b", "c", "d"),
          cols = c("alfa", "beta", "gamma"),
          cols_identifiers = c("k", "l", "m"),
          answers_identifiers = c("a k", "b l", "c l", "d m"),
          points = 5,
          title = "one_in_row_table"
)
create_qti_task(rt)

# task with match table with one right answer in a column
ct <- new("OneInColTable", text = new("Text",
                                      content = list("<h3>This is match table task</h3>",
                                                     "<i>table description</i>")),
          rows = c("row1", "row2", "row3"),
          rows_identifiers = c("a", "b", "c"),
          cols = c("alfa", "beta", "gamma"),
          cols_identifiers = c("k", "l", "m"),
          answers_identifiers = c("a k", "b l", "b m"),
          points = 5,
          title = "one_in_col_table"
)
create_qti_task(ct)

# task with match table with many right answers in rows and columns
mt <- new("MultipleChoiceTable", text = new("Text",
                                      content = list("<h3>This is match table task</h3>",
                                                     "<i>table description</i>")),
          rows = c("row1", "row2", "row3"),
          rows_identifiers = c("a", "b", "c"),
          cols = c("alfa", "beta", "gamma"),
          cols_identifiers = c("k", "l", "m"),
          answers_identifiers = c("a k", "b l", "b m"),
          points = 5,
          title = "multiple_choice_table"
)
create_qti_task(mt)

# essay type task
es <- new("Essay", text = new("Text",
                              content = list("<h2>this is an essay type of question</h2>")),
          title = "essay_task50x15",
          maxStrings = 100,
          points = 3)
create_qti_task(es)

# assessment test
test <- new("AssessmentTest", title = "Text exam", points = 5,
            test_part_identifier = "test_part",
            section = list(new("AssessmentSection",
                               identifier = "s1",
                               title = "Section 1",
                               assessment_item = list(new("AssessmentItemRef", identifier = "single_choice_task",
                                                      href = "single_choice_task.xml"),
                               new("AssessmentItemRef", identifier = "multiple_choice_task",
                                   href = "multiple_choice_task.xml"))),
                           new("AssessmentSection",
                               identifier = "s2",
                               title = "Section 2",
                               assessment_item = list(new("AssessmentItemRef", identifier = "order_task", href = "order_task.xml"),
                                                      new("AssessmentItemRef", identifier = "directed_pair", href = "directed_pair.xml"),
                                                      new("AssessmentSection", identifier = "s21", title = "Subsection 2-1",
                                                          assessment_item = list(new("AssessmentItemRef", identifier = "text_gaps_task", href = "text_gaps_task.xml"))
                                                          ),
                                                      new("AssessmentSection", identifier = "s22", title = "Subsection 2-2",
                                                          assessment_item = list(new("AssessmentItemRef", identifier = "one_in_row_table", href = "one_in_row_table.xml"),
                                                                                 new("AssessmentSection", identifier = "s221", title = "Subsection 2-2-1",
                                                                                     assessment_item = list(new("AssessmentItemRef", identifier = "essay_task50x15", href = "essay_task50x15.xml"))))
                                                          )
                                                      )
                               )
                           )
)
create_qti_test(test)




