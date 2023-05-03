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
                  choices = c("Data collection", "Data cleansing",
                              "Data marking", "Verification and visualization"),
                  choices_identifiers = c("1", "2", "3", "4"),
                  points = 1
    )
    exam_section <- new("AssessmentSection",
        identifier = "sec_id",
        title = "section",
        assessment_item = list(mc1, sc2, mc3, order1)
    )
    exam <- new("AssessmentTestOpal",
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
                  choices = c("Data collection", "Data cleansing",
                              "Data marking", "Verification and visualization"),
                  choices_identifiers = c("1", "2", "3", "4"),
                  points = 1
    )
    exam_section <- new("AssessmentSection",
                        identifier = "sec_id",
                        title = "section",
                        assessment_item = list(mc1, sc2, mc3, order1)
    )
    exam <- new("AssessmentTest",
                identifier = "id_test",
                title = "some title",
                section = list(exam_section))

    example <- "<additionalTag>
    <assessmentSection identifier=\"sec_id\" fixed=\"false\" title=\"section\" visible=\"true\">\n <assessmentItemRef identifier=\"q1\" href=\"q1.xml\"/>\n
    <assessmentItemRef identifier=\"q2\" href=\"q2.xml\"/>\n
    <assessmentItemRef identifier=\"q3\" href=\"q3.xml\"/>\n
    <assessmentItemRef identifier=\"q4\" href=\"q4.xml\"/>\n
    </assessmentSection>
    </additionalTag>"

     expected <- toString(htmltools::tag(
         "additionalTag", list(suppressMessages(buildAssessmentSection(exam_section,
                                                      folder = "todelete")))))

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
    suppressMessages(createQtiTask(sc, "todelete", "TRUE"))

    expected <- toString(buildAssessmentSection(object = "new.xml",
                                                folder = "todelete"))

    example <- "<assessmentItemRef identifier =\"new\" href=\"new.xml\"></assessmentItemRef>"

    xml1 <- xml2::read_xml(expected)
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
    unlink("todelete", recursive = TRUE)
    unlink("new.xml", recursive = TRUE)
})
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
                  choices = c("Data collection", "Data cleansing",
                              "Data marking", "Verification and visualization"),
                  choices_identifiers = c("1", "2", "3", "4"),
                  points = 1
    )
    exam_section <- new("AssessmentSection",
                        identifier = "sec_id",
                        title = "section",
                        assessment_item = list(mc1, sc2, mc3, order1)
    )
    exam <- new("AssessmentTestOpal",
                identifier = "id_test",
                title = "some title",
                section = list(exam_section))
    expected<-toString(getAssessmentItems(exam_section))
    example <- "q1.xml, q2.xml, q3.xml, q4.xml"
    expect_equal(expected, example)
})
# test_that("Testing AssessmentSection class for uploading files with tasks", {
#     # Creating xml files with use classes
#     mc <- new("MultipleChoice",
#                identifier = "q1", prompt = "What does 3/4 + 1/4 = ?",
#                title = "MultipleChoice",
#                choices = c("1", "4/8", "8/4", "4/4"),
#                choice_identifiers = c("1", "2", "3", "4"),
#                points = c(1, 0, 0, 1)
#     )
#     TextGapOpal <- new("Entry",
#                        identifier = "q2",
#                        points = 3,
#                        title = "TextGapOpal",
#                        content = list('The speed of light is',
#                                       new("TextGapOpal",
#                                           response_identifier = "RESPONSE_1",
#                                           score = 1,
#                                           response = "more",
#                                           alternatives = c("MORE", "More"),
#                                           value_precision = 2),
#                                       'than the speed of sound')
#     )
#     DirectedPair <- new("DirectedPair",
#                         content = list("<p>\"Directed pairs\" task</p>"),
#                         identifier = "q3",
#                         title = "Directed pairs",
#                         rows = c("12*4 =", "100/50 =", "25*2 ="),
#                         rows_identifiers = c("a", "b", "c"),
#                         cols = c("48", "2", "50"),
#                         cols_identifiers = c("k", "l", "m"),
#                         answers_identifiers = c("a k", "b l", 'c m'),
#                         points = 5
#     )
#     order <- new("Order",
#                  identifier = "q4",
#                  title = "Order",
#                  prompt = "Choose the correct order",
#                  choices = c("Data collection", "Data cleansing", "Data marking", "Verification and visualization"),
#                  choices_identifiers = c("1", "2", "3", "4"),
#                  points = 1
#     )
#
#     exam_section <- new("AssessmentSection",
#                         identifier = "sec_id",
#                         title = "section",
#                         assessment_item = list(mc, order, DirectedPair, TextGapOpal)
#     )
#     exam <- new("AssessmentTestOpal",
#                 identifier = "id_test",
#                 title = "Mock test",
#                 section = list(exam_section))
#     createQtiTest(exam, "exam_folder", "TRUE")
#
#     # Reading of tasks from xml files
#     path1 <- test_path("file/test_create_qti_task_MultipleChoice.xml")
#     path2 <- test_path("file/test_create_qti_task_TextGapOpal.xml")
#     path3 <- test_path("file/test_create_qti_task_DirectedPair.xml")
#     path4 <- test_path("file/test_create_qti_task_Order.xml")
#
#     example_exam_section <- new("AssessmentSection",
#                                identifier = "sec_id",
#                                title = "section",
#                                assessment_item = list(path1, path2, path3, path4))
#
#     example_exam <- new("AssessmentTestOpal",
#                 identifier = "id_test",
#                 title = "Mock test",
#                 section = list(example_exam_section))
#     createQtiTest(example_exam, "exam_folder2", "TRUE")
#
#     # Need to change the block below!
#     xml1 <- xml2::read_xml(expected)
#     xml2 <- xml2::read_xml(example)
#     expect_equal(expected, example)
# })
