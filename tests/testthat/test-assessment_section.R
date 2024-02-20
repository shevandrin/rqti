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

    sut<-toString(getAssessmentItems(exam_section))
    expected <- "q1.xml, q2.xml, q3.xml, q4.xml"
    expect_equal(sut, expected)
})

test_that("Testing method buildAssessmentSection() for AssessmentSection class",
          {
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
    <assessmentSection identifier=\"sec_id\" fixed=\"false\" title=\"section\" visible=\"true\">\n
    <itemSessionControl allowComment=\"true\"/>\n
    <assessmentItemRef identifier=\"q1\" href=\"q1.xml\"/>\n
    <assessmentItemRef identifier=\"q2\" href=\"q2.xml\"/>\n
    <assessmentItemRef identifier=\"q3\" href=\"q3.xml\"/>\n
    <assessmentItemRef identifier=\"q4\" href=\"q4.xml\"/>\n
    </assessmentSection>
    </additionalTag>"

     sut1 <- toString(htmltools::tag(
         "additionalTag",
         list(suppressMessages(buildAssessmentSection(exam_section,
                                                      folder = "todelete")))))

    sut <- xml2::read_xml(sut1)
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)
    unlink("todelete", recursive = TRUE)
})

test_that("Test of method buildAssessmentSection() when reading a file in AssessmentSection class", {
    sc <- new("SingleChoice",
              prompt = "What is the percentage of 3/20?",
              title = "SingleChoice",
              choices = c("15%", "20%", "30%"),
              choice_identifiers = "1",
              identifier = "new")
    suppressMessages(createQtiTask(sc, "todelete", FALSE))

    sut1 <- suppressMessages(toString(buildAssessmentSection(
        object = "todelete/new.xml", folder = "todelete")))

    example <- "<assessmentItemRef identifier =\"new\" href=\"new.xml\"></assessmentItemRef>"

    sut <- xml2::read_xml(sut1)
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)
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

    sut<-toString(getAssessmentItems(exam_section))
    expected <- "q1.xml, q2.xml, q3.xml, q4.xml"
    expect_equal(sut, expected)
})

test_that("Testing AssessmentTestOpal class: create tasks with upload
          files xml", {

    # Reading of tasks from xml files
    path1 <- test_path("file/test_create_qti_task_MultipleChoice.xml")
    path2 <- test_path("file/test_create_qti_task_Order.xml")

    example_exam_section <- new("AssessmentSection",
                               identifier = "sec_id",
                               title = "section",
                               assessment_item = list(path1, path2))
    example_exam <- new("AssessmentTestOpal",
                identifier = "id_test",
                title = "Mock test",
                section = list(example_exam_section))
    suppressWarnings(suppressMessages(createQtiTest(example_exam,
                                                    "test_exam_folder", FALSE)))
    # get list content zip files and compare them
    zip_sut <- list.files(path = "test_exam_folder", pattern = ".zip",
                              full.names = TRUE)

    list_sut <- zip::zip_list(zip_sut)$filename
    list_expected <- c("id_test.xml", "imsmanifest.xml",
                       "test_create_qti_task_MultipleChoice.xml",
                       "test_create_qti_task_Order.xml")

    ls <- list_expected %in% list_sut

    expect_equal(all(ls), TRUE)
    unlink(file.path(getwd(),"test_exam_folder"), recursive = TRUE)
})

test_that("Testing buildAssessmentSection() that returns a warning
          for an invalid XML file", {
    temp_folder <- tempdir()

    invalid_xml <- tempfile(tmpdir = temp_folder, fileext = ".xml")
    cat("<invalid></invalid>", file = invalid_xml)

    expect_warning(suppressMessages(buildAssessmentSection(
                                    invalid_xml, temp_folder, TRUE)),"is not valid")
})

test_that("Testing buildAssessmentSection() that returns a warning
          for incorrect file or path", {
    expect_warning(
        buildAssessmentSection("nonexistent.xml", "nonexistent_folder"),
        "is not correct. This file will be omitted in test"
    )
})

