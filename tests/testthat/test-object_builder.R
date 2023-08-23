test_that("Testing SingleChoice where answer is $nummer", {
    path <- test_path("file/md/test_sc_example3.md")
    sut <- create_question_object(path)

    content <- "<p>This is a mock question<br/>The speed of the light in kilometers per second is:</p>"
    expected <- new("SingleChoice",
                    content = list(content),
                    identifier = "eco",
                    qti_version = "v2p1",
                    title = "Physic",
                    choices = c("<span class=\"math inline\">\\(299\\)</span>",
                                "<span class=\"math inline\">\\(300\\)</span>",
                                "<span class=\"math inline\">\\(199\\)</span>",
                                "<span class=\"math inline\">\\(99\\)</span>"),
                    shuffle = TRUE,
                    prompt = "",
                    choice_identifiers = c("ChoiceA",
                                           "ChoiceB",
                                           "ChoiceC",
                                           "ChoiceD"),
                    orientation = "vertical",
                    solution = 2
    )
    expect_equal(sut, expected)
})

test_that("Testing create_question_object() for SingleChoice class", {
    path <- test_path("file/md/test_sc_example1.md")
    sut <- create_question_object(path)

    expected <- new("SingleChoice",
                    content = list(paste0("<p>This is a mock question.<br/>",
                                           "In economics it is generally ",
                                           "believed that the main ",
                                           "objective of a Public Sector ",
                                           "Financial Company ",
                                           "like Bank is to:</p>")),
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
                    orientation = "vertical")

    expect_equal(sut, expected)
})

