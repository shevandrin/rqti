# SingleChoice
test_that("create_question_object", {
    path <- test_path("file/test_sc_example1.md")
    sut <- create_question_object(path)

    content <- "<p>This is a mock question<br/>\nIn economics it is generally believed that the main objective of a Public Sector Financial Company like Bank is to:</p>"
    expected <- new("SingleChoice",
                   content = list(content),
                   identifier = "eco",
                   qti_version = "v2p1",
                   title = "Economics and Physic",
                   choices = c("Employ more and more people",
                               "Maximize total production",
                               "Maximize total profits",
                               "Sell the goods at subsidized cost"),
                   shuffle = TRUE,
                   prompt = "",
                   choice_identifiers = c("ChoiceA",
                                          "ChoiceB",
                                          "ChoiceC",
                                          "ChoiceD"),
                   orientation = "vertical",
                   solution = 1
    )
    expect_equal(sut, expected)
})

test_that("create_question_object", {
    path <- test_path("file/test_sc_example2.md")
    cqc <- create_question_object(path)
    expected <- new("SingleChoice",
                   content = list(
    "<p>Which term is used to describe the study of how people make decisions in a world where resources are limited?</p>"),
                   points = 2,
                   identifier = "sample 2",
                   qti_version = "v2p1",
                   title = "Economics 2",
                   choices = c("scarcity",
                               "decision-making modeling",
                               "economics",
                               "cost-benefit analysis"),
                   shuffle = TRUE,
                   prompt = "",
                   choice_identifiers = c("ChoiceA",
                                          "ChoiceB",
                                          "ChoiceC",
                                          "ChoiceD"),
                   orientation = "vertical",
                   solution = 2
    )
    expect_equal(cqc, expected)
})

test_that("create_question_object", {
    path <- test_path("file/test_sc_example3.md")
    cqc <- create_question_object(path)
    expected <- new("SingleChoice", content = list(
    "<p>Which of the following is a market economy primarily based on?</p>"),
                   points = 3,
                   identifier = "sample 2",
                   qti_version = "v2p1",
                   title = "Economics",
                   choices = c("capitalism and free enterprise",
                               "traditionalism and command",
                               "incentives and traditionalism"),
                   shuffle = TRUE,
                   prompt = "",
                   choice_identifiers = c("ChoiceA",
                                          "ChoiceB",
                                          "ChoiceC"),
                   orientation = "vertical",
                   solution = 1
    )
    expect_equal(cqc, expected)
})

# MultipleChoice - 1
test_that("create_question_object", {
    path <- test_path("file/test_mc_example.md")
    sut <- create_question_object(path)
    expected <- new("MultipleChoice",
                   content = list(
    "<p>When deciding between renovating a water treatment plant or building a new community pool, what is the government most likely to consider?</p>"),
                   points = c(1, 2, 0, 0),
                   identifier = "test 2",
                   qti_version = "v2p1",
                   title = "Economics",
                   choices = c("scarcity vs. resources",
                               "wages vs. prices",
                               "wants vs. needs",
                               "consumers vs. producers"),
                   shuffle = TRUE,
                   prompt = "",
                   choice_identifiers = c("ChoiceA",
                                          "ChoiceB",
                                          "ChoiceC",
                                          "ChoiceD"),
                   orientation = "vertical"
    )
    sut@choices <- textclean::replace_non_ascii(sut@choices)
    expect_equal(sut, expected)
})

# MultipleChoice - 2
test_that("create_question_object", {
    path <- test_path("file/test_mc_example2.md")
    sut <- create_question_object(path)
    expected <- new("MultipleChoice",
                    content = list(
                        "<p>When deciding between renovating a water treatment plant or building a new community pool, what is the government most likely to consider?</p>"),
                    points = c(2.5, 0, 2.5, 0),
                    identifier = "test 2",
                    qti_version = "v2p1",
                    title = "Economics",
                    choices = c("scarcity vs. resources",
                                "wants vs. needs",
                                "wages vs. prices",
                                "consumers vs. producers"),
                    shuffle = TRUE,
                    prompt = "",
                    choice_identifiers = c("ChoiceA",
                                           "ChoiceB",
                                           "ChoiceC",
                                           "ChoiceD"),
                    orientation = "vertical"
    )
    sut@choices <- textclean::replace_non_ascii(sut@choices)
    expect_equal(sut, expected)
})

