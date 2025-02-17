test_that("Testing qti_contribututor() function", {
    sut <- qtiContributor("Max Mustermann", "technical validator", "2024-01-01")
    expect_true(check_contributor(sut))
})

test_that("Testing qti_contribututor() function on Error", {
    sut<- qtiContributor("Max Mustermann", contribution_date = "2024-01-01")
    sut@role <- "tutor"
    expect_true(is.character(check_contributor(sut)))
})

test_that("Testing check_metadata() function in QtiMetadata class on Errors", {
    sut <- qtiMetadata()
    sut@contributor = list("Bob")
    sut <- check_metadata(sut)
    expect_true(is.character(sut))
})

test_that("Testing check_metadata() function  in QtiMetadata class in case
          if it doesn't any Errors", {
    sut<- qtiMetadata(description = "Task description",
                       rights = "This file is Copyright (C) 2024 Max
                                Mustermann, all rights reserved.",
                       version = "1.0")
    expect_true(check_metadata(sut))
})
