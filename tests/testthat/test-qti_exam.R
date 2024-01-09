test_that("Testing of counting points in the test if all tasks
          have the differ points, by = variants", {
              file1 <- test_path("file/rmd/test_order.Rmd")
              # points = 1
              file2 <- test_path("file/rmd/test_DirectedPair_from_table.Rmd")
              # points = 2.5
              file3 <- test_path("file/rmd/test_entry_Gap_InlineChoice.Rmd")
              # points = 3

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

            # Call the function under test
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
              test <- test(root_section, "test1")
              expect_equal(test@points, 22)
})
