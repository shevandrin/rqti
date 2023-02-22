
# Testing function of get-task-attribute ---------------------------------------
test_that("Testing function of get-task-attribute", {
    gta <- get_task_attributes("title: Konjunktiv two")
    example <- setNames("Konjunktiv two","title")
    expect_equal(gta, example)
})
test_that("Testing function of get-task-attribute", {
    gta <- get_task_attributes("identifier: 090909")
    example <- setNames("090909","identifier")
    expect_equal(gta, example)
})
test_that("Testing function of get-task-attribute", {
    path = test_path("file/input_gts1.md")
    gta <- get_task_attributes(get_task_section(readLines(path), "attributes"))
    example <- sort(setNames(c("singlechoice","Economics and Physic","145","12, 13, 1.23"),c("type","title","number", "num")))
    expect_equal(gta, example)
})
test_that("Testing function of get-task-attribute", {
    path = test_path("file/input_gts1.md")
    gta <- get_task_section(readLines(path), "attributes")
    example <- paste(c("type","title","number", "num"), c("singlechoice","Economics and Physic","145","12, 13, 1.23"), sep=": ", collapse = NULL)
    expect_equal(gta, example)
})
# Testing function of get_task_section -----------------------------------------
test_that("Testing function of get_task_section", {
    path = test_path("file/input_gts1.md")
    gts <- get_task_section(readLines(path), "question")
    x <- "In economics it is generallz believed that the main objective of\na Public Sector Financial Companz like Bank is to:"
    example <- strsplit(x, "\n")[[1]]
    expect_equal(gts, example)
})
test_that("Testing function of get_task_section", {
    path = test_path("file/input_gts1.md")
    gts <- get_task_section(readLines(path), "attributes")
    x <- "type: singlechoice\ntitle: Economics and Physic\nnumber: 145\nnum: 12, 13, 1.23"
    example <- strsplit(x, "\n")[[1]]
    expect_equal(gts, example)
})
test_that("Testing function of get_task_section", {
    path = test_path("file/input_gts1.md")
    gts <- get_task_section(readLines(path), "answers")
    x <- "Employ more and more people\nMaximize total production\nMaximize total profits\nSell the goods at subsidized cost"
    example <- strsplit(x, "\n")[[1]]
    expect_equal(gts, example)
})
# Testing function of create_question_content ----------------------------------
# SingleChoice
test_that("create_question_content", {
    path = test_path("file/input_gts.md")
    cqc <- create_question_content(path)
    example <- new("SingleChoice", content = list("<p>In economics it is generallz believed that the main objective of\na Public Sector Financial Companz like Bank is to:</p>\n"),
                   points = 1,
                   identifier = "eco",
                   qti_version = "v2p1",
                   title = "Economics and Physic",
                   choices = c("Employ more and more people",
                               "Maximize total production",
                               "Maximize total profits",
                               "Sell the goods at subsidized cost"),
                   shuffle = TRUE,
                   prompt = "",
                   choice_identifiers = c("ChoiceA",
                                          "ChoiceB",
                                          "ChoiceC",
                                          "ChoiceD"),
                   orientation = "vertical",
                   solution = 1
    )
    expect_equal(cqc, example)
})
test_that("create_question_content", {
    path = test_path("file/test_object1.md")
    cqc <- create_question_content(path)
     example <- new("SingleChoice", content = list("<p>Which term is used to describe the study of how people make decisions in a world where resources are limited?</p>"),
                   points = 2,
                   identifier = "sample 2",
                   qti_version = "v2p1",
                   title = "Economics 2",
                   choices = c("scarcity",
                               "decision-making modeling",
                               "economics",
                               "cost-benefit analysis"),
                   shuffle = TRUE,
                   prompt = "",
                   choice_identifiers = c("ChoiceA",
                                          "ChoiceB",
                                          "ChoiceC",
                                          "ChoiceD"),
                   orientation = "vertical",
                   solution = 2
    )
    expect_equal(cqc, example)
})
test_that("create_question_content", {
    path = test_path("file/test_object2.md")
    cqc <- create_question_content(path)
    example <- new("SingleChoice", content = list("<p>Which of the following is a market economy primarily based on?</p>"),
                   points = 3,
                   identifier = "sample 2",
                   qti_version = "v2p1",
                   title = "Economics",
                   choices = c("capitalism and free enterprise",
                               "traditionalism and command",
                               "incentives and traditionalism"),
                   shuffle = TRUE,
                   prompt = "",
                   choice_identifiers = c("ChoiceA",
                                          "ChoiceB",
                                          "ChoiceC"),
                   orientation = "vertical",
                   solution = 1
    )
    expect_equal(cqc, example)
})
# MultipleChoice
test_that("create_question_content", {
    path = test_path("file/test_object1-mc.md")
    cqc <- create_question_content(path)
    print(cqc)
    example <- new("MultipleChoice", content = list("<p>In economics it is generallz believed that the main objective of\na Public Sector Financial Companz like Bank is to:</p>"),
                   points = 1,
                   identifier = "test 2",
                   qti_version = "v2p1",
                   title = "Economics",
                   choices = c("scarcity vs. resources",
                               "wages vs. prices",
                               "wants vs. needs",
                               "consumers vs. producers"),
                   shuffle = TRUE,
                   prompt = "",
                   choice_identifiers = c("ChoiceA",
                                          "ChoiceB",
                                          "ChoiceC",
                                          "ChoiceD"),
                   orientation = "vertical",
                   lower_bound = 0,
                   default_value = 0

    )
    expect_equal(cqc, example)
})
# Essay
test_that("create_question_content", {
    path = test_path("file/test_object1-essay.md")
    cqc <- create_question_content(path)
    print(cqc)
    example <- new("Essay", content = list("<p>Defining Good Students Means More Than Just Grades.</p>"),
                   points = 10,
                   identifier = "test 2",
                   qti_version = "v2p1",
                   title = "Definition Essay",
                   expectedlength = 55,
                   expectedlines = 55,
                   dataAllowPaste = FALSE

    )
    expect_equal(cqc, example)
})
