test_that("Testing method buildAssessmentSection() for AssessmentItemRef class",
          {
    sut <- AssessmentItemRef (identifier = "ID_1",
                              href = "test_create_qti_task_SingleChoice.xml"
    )
    example <-"
    <assessmentItemRef identifier=\"ID_1\" href=\"test_create_qti_task_SingleChoice.xml\"></assessmentItemRef>"
    sut <- xml2::read_xml(toString(buildAssessmentSection(sut)))
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)
})

test_that("Testing method getAssessmentItems() for AssessmentItemRef class", {
    sut <- AssessmentItemRef (identifier = "ID_1",
                              href = "test_create_qti_task_SingleChoice.xml")

    expected <- "test_create_qti_task_SingleChoice.xml"
    sut <- toString(getAssessmentItems(sut))
    expect_equal(sut, expected)
})
