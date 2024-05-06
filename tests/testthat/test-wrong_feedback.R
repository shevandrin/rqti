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
    sut <- xml2::read_xml(toString(createModalFeedback(sut)))
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)
})

test_that("Testing method createResponseCondition() for WrongFeedback class", {
    sut <- wrongFeedback(show = FALSE, title = "Feedback wrong name",
                         content = list("<p>Text Feedback wrong</p>")
    )

    example <-"<additionalTag>
<responseCondition>
  <responseIf>
    <and>
      <match>
        <baseValue baseType=\"identifier\">incorrect</baseValue>
        <variable identifier=\"FEEDBACKBASIC\"></variable>
      </match>
    </and>
    <setOutcomeValue identifier=\"FEEDBACKMODAL\">
      <multiple>
        <variable identifier=\"FEEDBACKMODAL\"></variable>
        <baseValue baseType=\"identifier\">incorrect</baseValue>
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
test_that("Testing the constructor for WrongFeedback class", {
    sut <- wrongFeedback(content = list("Some comments"), title = "Feedback")

    xml_sut_1 <- createModalFeedback(sut)
    xml_sut_2 <- createResponseCondition(sut)

    expect_no_error(xml2::read_xml(as.character(xml_sut_1)))
    expect_no_error(xml2::read_xml(as.character(xml_sut_2)))
    expect_s4_class(sut, "WrongFeedback")
})
test_that("Testing the constructor for ModalFeedback class", {
    sut <- modalFeedback(content = list("Model answer"), title = "Feedback")

    xml_sut_1 <- createModalFeedback(sut)
    xml_sut_2 <- createResponseCondition(sut)

    expect_no_error(xml2::read_xml(as.character(xml_sut_1)))
    expect_no_error(xml2::read_xml(as.character(xml_sut_2)))
    expect_s4_class(sut, "ModalFeedback")
})