test_that("Testing values of slot prompt and slot identifier
          in AssessmentItem class", {
mc <- new("MultipleChoice",
           prompt = as.character(NA))

sc <- new("SingleChoice")

# Check the values of prompt and identifier for MultipleChoice
expect_equal(mc@prompt, "")
expect_true(!is.na(mc@identifier) && nchar(mc@identifier) > 0)

# Check the values of prompt and identifier for SingleChoice
expect_equal(sc@prompt, "")
expect_equal(sc@title, sc@identifier)
expect_true(!is.na(sc@identifier) && nchar(sc@identifier) > 0)
})

test_that("Testing of type of calculators in yaml section of Rmd file", {

    # Reading of tasks from Rmd files and create of unique identifiers
    path1 <- test_path("file/rmd/test_DirectedPair_from_table.Rmd")
    suppressMessages(path1obj <- Map(create_question_object, rep(path1, 4)))
    path1obj[[1]]@identifier <- "v1"
    path1obj[[2]]@identifier <- "v2"
    path1obj[[3]]@identifier <- "v3"
    path1obj[[4]]@identifier <- "v4"

    path2 <- test_path("file/rmd/test_DirectedPair_SimpleCalc.Rmd")
    # path 2 - The item contains the parameter: calculator: simple-calculator
    suppressMessages(path2obj <- Map(create_question_object, rep(path2, 3)))
    path2obj[[1]]@identifier <- "v11"
    path2obj[[2]]@identifier <- "v22"
    path2obj[[3]]@identifier <- "v33"

    path3 <- test_path("file/rmd/test_rmd_MultipleChoiceTable_as_table_F.Rmd")
    # path 3 - The item contains the parameter: calculator:scientific-calculator
    suppressMessages(path3obj <- Map(create_question_object, rep(path3, 2)))
    path3obj[[1]]@identifier <- "v111"
    path3obj[[2]]@identifier <- "v222"

    path4 <- test_path("file/rmd/test_OneInRowTable_rowid_colid_example.Rmd")
    suppressMessages(path4obj <- Map(create_question_object, rep(path4, 2)))
    path4obj[[1]]@identifier <- "v1111"
    path4obj[[2]]@identifier <- "v2222"

    root_section_1 = suppressMessages(list(section(path1obj[[1]]),
                                           section(c(path2obj[[1]],
                                                     path4obj[[1]])),
                                           section(path1obj[[2]])))
    root_section_2 = suppressMessages(list(section(c(path1obj[[3]],
                                                     path3obj[[1]])),
                                           section(c(path2obj[[2]],
                                                     path4obj[[2]])),
                                           section(path1obj[[4]])))
    root_section_3 = suppressMessages(list(section(c(path2obj[[3]],
                                                     path3obj[[2]]))))

    example_exam_1 <- new("AssessmentTestOpal",
                          identifier = "id_test_1",
                          title = "Mock test",
                          section = root_section_1)
    example_exam_2 <- new("AssessmentTestOpal",
                          identifier = "id_test_2",
                          title = "Mock test",
                          section = root_section_2)
    example_exam_3 <- new("AssessmentTestOpal",
                          identifier = "id_test_2",
                          title = "Mock test",
                          section = root_section_3)

    sut_1 <- example_exam_1@calculator
    sut_2 <- example_exam_2@calculator
    sut_3 <- example_exam_3@calculator

    expect_equal(sut_1,"simple-calculator")
    expect_equal(sut_2,"scientific-calculator")
    expect_equal(sut_3,"scientific-calculator")
})

# test_that("Testing yaml section of Rmd file in case if file not exist", {
#     path <- test_path("file/rmd/test_DirectedPair_SimpleCalc_pdf.Rmd")
#     root_section = suppressMessages(list(section(path)))
#
#     result <- tryCatch({
#         example_exam <- new("AssessmentTestOpal",
#                         identifier = "id_test_1",
#                         title = "Mock test",
#                         section = root_section)
#     }, error = function(e) e)
#
#     expect_true(inherits(result, "error"))
#     expect_match(result$message, "The following files do not exist: -Not_file.pdf")
# })
