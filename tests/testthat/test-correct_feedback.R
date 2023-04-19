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
test_that("Testing method createResponseCondition", {
    sut <- new ("ModalFeedback",outcome_identifier = "FEEDBACKMODAL",
                show = TRUE,
                identifier = "correct",
                title = "Feedback wrong name",
                content = list("<p>Text Feedback wrong</p>")
    )

    example <-"
<responseCondition>
  <responseIf>
    <and>
      <gte>
        <variable identifier=\"SCORE\"></variable>
        <baseValue baseType=\"float\">0</baseValue>
      </gte>
    </and>
    <setOutcomeValue identifier=\"FEEDBACKMODAL\">
      <multiple>
        <variable identifier=\"FEEDBACKMODAL\"></variable>
        <baseValue baseType=\"identifier\">correct</baseValue>
      </multiple>
    </setOutcomeValue>
  </responseIf>
</responseCondition>"

    xml1 <- xml2::read_xml(toString(createResponseCondition(sut)))
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
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
test_that("Testing method createResponseCondition() for CorrectFeedback class", {
    sut <- CorrectFeedback(outcome_identifier = "FEEDBACKMODAL",
                         show = FALSE,
                         title = "Feedback wrong name",
                         content = list("<p>Text Feedback wrong</p>")
    )

    example <-"<additionalTag>
<responseCondition>
  <responseIf>
    <and>
      <match>
        <baseValue baseType=\"identifier\">correct</baseValue>
        <variable identifier=\"FEEDBACKBASIC\"></variable>
      </match>
    </and>
    <setOutcomeValue identifier=\"FEEDBACKMODAL\">
      <multiple>
        <variable identifier=\"FEEDBACKMODAL\"></variable>
        <baseValue baseType=\"identifier\">correct</baseValue>
      </multiple>
    </setOutcomeValue>
  </responseIf>
</responseCondition>
    </additionalTag>"

    expected <- toString(htmltools::tag("additionalTag",
                                        list(createResponseCondition(sut))))

    xml1 <- xml2::read_xml(expected)
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
})

