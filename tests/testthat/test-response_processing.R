test_that("german_grading() returns the expected grading scale", {
    expected <- c(
        "1.0" = 0.95, "1.3" = 0.9,  "1.7" = 0.85,
        "2.0" = 0.8,  "2.3" = 0.75, "2.7" = 0.7,
        "3.0" = 0.65, "3.3" = 0.6,  "3.7" = 0.55,
        "4.0" = 0.5,  "5.0" = 0
    )

    expect_equal(german_grading(), expected)
})