# Essay
test_that("create_question_object", {
    path <- test_path("file/test_essay_example.md")
    sut <- create_question_object(path)
    expected <- new("Essay",
                    content = list(
                "<p>Defining Good Students Means More Than Just Grades.</p>"),
                   points = 10,
                   identifier = "test 2",
                   qti_version = "v2p1",
                   title = "Definition Essay",
                   data_allow_paste = FALSE
                   )
    expect_equal(sut, expected)
})
# Entry
test_that("create_question_object", {
path <- test_path("file/test_entry_example1.md")
sut <- create_question_object(path)
expected <- new("Entry", content = list("<p>Hast du ",
                new("TextGap", response_identifier = "response_1", response = "ein"),
                " Handy?</p>"),
                points = 5,
                identifier = "test 2",
                qti_version = "v2p1",
                title = "Germany"
)
expect_equal(sut, expected)
})
# Entry with YAML
test_that("create_question_object", {
path <- test_path("file/test_entry_example2.md")
sut <- create_question_object(path)
expected <- new("Entry", content = list("<p>Hast du ",
                new("TextGap",
                expected_length = 10,
                response_identifier = "response_1",
                response = "Ein"),
                " Handy?<br/>\nWie viele Äpfel liegen auf dem Tisch? ",
                new("NumericGap", response = 2,
                    response_identifier = "response_2"),
                "</p>"),
                points = 5,
                identifier = "test 2",
                qti_version = "v2p1",
                title = "Germany"
)
expect_equal(sut, expected)
})
 # Entry - Testing function create_outcome_declaration_entry
test_that("Testing function create_outcome_declaration_entry", {
    expected <- new("Entry", content = list("<p>Hast du",
                                            new("TextGap", response_identifier = "response_1", response = "ein"),
                                            " Handy?</p>"),
                    points = 5,
                    identifier = "test 2",
                    title = "Germany"
    )

    example <- "<additionalTag>
    <outcomeDeclaration identifier=\"SCORE\" cardinality=\"single\" baseType=\"float\">
        <defaultValue>
        <value>0</value>
        </defaultValue>
        </outcomeDeclaration>
        <outcomeDeclaration identifier=\"MAXSCORE\" cardinality=\"single\" baseType=\"float\">
        <defaultValue>
        <value>5</value>
        </defaultValue>
        </outcomeDeclaration>
        <outcomeDeclaration identifier=\"MINSCORE\" cardinality=\"single\" baseType=\"float\">
        <defaultValue>
        <value>0</value>
        </defaultValue>
        </outcomeDeclaration>
        <outcomeDeclaration identifier=\"SCORE_response_1\" cardinality=\"single\" baseType=\"float\">
        <defaultValue>
        <value>0</value>
        </defaultValue>
        </outcomeDeclaration>
        <outcomeDeclaration identifier=\"MAXSCORE_response_1\" cardinality=\"single\" baseType=\"float\">
        <defaultValue>
        <value>1</value>
        </defaultValue>
        </outcomeDeclaration>
        <outcomeDeclaration identifier=\"MINSCORE_response_1\" cardinality=\"single\" baseType=\"float\">
        <defaultValue>
        <value>0</value>
        </defaultValue>
        </outcomeDeclaration>
        </additionalTag>"

    expected <- toString(htmltools::tag(
        "additionalTag", list(create_outcome_declaration_entry(expected))))

    xml1 <- xml2::read_xml(expected)
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
})

