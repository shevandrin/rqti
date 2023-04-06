test_that("Testing WrongFeedback class", {
    sut <- new("WrongFeedback", outcome_identifier = "FEEDBACKMODAL",
                           show = FALSE,
                           identifier = "Feedback1905544310",
                           title = "Feedback wrong name",
                           content = list("<p>Text Feedback wrong</p>")
    )
    example <- new("WrongFeedback",
                   outcome_identifier = "FEEDBACKMODAL",
                   show = FALSE,
                   identifier = "Feedback1905544310",
                   title = "Feedback wrong name",
                   content = list("<p>Text Feedback wrong</p>")
    )

    expect_equal(sut, example)
})
test_that("Testing construction function for WrongFeedback class", {
    sut <- WrongFeedback(outcome_identifier = "FEEDBACKMODAL",
               show = FALSE,
               identifier = "Feedback1905544310",
               title = "Feedback wrong name",
               content = list("<p>Text Feedback wrong</p>")
    )
    example <- WrongFeedback(outcome_identifier = "FEEDBACKMODAL",
                   show = FALSE,
                   identifier = "Feedback1905544310",
                   title = "Feedback wrong name",
                   content = list("<p>Text Feedback wrong</p>")
    )
    expect_equal(sut, example)
})
test_that("Testing method createModalFeedback() for WrongFeedback class", {
    sut <- new ("ModalFeedback",outcome_identifier = "FEEDBACKMODAL",
                show = TRUE,
                identifier = "incorrect",
                title = "Feedback wrong name",
                content = list("<p>Text Feedback wrong</p>")
    )
    example <-"
<modalFeedback identifier=\"incorrect\" outcomeIdentifier=\"FEEDBACKMODAL\" showHide=\"show\" title=\"Feedback wrong name\">
		<p>Text Feedback wrong</p>
</modalFeedback>"
    xml1 <- xml2::read_xml(toString(createModalFeedback(sut)))
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
})
