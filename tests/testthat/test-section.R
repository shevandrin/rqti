test_that("Testing of function section() creates assessment section correctly", {
    file1 <- test_path("file/test_order.Rmd")
    file2 <- test_path("file/test_mc_no_point.Rmd")
    file <- c(file1,file2)
    num_variants <- 3
    seed_number <- c(1,2,3)

    # Call the function under test
    sut <- section(file, num_variants = num_variants, seed_number = seed_number)

    expect_true(inherits(sut, "AssessmentSection"))
    expect_equal(length(sut@assessment_item), num_variants)
    expect_equal(sut@selection, 1)
})
test_that("Testing of function section where handles mismatched num_variants and seed_number correctly", {
    file <- test_path("file/test_order.Rmd")
    num_variants <- 3
    seed_number <- c(1, 2)

    # Call the function under test and expect an error
    expect_error(section(file,
                         num_variants = num_variants,
                         seed_number = seed_number),
                 "The items in seed_number must be equal to number of files")
})
test_that("Testing of function section() creates assessment section correctly when nested is FALSE", {
    file1 <- test_path("file/test_order.Rmd")
    file2 <- test_path("file/test_mc_no_point.Rmd")
    file <- c(file1,file2)
    num_variants <- 4
    seed_number <- c(1,2,3,4)
    nested <- FALSE

    # Call the function under test
    sut <- section(file,
                   num_variants = num_variants,
                   seed_number = seed_number,
                   nested = nested)

    expect_true(inherits(sut, "AssessmentSection"))
    expect_equal(length(sut@assessment_item), length(file))
    expect_equal(sut@selection, 0)
})
