
# Testing function of get-task-attribute ---------------------------------------
test_that("Testing function of get-task-attribute", {
    gta <- get_task_attributes("title: Konjunktiv two")
    expected <- setNames("Konjunktiv two","title")
    expect_equal(gta, expected)
})

test_that("Testing function of get-task-attribute", {
    gta <- get_task_attributes("identifier: 090909")
    expected <- setNames("090909","identifier")
    expect_equal(gta, expected)
})

test_that("Testing function of get-task-attribute", {
    path <- test_path("file/test_fun_gts.md")
    gta <- get_task_attributes(get_task_section(readLines(path), "attributes"))
    expected <- sort(setNames(c("singlechoice",
                               "Economics and Physic",
                               "145","12, 13, 1.23"),
                             c("type","title","number", "num")))
    expect_equal(gta, expected)
})

test_that("Testing function of get-task-attribute", {
    path <- test_path("file/test_fun_gts.md")
    gta <- get_task_section(readLines(path), "attributes")
    expected <- paste(c("type","title","number", "num"),
                     c("singlechoice","Economics and Physic",
                       "145","12, 13, 1.23"), sep=": ", collapse = NULL)
    expect_equal(gta, expected)
})

# Testing function of get_task_section -----------------------------------------
test_that("Testing function of get_task_section", {
    path <- test_path("file/test_fun_gts.md")
    gts <- get_task_section(readLines(path), "question")
    expected <- c(
        "In economics it is generallz believed that the main objective of",
        "a Public Sector Financial Companz like Bank is to:")
    expect_equal(gts, expected)
})

test_that("Testing function of get_task_section", {
    path <- test_path("file/test_fun_gts.md")
    gts <- get_task_section(readLines(path), "attributes")
    expected <- c("type: singlechoice",
    "title: Economics and Physic",
    "number: 145", "num: 12, 13, 1.23")
    expect_equal(gts, expected)
})

test_that("Testing function of get_task_section", {
    path <- test_path("file/test_fun_gts.md")
    gts <- get_task_section(readLines(path), "answers")
    expected <- c("Employ more and more people",
    "Maximize total production", "Maximize total profits",
    "Sell the goods at subsidized cost")
    expect_equal(gts, expected)
})

# Testing function of create_question_content ----------------------------------
# SingleChoice
test_that("create_question_content", {
    path <- test_path("file/test_sc_example1.md")
    cqc <- create_question_content(path)
    expected <- new("SingleChoice",
                   content = list(
        "<p>This is a mock question<br />",
        "In economics it is generally believed that the main objective of a",
        "Public Sector Financial Company like Bank is to:</p>"
        ),
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
    expect_equal(cqc, expected)
})

test_that("create_question_content", {
    path <- test_path("file/test_sc_example2.md")
    cqc <- create_question_content(path)
    expected <- new("SingleChoice",
                   content = list(
    "<p>Which term is used to describe the study of how people make decisions",
    "in a world where resources are limited?</p>"),
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
    expect_equal(cqc, expected)
})

test_that("create_question_content", {
    path <- test_path("file/test_sc_example3.md")
    cqc <- create_question_content(path)
    expected <- new("SingleChoice", content = list(
    "<p>Which of the following is a market economy primarily based on?</p>"),
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
    expect_equal(cqc, expected)
})

# MultipleChoice
test_that("create_question_content", {
    path <- test_path("file/test_mc_example.md")
    cqc <- create_question_content(path)
    expected <- new("MultipleChoice",
                   content = list(
    "<p>When deciding between renovating a water treatment plant or building",
    "a new community pool, what is the government most likely to",
    "consider?</p>"),
                   points = c(1, 2, 0, 0),
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
    expect_equal(cqc, expected)
})

# Essay
test_that("create_question_content", {
    path <- test_path("file/test_essay_example.md")
    cqc <- create_question_content(path)
    expected <- new("Essay",
                    content = list(
                "<p>Defining Good Students Means More Than Just Grades.</p>"),
                   points = 10,
                   identifier = "test 2",
                   qti_version = "v2p1",
                   title = "Definition Essay"
                   )
    expect_equal(cqc, expected)
})
