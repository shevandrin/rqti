test_that("test rmd2zip", {
    file <- test_path("file/test_entry_Gap_primitive.Rmd")
    suppressMessages(rmd2zip(file, "to_delete/subfolder/test_exam.zip"))
    sut1 <- sort(list.files("to_delete/subfolder"))
    expected1 <- sort(c("test_exam.zip", "imsmanifest.xml", "id_test.xml",
                  "test_entry_example.xml"))
    expect_equal(sut1, expected1)
    suppressMessages(rmd2zip(file, "to_delete/subfolder"))
    sut2 <- sort(list.files("to_delete/subfolder"))
    expected2 <- sort(c("id_test.zip", "imsmanifest.xml", "id_test.xml",
                        "test_entry_example.xml"))
    expect_equal(sut2, expected2)
    unlink("to_delete", recursive = TRUE)
})
test_that("test rmd2xml", {
    file <- test_path("file/test_entry_Gap_primitive.Rmd")
    suppressMessages(rmd2xml(file, "to_delete/index.xml"))
    sut <- list.files("to_delete")
    expected <- "index.xml"
    expect_equal(sut, expected)
    unlink("to_delete", recursive = TRUE)
})
