test_that("Testing method getAssessmentItems() for AssessmentSection class", {
    mc1 <- new("MultipleChoice",
               identifier = "q1", prompt = "What does 3/4 + 1/4 = ?",
               title = "MultipleChoice",
               choices = c("1", "4/8", "8/4", "4/4"),
               choice_identifiers = c("1", "2", "3", "4"),
               points = c(1, 0, 0, 1))
    sc2 <- new("SingleChoice",
               prompt = "What is the percentage of 3/20?",
               title = "SingleChoice",
               choices = c("15%", "20%", "30%"),
               choice_identifiers = "1",
               identifier = "q2")
    mc3 <- new("MultipleChoice",
               identifier = "q3",
               prompt = "3 + 4b = 15. What is the value of b in this equation?",
               title = "MultipleChoice",
               choices = c("3", "2", "5", "6/2"),
               choice_identifiers = c("1", "2", "3", "4"),
               points = c(1, 0, 0, 1)
    )
    order1 <- new("Order",
                  identifier = "q4",
                  title = "Order",
                  prompt = "Choose the correct order",
                  choices = c("Data collection", "Data cleansing", "Data marking", "Verification and visualization"),
                  choices_identifiers = c("1", "2", "3", "4"),
                  points = 1
    )
    exam_section <- AssessmentSection(
        identifier = "sec_id",
        title = "section",
        assessment_item = list(mc1, sc2, mc3, order1)
    )
    exam <- AssessmentTestOpal(
        identifier = "id_test",
        title = "some title",
        section = list(exam_section))
    expected<-toString(getAssessmentItems(exam_section))
    example <- "q1.xml, q2.xml, q3.xml, q4.xml"
    expect_equal(expected, example)
})
test_that("Testing method buildAssessmentSection() for AssessmentSection class", {
    mc1 <- new("MultipleChoice",
               identifier = "q1", prompt = "What does 3/4 + 1/4 = ?",
               title = "MultipleChoice",
               choices = c("1", "4/8", "8/4", "4/4"),
               choice_identifiers = c("1", "2", "3", "4"),
               points = c(1, 0, 0, 1))
    sc2 <- new("SingleChoice",
               prompt = "What is the percentage of 3/20?",
               title = "SingleChoice",
               choices = c("15%", "20%", "30%"),
               choice_identifiers = "1",
               identifier = "q2")
    mc3 <- new("MultipleChoice",
               identifier = "q3",
               prompt = "3 + 4b = 15. What is the value of b in this equation?",
               title = "MultipleChoice",
               choices = c("3", "2", "5", "6/2"),
               choice_identifiers = c("1", "2", "3", "4"),
               points = c(1, 0, 0, 1)
    )
    order1 <- new("Order",
                  identifier = "q4",
                  title = "Order",
                  prompt = "Choose the correct order",
                  choices = c("Data collection", "Data cleansing", "Data marking", "Verification and visualization"),
                  choices_identifiers = c("1", "2", "3", "4"),
                  points = 1
    )
    exam_section <- new("AssessmentSection",
                        identifier = "sec_id",
                        title = "section",
                        assessment_item = list(mc1, sc2, mc3, order1)
    )
    exam <- AssessmentTest(
                identifier = "id_test",
                title = "some title",
                section = list(exam_section))

    example <- "<additionalTag>
    <assessmentSection identifier=\"sec_id\" fixed=\"false\" title=\"section\" visible=\"true\">\n <assessmentItemRef identifier=\"q1\"    href=\"q1.xml\"/>\n
    <assessmentItemRef identifier=\"q2\" href=\"q2.xml\"/>\n
    <assessmentItemRef identifier=\"q3\" href=\"q3.xml\"/>\n
    <assessmentItemRef identifier=\"q4\" href=\"q4.xml\"/>\n
    </assessmentSection>
    </additionalTag>"
    expected <- toString(htmltools::tag("additionalTag", list(invisible(buildAssessmentSection(exam_section, folder = "todelete")))))

    xml1 <- xml2::read_xml(expected)
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
    unlink("todelete", recursive = TRUE)
})
test_that("Test of method buildAssessmentSection() when reading a file in AssessmentSection class", {
    sc <- new("SingleChoice",
              prompt = "What is the percentage of 3/20?",
              title = "SingleChoice",
              choices = c("15%", "20%", "30%"),
              choice_identifiers = "1",
              identifier = "new")
    suppressMessages(create_qti_task(sc, "todelete", "TRUE"))

    expected <- toString(buildAssessmentSection(object = "new.xml", folder = "todelete"))

    example <- "<assessmentItemRef identifier =\"new\" href=\"new.xml\"></assessmentItemRef>"

    xml1 <- xml2::read_xml(expected)
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
    unlink("todelete", recursive = TRUE)
})
