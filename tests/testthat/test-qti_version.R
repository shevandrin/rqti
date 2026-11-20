test_that("QTI 2.1 stays the default and other versions are rejected", {
    withr::local_options(list(rqti.qti_version = NULL))
    withr::local_envvar(c(RQTI_SERVER_PID = NA))
    expect_identical(qti_version(), "2.1")
    expect_identical(qti_namespace(), "http://www.imsglobal.org/xsd/imsqti_v2p1")
    expect_identical(qti_resource_type("test"), "imsqti_test_xmlv2p1")
    expect_match(manifest_schema_location(), "qtiv2p1/imsqti_v2p1p1.xsd", fixed = TRUE)

    withr::local_options(list(rqti.qti_version = "3.0"))
    expect_error(qti_version(), "must be \"2.1\" or \"2.2\"", fixed = TRUE)
})

test_that("separate Knit sessions use the preview console's QTI version", {
    withr::local_options(list(rqti.qti_version = NULL))
    local_mocked_bindings(preview_console_options = function() list(qti_version = "2.2"))
    expect_identical(qti_version(), "2.2")
})

test_that("the preview server reports the console's QTI version", {
    skip_without_maxima_packages()
    withr::local_options(list(rqti.qti_version = "2.2"))
    app <- make_maxima_preview_app(tempdir(), "http://127.0.0.1:12345")$app
    config <- app$call(list(PATH_INFO = "/.rqti-maxima/config", REQUEST_METHOD = "GET"))
    expect_identical(jsonlite::fromJSON(config$body)$options$qti_version, "2.2")
})

test_that("QTI 2.2 items use the 2.2 namespace and validate against QTI 2.2", {
    withr::local_options(list(rqti.qti_version = "2.2"))
    item <- essay(identifier = "essay22", prompt = "Explain.", data_allow_paste = FALSE)
    path <- file.path(withr::local_tempdir(), "essay22.xml")
    expect_no_error(create_qti_task(item, path, verification = TRUE))

    doc <- xml2::read_xml(path)
    expect_true("http://www.imsglobal.org/xsd/imsqti_v2p2" %in% xml2::xml_ns(doc))
    expect_match(xml2::xml_attr(doc, "schemaLocation"), "qtiv2p2/imsqti_v2p2.xsd",
                 fixed = TRUE)
    # data-* attributes are QTI 2.2 data extensions.
    interaction <- xml2::xml_find_first(doc, "//*[local-name()='extendedTextInteraction']")
    expect_identical(xml2::xml_attr(interaction, "data-allowPaste"), "false")

    result <- verify_qti(path, print = FALSE)
    expect_true(result$valid)
    expect_identical(result$schema, "imsqti_v2p2.xsd")
    expect_false(verify_qti(path, schema = "qti21", print = FALSE)$valid)
})

test_that("QTI 2.2 tests and content packages declare QTI 2.2", {
    withr::local_options(list(rqti.qti_version = "2.2"))
    items <- list(singleChoice(identifier = "sc22", choices = c("A", "B")),
                  essay(identifier = "essay22", prompt = "Explain."))
    exam <- assessmentTest(list(assessmentSection(items, identifier = "s22")),
                           identifier = "test22", rebuild_variables = NA)

    out <- withr::local_tempdir()
    archive <- createQtiTest(exam, dir = out, zip_only = TRUE)
    expect_true(is_test(archive))
    files <- utils::unzip(archive, exdir = file.path(out, "unzipped"))
    manifest <- paste(readLines(files[basename(files) == "imsmanifest.xml"], warn = FALSE),
                      collapse = "\n")
    expect_match(manifest, "imsqti_test_xmlv2p2", fixed = TRUE)
    expect_match(manifest, "imsqti_item_xmlv2p2", fixed = TRUE)
    expect_match(manifest, "IMS QTI 2.2", fixed = TRUE)
    expect_false(grepl("v2p1", manifest, fixed = TRUE))

    results <- verify_qti(exam, print = FALSE)
    expect_length(results, 3L)
    expect_true(all(vapply(results, function(x) x$valid, logical(1))))
    expect_true(all(vapply(results, function(x) x$schema, "") == "imsqti_v2p2.xsd"))
})
