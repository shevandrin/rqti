test_that("verify_qti validates a correct QTI document", {
    f <- system.file("exercises", "sc1d.xml", package = "rqti")
    expect_true(nzchar(f))

    # Path input
    expect_true(verify_qti(f, print = F)$valid)

    # xml_document input
    x <- xml2::read_xml(f)
    expect_true(verify_qti(x, print = F)$valid)
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
})

test_that("verify_qti works with explicit xml2 engine", {
    f <- system.file("exercises", "sc1d.xml", package = "rqti")

    expect_true(verify_qti(f, engine = "xml2", print = F)$valid)
})
