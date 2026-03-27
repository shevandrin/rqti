test_that("verify_qti validates a correct QTI document", {
    f <- system.file("exercises", "sc1d.xml", package = "rqti")
    expect_true(nzchar(f))

    # Path input
    expect_true(verify_qti(f, print = F)$valid)

    # xml_document input
    x <- xml2::read_xml(f)
    expect_true(verify_qti(x, print = F)$valid)
    expect_true(verify_qti(x, print = F, engine = "xml2")$valid)
})

test_that("verify_qti returns structured result for invalid QTI", {
    f <- system.file("exercises", "sc1d.xml", package = "rqti")
    x <- xml2::read_xml(f)

    # introduce a schema error (add an invalid tag to itemBody)
    item_body <- xml2::xml_find_first(x, "//*[local-name()='itemBody']")
    xml2::xml_add_child(item_body, "details", .where = 0)

    res <- verify_qti(x, print = F)
    expect_s3_class(res, "qti_validation_result")
    expect_false(res$valid)
    expect_true(length(res$errors) >= 1)
    expect_false(verify_qti(x, print = F, engine = "xml2")$valid)
})

test_that("verify_qti validates Rmd file", {
    # Use a vignette Rmd as example
    rmd_file <- system.file("exercises", "sc1.Rmd", package = "rqti")
    expect_true(nzchar(rmd_file))

    res <- verify_qti(rmd_file, print = F)
    expect_s3_class(res, "qti_validation_result")
    expect_true(res$valid)
})

test_that("verify_qti validates AssessmentItem object", {
    # Create an AssessmentItem from Rmd
    rmd_file <- system.file("exercises", "sc1.Rmd", package = "rqti")
    expect_true(nzchar(rmd_file))

    item <- create_question_object(rmd_file)
    res <- verify_qti(item, print = F)

    expect_s3_class(res, "qti_validation_result")
    expect_true(res$valid)
})

test_that("verify_qti validates AssessmentTest object", {
    # Create two AssessmentItem objects from Rmd
    rmd_file1 <- system.file("exercises", "sc1.Rmd", package = "rqti")
    rmd_file2 <- system.file("exercises", "gap1.Rmd", package = "rqti")

    expect_true(nzchar(rmd_file1))
    expect_true(nzchar(rmd_file2))

    item1 <- create_question_object(rmd_file1)
    item2 <- create_question_object(rmd_file2)

    # Create an AssessmentTest with the items
    section <- new("AssessmentSection", assessment_item = list(item1, item2))
    test <- new("AssessmentTest",
                identifier = "test_001",
                title = "Test for verify_qti",
                section = list(section))
    test_opal <- new("AssessmentTestOpal",
                     identifier = "test_001",
                     title = "Test for verify_qti",
                     section = list(section))

    res <- verify_qti(test, print = F)
    expect_s3_class(res, "qti_validation_results_list")
    expect_true(length(res) >= 2)

    res_opal <- verify_qti(test_opal, print = F)
    expect_false(res_opal$test$valid) # OPAL test should fail due to OPAL-specific constraints
})
