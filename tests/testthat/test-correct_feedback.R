test_that("Testing CorrectFeedback class", {
    sut <- new("CorrectFeedback", outcome_identifier = "FEEDBACKMODAL",
               show = logical(),
               identifier = "Feedback1397975231",
               title = "Feedback correctly name",
               content = list("<p>Text Feedback correctly</p>")
    )
    example <- new("CorrectFeedback",
                   outcome_identifier = "FEEDBACKMODAL",
                   show = logical(),
                   identifier = "Feedback1397975231",
                   title = "Feedback correctly name",
                   content = list("<p>Text Feedback correctly</p>")
                   )

    expect_equal(sut, example)
})
test_that("Testing construction function for CorrectFeedback class", {
    sut <- CorrectFeedback(outcome_identifier = "FEEDBACKMODAL",
                         show = FALSE,
                         identifier = "Feedback1905544311",
                         title = "Feedback correctly name",
                         content = list("<p>Text Feedback correctly</p>")
    )
    example <- CorrectFeedback(outcome_identifier = "FEEDBACKMODAL",
                             show = FALSE,
                             identifier = "Feedback1905544311",
                             title = "Feedback correctly name",
                             content = list("<p>Text Feedback correctly</p>")
    )
    expect_equal(sut, example)
})
test_that("Testing method createModalFeedback() for WrongFeedback class", {
    sut <- new ("ModalFeedback",outcome_identifier = "FEEDBACKMODAL",
                show = TRUE,
                identifier = "correct",
                title = "Feedback wrong name",
                content = list("<p>Text Feedback wrong</p>")
    )
    example <-"
<modalFeedback identifier=\"correct\" outcomeIdentifier=\"FEEDBACKMODAL\" showHide=\"show\" title=\"Feedback wrong name\">
		<p>Text Feedback wrong</p>
</modalFeedback>"
    xml1 <- xml2::read_xml(toString(createModalFeedback(sut)))
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
})

