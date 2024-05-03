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
    sut <- new("WrongFeedback", outcome_identifier = "FEEDBACKMODAL",
                         show = FALSE,
                         title = "Feedback wrong name",
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

test_that("Testing wrongFeedback function", {
    # Expected WrongFeedback object
    expected <- new("WrongFeedback", content = list("Some comments"),
                    title = "Feedback", show = TRUE)

    # Create WrongFeedback object using the wrongFeedback function
    sut <- wrongFeedback(content = list("Some comments"), title = "Feedback")

    # # Check if the object is of class WrongFeedback
    expect_s3_class(sut, "WrongFeedback")

    # Check if the parameters are set correctly
    expect_equal(slot(sut, "title"), "Feedback")
    expect_equal(slot(sut, "content"), list("Some comments"))
    expect_equal(slot(sut, "show"), TRUE)

    # Check if the created object matches the expected object
    expect_identical(sut, expected)
})

