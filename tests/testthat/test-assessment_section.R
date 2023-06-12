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
test_that("Testing AssessmentTestOpal class: create tasks with upload files xml", {
    mc <- new("MultipleChoice",
               identifier = "test_create_qti_task_MultipleChoice",
               prompt = "What does 3/4 + 1/4 = ?",
               title = "MultipleChoice",
               choices = c("1", "4/8", "8/4", "4/4"),
               choice_identifiers = c("a1", "a2", "a3", "a4"),
               points = c(1, 0, 0, 1)
    )
    TextGapOpal <- new("Entry",
                       identifier = "test_create_qti_task_TextGapOpal",
                       points = 3,
                       title = "TextGapOpal",
                       content = list('<p>The speed of light is',
                                      new("TextGapOpal",
                                          response_identifier = "RESPONSE_1",
                                          score = 1,
                                          response = "more",
                                          alternatives = c("MORE", "More"),
                                          value_precision = 2),
                                      'than the speed of sound</p>')
    )
    DirectedPair <- new("DirectedPair",
                        content = list("<p>\"Directed pairs\" task</p>"),
                        identifier = "test_create_qti_task_DirectedPair",
                        title = "Directed pairs",
                        rows = c("12*4 =", "100/50 =", "25*2 ="),
                        rows_identifiers = c("a", "b", "c"),
                        cols = c("48", "2", "50"),
                        cols_identifiers = c("k", "l", "m"),
                        answers_identifiers = c("a k", "b l", 'c m'),
                        points = 5
    )
    order <- new("Order",
                 identifier = "test_create_qti_task_Order",
                 title = "Order",
                 prompt = "Choose the correct order",
                 choices = c("Data collection", "Data cleansing", "Data marking", "Verification and visualization"),
                 choices_identifiers = c("1", "2", "3", "4"),
                 points = 1
    )

    exam_section <- new("AssessmentSection",
                        identifier = "sec_id",
                        title = "section",
                        assessment_item = list(mc, order, DirectedPair, TextGapOpal)
    )
    exam <- new("AssessmentTestOpal",
                identifier = "id_test",
                title = "Mock test",
                section = list(exam_section))
    suppressMessages(createQtiTest(exam, "exam_folder", "TRUE"))

    # Reading of tasks from xml files
    path1 <- test_path("file/test_create_qti_task_MultipleChoice.xml")
    path2 <- test_path("file/test_create_qti_task_Order.xml")
    path3 <- test_path("file/test_create_qti_task_DirectedPair.xml")
    path4 <- test_path("file/test_create_qti_task_TextGapOpal.xml")

    example_exam_section <- new("AssessmentSection",
                               identifier = "sec_id",
                               title = "section",
                               assessment_item = list(path1, path2, path3, path4))

    example_exam <- new("AssessmentTestOpal",
                identifier = "id_test",
                title = "Mock test",
                section = list(example_exam_section))
    suppressMessages(createQtiTest(example_exam, "exam_folder3", "TRUE"))

    # get list content zip files and compare them
    zip_example <- list.files(path = "exam_folder", pattern = ".zip", full.names = TRUE)
    zip_expected <- list.files(path = "exam_folder3", pattern = ".zip", full.names = TRUE)

    list_example <- utils::unzip(zip_example, list = TRUE)
    list_expected <- utils::unzip(zip_expected, list = TRUE)

    ls <- list_example$Name %in% list_expected$Name

    expect_equal(all(ls), TRUE)

    unlink(file.path(getwd(),"exam_folder"), recursive = TRUE)
    unlink(file.path(getwd(),"exam_folder3"), recursive = TRUE)
})
test_that("Testing buildAssessmentSection() that returns a warning for an invalid XML file", {
    temp_folder <- tempdir()

    invalid_xml <- tempfile(tmpdir = temp_folder, fileext = ".xml")
    cat("<invalid></invalid>", file = invalid_xml)

    expect_warning(buildAssessmentSection(invalid_xml, temp_folder),"is not valid")
})
test_that("Testing buildAssessmentSection() that returns a warning for incorrect file or path", {
    expect_warning(
        buildAssessmentSection("nonexistent.xml", "nonexistent_folder"),
        "is not correct. This file will be omitted in test"
    )
})
