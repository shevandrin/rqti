## S4 examples
library(qti)

# create SingleChoice object ---------------------------------------------------
sc <- new("SingleChoice",
          choices = c("option 1", "option 2", "option 3", "option 4"),
          # orientation = "vertical",
          title = "single_choice_task",
          prompt = "Single choice question example",
          shuffle = FALSE,
          points = 2,
          identifier = "sc_example",
          feedback = list(WrongFeedback(title = "bad decision",
                                       content = list("<i>this is false</i>")))
          )
create_qti_task(sc, "to_delete", TRUE)

# create MultipleChoice object example 1 ---------------------------------------
mc <- new("MultipleChoice",
           content = list("<p>This is the mpc question</p>"),
           choices = c("A", "B", "C", "D"),
           choice_identifiers = c("a1", "a2", "a3", "a4"),
           points = c(1, 0, -1, 1),
           title = "multiple_choice_task",
           identifier = "mc",
           feedback = list(WrongFeedback(title = "bad decision",
                                        content = list("<i>this is false</i>")),
                           CorrectFeedback(title = "gut gemacht",
                                content = list("diese Antwort ist richtig")))
          )
create_qti_task(mc, "to_delete", TRUE)

# create MultipleChoice object example 2 ---------------------------------------
mpc0 <- new("MultipleChoice",
           prompt = "This is the mpc question",
           choices = c("A", "B", "C"),
           points = c(1, 0, 2),
           title = "multiple_choice_task")
create_qti_task(mpc0, "to_delete", TRUE)

