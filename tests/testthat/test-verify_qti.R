test_that("verify_qti validates a correct QTI document", {
    f <- system.file("extdata", "sc1d.xml", package = "rqti")
    expect_true(nzchar(f))

    # Path input
    expect_true(verify_qti(f, print = F)$valid)

    # xml_document input
    x <- xml2::read_xml(f)
    expect_true(verify_qti(x, print = F)$valid)
    expect_true(verify_qti(x, print = F, engine = "xml2")$valid)
})

test_that("OpenOlat configuration is packaged separately from QTI validation", {
    item <- singleChoice(identifier = "opal_item", choices = c("A", "B"))
    assessment <- assessmentTestOpenOlat(
        list(assessmentSection(list(item), identifier = "section")),
        identifier = "openolat", rebuild_variables = NA)
    results <- verify_qti(assessment, print = FALSE, engine = "xml2")
    expect_length(results, 2L)
    expect_true(all(vapply(results, function(x) x$valid, logical(1))))
    expect_false("QTI21PackageConfig.xml" %in% names(results))
    out <- withr::local_tempdir()
    archive <- createQtiTest(assessment, dir = out, zip_only = TRUE)
    expect_true(any(basename(utils::unzip(archive, list = TRUE)$Name) == "QTI21PackageConfig.xml"))
    assessment@section[[1]]@assessment_item[[1]]@content <- list("<madeUp/>")
    invalid <- verify_qti(assessment, print = FALSE, engine = "xml2")
    expect_true(any(!vapply(invalid, function(x) x$valid, logical(1))))
})

test_that("verify_qti reports the schema used for validation", {
    f <- system.file("extdata", "sc1d.xml", package = "rqti")

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
    f <- system.file("extdata", "sc1d.xml", package = "rqti")

    res <- verify_qti(f, extended_schema = TRUE, print = FALSE, engine = "xml2")

    expect_true(res$valid)
    expect_identical(res$schema, "qti_v2p1p2_extension.xsd")
})

test_that("extended schema allows details in itemBody", {
    f <- system.file("extdata", "sc1d.xml", package = "rqti")
    x <- xml2::read_xml(f)
    item_body <- xml2::xml_find_first(x, "//*[local-name()='itemBody']")
    details <- paste0(
        "<details>",
        "<summary>Hint</summary>",
        "Text with <i>inline emphasis</i> after the summary.",
        "<p>More text</p>",
        "</details>"
    )
    xml2::xml_add_child(item_body, xml2::read_xml(details))

    res_default <- verify_qti(x, print = FALSE, engine = "xml2")
    res_extended <- verify_qti(x, extended_schema = TRUE, print = FALSE, engine = "xml2")

    expect_false(res_default$valid)
    expect_true(res_extended$valid)
})

test_that("extended schema validates TextGapOpal tolerance processing", {
    item <- new(
        "Entry",
        identifier = "text_gap_opal_schema",
        content = list(
            "<p>",
            new(
                "TextGapOpal",
                response_identifier = "RESPONSE_1",
                solution = c("more", "MORE", "More"),
                tolerance = 4
            ),
            "</p>"
        )
    )

    res <- verify_qti(
        item,
        extended_schema = TRUE,
        print = FALSE,
        engine = "xml2"
    )

    expect_true(res$valid)
})

test_that("extended schema accepts OPAL test settings", {
    supplement <- withr::local_tempfile(fileext = ".pdf")
    writeLines("formulas", supplement)
    item <- singleChoice(identifier = "opal_settings_item", choices = c("A", "B"))
    exam <- assessmentTestOpal(list(assessmentSection(list(item), identifier = "s")),
                               identifier = "opal_settings", calculator = "scientific",
                               keep_responses = TRUE, files = supplement)
    out <- withr::local_tempdir()
    archive <- createQtiTest(exam, dir = out, zip_only = TRUE)
    test_xml <- utils::unzip(archive, "opal_settings.xml", exdir = out)
    text <- paste(readLines(test_xml, warn = FALSE), collapse = "\n")
    expect_match(text, "data-downloads=", fixed = TRUE)
    expect_match(text, "scientific-calculator", fixed = TRUE)
    expect_match(text, 'rebuildVariables="true"', fixed = TRUE)

    engines <- "xml2"
    if (.Platform$OS.type != "windows" && nzchar(Sys.which("xmllint"))) {
        engines <- c(engines, "xmllint")
    }
    for (engine in engines) {
        expect_true(verify_qti(test_xml, schema = "extended", engine = engine,
                               print = FALSE)$valid)
    }
    standard <- verify_qti(test_xml, engine = "xml2", print = FALSE)
    expect_false(standard$valid)
    invalid <- sub('rebuildVariables="true"', 'rebuildVariables="maybe"', text, fixed = TRUE)
    expect_false(verify_qti(invalid, schema = "extended", engine = "xml2",
                            print = FALSE)$valid)
})

