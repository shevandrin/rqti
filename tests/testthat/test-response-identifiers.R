test_that("custom choice response identifiers reach declarations, scoring and feedback", {
    factories <- list(
        function(id) singleChoice(choices = letters[1:3], response_identifier = id),
        function(id) singleChoice(choices = letters[1:3], response_identifier = id,
            scoring_scheme = "penalty"),
        function(id) singleChoice(choices = letters[1:3], response_identifier = id,
            scoring_scheme = single_choice_scoring(incorrect = -0.25, omitted = 0.1)),
        function(id) singleChoice(choices = letters[1:3], response_identifier = id,
            scoring_scheme = "kanzow_04"),
        function(id) multipleChoice(choices = letters[1:3], points = c(1, 0, 1),
            response_identifier = id),
        function(id) multipleChoice(choices = letters[1:3], points = c(1, 0, 1),
            response_identifier = id, scoring_scheme = multiple_choice_scoring("exams", negative = 0.25))
    )
    factories <- c(factories, lapply(c("all_or_nothing", "subset", "ripkey", "true_false", "weights"), function(method) {
        force(method)
        function(id) multipleChoice(choices = letters[1:3], points = c(1, 0, 1),
            response_identifier = id, scoring_scheme = method)
    }))
    for (factory in factories) {
        baseline <- factory("RESPONSE")
        item <- factory("answer_1")
        baseline@feedback <- item@feedback <- list(correctFeedback("Correct"), wrongFeedback("Wrong"))
        old <- scoring_item_xml(baseline)
        doc <- scoring_item_xml(item)
        expect_identical(xml2::xml_attr(xml2::xml_find_first(doc, "//responseDeclaration"), "identifier"), "answer_1")
        expect_identical(xml2::xml_attr(xml2::xml_find_first(doc, "//choiceInteraction"), "responseIdentifier"), "answer_1")
        expect_length(xml2::xml_find_all(doc, "//*[@identifier='RESPONSE']"), 0L)
        answers <- if (is(item, "SingleChoice")) list(NULL, "ChoiceA", "ChoiceB") else {
            list(NULL, character(), "ChoiceA", "ChoiceB", c("ChoiceA", "ChoiceC"))
        }
        for (answer in answers) {
            expected <- score_choice_qti(old, answer, outcomes = TRUE)
            actual <- score_choice_qti(doc, response = "ChoiceB",
                responses = list(answer_1 = answer), outcomes = TRUE)
            expect_equal(actual$SCORE, expected$SCORE)
            expect_identical(actual$FEEDBACKBASIC, expected$FEEDBACKBASIC)
            expect_equal(actual$FEEDBACKMODAL, expected$FEEDBACKMODAL)
        }
        expect_true(verify_qti(item, print = FALSE, engine = "xml2")$valid)
    }
})

test_that("essay and direct S4/YAML construction accept response identifiers", {
    item <- essay(response_identifier = "essay_answer", content = "<p>Explain.</p>")
    doc <- scoring_item_xml(item)
    expect_identical(xml2::xml_attr(xml2::xml_find_first(doc, "//extendedTextInteraction"), "responseIdentifier"), "essay_answer")
    expect_identical(xml2::xml_attr(xml2::xml_find_first(doc, "//responseDeclaration"), "identifier"), "essay_answer")
    expect_true(verify_qti(item, print = FALSE, engine = "xml2")$valid)
    item <- new("SingleChoice", choices = letters[1:3], response_identifier = "direct_answer")
    expect_equal(score_choice_qti(scoring_item_xml(item), responses = list(direct_answer = "ChoiceA")), 1)
    path <- tempfile(fileext = ".Rmd")
    withr::defer(unlink(path))
    writeLines(c("---", "type: sc", "response_identifier: yaml_answer", "---", "",
        "# question", "", "Choose one.", "", "- A", "- B"), path)
    doc <- scoring_item_xml(create_question_object(path))
    expect_equal(score_choice_qti(doc, responses = list(yaml_answer = "ChoiceA")), 1)
})

test_that("choice and essay response identifiers reject invalid or conflicting names", {
    for (id in list("", NA_character_, character(), c("a", "b"), "two words", "1answer", "SCORE", "FEEDBACKMODAL")) {
        expect_error(singleChoice(choices = letters[1:3], response_identifier = id), "response_identifier")
        expect_error(multipleChoice(choices = letters[1:3], points = c(1, 0, 1), response_identifier = id), "response_identifier")
        expect_error(essay(response_identifier = id), "response_identifier")
    }
})
