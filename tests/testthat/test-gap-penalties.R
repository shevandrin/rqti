test_that("numeric and text gap penalties distinguish incorrect answers from omissions", {
    gaps <- list(numericGap(12, response_identifier = "answer", points = 2,
                           tolerance = 0.25, incorrect = -0.5),
                 textGap(c("lm", "linear model"), response_identifier = "answer",
                         points = 2, case_sensitive = TRUE, incorrect = -0.5))
    candidates <- list(list(NULL, 11, 11.75, 12, 12.25, 12.251),
                       list(NULL, "", " \t\n", "lm", "linear model", "LM"))
    expected <- list(c(0, -0.5, 2, 2, 2, -0.5), c(0, 0, 0, 2, 2, -0.5))
    for (i in seq_along(gaps)) {
        item <- entry(identifier = paste0("penalty", i), content = list("Answer: ", gaps[[i]]))
        doc <- scoring_item_xml(item)
        for (j in seq_along(candidates[[i]])) {
            expect_equal(score_choice_qti(doc, responses = list(answer = candidates[[i]][[j]])),
                         expected[[i]][j])
        }
        # Processing a new omitted response must clear a prior awarded score.
        expect_equal(score_choice_qti(doc, manual_scores = list(SCORE_answer = 2)), 0)
        expect_equal(as.numeric(xml2::xml_text(xml2::xml_find_first(doc,
            "//outcomeDeclaration[@identifier='MINSCORE']/defaultValue/value"))), -0.5)
        expect_true(verify_qti(item, print = FALSE, engine = "xml2")$valid)
    }
})

test_that("entry aggregation keeps negative gap scores even with feedback", {
    item <- entry(identifier = "two_gaps", content = list(
        numericGap(2, response_identifier = "a", points = 2, incorrect = -1),
        textGap("yes", response_identifier = "b", points = 3, incorrect = -0.5)),
        feedback = list(modalFeedback(content = list("Explanation"))))
    doc <- scoring_item_xml(item)
    expect_equal(score_choice_qti(doc, responses = list(a = 0, b = "wrong")), -1.5)
    expect_equal(score_choice_qti(doc, responses = list(a = 2, b = "wrong")), 1.5)
    expect_true(verify_qti(item, print = FALSE, engine = "xml2")$valid)
    for (bad in list(NA_real_, Inf, -Inf, 1, numeric(), c(-1, -2))) {
        expect_error(numericGap(2, incorrect = bad), "incorrect")
        expect_error(textGap("yes", incorrect = bad), "incorrect")
    }
})

test_that("Rmd gap helpers preserve incorrect scores", {
    skip_if_not(rmarkdown::pandoc_available(), "Pandoc is required")
    path <- tempfile(fileext = ".Rmd")
    on.exit(unlink(path))
    writeLines(c("---", "type: gap", "---", "", "```{r, include=FALSE}",
        "library(rqti)", "```", "", "# question", "",
        'Number: `r rqti::gap_numeric(2, incorrect = -0.5)`', "",
        'Text: `r rqti::gap_text("yes", incorrect = -0.25)`'), path)
    item <- create_question_object(path)
    gaps <- Filter(function(x) is(x, "Gap"), item@content)
    expect_equal(vapply(gaps, function(x) x@incorrect, numeric(1)), c(-0.5, -0.25))
    expect_true(verify_qti(item, print = FALSE, engine = "xml2")$valid)
})
