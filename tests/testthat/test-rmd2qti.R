source(test_path("test_helpers.R"))
test_that("test rmd2zip", {
    # this parts tests path with file name
    file <- test_path("file/rmd/test_entry_Gap_primitive.Rmd")
    suppressMessages(rmd2zip(file, "to_delete/subfolder/test_exam.zip"))
    sut1 <- sort(list.files("to_delete/subfolder"))
    expected1 <- "test_exam.zip"
    expect_equal(sut1, expected1)
    unlink("to_delete", recursive = TRUE)
    # this part tests path without file name
    suppressMessages(rmd2zip(file, "to_delete/subfolder"))
    sut2 <- sort(list.files("to_delete/subfolder"))
    expected2 <- "test_test_entry_example.zip"
    expect_equal(sut2, expected2)
    unlink("to_delete", recursive = TRUE)
})

test_that("test rmd2xml", {
    file <- test_path("file/rmd/test_entry_Gap_primitive.Rmd")
    suppressMessages(rmd2xml(file, "to_delete/index.xml"))
    sut <- list.files("to_delete")
    expected <- "index.xml"
    expect_equal(sut, expected)
    unlink("to_delete", recursive = TRUE)
})

test_that("test abbreviate for rmd2xml() in OneInRowTable class", {
    file_sut <- test_path("file/rmd/test_OneInRowTable_abbr_example.Rmd")
    sut <- suppressMessages(rmd2xml(file_sut, "to_delete/index.xml"))
    sut <- readLines(sut)
    expected <- readLines(test_path("file/rmd/test_example_abbr_OneInRowTable.xml"))
    equal_xml(sut, expected)
    unlink("to_delete", recursive = TRUE)
})

test_that("test abbreviate for rmd2xml() in OneInColTable class", {
    file_sut <- test_path("file/rmd/test_OnInColTable_abbr_example.Rmd")
    sut <- suppressMessages(rmd2xml(file_sut, "to_delete/index.xml"))
    sut <- readLines(sut)
    expected <- readLines(test_path("file/rmd/test_example_abbr_OneInColTable.xml"))
    equal_xml(sut, expected)
    unlink("to_delete", recursive = TRUE)
})