test_that("verify_qti can select a local qti22 schema", {
    f <- system.file("extdata", "sc1d.xml", package = "rqti")
    qti22_xml <- paste(readLines(f, warn = FALSE), collapse = "\n")
    qti22_xml <- gsub(
        "http://www.imsglobal.org/xsd/imsqti_v2p1",
        "http://www.imsglobal.org/xsd/imsqti_v2p2",
        qti22_xml,
        fixed = TRUE
    )

    expect_no_warning(
        res <- verify_qti(
            qti22_xml,
            schema = "qti22",
            print = FALSE,
            engine = "xml2"
        )
    )

    expect_s3_class(res, "qti_validation_result")
    expect_true(res$valid)
    expect_identical(res$schema, "imsqti_v2p2.xsd")

    expect_no_warning(
        res_file_name <- verify_qti(
            qti22_xml,
            schema = "imsqti_v2p2.xsd",
            print = FALSE,
            engine = "xml2"
        )
    )
    expect_s3_class(res_file_name, "qti_validation_result")
    expect_true(res_file_name$valid)
    expect_identical(res_file_name$schema, "imsqti_v2p2.xsd")

    schema_path <- rqti:::resolve_qti_schema("qti22")
    validation <- xml2::xml_validate(
        xml2::read_xml(qti22_xml),
        xml2::read_xml(schema_path)
    )
    expect_true(isTRUE(validation))
    expect_length(attr(validation, "errors"), 0)
})

test_that("verify_qti explains unknown schema selectors", {
    skip_if(file.exists(file.path(getwd(), "unknown_schema.xsd")))

    f <- system.file("extdata", "sc1d.xml", package = "rqti")

    expect_error(
        verify_qti(f, schema = "unknown_schema.xsd", print = FALSE, engine = "xml2"),
        "Unknown schema selector or missing XSD file",
        fixed = TRUE
    )
})

test_that("QTI 2.2 schemas unpack in a session directory and are reused", {
    schema_file <- rqti:::qti22_schema_file()
    expect_true(startsWith(normalizePath(schema_file, winslash = "/"),
                           paste0(normalizePath(tempdir(), winslash = "/"), "/")))
    expect_identical(rqti:::qti22_schema_file(), schema_file)
    directory <- dirname(dirname(schema_file))
    expect_true(file.exists(file.path(directory, "w3", "mathml3", "mathml3.xsd")))
    expect_true(file.exists(file.path(directory, "apipv1p0",
                                     "apipv1p0_qtiextv2p2_v1p0p1.xsd")))

    # Rebuild if a caller clears the R session's temporary files.
    unlink(directory, recursive = TRUE)
    replacement <- rqti:::qti22_schema_file()
    expect_true(file.exists(replacement))
    expect_false(identical(replacement, schema_file))
})

test_that("compressed QTI 2.2 schemas reject invalid XML with both backends", {
    f <- system.file("extdata", "sc1d.xml", package = "rqti")
    text <- gsub("http://www.imsglobal.org/xsd/imsqti_v2p1",
                 "http://www.imsglobal.org/xsd/imsqti_v2p2",
                 paste(readLines(f, warn = FALSE), collapse = "\n"), fixed = TRUE)
    document <- xml2::read_xml(text)
    body <- xml2::xml_find_first(document, "//*[local-name()='itemBody']")
    xml2::xml_add_child(body, "invalid_element")
    expect_no_warning(result <- verify_qti(document, schema = "qti22",
                                          engine = "xml2", ignore_import = FALSE,
                                          print = FALSE))
    expect_false(result$valid)
    expect_gt(length(result$errors), 0)
    if (.Platform$OS.type != "windows" && nzchar(Sys.which("xmllint"))) {
        expect_no_warning(result <- verify_qti(as.character(document), schema = "qti22",
                                               engine = "xmllint", ignore_import = FALSE,
                                               print = FALSE))
        expect_false(result$valid)
        expect_gt(length(result$errors), 0)
    }
})

