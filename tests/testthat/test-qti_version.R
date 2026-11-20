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

item_namespace <- function(path) {
    unname(xml2::xml_ns(xml2::read_xml(path))[["d1"]])
}

zip_manifest <- function(archive) {
    zip_con <- unz(archive, "imsmanifest.xml")
    on.exit(close(zip_con))
    paste(readLines(zip_con, warn = FALSE), collapse = "\n")
}

test_that("qti_version arguments override the option for one export", {
    withr::local_options(list(rqti.qti_version = NULL))
    withr::local_envvar(c(RQTI_SERVER_PID = NA))
    item <- singleChoice(identifier = "sc_version", choices = c("A", "B"))
    out <- withr::local_tempdir()

    createQtiTask(item, dir = file.path(out, "a.xml"), qti_version = "2.2")
    expect_identical(item_namespace(file.path(out, "a.xml")),
                     "http://www.imsglobal.org/xsd/imsqti_v2p2")
    expect_null(getOption("rqti.qti_version"))

    options(rqti.qti_version = "2.2")
    createQtiTask(item, dir = file.path(out, "b.xml"), qti_version = "2.1")
    expect_identical(item_namespace(file.path(out, "b.xml")),
                     "http://www.imsglobal.org/xsd/imsqti_v2p1")
    expect_identical(getOption("rqti.qti_version"), "2.2")

    exam <- assessmentTest(list(assessmentSection(list(item), identifier = "s")),
                           identifier = "version_test", rebuild_variables = NA)
    archive <- createQtiTest(exam, dir = file.path(out, "test"), zip_only = TRUE,
                             qti_version = "2.1")
    expect_match(zip_manifest(archive), "imsqti_test_xmlv2p1", fixed = TRUE)
    expect_identical(getOption("rqti.qti_version"), "2.2")

    expect_error(createQtiTask(item, dir = out, qti_version = "3.0"),
                 "must be \"2.1\" or \"2.2\"", fixed = TRUE)
    expect_identical(getOption("rqti.qti_version"), "2.2")
})

test_that("Rmd exports pass qti_version through", {
    withr::local_options(list(rqti.qti_version = NULL))
    withr::local_envvar(c(RQTI_SERVER_PID = NA))
    rmd <- system.file("rmarkdown", "templates", "singlechoice-simple",
                       "skeleton", "skeleton.Rmd", package = "rqti")
    out <- withr::local_tempdir()

    suppressMessages(rmd2xml(rmd, file.path(out, "task.xml"), qti_version = "2.2"))
    expect_identical(item_namespace(file.path(out, "task.xml")),
                     "http://www.imsglobal.org/xsd/imsqti_v2p2")

    archive <- suppressMessages(rmd2zip(rmd, out, qti_version = "2.2"))
    expect_match(zip_manifest(archive), "imsqti_item_xmlv2p2", fixed = TRUE)
    expect_null(getOption("rqti.qti_version"))
})

test_that("the extended QTI 2.2 schema accepts rqti's OPAL extensions", {
    withr::local_options(list(rqti.qti_version = "2.2"))
    withr::local_envvar(c(RQTI_SERVER_PID = NA))
    out <- withr::local_tempdir()
    supplement <- file.path(out, "sheet.pdf")
    writeLines("formulas", supplement)
    details <- "<details><summary>Hint</summary><p>Text</p></details>"
    gaps <- entry(identifier = "gaps22", content = list(
        "<p>A</p>", details, "<p>B ",
        new("TextGapOpal", response_identifier = "R1", solution = c("more", "More"),
            tolerance = 2),
        "</p>"))
    maxima <- entry(identifier = "maxima22",
                    template = list(maxima_variables(
                        code = "block([a], a: random(10) + 1, string(['a = a]));",
                        variables = c(a = "integer"))),
                    content = list("<p>", template_value("a"), " = ",
                                   numericGap(solution_variable = "a",
                                              response_identifier = "R2"), "</p>"))
    exam <- assessmentTestOpal(list(assessmentSection(list(gaps, maxima), identifier = "s")),
                               identifier = "opal22", calculator = "scientific",
                               files = supplement)
    archive <- createQtiTest(exam, dir = out, zip_only = TRUE)
    files <- utils::unzip(archive, exdir = file.path(out, "unzipped"))
    roots <- vapply(files, function(f) {
        if (grepl("\\.xml$", f)) xml2::xml_name(xml2::read_xml(f)) else ""
    }, character(1))
    documents <- files[roots %in% c("assessmentTest", "assessmentItem")]
    expect_length(documents, 3L)

    for (f in documents) {
        expect_false(verify_qti(f, print = FALSE)$valid)
        extended <- verify_qti(f, extended_schema = TRUE, print = FALSE)
        expect_true(extended$valid, info = basename(f))
        expect_identical(extended$schema, "qti_v2p2_extension.xsd")
        expect_identical(verify_qti(f, schema = "extended", print = FALSE)$schema,
                         "qti_v2p2_extension.xsd")
    }
    test_xml <- paste(readLines(files[roots == "assessmentTest"], warn = FALSE),
                      collapse = "\n")
    expect_false(verify_qti(sub('rebuildVariables="true"', 'rebuildVariables="maybe"',
                                test_xml, fixed = TRUE),
                            schema = "extended", print = FALSE)$valid)
})
