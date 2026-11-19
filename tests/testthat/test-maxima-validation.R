test_that("Maxima XML requires the extended schema and validates without suppressed errors", {
    source <- system.file("extdata", "maxima-local-addition.xml", package = "rqti")
    expect_true(nzchar(source))
    document <- xml2::read_xml(source)
    schema <- xml2::read_xml(system.file("qti_v2p1p2_extension.xsd", package = "rqti"))
    expect_no_warning(raw <- xml2::xml_validate(document, schema))
    expect_true(isTRUE(raw))
    expect_length(attr(raw, "errors"), 0)

    engines <- "xml2"
    if (.Platform$OS.type != "windows" && nzchar(Sys.which("xmllint"))) {
        engines <- c(engines, "xmllint")
    }
    for (engine in engines) {
        standard <- verify_qti(source, schema = "qti21", engine = engine,
                               ignore_import = FALSE, print = FALSE)
        expect_false(standard$valid)
        expect_true(any(vapply(standard$errors, function(error) {
            grepl("attribute 'value'", error$message, fixed = TRUE)
        }, logical(1))))
        expect_no_warning(extended <- verify_qti(source, schema = "extended",
            engine = engine, ignore_import = FALSE, print = FALSE))
        expect_true(extended$valid)
        expect_length(extended$errors, 0)

        broken <- xml2::read_xml(source)
        gap <- xml2::xml_find_first(broken, "//*[local-name()='textEntryInteraction']")
        xml2::xml_set_attr(gap, "expectedLength", "not-an-integer")
        result <- verify_qti(broken, schema = "extended", engine = engine,
                             ignore_import = FALSE, print = FALSE)
        expect_false(result$valid)
        expect_gt(length(result$errors), 0)
    }
})

test_that("XML schema validation does not claim to validate Maxima syntax", {
    source <- system.file("extdata", "maxima-local-addition.xml", package = "rqti")
    document <- xml2::read_xml(source)
    program <- xml2::xml_find_first(document, "//*[local-name()='customOperator']")
    xml2::xml_set_attr(program, "value", "1/0;")
    # The program is an XML string; runtime checks are a separate operation.
    result <- verify_qti(document, schema = "extended", engine = "xml2",
                         ignore_import = FALSE, print = FALSE)
    expect_true(result$valid)
    expect_length(result$errors, 0)
})
