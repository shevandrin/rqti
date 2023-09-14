test_that("Testing method createOutcomeDeclaration()
          for AssessmentTest class", {
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
                section = list(exam_section)
                )

    example <- "<additionalTag>
<outcomeDeclaration identifier=\"SCORE\" cardinality=\"single\" baseType=\"float\">
  <defaultValue>
    <value>0</value>
  </defaultValue>
</outcomeDeclaration>
<outcomeDeclaration identifier=\"MAXSCORE\" cardinality=\"single\" baseType=\"float\">
  <defaultValue>
    <value>6</value>
  </defaultValue>
</outcomeDeclaration>
<outcomeDeclaration identifier=\"MINSCORE\" cardinality=\"single\" baseType=\"float\">
	<defaultValue>
	<value>0</value>
  </defaultValue>
</outcomeDeclaration>
    </additionalTag>"

    expected <- paste('<additionalTag>', toString(createOutcomeDeclaration(exam)),'</additionalTag>')
    xml1 <- xml2::read_xml(expected)
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
})

test_that("Testing method createAssessmentTest for AssessmentTestOpal class", {
sc1 <- new("SingleChoice", prompt = "Test task", title = "SC",
           identifier = "q1", choices = c("a", "b", "c"))
sc2 <- new("SingleChoice", prompt = "Test task", title = "SC",
           identifier = "q2", choices = c("A", "B", "C"))
sc3 <- new("SingleChoice", prompt = "Test task", title = "SC",
           identifier = "q3", choices = c("aa", "bb", "cc"))
e1 <- new("Essay", prompt = "Essay task", identifier = "e1")
e2 <- new("Essay", prompt = "Essay task", identifier = "e2")
e3 <- new("Essay", prompt = "Essay task", identifier = "e3")
exam_subsection <- new("AssessmentSection", identifier = "subsec_id",
                       title = "Subsection", assessment_item = list(e1, e2, e3),
                       shuffle = TRUE, selection = 2)
exam_section <- new("AssessmentSection", identifier = "sec_id",
                    title = "section",
                    assessment_item = list(sc1, sc2, sc3, exam_subsection),
                    max_attempts = 3, time_limits = 30, allow_comment = TRUE)

exam <- new("AssessmentTestOpal", identifier = "id_test",
            title = "some title", section = list(exam_section),
            files = c(test_path("file/test_fig1.jpg"),
                      test_path("file/test_fig2.jpg")),
            max_attempts = 5, time_limits = 100, allow_comment = TRUE,
            rebuild_variables = TRUE,
            show_test_time = TRUE, calculator = "simple-calculator",
            keep_responses = TRUE
            )
suppressMessages(createQtiTest(exam, "todelete", "TRUE"))

sut <- sort(list.files("todelete"))
expected <- sort(c("downloads", "e1.xml", "e2.xml", "e3.xml", "q1.xml", "q2.xml", "q3.xml",
              "id_test.xml", "id_test.zip", "imsmanifest.xml"))
expect_equal(sut, expected)
unlink("todelete", recursive = TRUE)
})

