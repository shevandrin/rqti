# Essay
test_that("create_qti_task", {
    path <- test_path("file/test_create_qti_task_Essay.xml")
    sut <- readLines(path)

    essay <- new("Essay", prompt = "Test task",
                 title = "Essay",
                 identifier = "new")
    suppressMessages(create_qti_task(essay))
    expected <- readLines("new.xml")

    expect_equal(sut, expected)
    file.remove("new.xml")
})
# MultipleChoice
test_that("create_qti_task", {
    path <- test_path("file/test_create_qti_task_MultipleChoice.xml")
    cqt <- readLines(path)
    mc <- new("MultipleChoice",
               identifier = "new", prompt = "What does 3/4 + 1/4 = ?",
               title = "MultipleChoice",
               choices = c("1", "4/8", "8/4", "4/4"),
               choice_identifiers = c("a1", "a2", "a3", "a4"),
               points = c(1, 0, 0, 1)
    )
    suppressMessages(create_qti_task(mc))
    expected <- readLines("new.xml")

    expect_equal(cqt, expected)
    file.remove("new.xml")
})
# SingleChoice
test_that("create_qti_task", {
    path <- test_path("file/test_create_qti_task_SingleChoice.xml")
    cqt <- readLines(path)
    sc <- new("SingleChoice",
               prompt = "What is the percentage of 3/20?",
               title = "SingleChoice",
               choices = c("15%", "20%", "30%"),
               choice_identifiers = "1",
               identifier = "new")
    suppressMessages(create_qti_task(sc))
    expected <- readLines("new.xml")

    expect_equal(cqt, expected)
    file.remove("new.xml")
})
# Order
test_that("create_qti_task", {
    path <- test_path("file/test_create_qti_task_Order.xml")
    cqt <- readLines(path)
    order <- new("Order",
                  identifier = "new",
                  title = "Order",
                  prompt = "Choose the correct order",
                  choices = c("Data collection",
                              "Data cleansing", "Data marking",
                              "Verification and visualization"),
                  choices_identifiers = c("a1", "a2", "a3", "a4"),
                  points = 1,
                 points_per_answer = FALSE)
    suppressMessages(create_qti_task(order))
    expected <- readLines("new.xml")

    expect_equal(cqt, expected)
    file.remove("new.xml")
})
# OneInColTable
test_that("create_qti_task", {
    path <- test_path("file/test_create_qti_task_OneInColTable.xml")
    cqt <- readLines(path)
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
    suppressMessages(create_qti_task(oneInColTable))
    expected <- readLines("new.xml")

    expect_equal(cqt, expected)
    file.remove("new.xml")
})
# OneInRowTable
test_that("create_qti_task", {
    path <- test_path("file/test_create_qti_task_OneInRowTable.xml")
    cqt <- readLines(path)
    OneInRowTable <- new("OneInRowTable", content = list("<p>\"One in row\" table task</p>",
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
    suppressMessages(create_qti_task(OneInRowTable))
    expected <- readLines("new.xml")

    expect_equal(cqt, expected)
    file.remove("new.xml")
})
# MultipleChoiceTable
test_that("create_qti_task", {
    path <- test_path("file/test_create_qti_task_MultipleChoiceTable.xml")
    cqt <- readLines(path)
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
    suppressMessages(create_qti_task(MultipleChoiceTable))
    expected <- readLines("new.xml")

    expect_equal(cqt, expected)
    file.remove("new.xml")
})
# DirectedPair
test_that("create_qti_task", {
    path <- test_path("file/test_create_qti_task_DirectedPair.xml")
    cqt <- readLines(path)
    DirectedPair <- new("DirectedPair",
                    content = list("<p>\"Directed pairs\" task</p>"),
                    identifier = "new",
                    title = "Directed pairs",
                    rows = c("12*4 =", "100/50 =", "25*2 ="),
                    rows_identifiers = c("a", "b", "c"),
                    cols = c("48", "2", "50"),
                    cols_identifiers = c("k", "l", "m"),
                    answers_identifiers = c("a k", "b l", 'c m'),
                    points = 5
)
    suppressMessages(create_qti_task(DirectedPair))
    expected <- readLines("new.xml")

    expect_equal(cqt, expected)
    file.remove("new.xml")
})
# TextGapOpal
test_that("create_qti_task", {
    path <- test_path("file/test_create_qti_task_TextGapOpal.xml")
    expected <- readLines(path)
TextGapOpal <- new("Entry",
                   identifier = "new",
                   points = 3,
                   title = "TextGapOpal",
                   content = list('<p>The speed of light is',
                                  new("TextGapOpal",
                                      response_identifier = "RESPONSE_1",
                                      score = 1,
                                      response = "more",
                                      alternatives = c("MORE", "More"),
                                      value_precision = 2),
                                  'than the speed of sound</p>'))

    suppressMessages(create_qti_task(TextGapOpal))
    sut <- readLines("new.xml")

    expect_equal(sut, expected)
    file.remove("new.xml")
})
# NumericGap
test_that("create_qti_task", {
    path <- test_path("file/test_create_qti_task_NumericGap.xml")
    expected <- readLines(path)
NumericGap <- new("Entry",
                  identifier = "new",
                  points = 3,
                  title = "NumericGap",
                  content = list('The speed of light is equal',
                                 new("NumericGap",
                                     response_identifier = "RESPONSE_1",
                                     score = 1,
                                     response = 300,
                                     value_precision = 2),
                                 'm/s')
)
    suppressMessages(create_qti_task(NumericGap))
    sut <- readLines("new.xml")

    expect_equal(sut, expected)
    file.remove("new.xml")
})
# InlineChoice
test_that("create_qti_task", {
    path <- test_path("file/test_create_qti_task_InlineChoice.xml")
    cqt <- readLines(path)
InlineChoice <- new("Entry",
                    identifier = "new",
                    points = 4,
                    title = "InlineChoice",
                    content = list('The speed of light is equal',
                                   new("InlineChoice",
                                       choices = c("400","300","500"),
                                       response_identifier = "RESPONSE_1",
                                       solution = 2,
                                       score = 1),
                                   'm/s')
)
    suppressMessages(create_qti_task(InlineChoice))
    expected <- readLines("new.xml")

    expect_equal(cqt, expected)
    file.remove("new.xml")
})
