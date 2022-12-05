## S4 example

library(qti)
library(markdown)
library(shiny)

# example of md description of question
file1 <- "D:/Data Science/R headson/some trash/gap/ex_g"
file2 <- "D:/Data Science/R headson/some trash/gap/ex_g_yaml"
file3 <- "D:/Data Science/R headson/qti/results/choice.xml"
x <- create_content_object(file)
x

# create sc and mpc
sc <- new("SingleChoice",
          text = new("Text", content = list("<p>With SQL, how do you select <b>all the records</b> from a table named Persons where the value of the column FirstName is Peter?<br />SELECT * FROM", new("Br"), "this is the second line of text</p>")),
          choices = c("You must stay with your luggage at all times.", "Bb", "Cc", "Dd"),
          title = "filename_sc",
          prompt = "this is a prompt",
          points = 2)

mpc <- new("MultipleChoice",
           text = new("Text", content = list("This is the mpc question")),
           choices = c("A", "B", "C", "D"),
           points = c(1, 1, -1, 0),
           title = "filename_mc")

te <- new("TextEntry",
          text = new("Text", content = list(
              "first line ", htmltools::HTML("</br>"),
              new("Br"),
              "sec",
              new("TextGap", response_identifier = "RESPONSE",
                  score = 1, response = "answer",
                  alternatives = c("answer", "Answer")),
              "text after the gap",
              new("Br"),
              "third line")),
          title = "filename_te"
          )

tem1 <- new("Entry", text = create_content_object(file1), title = "test_example")
tem2 <- new("Entry", text = create_content_object(file2), title = "test_example")


g1 <- new("Text", content = "some text of question \n the second line")
g2 <- new("Text", content = "some text of question")

tg <- new("TextGap", positions = 10, scores = 1, responses = "Chemnitz")
ng <- new("NumericGap", positions = 10, score = 1, responses = 5)

create_item_body(sc)
create_response_declaration(sc)

create_item_body(mpc)
create_response_declaration(mpc)

create_qti_task(sc)
create_qti_task(mpc)
file2 <- "D:/Data Science/R headson/some trash/gap/ex_g_yaml"


# task with text gaps
tem2 <- new("Entry", text = create_content_object(file2), title = "text_gaps_task")
create_qti_task(tem2)



# task with numeric gaps
tem3 <- new("Entry", text = new("Text", content = list("5 - ",
                                                           new("NumericGap", response_identifier = "numeric_1", response = 7, value_precision = 1, expected_length = 1),
                                                           " = -2")
                                    ), title = "numeric_gaps_task")
create_qti_task(tem3)


# task with combination of text and numeric gaps
com <- new("Entry", text = new("Text", content = list("5 ",
                                                            new("TextGap", response_identifier = "str_1", response = "+", score = 1, placeholder = "+ or -"),
                                                          " 2 = ",
                                                          new("NumericGap", response_identifier = "numeric_1", response = 7, value_precision = 1, expected_length = 11, placeholder = "here is number"),
                                                      "some line",
                                                      new("NumericGap", response_identifier = "numeric_2", response = 7, value_precision = 1, expected_length = 11, placeholder = "here is number")
                                                           )), title = "complex_gap_task")
create_qti_task(com)

# task with dropdownlist
dd <- new("Entry", text = new("Text", content = list("first line",
                                                     new("InlineChoice", response_identifier = "list_1", options = c("a", "b", "c")
                                                     ))),
          title = "dropdown")
create_qti_task(dd)
dd2 <- new("Entry", text = new("Text", content = list("first line <br/>",
                                                      "<h2>second line</h2>",
                                                     new("InlineChoice", response_identifier = "list_1", options = c("a", "b", "c")),
                                                         "<br/>third line",
                                                         new("InlineChoice", response_identifier = "list_2", options = c("answer1", "answer2", "answer3"), score = 2),
                                                     "end text."
                                                     )),
          title = "dropdown")
create_qti_task(dd2)

# TODO parse text in choices
ord <- new("Order", text = new("Text", content = list("put in a right order")),
           identifier = "order_id", title = "order_task",
           choices = c("first", "second", "third"), points = 5)
create_qti_task(ord)

mt <- new("DirectedPair", text = new("Text",
                                   content = list("<h3>This is match table task</h3>",
                                                  "<i>table description</i>")),
        rows = c("row1", "row2", "row3", "row4"),
        rows_identifiers = c("a", "b", "c", "d"),
        cols = c("alfa", "beta", "gamma"),
        cols_identifiers = c("k", "l", "m"),
        answers_identifiers = c("a k", "b l", "c l", "d m"),
        points = 5,
        title = "match_table"
)
create_qti_task(mt)
