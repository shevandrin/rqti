# Essay
test_that("create_qti_task", {
    path <- test_path("file/xml/Essay.xml")
    expected <- readLines(path)

    essay <- new("Essay", prompt = "Test task",
                 title = "Essay",
                 identifier = "new")
    suppressMessages(createQtiTask(essay))
    sut <- readLines("new.xml")

    expect_equal(sut, expected)
    file.remove("new.xml")
})

# MultipleChoice
test_that("create_qti_task", {
    path <- test_path("file/xml/MultipleChoice.xml")
    expected <- readLines(path)
    mc <- new("MultipleChoice",
               identifier = "mpc", prompt = "What does 3/4 + 1/4 = ?",
               title = "MultipleChoice",
               choices = c("1", "4/8", "8/4", "4/4"),
               choice_identifiers = c("a1", "a2", "a3", "a4"),
               points = c(1, 0, 0, 1)
    )
    suppressMessages(createQtiTask(mc))
    sut <- readLines("mpc.xml")

    expect_equal(sut, expected)
    file.remove("mpc.xml")
})

# SingleChoice
test_that("create_qti_task", {
    path <- test_path("file/xml/SingleChoice.xml")
    expected <- readLines(path)
    sc <- new("SingleChoice",
               prompt = "What is the percentage of 3/20?",
               title = "SingleChoice",
               choices = c("15%", "20%", "30%"),
               choice_identifiers = "1",
               identifier = "new")
    suppressMessages(createQtiTask(sc))
    sut <- readLines("new.xml")

    expect_equal(sut, expected)
    file.remove("new.xml")
})

# Order
test_that("create_qti_task", {
    path <- test_path("file/xml/Order_output_createQtiTask.xml")
    expected <- readLines(path)
    order <- new("Order",
                  identifier = "ord",
                  title = "Order",
                  prompt = "Choose the correct order",
                  choices = c("Data collection",
                              "Data cleansing", "Data marking",
                              "Verification and visualization"),
                  choices_identifiers = c("ChoiceA", "ChoiceB",
                                          "ChoiceC", "ChoiceD"),
                  points = 1,
                 points_per_answer = FALSE)
    suppressMessages(createQtiTask(order))
    sut <- readLines("ord.xml")

    expect_equal(sut, expected)
    file.remove("ord.xml")
})

# OneInColTable
test_that("create_qti_task", {
    path <- test_path("file/xml/OneInColTable.xml")
    expected <- readLines(path)
    oneInColTable <- new("OneInColTable",
                         content = list("<p>\"One in col\" table task</p>",
                                        "<i>table description</i>"),
                 identifier = "new",
                 title = "OneInColTable",
                 prompt = "Choose the correct order in the multiplication table",
                 rows = c("4*7 =", "3*9 =", "5*5 =", "2*3 =", "12*3 ="),
                 rows_identifiers = c("a", "b", "c", "d", "e"),
                 cols = c("27", "36", "25", "6", "72/2"),
                 cols_identifiers = c("k", "l", "m", "n", "p"),
                 answers_identifiers =c("b k", "c m", "d n", "e l", "e p"),
                 points = 5
    )
    suppressMessages(createQtiTask(oneInColTable))
    sut <- readLines("new.xml")

    expect_equal(sut, expected)
    file.remove("new.xml")
})

# OneInRowTable
test_that("create_qti_task", {
    path <- test_path("file/xml/OneInRowTable.xml")
    expected <- readLines(path)
    OneInRowTable <- new("OneInRowTable",
                         content = list("<p>\"One in row\" table task</p>",
                                                   "<i>table description</i>"),
             identifier = "new",
             title = "OneInRowTable",
             prompt = "Choose the correct order in the multiplication table",
             rows = c("4*9 =", "3*9 =", "5*5 =", "2*3 =", "12*3 ="),
             rows_identifiers = c("a", "b", "c", "d", "e"),
             cols = c("27", "36", "25", "6"),
             cols_identifiers = c("k", "l", "m", "n"),
             answers_identifiers = c("a l", "b k", "c m", "d n", "e l"),
             points = 5)
    suppressMessages(createQtiTask(OneInRowTable))
    sut <- readLines("new.xml")

    expect_equal(sut, expected)
    file.remove("new.xml")
})

# MultipleChoiceTable
test_that("create_qti_task", {
    path <- test_path("file/xml/MultipleChoiceTable.xml")
    expected <- readLines(path)

    MultipleChoiceTable <- new("MultipleChoiceTable",
                content = list("<p>\"One in col\" table task</p>",
                              "<i>table description</i>"),
                identifier = "new",
                title = "MultipleChoiceTable",
                prompt = "Choose the correct order in the multiplication table",
                rows = c("4*7 =", "3*9 =", "5*5 =", "2*3 =", "12*3 ="),
                rows_identifiers = c("a", "b", "c", "d", "e"),
                cols = c("27", "36", "25", "6", "72/2"),
                cols_identifiers = c("k", "l", "m", "n", "p"),
                answers_identifiers =c("b k", "c m", "d n", "e l", "e p"),
                points = 5
    )
    suppressMessages(createQtiTask(MultipleChoiceTable))
    sut <- readLines("new.xml")

    expect_equal(sut, expected)
    file.remove("new.xml")
})

