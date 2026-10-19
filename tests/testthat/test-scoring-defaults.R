test_that("ordinary multiple-choice defaults equal floored Youden scores", {
    solution <- c(TRUE, TRUE, FALSE, FALSE, FALSE)
    answers <- as.matrix(expand.grid(rep(list(c(FALSE, TRUE)), 5)))
    for (scheme in list("standard", multiple_choice_scoring())) {
        item <- multipleChoice(choices = letters[1:5],
            points = c(1, 1, 0, 0, 0), scoring_scheme = scheme)
        doc <- scoring_item_xml(item)
        for (i in seq_len(nrow(answers))) {
            answer <- answers[i, ]
            sensitivity <- mean(answer[solution])
            specificity <- mean(!answer[!solution])
            expect_equal(score_choice_qti(doc, item@choice_identifiers[answer]),
                2 * max(0, sensitivity + specificity - 1))
        }
    }
    custom <- multipleChoice(choices = letters[1:4],
        points = c(0.5, 0.5, -0.2, -0.2))
    expect_equal(score_choice_qti(scoring_item_xml(custom), "ChoiceC"), 0)
    expect_equal(score_choice_qti(scoring_item_xml(custom),
        custom@choice_identifiers), 0.6)
})

test_that("single-choice exams penalties follow the documented magnitude convention", {
    for (penalty in list(FALSE, TRUE, 0.25, -0.25)) {
        item <- singleChoice(choices = letters[1:3], points = 2,
            scoring_scheme = single_choice_scoring("exams", negative = penalty))
        doc <- scoring_item_xml(item)
        expected_wrong <- -2 * abs(as.numeric(penalty))
        expect_equal(score_choice_qti(doc, "ChoiceA"), 2)
        expect_equal(score_choice_qti(doc, "ChoiceB"), expected_wrong)
        expect_equal(score_choice_qti(doc), 0)
    }
})
