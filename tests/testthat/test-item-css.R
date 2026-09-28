css_question <- function(dir, yaml = character(), id = "styled") {
    dir.create(dir, recursive = TRUE, showWarnings = FALSE)
    path <- file.path(dir, paste0(id, ".Rmd"))
    writeLines(c("---", paste0("identifier: ", id), "type: sc", yaml,
                 "---", "", "# question", "",
                 '<p class="highlight">Choose one.</p>', "",
                 "- *Yes*", "- No"), path)
    path
}

css_xml_hrefs <- function(doc, xpath) {
    xml2::xml_attr(xml2::xml_find_all(doc, xpath), "href")
}

test_that("Rmd YAML supports relative file paths and CSS text in order", {
    root <- tempfile()
    on.exit(unlink(root, recursive = TRUE), add = TRUE)
    src <- css_question(file.path(root, "source"), c(
        "stylesheet_path:", "  - first.css", "  - second.css",
        "css: |", "  .highlight { color: green; }"))
    writeLines(".highlight { color: red; }", file.path(dirname(src), "first.css"))
    writeLines(".highlight { color: blue; }", file.path(dirname(src), "second.css"))
    item <- create_question_object(src)
    expect_equal(
        item@stylesheet_path,
        normalizePath(
            file.path(dirname(src), c("first.css", "second.css")),
            winslash = "/"
        )
    )
    expect_match(item@css, "color: green", fixed = TRUE)
    # Parsed objects keep absolute paths and can be exported from another cwd.
    out <- file.path(root, "output")
    createQtiTask(item, dir = out, verification = TRUE)
    doc <- xml2::read_xml(file.path(out, "styled.xml"))
    hrefs <- css_xml_hrefs(doc, ".//d1:stylesheet")
    expect_length(hrefs, 3)
    expect_equal(vapply(file.path(out, hrefs), function(p) paste(readLines(p), collapse = ""), ""),
                 c(".highlight { color: red; }", ".highlight { color: blue; }",
                   ".highlight { color: green; }"), ignore_attr = TRUE)
    expect_true(verify_qti(doc, print = FALSE)$valid)
    expect_match(as.character(doc), 'class="highlight"', fixed = TRUE)
})

test_that("CSS files survive item ZIPs and have manifest entries", {
    root <- tempfile()
    dir.create(root)
    on.exit(unlink(root, recursive = TRUE), add = TRUE)
    src <- css_question(file.path(root, "source"), "stylesheet_path: style.css")
    css <- file.path(dirname(src), "style.css")
    writeBin(charToRaw("/* café */\r\n.highlight { color: blue; }\r\n"), css)
    item <- create_question_object(src)
    archive <- suppressMessages(createQtiTask(item, dir = file.path(root, "out"), zip = TRUE, verification = TRUE))
    extracted <- file.path(root, "extracted")
    unzip(archive, exdir = extracted)
    doc <- xml2::read_xml(file.path(extracted, "styled.xml"))
    hrefs <- css_xml_hrefs(doc, ".//d1:stylesheet")
    manifest <- xml2::read_xml(file.path(extracted, "imsmanifest.xml"))
    expect_true(all(hrefs %in% css_xml_hrefs(manifest, ".//d1:resource/d1:file")))
    expect_equal(unname(tools::md5sum(file.path(extracted, hrefs))), unname(tools::md5sum(css)))
    expect_true(verify_qti(doc, print = FALSE)$valid)
})

