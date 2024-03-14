test_that("Testing mdlist function", {
    # Test case 1: Single choice task with solutions
    options1 <- c("Option A", "Option B", "Option C")
    solutions1 <- 1  # Option A is the correct answer
    expected_output1 <- "- *Option A*\n- Option B\n- Option C"
    result1 <- mdlist(options1, solutions1)
    expect_equal(result1, expected_output1)

    # Test case 2: Multiple choice task with solutions
    options2 <- c("Option 1", "Option 2", "Option 3", "Option 4")
    solutions2 <- c(2, 4)  # Options 2 and 4 are correct answers
    expected_output2 <- "- Option 1\n- *Option 2*\n- Option 3\n- *Option 4*"
    result2 <- mdlist(options2, solutions2)
    expect_equal(result2, expected_output2)

    # Test case 3: Single choice task with gaps
    options3 <- c("Sentence 1", "Sentence 2", "Sentence 3")
    gaps3 <- c(1, 2, 3)  # Define gaps for each option
    expected_output3 <- "- Sentence 1 <gap>1</gap>\n- Sentence 2 <gap>2</gap>\n- Sentence 3 <gap>3</gap>"
    result3 <- mdlist(options3, gaps = gaps3)
    expect_equal(result3, expected_output3)

    # Test case 4: Error case - mismatch between options and gaps
    options4 <- c("Option A", "Option B")
    gaps4 <- c(1, 2, 3)  # There are more gaps than options
    expect_error(mdlist(options4, gaps = gaps4))
})

test_that("Testing gap_numeric() function", {
    sut<- gap_numeric(solution = 300,
                      tolerance = 1,
                      points = 2)

    expected <- '<gap>{solution: [300], tolerance: 1.0, tolerance_type: absolute, points: 2.0, include_lower_bound: yes, include_upper_bound: yes, expected_length: 2.0, type: numeric}</gap>'

    expect_equal(sut, expected)
})
