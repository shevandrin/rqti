test_that("Testing function of get-task-attribute", {
    gta <- get_task_attributes("title: Konjunktiv two")
    example <- c("Konjunktiv two")
    names(example) <- "title"
    expect_equal(gta, example)
}
)
test_that("Testing function of get-task-attribute", {
    gta <- get_task_attributes("identifier: 090909")
    example <- c("090909")
    names(example) <- "identifier"
    expect_equal(gta, example)
}
)
test_that("Testing function of get-task-attribute", {
    gta <- get_task_attributes("options: 1.4,4.3,5.6")
    example <- c(1.4,4.3,5.6)
    names(example) <- "options"
    expect_equal(gta, example)
}
)
test_that("Testing function of get-task-attribute 2", {
    gta <- get_task_attributes("way: 26")
    example <- c("26")
    names(example) <- "way"
    expect_equal(gta, example)
}
)
