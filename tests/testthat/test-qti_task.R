# Essay
test_that("create_qti_task", {
    path <- test_path("file/test_create_qti_task_Essay.xml")
    cqt <- readLines(path)

    essay <- new("Essay", prompt = "Test task", title = "Essay", identifier = "new")
    create_qti_task(essay)
    expected <- readLines("new.xml")

    expect_equal(cqt, expected)
    file.remove("new.xml")
})

