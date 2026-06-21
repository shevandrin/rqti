source(test_path("test_helpers.R"))
test_that("test rmd2zip", {
    # this parts tests path with file name
    file <- test_path("file/rmd/Gap_primitive.Rmd")
    suppressMessages(rmd2zip(file, "to_delete/subfolder/test_exam.zip"))
    sut1 <- sort(list.files("to_delete/subfolder"))
    expected1 <- "test_exam.zip"
    expect_equal(sut1, expected1)
    unlink("to_delete", recursive = TRUE)
    # this part tests path without file name
    suppressMessages(rmd2zip(file, "to_delete/subfolder"))
    sut2 <- sort(list.files("to_delete/subfolder"))
    expected2 <- "test_entry_example.zip"
    expect_equal(sut2, expected2)
    unlink("to_delete", recursive = TRUE)
})

test_that("test rmd2xml", {
    file <- test_path("file/rmd/Gap_primitive.Rmd")
    suppressMessages(rmd2xml(file, "to_delete/index.xml"))
    sut <- list.files("to_delete")
    expected <- "index.xml"
    expect_equal(sut, expected)
    unlink("to_delete", recursive = TRUE)
})

test_that("detect_rmd_format() detects rqti, exams, and unknown Rmd files", {
    rqti_file <- tempfile(fileext = ".Rmd")
    writeLines(c("---", "title: Example", "---", "", "Question"), rqti_file)

    exams_file <- tempfile(fileext = ".Rmd")
    writeLines(c("Question", "", "Meta-information", "extype: schoice"),
               exams_file)

    unknown_file <- tempfile(fileext = ".Rmd")
    writeLines("Question without metadata", unknown_file)

    expect_equal(detect_rmd_format(rqti_file), "rqti_rmd")
    expect_equal(detect_rmd_format(exams_file), "exams_rmd")
    expect_equal(detect_rmd_format(unknown_file), "unknown")
    expect_error(
        detect_rmd_format("missing_file.Rmd"),
        "File does not exist"
    )
})

testthat::skip_if_not_installed("XML")
test_that("test abbreviate for rmd2xml() in OneInRowTable class", {
    file_sut <- test_path("file/rmd/OneInRowTable_abbr_example.Rmd")
    sut <- suppressMessages(rmd2xml(file_sut, "to_delete/index.xml"))
    sut <- readLines(sut)
    unlink("to_delete", recursive = TRUE)
    expected <- readLines(test_path("file/xml/OneInRowTable_abbr.xml"))
    equal_xml(sut, expected)
})

testthat::skip_if_not_installed("XML")
test_that("test abbreviate for rmd2xml() in OneInColTable class", {
    file_sut <- test_path("file/rmd/OnInColTable_abbr_example.Rmd")
    sut <- suppressMessages(rmd2xml(file_sut, "to_delete/index.xml"))
    sut <- readLines(sut)
    unlink("to_delete", recursive = TRUE)
    expected <- readLines(test_path("file/xml/OneInColTable_abbr.xml"))
    equal_xml(sut, expected)
})

testthat::skip_if_not_installed("XML")
test_that("test abbreviate for rmd2xml() in MultipleChoiceTable class", {
    file_sut <- test_path("file/rmd/MultipleChoiceTable_abbr_example.Rmd")
    sut <- suppressMessages(rmd2xml(file_sut, "to_delete/index.xml"))
    sut <- readLines(sut)
    unlink("to_delete", recursive = TRUE)
    expected <- readLines(test_path("file/xml/MultipleChoiceTable_abbr.xml"))
    equal_xml(sut, expected)
})

testthat::skip_if_not_installed("XML")
test_that("test abbreviate for rmd2xml() in DirectPair class", {
    file_sut <- test_path("file/rmd/directedPair_abbr_example.Rmd")
    sut <- suppressMessages(rmd2xml(file_sut, "to_delete/index.xml"))
    sut <- readLines(sut)
    unlink("to_delete", recursive = TRUE)
    expected <- readLines(test_path("file/xml/DirectedPair_abbr.xml"))
    equal_xml(sut, expected)
})
