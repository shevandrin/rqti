# Testing function of get-task-attribute --------------------------------------
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
    gta <- get_task_attributes(get_task_section(readLines("./tests/testthat/file/input_gts.md"), "attributes"))
    example <- c("singlechoice","Economics and Physic","145","12, 13, 1.23")
    names(example) <- c("type","title","number", "num")
    expect_equal(gta, example)
})
test_that("Testing function of get-task-attribute", {
    gta <- get_task_section(readLines("./tests/testthat/file/input_gts.md"), "attributes")
    example <- paste(c("type","title","number", "num"), c("singlechoice","Economics and Physic","145","12, 13, 1.23"), sep=": ", collapse = NULL)
    expect_equal(gta, example)
})
# Testing function of get_task_section ----------------------------------------
test_that("Testing function of get_task_section", {
    gts <- get_task_section(readLines("./tests/testthat/file/input_gts.md"), "question")
        example <- unlist(strsplit("In economics it is generallz believed that the main objective of\na Public Sector Financial Companz like Bank is to:", "\n"))
    expect_equal(gts, example)
})
test_that("Testing function of get_task_section", {
    gts <- get_task_section(readLines("./tests/testthat/file/input_gts.md"), "attributes")
    example <- unlist(strsplit("type: singlechoice\ntitle: Economics and Physic\nnumber: 145\nnum: 12, 13, 1.23","\n"))
    expect_equal(gts, example)
})
test_that("Testing function of get_task_section", {
    gts <- get_task_section(readLines("./tests/testthat/file/input_gts.md"), "answers")
    example <- unlist(strsplit("Employ more and more people\nMaximize total production\nMaximize total profits\nSell the goods at subsidized cost","\n"))
    expect_equal(gts, example)
})
