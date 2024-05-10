test_that("Testing qti_contribututor() function", {
    sut <- qti_contributor("Max Mustermann", "technical validator")
    expect_true(check_contributor(sut))
})

test_that("Testing qti_contribututor() function on Error", {
    roles <- c("author", "publisher", "unknown", "initiator", "terminator",
               "validator", "editor", "graphial designer",
               "technical implementer", "content provider",
               "technical validator", "educational validator", "script writer",
               "instructional designer", "subject matter expert")


    sut<- qti_contributor("Max Mustermann")
    sut@role <- "tutor"



    expect_equal({check_contributor(sut)},
                 paste0("The Role of the contributer has to have one
                                   of these values: ",
                    paste(roles, collapse = ", "), "."))

})

test_that("Testing check_metadata() function in QtiMetadata class on Errors", {

sut<- qti_metadata(description = "Task description",
                   rights = "This file is Copyright (C) 2024 Max
                    Mustermann, all rights reserved.",
                   version = "1.0")
    sut@contributor = list("Bob")
    sut <- check_metadata(sut)

    expect_equal(sut,"Item 'Bob' is not an object of QtiContributor class")
})

test_that("Testing check_metadata() function  in QtiMetadata class in case
          if it doesn't any Errors", {

    sut<- qti_metadata(description = "Task description",
                       rights = "This file is Copyright (C) 2024 Max
                    Mustermann, all rights reserved.",
                       version = "1.0")

    sut <- check_metadata(sut)

    expect_error(check_metadata(sut))
})
