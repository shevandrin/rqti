test_that("score bounds expose scoring policy and gap penalties directly", {
    expect_equal(getScoreBounds(singleChoice(choices = letters[1:3], points = 2,
        scoring_scheme = "penalty")), c(minimum = -1, maximum = 2))
    expect_equal(getScoreBounds(singleChoice(choices = letters[1:5], points = 4,
        scoring_scheme = "kanzow_04")), c(minimum = 0, maximum = 1))
    expect_equal(getScoreBounds(multipleChoice(choices = letters[1:3], points = c(1.5, -2, 0.5),
        scoring_scheme = multiple_choice_scoring("weights", lower_bound = -0.5))),
        c(minimum = -1, maximum = 2))
    numeric <- numericGap(12, points = 2, incorrect = -0.5)
    text <- textGap("yes", points = 3, incorrect = -0.25)
    expect_equal(getScoreBounds(numeric), c(minimum = -0.5, maximum = 2))
    expect_equal(getScoreBounds(text), c(minimum = -0.25, maximum = 3))
    expect_equal(getScoreBounds(entry(content = list(numeric, " then ", text))),
        c(minimum = -0.75, maximum = 5))
    expect_equal(getScoreBounds(essay(points = 4)), c(minimum = 0, maximum = 4))
    expect_equal(getScoreBounds(numericGap(12, points = c(full = 2), incorrect = c(wrong = -0.5))),
        c(minimum = -0.5, maximum = 2))
    expect_equal(getScoreBounds(singleChoice(choices = letters[1:3], points = c(full = 2))),
        c(minimum = 0, maximum = 2))
})

test_that("declared QTI bounds agree with the public accessor", {
    items <- list(
        singleChoice(choices = letters[1:3], scoring_scheme = single_choice_scoring(incorrect = -0.3)),
        multipleChoice(choices = letters[1:3], points = c(1, 0, 1)),
        multipleChoice(choices = letters[1:3], points = c(1, 0, 1),
            scoring_scheme = multiple_choice_scoring("all_or_nothing", incorrect = -0.25)),
        entry(content = list(numericGap(12, incorrect = -0.5), textGap("yes"))),
        essay(points = 4))
    for (item in items) {
        doc <- scoring_item_xml(item)
        declared <- vapply(c("MINSCORE", "MAXSCORE"), function(id) {
            as.numeric(xml2::xml_text(xml2::xml_find_first(doc,
                paste0("//outcomeDeclaration[@identifier='", id, "']/defaultValue/value"))))
        }, numeric(1))
        expect_equal(unname(getScoreBounds(item)), unname(declared))
    }
})

test_that("score bound access does not serialize declarations", {
    item <- singleChoice(choices = letters[1:3], scoring_scheme = "penalty")
    local_mocked_bindings(createOutcomeDeclaration = function(...) stop("Unexpected XML generation"))
    expect_equal(getScoreBounds(item), c(minimum = -0.5, maximum = 1))
    expect_equal(getScoreBounds(numericGap(12, incorrect = -0.25)), c(minimum = -0.25, maximum = 1))
})