sc1d_with_body <- function(body, version = "v2p1") {
    f <- system.file("extdata", "sc1d.xml", package = "rqti")
    text <- paste(readLines(f, warn = FALSE), collapse = "\n")
    text <- gsub("imsqti_v2p1", paste0("imsqti_", version), text, fixed = TRUE)
    sub("<itemBody>", paste0("<itemBody>", body), text, fixed = TRUE)
}

test_that("bundled schemas have wrappers that stub out unused MathML", {
    no_math <- "<p>x</p>"
    mathml2 <- '<m:math xmlns:m="http://www.w3.org/1998/Math/MathML"/>'
    mathml3 <- '<m:math xmlns:m="http://www.w3.org/2010/Math/MathML"/>'
    for (schema in c("qti21", "extended", "qti22")) {
        full <- rqti:::resolve_qti_schema(schema)
        wrapper <- rqti:::mathml_free_schema(full, no_math)
        expect_true(endsWith(wrapper, "_no_mathml.xsd"))
        expect_true(file.exists(wrapper))
        expect_identical(rqti:::mathml_free_schema(full, mathml3), full)
    }
    qti21 <- rqti:::resolve_qti_schema("qti21")
    expect_identical(rqti:::mathml_free_schema(qti21, mathml2), qti21)
    qti22 <- rqti:::mathml_free_schema(rqti:::resolve_qti_schema("qti22"), mathml2)
    expect_true(endsWith(qti22, "_no_mathml3.xsd"))
    expect_true(file.exists(qti22))
    custom <- withr::local_tempfile(fileext = ".xsd")
    file.copy(system.file("imsqti_v2p1p2.xsd", package = "rqti"), custom)
    expect_identical(rqti:::mathml_free_schema(custom, no_math), custom)
})

test_that("documents without MathML get the same errors as with the full schemas", {
    x <- xml2::read_xml(sc1d_with_body("<details/>"))
    validity_errors <- function(errors) {
        errors[!grepl("Skipping import", errors, fixed = TRUE)]
    }
    for (schema in c("qti21", "extended")) {
        full <- rqti:::resolve_qti_schema(schema)
        expected <- attr(xml2::xml_validate(x, xml2::read_xml(full)), "errors")
        res <- verify_qti(x, schema = schema, engine = "xml2",
                          ignore_import = FALSE, print = FALSE)
        expect_false(res$valid)
        raw <- vapply(res$errors, function(err) err$raw_message, character(1))
        expect_identical(validity_errors(raw), validity_errors(expected))
        expect_false(any(grepl("stub", raw, fixed = TRUE)))
    }
    skip_if(.Platform$OS.type == "windows")
    skip_if_not(nzchar(Sys.which("xmllint")), "xmllint is not installed")
    res <- verify_qti(as.character(x), engine = "xmllint", ignore_import = FALSE,
                      print = FALSE, color = FALSE)
    expect_false(res$valid)
    raw <- unlist(lapply(res$errors, function(err) err$raw_message))
    expect_false(any(grepl("stub", raw, fixed = TRUE)))
})

test_that("documents with MathML are checked against the full MathML schemas", {
    mathml2 <- "http://www.w3.org/1998/Math/MathML"
    valid <- sprintf('<p><m:math xmlns:m="%s"><m:mi>x</m:mi></m:math></p>', mathml2)
    invalid <- sprintf('<p><m:math xmlns:m="%s"><m:notMathML/></m:math></p>', mathml2)
    engines <- "xml2"
    if (.Platform$OS.type != "windows" && nzchar(Sys.which("xmllint"))) {
        engines <- c(engines, "xmllint")
    }
    for (engine in engines) {
        expect_true(verify_qti(sc1d_with_body(valid), engine = engine,
                               print = FALSE)$valid)
        res <- verify_qti(sc1d_with_body(invalid), engine = engine, print = FALSE)
        expect_false(res$valid)
        expect_true(any(vapply(res$errors, function(err) identical(err$element, "notMathML"),
                               logical(1))))
    }
    expect_false(verify_qti(sc1d_with_body(invalid), schema = "extended",
                            engine = "xml2", print = FALSE)$valid)
    expect_true(verify_qti(sc1d_with_body(valid, "v2p2"), schema = "qti22",
                           engine = "xml2", print = FALSE)$valid)
    expect_false(verify_qti(sc1d_with_body(invalid, "v2p2"), schema = "qti22",
                            engine = "xml2", print = FALSE)$valid)
    mathml3 <- sub("1998", "2010", invalid, fixed = TRUE)
    expect_false(verify_qti(sc1d_with_body(mathml3, "v2p2"), schema = "qti22",
                            engine = "xml2", print = FALSE)$valid)
})