test_that("Testing create_question_object() for SingleChoice class: solution", {
    path <- test_path("file/md/test_sc_example2.md")
    sut <- create_question_object(path)

    expected <- new("SingleChoice",
                    content = list(paste0("<p>Which term is used to ",
                                          "describe the study ",
                                          "of how people make decisions",
                                          " in a world where ",
                                          "resources are limited?</p>")),
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
    expect_equal(sut, expected)
})

test_that("Testing create_question_object() for MultipleChoice class:
          solution 1 and 2", {
    path <- test_path("file/md/test_mc_example.md")
    sut <- create_question_object(path)
    expected <- new("MultipleChoice",
                    content = list(paste0("<p>When deciding between ",
                                          "renovating a water treatment plant ",
                                          "or building a new community pool, ",
                                          "what is the government most likely ",
                                          "to consider?</p>")),
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

test_that("Testing create_question_object() for MultipleChoice class:
          solution 1 and 3", {
    path <- test_path("file/md/test_mc_example2.md")
    sut <- create_question_object(path)
    expected <- new("MultipleChoice",
                    content = list(paste0("<p>Economic systems are ways ",
                                          "that countries answer the 5 ",
                                          "fundamental questions:",
                                          "</p><ul><li>What will be ",
                                          "produced?</li><li>How will goods ",
                                          "and services be produced?",
                                          "</li><li>Who will get the output?",
                                          "</li><li>How will the system ",
                                          "accommodate change?</li><li>How ",
                                          "will the system promote progress?",
                                          "</li></ul><p>When deciding ",
                                          "between renovating a water ",
                                          "treatment plant or building a new ",
                                          "community pool, what is the ",
                                          "government most likely to ",
                                          "consider?</p>")),
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

test_that("Testing create_question_object() for Essay class", {
    path <- test_path("file/md/test_essay_example.md")
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

test_that("Testing create_question_object() for Entry class", {
path <- test_path("file/md/test_entry_example1.md")
sut <- suppressMessages(create_question_object(path))
expected <- suppressMessages(new("Entry", content = list("<p>Hast du ",
                new("TextGap", response_identifier = "response_1",
                    solution = "ein"),
                " Handy?</p>"),
                points = 5,
                identifier = "test 2",
                qti_version = "v2p1",
                title = "Germany"
                ))
expect_equal(sut, expected)
})

test_that("Testing create_question_object() for Entry with YAML", {
path <- test_path("file/md/test_entry_example2.md")
sut <- suppressMessages(create_question_object(path))
expected <- suppressMessages(new("Entry", content = list("<p>Hast du ",
                new("TextGap",
                expected_length = 10,
                response_identifier = "response_1",
                solution = "Ein"),
                " Handy?<br/>Wie viele Äpfel liegen auf dem Tisch? ",
                new("NumericGap", solution = 2,
                    response_identifier = "response_2"),
                "</p>"),
                points = 5,
                identifier = "test 2",
                qti_version = "v2p1",
                title = "Germany"
                ))
expect_equal(sut, expected)
})

test_that("Testing create_outcome_declaration() for Entry class", {
    expected <- suppressMessages(new("Entry",
                                     content = list("<p>Hast du",
                                     new("TextGap",
                                     response_identifier = "response_1",
                                     solution = "ein"),
                                     " Handy?</p>"),
                    points = 1,
                    identifier = "test 2",
                    title = "Germany"
    ))

    example <- "<additionalTag>
    <outcomeDeclaration identifier=\"SCORE\" cardinality=\"single\" baseType=\"float\">
        <defaultValue>
        <value>0</value>
        </defaultValue>
        </outcomeDeclaration>
        <outcomeDeclaration identifier=\"MAXSCORE\" cardinality=\"single\" baseType=\"float\">
        <defaultValue>
        <value>1</value>
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

test_that("Testing create_question_object() for Order task", {
    path <- test_path("file/md/test_order_example.md")
    sut <- create_question_object(path)
    expected <- new("Order",
                    content = list(paste0("<p>Arrange German cities ",
                                          "in ascending order of ",
                                          "population</p>")),
                    identifier = "test_order_example",
                    choices = c("Berlin", "Hamburg", "Munich",
                                "Cologne", "Düsseldorf",  "Leipzig")
                    )
    expect_equal(sut, expected)
})

test_that("Testing create_question_object() for Direct Pair task", {
    path <- test_path("file/md/test_directedPair_example.md")
    sut <- create_question_object(path)
    expected <- new("DirectedPair",
                    content = list("<p>Associate the cities with lands.</p>"),
                    identifier = "test_direct_pair_example",
                    rows = c("Munchen", "Chemnitz", "Dusseldorf",
                             "Karlsruhe", "Erfurt"),
                    rows_identifiers = c("row_1", "row_2", "row_3",
                                         "row_4","row_5"),
                    cols = c("Bayern", "Sachsen", "NRW",
                             "Baden-Württemberg", "Thüringen"),
                    cols_identifiers = c("col_1", "col_2", "col_3",
                                         "col_4","col_5"),
                    answers_identifiers = c("row_1 col_1", "row_2 col_2",
                                            "row_3 col_3", "row_4 col_4",
                                            "row_5 col_5"),
                    answers_scores = c(1, 1, 1, 1, 0.5)
    )
    expect_equal(sut, expected)
})

test_that("Testing create_question_object() for OnInColTable task", {
    path <- test_path("file/md/test_OnInColTable_example.md")
    sut <- create_question_object(path)
    expected <- new("OneInColTable",
                    content = list(paste0("<p>Choose the correct order in ",
                                          "the multiplication table</p>")),
                    identifier = "test_OnInColTable_example",
                    title = "test_OnInColTable_example",
                    rows = c("2*3 =", "4*7 =", "12*3 =","3*9 =", "5*5 ="),
                    rows_identifiers = c("row_1", "row_2", "row_3",
                                         "row_4", "row_5"),
                    cols = c("6", "36", "27", "72/2", "25"),
                    cols_identifiers = c("col_1", "col_2", "col_3",
                                         "col_4", "col_5"),
                    answers_identifiers =c("row_1 col_1", "row_3 col_2",
                                           "row_3 col_4", "row_4 col_3",
                                           "row_5 col_5"),
                    answers_scores = c(0.5, 1, 1, 1, 1)
    )
    expect_equal(sut, expected)
})

test_that("Testing create_question_object() for OneInRowTable task", {
    path1 <- test_path("file/md/test_OneInRowTable_example.md")
    sut1 <- create_question_object(path1)
    path2 <- test_path("file/rmd/test_OneInRowTable_example.Rmd")
    sut2 <- create_question_object(path2)
    expected <- new("OneInRowTable",
                    content = list(paste0("<p>Choose the correct order in ",
                                          "the multiplication table</p>")),
                    identifier = "test_OneInRowTable_example",
                    title = "OneInRowTable",
                    rows = c("4*9 =", "3*9 =", "5*5 =", "2*3 =", "12*3 ="),
                    rows_identifiers = c("row_1", "row_2", "row_3",
                                         "row_4", "row_5"),
                    cols = c("27", "36", "25", "6"),
                    cols_identifiers = c("col_1", "col_2",
                                         "col_3", "col_4"),
                    answers_identifiers = c("row_1 col_2", "row_2 col_1",
                                            "row_3 col_3", "row_4 col_4",
                                            "row_5 col_2"),
                    answers_scores = c(0.5, 1, 1, 1, 1))
    expect_equal(sut1, expected)
    expect_equal(sut2, expected)
})

test_that("Testing create_question_object() for  MultipleChoiceTable task", {
    path <- test_path("file/md/test_MultipleChoiceTable_example.md")
    sut <- create_question_object(path)
    expected <- new("MultipleChoiceTable",
                    content = list(paste0("<p>Choose the correct order in ",
                                          "the multiplication table</p>")),
                    identifier = "test_MultipleChoiceTable_example",
                    rows = c("4*7-1 =", "3*9 =", "5*5 =", "2*3 =", "12*3 ="),
                    rows_identifiers = c("row_1", "row_2", "row_3","row_4",
                                         "row_5"),
                    cols = c("27", "36", "25", "6", "72/2"),
                    cols_identifiers = c("col_1", "col_2", "col_3",
                                         "col_4", "col_5"),
                    answers_identifiers =c("row_1 col_1", "row_2 col_1",
                    "row_3 col_3", "row_4 col_4", "row_5 col_2", "row_5 col_5"),
                    answers_scores = c(1, 1, 1, 1, 1, 1))
    expect_equal(sut, expected)
})

test_that("Testing create_question_object() for TextGap
          (yaml and primitive) tasks", {
    path <- test_path("file/rmd/test_entry_Gap_primitive.Rmd")
    sut <- suppressMessages(create_question_object(path))

    content <- paste0("<p><strong>Diese Aufgabe dient zum Testen ",
                           "verschiedener Möglichkeiten zum Erstellen von ",
                           "Lücken</strong></p><p>Hast du ")
    expected <- suppressMessages(new("Entry",
           identifier = "test_entry_example",
           title = "test_entry_example",
           content = list(content,
                     new("TextGap",
                          response_identifier = "response_1",
                          solution = c("ein","EIN", "Ein"),
                          expected_length = 2,
                          case_sensitive = TRUE),
                     ' Handy? Dieses Telefonmodell ist Nokia ',
                     new("NumericGap",
                          response_identifier = "response_2",
                          expected_length = 3,
                          solution = 3310),
                     '. Hast du ',
                     new("TextGap",
                          response_identifier = "response_3",
                          expected_length = 2,
                          solution = "ein"),
                     paste0(" Computer? Der beliebteste Prozessor ",
                          "im ersten Quartal 2023 ist der Core i"),
                     new("NumericGap",
                          response_identifier = "response_4",
                          expected_length = 1,
                          solution = 5),
                     paste0(".</p><p>neue numerische Lücke, die mit ",
                                 "der Funktion gebaut würde "),
                     new("NumericGap",
                         response_identifier = "response_5",
                         solution = 8,
                         placeholder = "die richtige Antwort ist 8",
                         tolerance_type = "relative",
                         expected_length = 1,
                         tolerance = 10,
                         include_lower_bound = FALSE),
                         paste0("</p><p>eine texte Lücke, die mit der ",
                                "Funktion gebaut würde "),
                      new("TextGap",
                         response_identifier = "response_6",
                         solution = c("answer0", "answer1", "answer2"),
                         score = 3,
                         placeholder = "put answer here",
                         expected_length = 6,
                         case_sensitive = FALSE),
                         paste0("</p><p>eine texte Lücke <strong>für ",
                                "opal</strong>, die mit der Funktion ",
                                "gebaut würde "),
                     new("TextGapOpal",
                         response_identifier = "response_7",
                         solution = c("answer000", "answer111", "answer222"),
                         score = 3,
                         expected_length = 8,
                         placeholder = "opal allows some tolerance rate",
                         case_sensitive = FALSE,
                         tolerance = 2),'</p>'),
                    feedback = list(new("ModalFeedback",
                                content = list("<p>general feedback</p>")))))
    expect_equal(sut, expected)
})

test_that("Testing create_question_object() for InlineChoice
          (yaml and primitive) tasks", {
    path <- test_path("file/rmd/test_entry_Gap_InlineChoice.Rmd")
    sut <- suppressMessages(create_question_object(path))
    expected <- suppressMessages(new("Entry",
                    identifier = "test_entry_example",
                    title = "test_entry_example",
                    content = list('<p>Das beliebteste Telefon der Welt ist ',
                                   new("InlineChoice",
                                       solution = c("Realme 9 Pro",
                                                    "Realme GT Master Edition",
                                                    "Samsung Galaxy A52"),
                                       expected_length = 11,
                                       response_identifier = "response_1"),
                                       paste0(". Das meistverkaufte ",
                                       "Telefonmodell in Deutschland ist "),
                                   new("InlineChoice",
                                       solution = c("Apple iPhone 13 Pro",
                                                    "Apple iPhone 13 Pro Max",
                                                    "Apple iPhone 13"),
                                       expected_length = 14,
                                       response_identifier = "response_2",
                                       answer_index = 3),
                                       paste0(".</p><p>In welchem Jahr ",
                                              "begann das iPhone auf dem ",
                                              "europäischen Markt zu ",
                                              "verkaufen?"),
                                   new("InlineChoice",
                                       response_identifier = "response_3",
                                       solution = c(2007, 2008),
                                       expected_length = 3),
                                   '</p>'),
                    feedback = list(new("WrongFeedback",
                                    content = list("<p>wrong feedback</p>")),
                                     new("CorrectFeedback",
                                      content = list("<p>correct feedback</p>"))
                                       )
                    ))
    expect_equal(sut, expected)
})

test_that("Testing create_question_object() for MultipleChoice class
          without points", {
    path <- test_path("file/rmd/test_mc_no_point.Rmd")
    sut <- create_question_object(path)
    expected <- new("MultipleChoice",
                    content = list(paste0("<p>When deciding between ",
                                          "renovating a water treatment plant ",
                                          "or building a new community pool, ",
                                          "what is the government most likely ",
                                          "to consider?</p>")),
                    identifier = "test 2",
                    points = c(0.5, 0.5, 0, 0),
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

    expect_equal(sut@points, expected@points)
})

test_that("Testing the Order task, points are awarded for each correct answer.",
          {
    path <- test_path("file/rmd/test_order.Rmd")
    suppressMessages(rmd2xml(path, path = test_path()))
    xml_file_sut <- xml2::read_xml(test_path("test_order.xml"))

    xml_file_expected <- xml2::read_xml(test_path("file/test_order_opal.xml"))

# Strip namespaces from the XML files
    xml_file_sut <- xml_ns_strip(xml_file_sut)
    xml_file_expected <- xml_ns_strip(xml_file_expected)

# Find the 'match' and 'baseValue' tags
    match_sut <- xml_find_all(xml_file_sut, ".//match")
    bv_sut <- xml_find_all(xml_file_sut, ".//baseValue")
    list_bv_sut <- sum(as.numeric(xml2::xml_text(bv_sut)))

    match_expected <- xml_find_all(xml_file_expected, ".//match")
    bv_expected <- xml_find_all(xml_file_sut, ".//baseValue")
    list_bv_expected <- sum(as.numeric(xml2::xml_text(bv_expected)))

# Copy the contents to the 'sut' and 'expected' variables
    sut <- as.character(match_sut)
    expected <- as.character(match_expected)

    expect_equal(sut, expected)
    expect_equal(list_bv_sut, list_bv_expected )
    unlink(test_path("test_order.xml"))
})