test_that("Test parsing md for Order task", {
    path <- test_path("file/test_order_example.md")
    sut <- create_question_object(path)
    expected <- new("Order", content = list("<p>Arrange German cities in ascending order of population</p>"),
                    identifier = "test_order_example",
                    choices = c("Berlin", "Hamburg", "Munich", "Cologne", "Düsseldorf",  "Leipzig")
    )
    expect_equal(sut, expected)
})
test_that("Test parsing md for Direct Pair task", {
    path <- test_path("file/test_directedPair_example.md")
    sut <- create_question_object(path)
    expected <- new("DirectedPair", content = list("<p>Associate the cities with lands.</p>"),
                    identifier = "test_direct_pair_example",
                    rows = c("Munchen", "Chemnitz", "Dusseldorf", "Karlsruhe", "Erfurt"),
                    rows_identifiers = c("row_1", "row_2", "row_3","row_4","row_5"),
                    cols = c("Bayern", "Sachsen", "NRW", "Baden-Württemberg", "Thüringen"),
                    cols_identifiers = c("col_1", "col_2", "col_3","col_4","col_5"),
                    answers_identifiers = c("row_1 col_1", "row_2 col_2",
                                    "row_3 col_3", "row_4 col_4", "row_5 col_5"),
                    answers_scores = c(1, 1, 1, 1, 0.5)
    )
    expect_equal(sut, expected)
})
test_that("Test parsing md for OnInColTable task", {
    path <- test_path("file/test_OnInColTable_example.md")
    sut <- create_question_object(path)
    expected <- new("OneInColTable",
                         content = list("<p>Choose the correct order in the multiplication table</p>"),
                         identifier = "test_OnInColTable_example",
                         title = "test_OnInColTable_example",
                         rows = c("2*3 =", "4*7 =", "12*3 =", "3*9 =", "5*5 ="),
                         rows_identifiers = c("row_1", "row_2", "row_3", "row_4", "row_5"),
                         cols = c("6", "36", "27", "72/2", "25"),
                         cols_identifiers = c("col_1", "col_2", "col_3", "col_4", "col_5"),
                         answers_identifiers =c("row_1 col_1", "row_3 col_2", "row_3 col_4", "row_4 col_3", "row_5 col_5"),
                         answers_scores = c(0.5, 1, 1, 1, 1)
    )
    expect_equal(sut, expected)
})
test_that("Test parsing md for OneInRowTable task", {
    path1 <- test_path("file/test_OneInRowTable_example.md")
    sut1 <- create_question_object(path1)
    path2 <- test_path("file/test_OneInRowTable_example.Rmd")
    sut2 <- create_question_object(path2)
    expected <- new("OneInRowTable",
                         content = list("<p>Choose the correct order in the multiplication table</p>"),
                         identifier = "test_OneInRowTable_example",
                         title = "OneInRowTable",
                         rows = c("4*9 =", "3*9 =", "5*5 =", "2*3 =", "12*3 ="),
                         rows_identifiers = c("row_1", "row_2", "row_3", "row_4", "row_5"),
                         cols = c("27", "36", "25", "6"),
                         cols_identifiers = c("col_1", "col_2", "col_3", "col_4"),
                         answers_identifiers = c("row_1 col_2", "row_2 col_1", "row_3 col_3", "row_4 col_4", "row_5 col_2"),
                         answers_scores = c(0.5, 1, 1, 1, 1))
    expect_equal(sut1, expected)
    expect_equal(sut2, expected)
})
test_that("Test parsing md for MultipleChoiceTable task", {
    path <- test_path("file/test_MultipleChoiceTable_example.md")
    sut <- create_question_object(path)
    expected <- new("MultipleChoiceTable",
                    content = list("<p>Choose the correct order in the multiplication table</p>"),
                    identifier = "test_MultipleChoiceTable_example",
                    rows = c("4*7-1 =", "3*9 =", "5*5 =", "2*3 =", "12*3 ="),
                    rows_identifiers = c("row_1", "row_2", "row_3", "row_4", "row_5"),
                    cols = c("27", "36", "25", "6", "72/2"),
                    cols_identifiers = c("col_1", "col_2", "col_3", "col_4", "col_5"),
                    answers_identifiers =c("row_1 col_1", "row_2 col_1", "row_3 col_3", "row_4 col_4", "row_5 col_2", "row_5 col_5"),
                    answers_scores = c(1, 1, 1, 1, 1, 1))
    expect_equal(sut, expected)
})
test_that("Test parsing md for TextGap (yaml and primitive) tasks", {
    path <- test_path("file/test_entry_Gap_primitive.Rmd")
    sut <- create_question_object(path)
    expected <- new("Entry",
           identifier = "test_entry_example",
           title = "test_entry_example",
           content = list('<p><strong>Diese Aufgabe dient zum Testen verschiedener Möglichkeiten zum Erstellen von Lücken</strong></p>\n<p>Hast du ',
                     new("TextGap",
                          response_identifier = "response_1",
                          response = "ein",
                          alternatives = c("EIN", "Ein"),
                          case_sensitive = TRUE),
                     ' Handy? Dieses Telefonmodell ist Nokia ',
                     new("NumericGap",
                          response_identifier = "response_2",
                          response = 3310),
                     '. Hast du ',
                     new("TextGap",
                          response_identifier = "response_3",
                          response = "ein"),
                     ' Computer? Der beliebteste Prozessor im ersten Quartal 2023 ist der Core i',
                     new("NumericGap",
                          response_identifier = "response_4",
                          response = 5),
                     '.</p>\n<p>neue numerische Lücke, die mit der Funktion gebaut würde ',
                     new("NumericGap",
                         response_identifier = "response_5",
                         response = 8,
                         placeholder = "die richtige Antwort ist 8",
                         expected_length = 50,
                         type_precision = "relative",
                         value_precision = 10,
                         include_lower_bound = FALSE),
                     '</p>\n<p>eine texte Lücke, die mit der Funktion gebaut würde ',
                     new("TextGap",
                         response_identifier = "response_6",
                         response = "answer0",
                         alternatives = c("answer1", "answer2"), score = 3,
                         placeholder = "put answer here",
                         expected_length = 70, case_sensitive = FALSE),
                     '</p>\n<p>eine texte Lücke <strong>für opal</strong>, die mit der Funktion gebaut würde ',
                     new("TextGapOpal",
                         response_identifier = "response_7",
                         response = "answer0",
                         alternatives = c("answer1", "answer2"),
                         score = 3,
                         placeholder = "opal allows some tolerance rate",
                         expected_length = 50,
                         case_sensitive = FALSE,
                         value_precision = 2),'</p>'),
                    feedback = list(new("ModalFeedback",
                                        content = list("<p>general feedback</p>"))))
    expect_equal(sut, expected)
})
test_that("Test parsing md for InlineChoice (yaml and primitive) tasks", {
    path <- test_path("file/test_entry_Gap_InlineChoice.md")
    sut <- create_question_object(path)
    expected <- new("Entry",
                    identifier = "test_entry_example",
                    title = "test_entry_example",
                    content = list('<p>Das beliebteste Telefon der Welt ist ',
                                   new("InlineChoice",
                                       options = c("Realme 9 Pro","Realme GT Master Edition","Samsung Galaxy A52"),
                                       response_identifier = "response_1"),
                                   '. Das meistverkaufte Telefonmodell in Deutschland ist ',
                                   new("InlineChoice",
                                       options = c("Apple iPhone 13 Pro","Apple iPhone 13 Pro Max","Apple iPhone 13"),
                                       response_identifier = "response_2",
                                       solution = 3),
                                   '.</p>'),
                    feedback = list(new("WrongFeedback",
                                        content = list("<p>wrong feedback</p>")),
                                     new("CorrectFeedback",
                                        content = list("<p>correct feedback</p>"))
                                       )
                    )
    expect_equal(sut, expected)
})