test_that("rmd2zip bundles embedded YAML CSS under the renamed item identifier", {
    root <- tempfile()
    on.exit(unlink(root, recursive = TRUE), add = TRUE)
    src <- css_question(file.path(root, "source"), c("css: |", "  .highlight { color: purple; }"))
    archive <- suppressMessages(rmd2zip(src, path = file.path(root, "out")))
    extracted <- file.path(root, "extracted")
    unzip(archive, exdir = extracted)
    doc <- xml2::read_xml(file.path(extracted, "task_styled.xml"))
    hrefs <- css_xml_hrefs(doc, ".//d1:stylesheet")
    expect_length(hrefs, 1)
    expect_true(all(file.exists(file.path(extracted, hrefs))))
    expect_match(readLines(file.path(extracted, hrefs))[1], "color: purple", fixed = TRUE)
    manifest <- xml2::read_xml(file.path(extracted, "imsmanifest.xml"))
    expect_true(all(hrefs %in% css_xml_hrefs(manifest, ".//d1:resource[@identifier='task_styled']/d1:file")))
    expect_true(verify_qti(doc, print = FALSE)$valid)
})

test_that("nested sections and same CSS basenames have independent assets", {
    root <- tempfile()
    on.exit(unlink(root, recursive = TRUE), add = TRUE)
    items <- lapply(c("red", "blue"), function(color) {
        src <- css_question(file.path(root, color), "stylesheet_path: style.css", id = color)
        writeLines(paste0(".highlight { color: ", color, "; }"), file.path(dirname(src), "style.css"))
        create_question_object(src)
    })
    exam <- test(section(list(section(items[[1]]), section(items[[2]]))),
                 identifier = "exam_css", rebuild_variables = NA)
    archive <- suppressMessages(createQtiTest(exam, dir = file.path(root, "out"), zip_only = TRUE))
    extracted <- file.path(root, "extracted")
    unzip(archive, exdir = extracted)
    manifest <- xml2::read_xml(file.path(extracted, "imsmanifest.xml"))
    all_hrefs <- character()
    for (id in c("red", "blue")) {
        doc <- xml2::read_xml(file.path(extracted, paste0(id, ".xml")))
        hrefs <- css_xml_hrefs(doc, ".//d1:stylesheet")
        expect_length(hrefs, 1)
        expect_true(all(hrefs %in% css_xml_hrefs(manifest, paste0(".//d1:resource[@identifier='", id, "']/d1:file"))))
        expect_match(readLines(file.path(extracted, hrefs)), paste0("color: ", id), fixed = TRUE)
        expect_true(verify_qti(doc, print = FALSE)$valid)
        all_hrefs <- c(all_hrefs, hrefs)
    }
    expect_equal(length(unique(all_hrefs)), 2)
    expect_true(verify_qti(file.path(extracted, "exam_css.xml"), print = FALSE)$valid)
})

test_that("YAML CSS input errors are actionable", {
    root <- tempfile()
    on.exit(unlink(root, recursive = TRUE), add = TRUE)
    for (yaml in c("stylesheet_path: 123", "stylesheet_path: ['']",
                   "stylesheet_path: [style.css, 42]")) {
        expect_error(create_question_object(css_question(root, yaml)), "stylesheet_path")
    }
    for (yaml in c("css: 123", "css: [a, b]", "css: {a: b}")) {
        expect_error(create_question_object(css_question(root, yaml)), "single string of CSS")
    }
    expect_error(create_question_object(css_question(root, "stylesheet_path: missing.css")), "do not exist")
    expect_error(create_question_object(css_question(root, "stylesheet_path: '.'")), "refer to files")
})

test_that("questions without CSS retain their existing XML and manifest shape", {
    root <- tempfile()
    on.exit(unlink(root, recursive = TRUE), add = TRUE)
    for (yaml in list(character(), c("css: null", "stylesheet_path: null"))) {
        item <- create_question_object(css_question(root, yaml))
        expect_identical(item@css, character())
        expect_identical(item@stylesheet_path, character())
        doc <- xml2::read_xml(as.character(create_assessment_item(item)))
        expect_length(xml2::xml_find_all(doc, ".//d1:stylesheet"), 0)
        manifest <- xml2::read_xml(as.character(create_manifest_task(item)))
        expect_identical(css_xml_hrefs(manifest, ".//d1:resource/d1:file"), "styled.xml")
    }
})

