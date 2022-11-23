## S4 example

library(qti)
library(markdown)
library(shiny)

# example of md description of question
file1 <- "D:/Data Science/R headson/some trash/gap/ex_g"
file2 <- "D:/Data Science/R headson/some trash/gap/ex_g_yaml"
x <- create_content_object(file)
x

# create sc and mpc
sc <- new("SingleChoice",
          text = new("Text", content = list("<p>With SQL, how do you select <b>all the records</b> from a table named Persons where the value of the column FirstName is Peter?<br />SELECT * FROM", new("Br"), "this is the second line of text</p>")),
          choices = c("Aa", "Bb", "Cc", "Dd"),
          title = "filename_sc",
          prompt = "this is a prompt")

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

tem1 <- new("TextEntry", text = create_content_object(file1), title = "test_example")
tem2 <- new("TextEntry", text = create_content_object(file2), title = "test_example")

g1 <- new("Text", content = "some text of question \n the second line")
g2 <- new("Text", content = "some text of question")

tg <- new("TextGap", positions = 10, scores = 1, responses = "Chemnitz")
ng <- new("NumericGap", positions = 10, score = 1, responses = 5)
# Checks for types automatically! For instance, points must be a numeric:

# sc@points <- "text"

# Use generic function:

create_item_body(sc)
create_response_declaration(sc)

create_item_body(mpc)
create_response_declaration(mpc)

create_qti_task(sc)
create_qti_task(mpc)
create_qti_task(tem2)

