source(test_path("test_helpers.R"))
test_that("test rmd2zip", {
    # this parts tests path with file name
    file <- test_path("file/rmd/Gap_primitive.Rmd")
    suppressMessages(rmd2zip(file, "to_delete/subfolder/test_exam.zip"))
    sut1 <- sort(list.files("to_delete/subfolder"))
    expected1 <- "test_exam.zip"
    expect_equal(sut1, expected1)
    unlink("to_delete", recursive = TRUE)
    # this part tests path without file name
    suppressMessages(rmd2zip(file, "to_delete/subfolder"))
    sut2 <- sort(list.files("to_delete/subfolder"))
    expected2 <- "test_entry_example.zip"
    expect_equal(sut2, expected2)
    unlink("to_delete", recursive = TRUE)
})

test_that("test rmd2xml", {
    file <- test_path("file/rmd/Gap_primitive.Rmd")
    suppressMessages(rmd2xml(file, "to_delete/index.xml"))
    sut <- list.files("to_delete")
    expected <- "index.xml"
    expect_equal(sut, expected)
    unlink("to_delete", recursive = TRUE)
})

test_that("single-Rmd archives preserve titles with a source filename fallback", {
    root <- withr::local_tempdir()
    for (title in list('title: "Algebra & sets"', character())) {
        file <- file.path(root, "minimal-latex.Rmd")
        writeLines(c("---", "type: essay", "identifier: minimal_latex", title,
                     "---", "", "# question", "", "Explain the formula."), file)
        expected <- if (length(title)) "Algebra & sets" else "minimal-latex"
        archive <- suppressMessages(rmd2zip(file, path=file.path(root, "out")))
        extracted <- file.path(root, "extracted")
        zip::unzip(archive, exdir=extracted, overwrite=TRUE)
        test <- xml2::read_xml(file.path(extracted, "minimal_latex.xml"))
        item <- xml2::read_xml(file.path(extracted, "task_minimal_latex.xml"))
        expect_identical(xml2::xml_attr(test, "title"), expected)
        expect_identical(xml2::xml_attr(item, "title"), expected)
        manifest <- xml2::read_xml(file.path(extracted, "imsmanifest.xml"))
        expect_true(expected %in% xml2::xml_text(xml2::xml_find_all(manifest,
            ".//*[local-name()='title']/*[local-name()='string']")))
    }
})

test_that("XML exports and Knit copies preserve source punctuation independently of identifiers", {
    root <- withr::local_tempdir()
    renderer <- file.path(root, "renderer")
    dir.create(renderer)
    withr::local_envvar(c(RQTI_URL="http://127.0.0.1:12345",
                         RQTI_QTIJS_PATH=renderer, RSTUDIO="0", RQTI_SERVER_PID=NA))
    for (stem in c("minimal-latex", "minimal_latex")) {
        file <- file.path(root, paste0(stem, ".Rmd"))
        writeLines(c("---", "type: essay", "identifier: different_identifier", "---", "",
                     "# question", "", "Explain the formula."), file)
        exported <- rmd2xml(file, path=file.path(root, "export"))
        expect_identical(basename(exported), paste0(stem, ".xml"))
        copied <- file.path(root, paste0(stem, ".xml"))
        writeLines("stale preview", copied)
        suppressMessages(render_qtijs(file))
        doc <- xml2::read_xml(copied)
        expect_identical(xml2::xml_attr(doc, "identifier"), "different_identifier")
        expect_identical(readLines(copied), readLines(exported))
        expect_identical(readLines(copied), readLines(file.path(renderer, "index.xml")))
        explicit <- rmd2xml(file, path=file.path(root, "chosen.xml"))
        expect_identical(basename(explicit), "chosen.xml")
    }
})

test_that("detect_rmd_format() detects rqti, exams, and unknown Rmd files", {
    rqti_file <- tempfile(fileext = ".Rmd")
    writeLines(c("---", "title: Example", "---", "", "Question"), rqti_file)

    exams_file <- tempfile(fileext = ".Rmd")
    writeLines(c("Question", "", "Meta-information", "extype: schoice"),
               exams_file)

    unknown_file <- tempfile(fileext = ".Rmd")
    writeLines("Question without metadata", unknown_file)

    expect_equal(detect_rmd_format(rqti_file), "rqti_rmd")
    expect_equal(detect_rmd_format(exams_file), "exams_rmd")
    expect_equal(detect_rmd_format(unknown_file), "unknown")
    expect_error(
        detect_rmd_format("missing_file.Rmd"),
        "File does not exist"
    )
})

testthat::skip_if_not_installed("XML")
test_that("test abbreviate for rmd2xml() in OneInRowTable class", {
    file_sut <- test_path("file/rmd/OneInRowTable_abbr_example.Rmd")
    sut <- suppressMessages(rmd2xml(file_sut, "to_delete/index.xml"))
    sut <- readLines(sut)
    unlink("to_delete", recursive = TRUE)
    expected <- readLines(test_path("file/xml/OneInRowTable_abbr.xml"))
    equal_xml(sut, expected)
})

testthat::skip_if_not_installed("XML")
test_that("test abbreviate for rmd2xml() in OneInColTable class", {
    file_sut <- test_path("file/rmd/OnInColTable_abbr_example.Rmd")
    sut <- suppressMessages(rmd2xml(file_sut, "to_delete/index.xml"))
    sut <- readLines(sut)
    unlink("to_delete", recursive = TRUE)
    expected <- readLines(test_path("file/xml/OneInColTable_abbr.xml"))
    equal_xml(sut, expected)
})

testthat::skip_if_not_installed("XML")
test_that("test abbreviate for rmd2xml() in MultipleChoiceTable class", {
    file_sut <- test_path("file/rmd/MultipleChoiceTable_abbr_example.Rmd")
    sut <- suppressMessages(rmd2xml(file_sut, "to_delete/index.xml"))
    sut <- readLines(sut)
    unlink("to_delete", recursive = TRUE)
    expected <- readLines(test_path("file/xml/MultipleChoiceTable_abbr.xml"))
    equal_xml(sut, expected)
})

testthat::skip_if_not_installed("XML")
test_that("test abbreviate for rmd2xml() in DirectPair class", {
    file_sut <- test_path("file/rmd/directedPair_abbr_example.Rmd")
    sut <- suppressMessages(rmd2xml(file_sut, "to_delete/index.xml"))
    sut <- readLines(sut)
    unlink("to_delete", recursive = TRUE)
    expected <- readLines(test_path("file/xml/DirectedPair_abbr.xml"))
    expected <- sub('title="test_abb_direct_pair_example"',
                    'title="directedPair_abbr_example"', expected, fixed=TRUE)
    equal_xml(sut, expected)
})