test_that("standalone XML and preview exports keep stylesheet files alongside XML", {
    root <- tempfile()
    on.exit(unlink(root, recursive = TRUE), add = TRUE)
    src <- css_question(file.path(root, "source"), c("css: |", "  .highlight { font-size: 200%; }"))
    out <- file.path(root, "out")
    rmd2xml(src, path = out, verification = TRUE)
    item <- create_question_object(src)
    prepareQTIJSFiles(item, out)
    for (name in c("styled.xml", "index.xml")) {
        doc <- xml2::read_xml(file.path(out, name))
        hrefs <- css_xml_hrefs(doc, ".//d1:stylesheet")
        expect_length(hrefs, 1)
        expect_true(all(file.exists(file.path(out, hrefs))))
    }
})

test_that("multiple-choice variants retain CSS and get distinct references", {
    root <- tempfile()
    on.exit(unlink(root, recursive = TRUE), add = TRUE)
    src <- css_question(file.path(root, "source"), c("css: |", "  .highlight { color: green; }"))
    lines <- readLines(src)
    writeLines(sub("^type: sc$", "type: mc", lines), src)
    variants <- section(src, n_variants = 2, seed_number = c(17, 42))
    exam <- test(variants, identifier = "mc_css", rebuild_variables = NA)
    archive <- suppressMessages(createQtiTest(exam, dir = file.path(root, "out"), zip_only = TRUE))
    extracted <- file.path(root, "extracted")
    unzip(archive, exdir = extracted)
    manifest <- xml2::read_xml(file.path(extracted, "imsmanifest.xml"))
    hrefs <- character()
    for (id in c("styled_S17", "styled_S42")) {
        doc <- xml2::read_xml(file.path(extracted, paste0(id, ".xml")))
        ref <- css_xml_hrefs(doc, ".//d1:stylesheet")
        expect_length(ref, 1)
        expect_true(file.exists(file.path(extracted, ref)))
        expect_true(ref %in% css_xml_hrefs(manifest, paste0(".//d1:resource[@identifier='", id, "']/d1:file")))
        expect_true(verify_qti(doc, print = FALSE)$valid)
        hrefs <- c(hrefs, ref)
    }
    expect_length(unique(hrefs), 2)
})

test_that("missing CSS files at export fail rather than produce broken links", {
    root <- tempfile()
    on.exit(unlink(root, recursive = TRUE), add = TRUE)
    src <- css_question(root, "stylesheet_path: style.css")
    path <- file.path(root, "style.css")
    writeLines(".highlight {}", path)
    item <- create_question_object(src)
    unlink(path)
    expect_error(createQtiTask(item, dir = file.path(root, "out")), "do not exist")
    expect_false(file.exists(file.path(root, "out", "styled.xml")))
})

test_that("named item lists include CSS in each manifest resource", {
    root <- tempfile()
    on.exit(unlink(root, recursive = TRUE), add = TRUE)
    items <- list(first = new("SingleChoice", identifier = "named_css",
        choices = c("Yes", "No"), solution = 1, css = ".highlight { color: blue; }"))
    exam <- assessmentTest(identifier = "named_exam",
        section = list(assessmentSection(items, identifier = "named_section")))
    archive <- suppressMessages(createQtiTest(exam, dir = root, zip_only = TRUE))
    unpacked <- file.path(root, "unpacked")
    unzip(archive, exdir = unpacked)
    doc <- xml2::read_xml(file.path(unpacked, "named_css.xml"))
    hrefs <- css_xml_hrefs(doc, ".//d1:stylesheet")
    manifest <- xml2::read_xml(file.path(unpacked, "imsmanifest.xml"))
    expect_length(hrefs, 1)
    expect_true(all(file.exists(file.path(unpacked, hrefs))))
    expect_true(all(hrefs %in% css_xml_hrefs(manifest,
        ".//d1:resource[@href='named_css.xml']/d1:file")))
})
