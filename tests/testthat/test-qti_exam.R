file1 <- test_path("file/rmd/test_order.Rmd")
# points = 1
file2 <- test_path("file/rmd/test_DirectedPair_from_table.Rmd")
# points = 2.5
file3 <- test_path("file/rmd/test_entry_Gap_InlineChoice.Rmd")
# points = 3
file4 <- test_path("file/test_create_qti_task_NumericGap.xml")
# points = 1
file5 <- test_path("file/test_create_qti_task_TextGapOpal.xml")
# points = 3
file6 <- test_path("file/md/test_mc_example.md")
# points = 3
file7 <- test_path("file/md/test_order_example.md")
# points = 1

files1 <- c(file1,file2,file3)
files2 <- c(file1,file2)
files3 <- c(file1,file3)
files4 <- c(file4,file5)
files5 <- c(file6,file7)

num_variants1 <- 3
seed_number1 <- c(1,2,3)

num_variants3 <- 2
seed_number3 <- c(4,5)

by <- "variants"
root_section = suppressMessages(list(section(files1,
                                             n_variants = num_variants1,
                                             seed_number = seed_number1,
                                             by = by),
                                     section(c(files4,
                                               section(c(files2,
                                                         section(files5))))),
                                     section(files3,
                                             n_variants = num_variants3,
                                             seed_number = seed_number3,
                                             by = by)))

test_that("Testing of counting points in the test if all tasks
          have the differ points, by = variants", {
              # file1 - points = 1
              # file2 - points = 2.5
              # file3 - points = 3


              file <- c(file1,file2,file3)

              num_variants <- 3
              seed_number <- c(1,2,3)
              by <- "variants"

              # Call the function under test
              sut_section <- suppressMessages(section(file,
                                     n_variants = num_variants,
                                     seed_number = seed_number,
                                     by = by))

              test <- test(sut_section, "test1")
              expect_equal(test@points, 6.5)
})

test_that("Testing of counting points in the test that had
          the complex hierarchical structure", {

              test <- test(root_section, "test1")
              expect_equal(test@points, 22)
})

test_that("Testing unique identifiers in AssessmentSection and
          AssessmentItem",{

        id <- unlist(lapply(root_section, getIdentifier))
        has_duplicates <- !any(duplicated(id))

# Assert that there are no duplicates, True
expect_true(has_duplicates, "Duplicate identifiers found in AssessmentSections")
})

test_that("Testing createQtiTest method behavior when the Rmd file
          is not exist", {
              path <- test_path("file/rmd/NoFile.Rmd")

              error_message <- tryCatch(
                  createQtiTest(path),
                  error = function(e) {
                      conditionMessage(e)
                  }
              )

              expect_equal("The file does not exist", error_message)
})

test_that("Testing createQtiTest method", {
              path_1 <- test_path("file/rmd/test_mc_no_point.Rmd")
              path_2 <- test_path("file/md/test_sc_example2.md")
              path_3 <- test_path("file/test_create_qti_task_MultipleChoice.xml")

              sut_1 <- createQtiTest(path_1)
              sut_2 <- createQtiTest(path_2)
              sut_3 <- createQtiTest(path_3)

              expect_no_error(sut_1)
              expect_no_error(sut_2)
              expect_no_error(sut_3)

              unlink("Preview.zip", expand = TRUE )
              unlink("sample 2.zip", expand = TRUE )
              unlink("test 2.zip", expand = TRUE )
})

test_that("Testing createQtiTest method for AssessmentItem object", {
    mc <- new("MultipleChoice",
              identifier = "2", prompt = "What does 3/4 + 1/4 = ?",
              title = "MultipleChoice",
              choices = c("1", "4/8", "8/4", "4/4"),
              choice_identifiers = c("a1", "a2", "a3", "a4"),
              points = c(1, 0, 0, 1)
    )

    sut <- createQtiTest(mc, "exam_folder")

    expected <- file.path("exam_folder", "test_2.zip")
    expect_equal(sut, expected)

    unlink("exam_folder", recursive = FALSE)
})
