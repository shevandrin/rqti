test_that("test inherit OneInRowTable class from Rmd file
          if parameter set - as table: T", {
    file_sut <- test_path("file/rmd/test_rmd_OneInRowTable_as_table_T.Rmd")
    sut <- create_question_object(file_sut)
    expect_true(inherits(sut, "OneInRowTable"))
})

test_that("test inherit OneInColTable class from Rmd file
          if parameter set - as table: T", {
    file_sut <- test_path("file/rmd/test_rmd_OneInColTable_as_table_T.Rmd")
    sut <- create_question_object(file_sut)
    expect_true(inherits(sut, "OneInColTable"))
})

test_that("test inherit DirectedPair class from Rmd file
          with out parameter - as table:F", {
    file_sut <- test_path("file/rmd/test_DirectedPair_with_table.Rmd")
    sut <- suppressMessages(create_question_object(file_sut))
    expect_true(inherits(sut, "DirectedPair"))
})

test_that("test inherit OneInRowTable class from Rmd file
          with out parameter -as table:F", {
    file_sut <- test_path("file/rmd/test_OneInRowTable_example.Rmd")
    sut <- create_question_object(file_sut)
    expect_true(inherits(sut, "OneInRowTable"))
})

test_that("test inherit OneInColTable class from Rmd file
          with out parameter - as table:F", {
    file_sut <- test_path("file/rmd/test_OneInColTable_rowid_colid_example.Rmd")
    sut <- create_question_object(file_sut)
    expect_true(inherits(sut, "OneInColTable"))
})

test_that("test inherit MultipleChoiceTable class from Rmd file
          with out parameter - as table:F", {
    file_sut <- test_path("file/rmd/test_MultipleChoiceTable_rowid_colid_example.Rmd")
    sut <- create_question_object(file_sut)
    expect_true(inherits(sut, "MultipleChoiceTable"))
})

test_that("test inherit MultipleChoiceTable class from Rmd file
          with out parameter - as table:F", {
    file_sut <- test_path("file/rmd/test_rmd_MultipleChoiceTable_as_table_F.Rmd")
    sut <- create_question_object(file_sut)
    expect_true(inherits(sut, "MultipleChoiceTable"))
})