# task with TextGap  -----------------------------------------------------------
te <- new("Entry", content = list("<h2>some markdown title1</h2><h1><b>Some
                                  title</b><br />svsdvsdvsd</h1><p>With <em>SQL
                                  </em>, how do you select <b>all the records
                                  </b> from a table named <em><strong>Persons
                                  </strong></em> where the value of the column
                                 <i>FirstName</i> is Peter?<br />SELECT * FROM",
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
                                "=‘Peter’</p><h3>markdown title 2</h3><p>Put the
                                right answers in the text field above.</p>"),
           title = "text_gaps_task",
          feedback = list(WrongFeedback(title = "Fehler",
                                        content = list("falsche Antwort")),
                          CorrectFeedback(title = "Erfolg",
                                          content = list("richtige Antwort"))),
          identifier = "gaps_with_feedback")
create_qti_task(te, "to_delete", TRUE)

# task with TextGap for opal --------------------------------------------------
te_opal <- new("Entry", content = list("<p>es geht",
                                        new("TextGapOpal",
                                            response_identifier = "res1",
                                            response = "um",
                                            score = 0.5,
                                            value_precision = 1),
                                        "die neuen Produkte</p>"),
               title = "preposition with gehen")
create_qti_task(te_opal, "to_delete", TRUE)

# task with NumericGap  --------------------------------------------------------
ne <- new("Entry", content = list("<p>5 - ",
                                    new("NumericGap",
                                        response_identifier = "numeric_1",
                                        response = 7,
                                        value_precision = 10,
                                        expected_length = 1,
                                        include_lower_bound = FALSE,
                                        include_upper_bound = FALSE),
                                    " = -2</p>"),
          title = "numeric_gaps_task")
create_qti_task(ne, "to_delete", TRUE)


# task with combination of TextGap and NumericGap  -----------------------------
com <- new("Entry", content = list("<p>5 ",
                                    new("TextGap",
                                        response_identifier = "str_1",
                                        response = "+",
                                        score = 1,
                                        placeholder = "+ or -"),
                                    " 2 = ",
                                    new("NumericGap",
                                        response_identifier = "numeric_1",
                                        response = 7, value_precision = 1,
                                        expected_length = 11,
                                        placeholder = "here is number"),
                                   "</p>"),
           feedback = list(WrongFeedback(title = "Fehler",
                                         content = list("falsche Antwort")),
                           CorrectFeedback(title = "Erfolg",
                                           content = list("richtige Antwort"))),
           title = "complex_gap_task")
create_qti_task(com, "to_delete", TRUE)

# task with dropdown list (InlineChoice)  --------------------------------------
dd1 <- new("Entry", content = list("<p>first line",
                                    new("InlineChoice",
                                        response_identifier = "list_1",
                                        options = c("a", "b", "c")),
                                   "</p>"),
          title = "dropdown1")
create_qti_task(dd1, "to_delete", TRUE)

dd2 <- new("Entry", content = list("<p>first line <br/>",
                                   "<big>second line</big>",
                                    new("InlineChoice",
                                        response_identifier = "list_1",
                                        options = c("a", "b", "c")),
                                   "<br/>third line",
                                   new("InlineChoice",
                                       response_identifier = "list_2",
                                       options = c("answ1", "answ2", "answ3"),
                                       score = 2),
                                   "end text.</p>"),
           feedback = list(WrongFeedback(title = "Fehler",
                                         content = list("falsche Antwort")),
                           CorrectFeedback(title = "Erfolg",
                                           content = list("richtige Antwort"))),
          title = "dropdown2")
create_qti_task(dd2, "to_delete", TRUE)

# task with Order  -------------------------------------------------------------
ord <- new("Order", content = list("<p>put in a right order</p>"),
           identifier = "order_id", title = "order_task",
           choices = c("first", "second", "third"),
           choices_identifiers = c("a","b","c"),
           points = 5,
           feedback = list(WrongFeedback(title = "Fehler",
                                         content = list("falsche Antwort")),
                           CorrectFeedback(title = "Erfolg",
                                           content = list("richtige Antwort"))))
create_qti_task(ord, "to_delete", TRUE)

# task with directed pairs  ----------------------------------------------------
# TODO validation number of cols and rows
dp <- new("DirectedPair", content = list("<h3>This is match table task</h3>",
                                         "<p>table description</p>"),
        rows = c("row1", "row2", "row3"),
        rows_identifiers = c("a", "b", "c"),
        cols = c("alfa", "beta", "gamma"),
        cols_identifiers = c("k", "l", "m"),
        answers_identifiers = c("a k", "b l", "c m"),
        points = 5,
        title = "directed_pair",
        prompt = "this is a prompt",
        feedback = list(WrongFeedback(title = "Fehler",
                                      content = list("falsche Antwort")),
                        CorrectFeedback(title = "Erfolg",
                                        content = list("richtige Antwort")))
)
create_qti_task(dp, "to_delete", TRUE)

# task with OneInRow  ----------------------------------------------------------
# match table with one right answer in a row
rt <- new("OneInRowTable", content = list("<h3>This is match table task</h3>",
                                          "<h6>table description</h6>"),
          rows = c("row1", "row2", "row3", "row4"),
          rows_identifiers = c("a", "b", "c", "d"),
          cols = c("alfa", "beta", "gamma"),
          cols_identifiers = c("k", "l", "m"),
          answers_identifiers = c("a k", "b l", "c l", "d m"),
          points = 5,
          title = "one_in_row_table",
          feedback = list(WrongFeedback(title = "Fehler",
                                        content = list("falsche Antwort")),
                          CorrectFeedback(title = "Erfolg",
                                          content = list("richtige Antwort")))
)
create_qti_task(rt, "to_delete", TRUE)

# task with OneInCol  ----------------------------------------------------------
# match table with one right answer in a column
ct <- new("OneInColTable", content = list("<h3>This is match table task</h3>",
                                          "<h6>table description</h6>"),
          rows = c("row1", "row2", "row3"),
          rows_identifiers = c("a", "b", "c"),
          cols = c("alfa", "beta", "gamma"),
          cols_identifiers = c("k", "l", "m"),
          answers_identifiers = c("a k", "b l", "b m"),
          points = 5,
          title = "one_in_col_table",
          feedback = list(WrongFeedback(title = "Fehler",
                                        content = list("falsche Antwort")),
                          CorrectFeedback(title = "Erfolg",
                                          content = list("richtige Antwort")))
)
create_qti_task(ct, "to_delete", TRUE)

# task with MultipleChoiceTable  -----------------------------------------------
#match table with many right answers in rows and columns
mt <- new("MultipleChoiceTable",
          content = list("<h3>This is match table task</h3>",
                          "<h6>table description</h6>"),
          rows = c("row1", "row2", "row3"),
          rows_identifiers = c("a", "b", "c"),
          cols = c("alfa", "beta", "gamma"),
          cols_identifiers = c("a", "b", "c"),
          answers_identifiers = c("a a", "b b", "b c"),
          points = 5,
          title = "multiple_choice_table",
          identifier = "mc_table",
          feedback = list(WrongFeedback(title = "Fehler",
                                        content = list("falsche Antwort")),
                          CorrectFeedback(title = "Erfolg",
                                          content = list("richtige Antwort")))
)
create_qti_task(mt, "to_delete", TRUE)

# Essay type task  -------------------------------------------------------------
es <- new("Essay", content = list("<h2>this is an essay type of question</h2>"),
          title = "essay_task50x15",
          max_strings = 100,
          points = 3,
          identifier = "es",
          feedback = list(WrongFeedback(title = "Fehler",
                                        content = list("falsche Antwort")),
                          CorrectFeedback(title = "Erfolg",
                                          content = list("richtige Antwro"))))
create_qti_task(es, "to_delete", TRUE)

# assessment test with assessment items-----------------------------------------
sc1 <- new("SingleChoice", prompt = "Test task", title = "SC",
             identifier = "q1", choices = c("a", "b", "c"))
sc2 <- new("SingleChoice", prompt = "Test task", title = "SC",
             identifier = "q2", choices = c("A", "B", "C"))
sc3 <- new("SingleChoice", prompt = "Test task", title = "SC",
             identifier = "q3", choices = c("aa", "bb", "cc"))
e1 <- new("Essay", prompt = "Essay task", identifier = "e1")
e2 <- new("Essay", prompt = "Essay task", identifier = "e2")
e3 <- new("Essay", prompt = "Essay task", identifier = "e3")
exam_subsection <- new("AssessmentSection", identifier = "subsec_id",
                       title = "Subsection", assessment_item = list(e1, e2, e3),
                       shuffle = TRUE, selection = 2)
exam_section <- new("AssessmentSection", identifier = "sec_id",
                   title = "section",
                   assessment_item = list(sc1, sc2, sc3, exam_subsection))

exam <- new("AssessmentTestOpal", identifier = "id_test",
            title = "some title", section = list(exam_section),
            files = c("man/figures/assessmentTest.png",
                      "man/figures/README-S4_classes_diagramm.jpg"))
create_qti_test(exam, "to_delete")
