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

# MultipleChoice
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
                   orientation = "vertical",
                   lower_bound = 0,
                   default_value = 0

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
