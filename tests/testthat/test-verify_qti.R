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

test_that("verify_qti reports the schema used for validation", {
    f <- system.file("exercises", "sc1d.xml", package = "rqti")

    res_default <- verify_qti(f, print = FALSE, engine = "xml2")
    expect_true(res_default$valid)
    expect_identical(res_default$schema, "imsqti_v2p1p2.xsd")

    res_extended <- verify_qti(f, schema = "extended", print = FALSE, engine = "xml2")
    expect_s3_class(res_extended, "qti_validation_result")
    expect_identical(res_extended$schema, "qti_v2p1p2_extension.xsd")

    schema_path <- system.file("imsqti_v2p1p2.xsd", package = "rqti")
    res_path <- verify_qti(f, schema = schema_path, print = FALSE, engine = "xml2")
    expect_true(res_path$valid)
    expect_identical(res_path$schema, "imsqti_v2p1p2.xsd")

    res_file_name <- verify_qti(f, schema = "imsqti_v2p1p2.xsd", print = FALSE, engine = "xml2")
    expect_true(res_file_name$valid)
    expect_identical(res_file_name$schema, "imsqti_v2p1p2.xsd")
})

test_that("verify_qti accepts legacy extended_schema flag", {
    f <- system.file("exercises", "sc1d.xml", package = "rqti")

    res <- verify_qti(f, extended_schema = TRUE, print = FALSE, engine = "xml2")

    expect_s3_class(res, "qti_validation_result")
    expect_identical(res$schema, "qti_v2p1p2_extension.xsd")
})

test_that("verify_qti can select a local qti22 schema", {
    skip_if_not(any(file.exists(file.path(rqti:::qti_schema_search_dirs(), "imsqti_v2p2.xsd"))))

    f <- system.file("exercises", "sc1d.xml", package = "rqti")

    res <- verify_qti(f, schema = "qti22", print = FALSE, engine = "xml2")

    expect_s3_class(res, "qti_validation_result")
    expect_identical(res$schema, "imsqti_v2p2.xsd")

    res_file_name <- verify_qti(f, schema = "imsqti_v2p2.xsd", print = FALSE, engine = "xml2")
    expect_s3_class(res_file_name, "qti_validation_result")
    expect_identical(res_file_name$schema, "imsqti_v2p2.xsd")
})

test_that("verify_qti explains unknown schema selectors", {
    skip_if(file.exists(file.path(getwd(), "unknown_schema.xsd")))

    f <- system.file("exercises", "sc1d.xml", package = "rqti")

    expect_error(
        verify_qti(f, schema = "unknown_schema.xsd", print = FALSE, engine = "xml2"),
        "Unknown schema selector or missing XSD file",
        fixed = TRUE
    )
})

test_that("verify_qti prints valid validation results", {
    f <- system.file("exercises", "sc1d.xml", package = "rqti")

    out <- capture.output(res <- verify_qti(f, print = TRUE, color = FALSE, engine = "xml2"))

    expect_true(res$valid)
    expect_match(out, "QTI validation: valid \\[engine: xml2\\]")
})

test_that("verify_qti validates XML string input with xmllint", {
    skip_if(.Platform$OS.type == "windows")
    skip_if_not(nzchar(Sys.which("xmllint")), "xmllint is not installed")

    f <- system.file("exercises", "sc1d.xml", package = "rqti")
    xml <- paste(readLines(f, warn = FALSE, encoding = "UTF-8"), collapse = "\n")

    res <- verify_qti(xml, print = FALSE, engine = "xmllint")

    expect_s3_class(res, "qti_validation_result")
    expect_true(res$valid)
    expect_identical(res$engine, "xmllint")
})

test_that("verify_qti returns structured result for invalid QTI", {
    f <- system.file("exercises", "sc1d.xml", package = "rqti")
    x <- xml2::read_xml(f)

    # introduce a schema error (add an invalid tag to itemBody)
    item_body <- xml2::xml_find_first(x, "//*[local-name()='itemBody']")
    xml2::xml_add_child(item_body, "details", .where = 0)

    res <- verify_qti(x, print = F, engine = "xml2")
    expect_s3_class(res, "qti_validation_result")
    expect_false(res$valid)
    expect_true(length(res$errors) >= 1)
    expect_identical(res$engine, "xml2")
    expect_true(any(vapply(res$errors, function(err) identical(err$element, "details"), logical(1))))
    expect_true(any(vapply(res$errors, function(err) length(err$allowed) > 0, logical(1))))
    expect_false(verify_qti(x, print = F, engine = "xml2")$valid)
})

test_that("verify_qti prints invalid validation results with parsed detail", {
    f <- system.file("exercises", "sc1d.xml", package = "rqti")
    x <- xml2::read_xml(f)
    item_body <- xml2::xml_find_first(x, "//*[local-name()='itemBody']")
    xml2::xml_add_child(item_body, "details", .where = 0)

    out <- capture.output(res <- verify_qti(x, print = TRUE, color = FALSE, engine = "xml2"))

    expect_false(res$valid)
    expect_match(paste(out, collapse = "\n"), "QTI validation: invalid \\[engine: xml2\\]")
    expect_match(paste(out, collapse = "\n"), "Allowed tags:")
})

test_that("verify_qti reports invalid documents with xmllint", {
    skip_if(.Platform$OS.type == "windows")
    skip_if_not(nzchar(Sys.which("xmllint")), "xmllint is not installed")

    f <- system.file("exercises", "sc1d.xml", package = "rqti")
    x <- xml2::read_xml(f)
    item_body <- xml2::xml_find_first(x, "//*[local-name()='itemBody']")
    xml2::xml_add_child(item_body, "details", .where = 0)

    res <- verify_qti(as.character(x), print = FALSE, engine = "xmllint", color = FALSE)

    expect_s3_class(res, "qti_validation_result")
    expect_false(res$valid)
    expect_identical(res$engine, "xmllint")
    expect_true(any(vapply(res$errors, function(err) identical(err$element, "details"), logical(1))))
})

test_that("verify_qti rejects character input that is neither a path nor XML", {
    expect_error(
        verify_qti("not a qti document", print = FALSE),
        "must start with '<'",
        fixed = TRUE
    )
})

test_that("verify_qti identifies schema import errors", {
    import_error <- list(element = "import")
    namespaced_import_error <- list(element = "{http://www.w3.org/2001/XMLSchema}import")
    content_error <- list(element = "assessmentItem")

    expect_true(rqti:::is_schema_import_error(import_error))
    expect_true(rqti:::is_schema_import_error(namespaced_import_error))
    expect_false(rqti:::is_schema_import_error(content_error))
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

test_that("verify_qti prints AssessmentTest validation summaries", {
    rmd_file <- system.file("exercises", "sc1.Rmd", package = "rqti")
    item <- create_question_object(rmd_file)
    section <- new("AssessmentSection", assessment_item = list(item))
    test <- new("AssessmentTest",
                identifier = "test_001",
                title = "Test for verify_qti",
                section = list(section))

    out <- capture.output(res <- verify_qti(test, print = TRUE, color = FALSE, engine = "xml2"))

    expect_s3_class(res, "qti_validation_results_list")
    expect_match(paste(out, collapse = "\n"), "QTI Validation Results - Assessment Test")
    expect_match(paste(out, collapse = "\n"), "Files:")
})
