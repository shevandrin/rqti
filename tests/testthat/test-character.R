test_that("Testing createQtiTest() method for the object of character
          in case if the file does not exist", {

        path <- test_path("fileNotExist.xml")

        expect_error({
            createQtiTest(path)
            }, "The file does not exist")
})

test_that("Testing createQtiTest() method for the object of character
          in case if the file exist", {

        path_1 <- test_path("file/xml/Order.xml")
        path_2 <- test_path("file/rmd/OneInRowTable_example.Rmd")

        sut_1 <- suppressMessages(createQtiTest(path_1))
        sut_2 <- suppressMessages(createQtiTest(path_2))

        expected_path_1 <- file.path(getwd(),"Preview.zip")
        expected_path_2 <- file.path(getwd(),"test_OneInRowTable_example.zip")

        expect_equal(sut_1,expected_path_1)
        expect_equal(sut_2,expected_path_2)
        unlink("Preview.zip",recursive = TRUE)
        unlink("test_OneInRowTable_example.zip",recursive = TRUE)
})

test_that("createQtiTask() for character rejects multiple and missing files", {
        paths <- c(
            test_path("file/xml/Essay.xml"),
            test_path("file/xml/Order.xml")
        )

        expect_error(
            createQtiTask(paths),
            "Only one file can be provided as input."
        )

        expect_error(
            createQtiTask(test_path("fileNotExist.md")),
            "The file does not exist"
        )
})

test_that("createQtiTask() for character returns zip files unchanged", {
        path <- test_path("file/test_result.zip")

        sut <- createQtiTask(path, dir = tempdir(), zip = TRUE)

        expect_identical(sut, path)
        expect_true(file.exists(sut))
})

test_that("createQtiTask() for character converts Rmd and md files", {
        out_dir <- tempfile("rqti-character-")
        dir.create(out_dir)

        rmd_path <- test_path("file/rmd/OneInRowTable_example.Rmd")
        md_path <- test_path("file/md/essay_example.md")

        rmd_sut <- suppressMessages(createQtiTask(rmd_path, dir = out_dir,
                                                  zip = TRUE))
        md_sut <- suppressMessages(createQtiTask(md_path, dir = out_dir,
                                                 zip = FALSE))

        expect_true(file.exists(rmd_sut))
        expect_true(file.exists(md_sut))
        expect_match(basename(rmd_sut), "\\.zip$")
        expect_match(basename(md_sut), "\\.xml$")
})

test_that("getObject() for character handles xml, Rmd, and md files", {
        xml_path <- test_path("file/xml/Essay.xml")
        rmd_path <- test_path("file/rmd/OneInRowTable_example.Rmd")
        md_path <- test_path("file/md/essay_example.md")

        xml_sut <- getObject(xml_path)
        rmd_sut <- getObject(rmd_path)
        md_sut <- getObject(md_path)

        expect_type(xml_sut, "character")
        expect_true(file.exists(xml_sut))
        expect_match(basename(xml_sut), "\\.xml$")

        expect_s4_class(rmd_sut, "OneInRowTable")
        expect_identical(rmd_sut@identifier, "test_OneInRowTable_example")

        expect_s4_class(md_sut, "Essay")
        expect_identical(md_sut@identifier, "test_2")
})

test_that("prepareQTIJSFiles() for character rejects missing files", {
        expect_error(
            prepareQTIJSFiles(test_path("fileNotExist.xml"), tempdir()),
            "The file does not exist"
        )
})

test_that("prepareQTIJSFiles() for character prepares XML input", {
        out_dir <- tempfile("rqti-qtijs-xml-")
        dir.create(out_dir)

        res <- prepareQTIJSFiles(test_path("file/xml/Essay.xml"), out_dir)
        index_path <- file.path(out_dir, "index.xml")

        expect_null(res)
        expect_true(file.exists(index_path))
        expect_equal(xml2::xml_name(xml2::read_xml(index_path)), "assessmentItem")
})

test_that("prepareQTIJSFiles() for character prepares Rmd input", {
        out_dir <- tempfile("rqti-qtijs-rmd-")
        dir.create(out_dir)
        rmd_path <- file.path(out_dir, "essay_preview.Rmd")
        writeLines(c(
            "---",
            "identifier: essay_preview",
            "type: essay",
            "title: Essay Preview",
            "---",
            "# question",
            "Write a short answer."
        ), rmd_path)

        res <- suppressMessages(prepareQTIJSFiles(rmd_path, out_dir))
        index_path <- file.path(out_dir, "index.xml")
        sidecar_xml <- file.path(out_dir, "essay_preview.xml")

        expect_null(res)
        expect_true(file.exists(index_path))
        expect_true(file.exists(sidecar_xml))
        expect_equal(xml2::xml_name(xml2::read_xml(index_path)), "assessmentItem")
})

test_that("xml_preparation() returns unchanged XML paths without images", {
        xml_path <- test_path("file/xml/Essay.xml")

        sut <- xml_preparation(xml_path)

        expect_identical(sut, xml_path)
})

test_that("xml_preparation() embeds local image references", {
        xml_dir <- tempfile("rqti-xml-image-")
        dir.create(xml_dir)
        image_path <- file.path(xml_dir, "figure.png")
        xml_path <- file.path(xml_dir, "item.xml")
        writeBin(charToRaw("fake image"), image_path)
        writeLines(
            '<assessmentItem identifier="image_item"><itemBody><img src="figure.png"/></itemBody></assessmentItem>',
            xml_path
        )

        sut <- xml_preparation(xml_path)
        doc <- xml2::read_xml(sut)
        src <- xml2::xml_attr(xml2::xml_find_first(doc, ".//*[local-name()='img']"),
                              "src")

        expect_true(file.exists(sut))
        expect_match(src, "^data:image/png;base64,")
})

test_that("xml_preparation() warns when referenced images are missing", {
        xml_dir <- tempfile("rqti-xml-missing-image-")
        dir.create(xml_dir)
        xml_path <- file.path(xml_dir, "item.xml")
        writeLines(
            '<assessmentItem identifier="missing_image_item"><itemBody><img src="missing.png"/></itemBody></assessmentItem>',
            xml_path
        )

        expect_warning(
            sut <- xml_preparation(xml_path),
            "Image file does not exist: missing.png"
        )
        doc <- xml2::read_xml(sut)
        src <- xml2::xml_attr(xml2::xml_find_first(doc, ".//*[local-name()='img']"),
                              "src")

        expect_identical(src, "missing.png")
})
