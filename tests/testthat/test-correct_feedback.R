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
    sut <- xml2::read_xml(toString(createModalFeedback(sut)))
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)
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

    sut <- xml2::read_xml(toString(createResponseCondition(sut)))
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)
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
    sut <- xml2::read_xml(toString(createModalFeedback(sut)))
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)
})

test_that("Testing method createResponseCondition() for CorrectFeedback class",
          {
    sut <- correctFeedback(show = FALSE, title = "Feedback wrong name",
                         content = list("<p>Text Feedback wrong</p>"))

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

    sut <- toString(htmltools::tag("additionalTag",
                                        list(createResponseCondition(sut))))

    sut <- xml2::read_xml(sut)
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)
})
test_that("Testing the constructor for CorrectFeedback class", {
    sut <- correctFeedback(content = list("Some comments"), title = "Feedback")

    xml_sut_1 <- createModalFeedback(sut)
    xml_sut_2 <- createResponseCondition(sut)

    expect_no_error(xml2::read_xml(as.character(xml_sut_1)))
    expect_no_error(xml2::read_xml(as.character(xml_sut_2)))
    expect_s4_class(sut, "CorrectFeedback")
})

