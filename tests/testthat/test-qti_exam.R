test_that("Testing of counting points in the test if all tasks
          have the differ points, NESTED = TRUE", {
              file1 <- test_path("file/rmd/test_order.Rmd")
              # points = 1
              file2 <- test_path("file/rmd/test_DirectedPair_from_table.Rmd")
              # points = 2.5
              file3 <- test_path("file/rmd/test_entry_Gap_InlineChoice.Rmd")
              # points = 3

              file <- c(file1,file2,file3)

              num_variants <- 3
              seed_number <- c(1,2,3)
              nested <- TRUE

              # Call the function under test
              sut_section <- section(file,
                                     n_variants = num_variants,
                                     seed_number = seed_number,
                                     nested = nested)

              test <- test(sut_section, "test1")
              expect_equal(test@points, 6.5)
})
