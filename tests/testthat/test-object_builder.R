test_that("Testing function of get-task-attribute", {
    gta <- get_task_attributes("title: Konjunktiv two")
    example <- c("Konjunktiv two")
    names(example) <- "title"
    expect_equal(gta, example)
})
test_that("Testing function of get-task-attribute", {
    gta <- get_task_attributes("identifier: 090909")
    example <- c("090909")
    names(example) <- "identifier"
    expect_equal(gta, example)
})
test_that("Testing function of get-task-attribute", {
    gta <- get_task_attributes("options: 1.4,4.3,5.6")
    example <- c(1.4,4.3,5.6)
    names(example) <- "options"
    expect_equal(gta, example)
})
test_that("Testing function of get-task-attribute", {
    gta <- get_task_attributes("way: 26")
    example <- c("26")
    names(example) <- "way"
    expect_equal(gta, example)
})
test_that("Testing function of get_task_section", {
    gts <- get_task_section(readLines("./tests/testthat/file/input_gts.md"), "question")
        example <- unlist(strsplit("In economics it is generallz believed that the main objective of\na Public Sector Financial Companz like Bank is to:", "\n"))
    expect_equal(gts, example)
})
test_that("Testing function of get_task_section", {
    gts <- get_task_section(readLines("./tests/testthat/file/input_gts.md"), "attributes")
    example <- unlist(strsplit("type: singlechoice\ntitle: Economics","\n"))
    expect_equal(gts, example)
})
test_that("Testing function of get_task_section", {
    gts <- get_task_section(readLines("./tests/testthat/file/input_gts.md"), "answers")
    example <- unlist(strsplit("Employ more and more people\nMaximize total production\nMaximize total profits\nSell the goods at subsidized cost","\n"))
    expect_equal(gts, example)
})
