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

test_that("correctFeedback() accepts character content", {
    sut <- correctFeedback(content = "Some comments", title = "Feedback")

    expect_s4_class(sut, "CorrectFeedback")
    expect_type(sut@content, "list")
    expect_equal(sut@content, list("Some comments"))
})


test_that("full-credit feedback tolerates fractional-weight serialization roundoff", {
    item <- multipleChoice(choices = c("A", "B", "C", "D", "E"),
        points = c(1 / 3, 1 / 3, 1 / 3, -0.5, -0.5),
        feedback = list(correctFeedback("Correct"), wrongFeedback("Incorrect")))
    doc <- xml2::read_xml(as.character(createResponseProcessing(item)))
    tolerance <- xml2::xml_find_first(doc,
        ".//responseElseIf[setOutcomeValue[@identifier='FEEDBACKBASIC']]//equal")
    expect_equal(xml2::xml_attr(tolerance, "toleranceMode"), "relative")
    percent <- as.numeric(strsplit(xml2::xml_attr(tolerance, "tolerance"), " ")[[1]])
    # QTI relative tolerances are percentages. Catch the live OpenOlat case
    # while keeping genuine shortfalls (including fine custom weights) wrong.
    expect_true(1 - 0.999999999999999 < percent[1] / 100)
    expect_true(1 - 0.999999999 > percent[1] / 100)
    expect_true(1 - 2 / 3 > percent[1] / 100)
})
