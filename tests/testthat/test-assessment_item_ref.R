test_that("Testing method buildAssessmentSection() for AssessmentItemRef class", {
    sut <- AssessmentItemRef (identifier = "ID_1",
                              href = "test_create_qti_task_SingleChoice.xml"
    )
    example <-"
    <assessmentItemRef identifier=\"ID_1\" href=\"test_create_qti_task_SingleChoice.xml\"></assessmentItemRef>"
    xml1 <- xml2::read_xml(toString(buildAssessmentSection(sut)))
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
})
test_that("Testing method getAssessmentItems() for AssessmentItemRef class", {
    sut <- AssessmentItemRef (identifier = "ID_1",
                              href = "test_create_qti_task_SingleChoice.xml"
    )
    a <- toString(getAssessmentItems(sut))

    example <- "test_create_qti_task_SingleChoice.xml"
    extended <- toString(getAssessmentItems(sut))
    expect_equal(example, extended)
})
