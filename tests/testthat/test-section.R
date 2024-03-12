test_that("Testing of function section() creates assessment
          section correctly", {
    file1 <- test_path("file/rmd/order.Rmd")
    file2 <- test_path("file/rmd/mc_no_point.Rmd")
    file <- c(file1,file2)
    num_variants <- 3
    seed_number <- c(1,2,3)

    # Call the function under test
    sut <- section(file, n_variants = num_variants, seed_number = seed_number)

    expect_true(inherits(sut, "AssessmentSection"))
    expect_equal(length(sut@assessment_item), num_variants)
    expect_equal(sut@selection, 1)
})

test_that("Testing of function section where handles mismatched num_variants
          and seed_number correctly", {
    file <- test_path("file/rmd/order.Rmd")
    num_variants <- 3
    seed_number <- c(1, 2)

    # Call the function under test and expect an error
    expect_error(section(file,
                         n_variants = num_variants,
                         seed_number = seed_number),
                 "The items in seed_number must be equal to number of variants")
})

test_that("Testing of function section() creates assessment section correctly
          when by is \'files\'", {
    file1 <- test_path("file/rmd/order.Rmd")
    file2 <- test_path("file/rmd/mc_no_point.Rmd")
    file <- c(file1,file2)
    num_variants <- 4
    seed_number <- c(1,2,3,4)
    by <- "files"

    # Call the function under test
    sut <- section(file,
                   n_variants = num_variants,
                   seed_number = seed_number,
                   by = by)

    expect_true(inherits(sut, "AssessmentSection"))
    expect_equal(length(sut@assessment_item), length(file))
    expect_equal(sut@selection, NA_integer_)
})

test_that("Testing of function section() with files and S4 objects creates
assessment section correctly", {
              file1 <- test_path("file/rmd/order.Rmd")
              file2 <- test_path("file/rmd/mc_no_point.Rmd")
              sc <- new("SingleChoice", choices = c("A", "B", "C"),
                        identifier = "sc_test")
              content <- c(file1, file2, sc)
              num_variants <- 3
              seed_number <- c(1,2,3)

              # Call the function under test
              sut <- section(content, n_variants = num_variants,
                             seed_number = seed_number)
              # Get sc object from outcome section
              sut2 <- sut@assessment_item[[1]]@assessment_item[[3]]
              # Call only with object
              sut3 <- section(sc, n_variants = num_variants)

              expect_true(inherits(sut, "AssessmentSection"))
              expect_equal(length(sut@assessment_item), num_variants)
              expect_equal(sut@selection, 1)
              expect_true(is(sut2, "SingleChoice"))
              expect_equal(length(sut3@assessment_item), 3)
          })