test_that("Testing method createAssessmentTest for AssessmentTest class", {
    sc1 <- new("SingleChoice", prompt = "Test task", title = "SC",
               identifier = "q1", choices = c("a", "b", "c"))
    sc2 <- new("SingleChoice", prompt = "Test task", title = "SC",
               identifier = "q2", choices = c("A", "B", "C"))
    sc3 <- new("SingleChoice", prompt = "Test task", title = "SC",
               identifier = "q3", choices = c("aa", "bb", "cc"))
    e1 <- new("Essay", prompt = "Essay task", identifier = "e1")
    e2 <- new("Essay", prompt = "Essay task", identifier = "e2")
    e3 <- new("Essay", prompt = "Essay task", identifier = "e3")
    exam_subsection <- new("AssessmentSection", identifier = "subsec_id",
                           title = "Subsection",
                                            assessment_item = list(e1, e2, e3),
                           shuffle = TRUE, selection = 2)
    exam_section <- new("AssessmentSection", identifier = "sec_id",
                        title = "section",
                        assessment_item = list(sc1, sc2, sc3, exam_subsection),
                        max_attempts = 3, time_limits = 30,
                                                        allow_comment = TRUE)

    exam <- new("AssessmentTest", identifier = "id_test",
                title = "some title", section = list(exam_section),
                max_attempts = 5, time_limits = 100, allow_comment = TRUE,
                rebuild_variables = TRUE
    )

    # Testing AssessmentTest
    suppressMessages(createQtiTest(exam, "todelete", "TRUE"))

    sut <- xml2::read_xml(suppressMessages(toString(createAssessmentTest(
        object = exam, folder = getwd()))))
    expected <- xml2::read_xml("todelete/id_test.xml")
    expect_equal(sut, expected)
    file.remove("e1.xml")
    file.remove("e2.xml")
    file.remove("e3.xml")
    file.remove("q1.xml")
    file.remove("q2.xml")
    file.remove("q3.xml")
    unlink("todelete", recursive = TRUE)
})

test_that("Testing of AssessmentSection class that contains
          non-unique identifiers of AssessmentItem class", {
    mc1 <- new("MultipleChoice",
               identifier = "theSame", prompt = "What does 3/4 + 1/4 = ?",
               title = "MultipleChoice",
               choices = c("1", "4/8", "8/4", "4/4"),
               choice_identifiers = c("1", "2", "3", "4"),
               points = c(1, 0, 0, 1))

    sc2 <- new("SingleChoice",
               prompt = "What is the percentage of 3/20?",
               title = "SingleChoice",
               choices = c("15%", "20%", "30%"),
               choice_identifiers = "1",
               identifier = "theSame")

    expect_error({
        new("AssessmentSection",
            identifier = "sec_id",
            title = "section",
            assessment_item = list(mc1, sc2)
        )
    }, "Items of section id:sec_id contain non-unique values: theSame, theSame")
})

test_that("Testing of AssessmentTest class that contains non-unique identifiers
          of AssessmentSection", {
    mc1 <- new("MultipleChoice",
                identifier = "theSame", prompt = "What does 3/4 + 1/4 = ?",
                title = "MultipleChoice",
                choices = c("1", "4/8", "8/4", "4/4"),
                choice_identifiers = c("1", "2", "3", "4"),
                points = c(1, 0, 0, 1))
    sc2 <- new("SingleChoice",
               prompt = "What is the percentage of 3/20?",
               title = "SingleChoice",
               choices = c("15%", "20%", "30%"),
               choice_identifiers = "1",
               identifier = "theSame")
    section1 <- new("AssessmentSection",
                    identifier = "sec_id",
                    title = "section",
                    assessment_item = list(mc1))
    section2 <- new("AssessmentSection",
                     identifier = "sec_id",
                     title = "section",
                     assessment_item = list(sc2))

    expect_warning({ exam <- new("AssessmentTest",
                                  identifier = "id_test",
                                  title = "some title",
                                  section = list(section1, section2))
    }, "Identifiers of test sections contain non-unique values: sec_id, sec_id")
})
test_that("Testing of time_limits in AssessmentTest class", {
              mc1 <- new("MultipleChoice",
                         identifier = "theSame", prompt = "What does 3/4 + 1/4 = ?",
                         title = "MultipleChoice",
                         choices = c("1", "4/8", "8/4", "4/4"),
                         choice_identifiers = c("1", "2", "3", "4"),
                         points = c(1, 0, 0, 1))
              section <- new("AssessmentSection",
                              identifier = "sec_id",
                              title = "section",
                              assessment_item = list(mc1))
              expect_warning({
                  exam <- new("AssessmentTest",
                               identifier = "id_test",
                               title = "some title",
                               time_limits = 190,
                               section = list(section))
              }, "Value of time_limits does not seem plausible.")
          })