# DirectedPair
test_that("create_qti_task", {
    path <- test_path("file/xml/DirectedPair.xml")
    expected <- readLines(path)
    DirectedPair <- new("DirectedPair",
                    content = list("<p>\"Directed pairs\" task</p>"),
                    identifier = "dpr",
                    title = "Directed pairs",
                    rows = c("12*4 =", "100/50 =", "25*2 ="),
                    rows_identifiers = c("a", "b", "c"),
                    cols = c("48", "2", "50"),
                    cols_identifiers = c("k", "l", "m"),
                    answers_identifiers = c("a k", "b l", 'c m'),
                    points = 5
)
    suppressMessages(createQtiTask(DirectedPair))
    sut <- readLines("dpr.xml")

    expect_equal(sut, expected)
    file.remove("dpr.xml")
})

# TextGapOpal
test_that("create_qti_task", {
    path <- test_path("file/xml/TextGapOpal.xml")
    expected <- readLines(path)
TextGapOpal <- new("Entry",
                   identifier = "tgo",
                   points = 3,
                   title = "TextGapOpal",
                   content = list('<p>The speed of light is',
                                  new("TextGapOpal",
                                      response_identifier = "RESPONSE_1",
                                      points = 3,
                                      solution = c("more", "MORE", "More"),
                                      tolerance = 2),
                                  'than the speed of sound</p>'))

    suppressMessages(createQtiTask(TextGapOpal))
    sut <- readLines("tgo.xml")

    expect_equal(sut, expected)
    file.remove("tgo.xml")
})

# NumericGap
test_that("create_qti_task", {
    path <- test_path("file/xml/NumericGap.xml")
    expected <- readLines(path)
NumericGap <- new("Entry",
                  identifier = "new",
                  points = 1,
                  title = "NumericGap",
                  content = list('The speed of light is equal',
                                 new("NumericGap",
                                     response_identifier = "RESPONSE_1",
                                     points = 1,
                                     solution = 300,
                                     tolerance = 2),
                                 'm/s')
)
    suppressMessages(createQtiTask(NumericGap))
    sut <- readLines("new.xml")

    expect_equal(sut, expected)
    file.remove("new.xml")
})

# InlineChoice
test_that("create_qti_task", {
    path <- test_path("file/xml/InlineChoice.xml")
    expected <- readLines(path)
InlineChoice <- new("Entry",
                    identifier = "new",
                    points = 1,
                    title = "InlineChoice",
                    content = list('The speed of light is equal',
                                   new("InlineChoice",
                                       choices = c("400","300","500"),
                                       response_identifier = "RESPONSE_1",
                                       solution_index = 2,
                                       points = 1),
                                   'm/s')
)
    suppressMessages(createQtiTask(InlineChoice))
    sut <- readLines("new.xml")

    expect_equal(sut, expected)
    file.remove("new.xml")
})

test_that("Testing of create_manifest_task() function", {
    sc <- new("SingleChoice",
              identifier = "SingleChoice")
    sut <- toString(create_manifest_task(sc))

expected <- '<manifest xmlns="http://www.imsglobal.org/xsd/imscp_v1p1" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.imsglobal.org/xsd/imscp_v1p1 http://www.imsglobal.org/xsd/qti/qtiv2p1/qtiv2p1_imscpv1p2_v1p0.xsd http://www.imsglobal.org/xsd/imsqti_v2p1 http://www.imsglobal.org/xsd/qti/qtiv2p1/imsqti_v2p1p1.xsd http://www.imsglobal.org/xsd/imsqti_metadata_v2p1 http://www.imsglobal.org/xsd/qti/qtiv2p1/imsqti_metadata_v2p1p1.xsd http://ltsc.ieee.org/xsd/LOM http://www.imsglobal.org/xsd/imsmd_loose_v1p3p2.xsd http://www.w3.org/1998/Math/MathML http://www.w3.org/Math/XMLSchema/mathml2/mathml2.xsd" identifier="SingleChoice_manifest">
  <metadata></metadata>
  <organisations></organisations>
  <resources>
    <resource identifier="SingleChoice" type="imsqti_item_xmlv2p1" href="SingleChoice.xml">
      <file href="SingleChoice.xml"></file>
    </resource>
  </resources>
</manifest>'

expect_equal(sut, expected)
})

test_that("Testing of create_task_zip() function", {
    sc <- new("SingleChoice",
              identifier = "SingleChoice")
    sut1 <-  suppressMessages(capture.output(create_task_zip(sc)))
    sut2 <-  suppressMessages(capture.output(create_task_zip(sc, path="main")))

expect_true(any(grepl("./SingleChoice.zip", sut1)))
expect_true(any(grepl("main/SingleChoice.zip", sut2, fixed = TRUE)))
file.remove("SingleChoice.zip")
unlink("main", recursive = TRUE)
})