test_that("verify_qti prints valid validation results", {
    f <- system.file("extdata", "sc1d.xml", package = "rqti")

    out <- capture.output(res <- verify_qti(f, print = TRUE, color = FALSE, engine = "xml2"))

    expect_true(res$valid)
    expect_match(out, "QTI validation: valid \\[engine: xml2\\]")
})

test_that("verify_qti validates XML string input with xmllint", {
    skip_if(.Platform$OS.type == "windows")
    skip_if_not(nzchar(Sys.which("xmllint")), "xmllint is not installed")

    f <- system.file("extdata", "sc1d.xml", package = "rqti")
    xml <- paste(readLines(f, warn = FALSE, encoding = "UTF-8"), collapse = "\n")

    res <- verify_qti(xml, print = FALSE, engine = "xmllint")

    expect_s3_class(res, "qti_validation_result")
    expect_true(res$valid)
    expect_identical(res$engine, "xmllint")
})

test_that("verify_qti returns structured result for invalid QTI", {
    f <- system.file("extdata", "sc1d.xml", package = "rqti")
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
    f <- system.file("extdata", "sc1d.xml", package = "rqti")
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

    f <- system.file("extdata", "sc1d.xml", package = "rqti")
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
    import_warning <- list(
        element = NA_character_,
        raw_message = paste(
            "element import: Schemas parser warning :",
            "Skipping import of schema located at 'http://www.imsglobal.org/xsd/w3/2001/xml.xsd'",
            "since this namespace was already imported"
        )
    )
    content_error <- list(element = "assessmentItem")

    expect_true(rqti:::is_schema_import_error(import_error))
    expect_true(rqti:::is_schema_import_error(namespaced_import_error))
    expect_true(rqti:::is_schema_import_error(import_warning))
    expect_false(rqti:::is_schema_import_error(content_error))
})

test_that("verify_qti validates Rmd file", {
    # Use a vignette Rmd as example
    rmd_file <- system.file("rmarkdown", "templates", "singlechoice-simple",
                            "skeleton", "skeleton.Rmd", package = "rqti")
    expect_true(nzchar(rmd_file))

    res <- verify_qti(rmd_file, print = F)
    expect_s3_class(res, "qti_validation_result")
    expect_true(res$valid)
})

test_that("verify_qti validates AssessmentItem object", {
    # Create an AssessmentItem from Rmd
    rmd_file <- system.file("rmarkdown", "templates", "singlechoice-simple",
                            "skeleton", "skeleton.Rmd", package = "rqti")
    expect_true(nzchar(rmd_file))

    item <- create_question_object(rmd_file)
    res <- verify_qti(item, print = F)

    expect_s3_class(res, "qti_validation_result")
    expect_true(res$valid)
})

test_that("verify_qti validates AssessmentTest object", {
    # Create two AssessmentItem objects from Rmd
    rmd_file1 <- system.file("rmarkdown", "templates", "singlechoice-simple",
                            "skeleton", "skeleton.Rmd", package = "rqti")

    rmd_file2 <- system.file("rmarkdown", "templates", "gap-simple",
                            "skeleton", "skeleton.Rmd", package = "rqti")

    expect_true(nzchar(rmd_file1))
    expect_true(nzchar(rmd_file2))

    item1 <- create_question_object(rmd_file1)
    item1@identifier <- "item1"
    item2 <- create_question_object(rmd_file2)
    item2@identifier <- "item2"

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
    rmd_file <- system.file("rmarkdown", "templates", "singlechoice-simple",
                            "skeleton", "skeleton.Rmd", package = "rqti")
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

test_that("validation result lists have a registered silent print method", {
    result <- structure(list(), class = c("qti_validation_results_list", "list"))
    expect_identical(getS3method("print", "qti_validation_results_list"),
                     print.qti_validation_results_list)
    output <- capture.output(printed <- withVisible(print(result)))
    expect_length(output, 0L)
    expect_identical(printed$value, result)
    expect_false(printed$visible)
})
