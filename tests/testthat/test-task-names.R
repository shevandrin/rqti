name_fixture <- function(root, stem = "source-name", title = "Algebra & sets") {
    file <- file.path(root, paste0(stem, ".Rmd"))
    writeLines(c("---", "type: essay", "identifier: internal_id",
                 if (!is.null(title)) paste0('title: "', title, '"'),
                 "---", "", "# question", "", "Explain."), file)
    file
}

archive_name_titles <- function(archive) {
    root <- withr::local_tempdir()
    zip::unzip(archive, exdir = root)
    docs <- lapply(list.files(root, "\\.xml$", recursive=TRUE, full.names=TRUE), xml2::read_xml)
    test <- Filter(function(doc) xml2::xml_name(doc) == "assessmentTest", docs)[[1]]
    items <- Filter(function(doc) xml2::xml_name(doc) == "assessmentItem", docs)
    manifest <- xml2::read_xml(file.path(root,"imsmanifest.xml"))
    list(test=xml2::xml_attr(test, "title"),
         items=vapply(items, xml2::xml_attr, "", "title"),
         manifest=xml2::xml_text(xml2::xml_find_first(manifest,
             ".//*[local-name()='general']/*[local-name()='title']/*")))
}

test_that("preview, XML, test ZIPs and generic conversion share all four naming modes", {
    root <- withr::local_tempdir()
    file <- name_fixture(root)
    renderer <- file.path(root, "renderer")
    dir.create(renderer)
    withr::local_envvar(c(RQTI_URL="http://127.0.0.1:12345", RQTI_QTIJS_PATH=renderer,
                         RQTI_SERVER_PID=NA, RSTUDIO="0"))
    expected <- c(title="Algebra & sets", filename="source-name",
                  both="Algebra & sets (source-name)", hidden="Task 1.1")
    for (mode in names(expected)) {
        withr::with_options(list(rqti.task_names=mode), {
            xml <- rmd2xml(file, file.path(root, mode))
            expect_identical(xml2::xml_attr(xml2::read_xml(xml), "title"), expected[[mode]])
            expect_true(verify_qti(xml, print=FALSE)$valid)
            suppressMessages(render_qtijs(file))
            expect_identical(xml2::xml_attr(xml2::read_xml(file.path(renderer, "index.xml")), "title"), expected[[mode]])
            for (archive in list(rmd2zip(file, file.path(root, mode)),
                                 createQtiTest(file, file.path(root, paste0(mode, "-generic")), zip_only=TRUE),
                                 createQtiTest(create_question_object(file), file.path(root,paste0(mode,"-object")), zip_only=TRUE))) {
                titles <- archive_name_titles(archive)
                expect_identical(unname(titles$items), expected[[mode]])
                expect_identical(titles$test, if (mode == "hidden") "Test" else expected[[mode]])
            }
        })
    }
    withr::local_options(list(rqti.task_names="hidden"))
    explicit <- rmd2xml(file, root, task_names="title")
    expect_identical(xml2::xml_attr(xml2::read_xml(explicit), "title"), "Algebra & sets")
    expect_identical(create_question_object(file)@title, "Algebra & sets")
    writeLines("preserve", file.path(renderer, "index.xml"))
    expect_error(render_qtijs(file, task_names="invalid"), "rqti.task_names")
    expect_identical(readLines(file.path(renderer, "index.xml")), "preserve")
})

test_that("title defaults, missing titles and both avoid redundant labels", {
    root <- withr::local_tempdir()
    withr::local_options(list(rqti.task_names=NULL))
    file <- name_fixture(root, title=NULL)
    expect_identical(archive_name_titles(rmd2zip(file, root))$items, "source-name")
    expect_identical(archive_name_titles(rmd2zip(file, root, task_names="both"))$items, "source-name")
    expect_identical(task_name_mode(), "title")
    for (bad in list(NA_character_, character(), c("title","hidden"), TRUE)) {
        expect_error(task_name_mode(bad), "rqti.task_names")
    }
})

test_that("nested exports hide XML and Rmd tasks without modifying originals", {
    root <- withr::local_tempdir()
    file <- name_fixture(root)
    xml <- rmd2xml(file, root)
    doc <- xml2::read_xml(xml)
    xml2::xml_attr(doc, "identifier") <- "xml_id"
    xml2::write_xml(doc, xml)
    original <- readBin(xml, "raw", n=file.info(xml)$size)
    s <- section(list(file, section(xml)))
    exam <- test(s, identifier="names", title="Exam")
    withr::local_options(list(rqti.task_names="hidden"))
    titles <- archive_name_titles(createQtiTest(exam, root, zip_only=TRUE))
    expect_setequal(titles$items, c("Task 1.1", "Task 1.1.1"))
    expect_identical(readBin(xml,"raw",n=file.info(xml)$size), original)
    named <- archive_name_titles(createQtiTest(exam, root, zip_only=TRUE, task_names="both"))
    expect_identical(named$test, "Exam (names)")
    expect_true(all(grepl("Algebra & sets", named$items, fixed=TRUE)))
    legacy <- test(section(file), fallback_titles="generic")
    expect_identical(archive_name_titles(createQtiTest(legacy, root, zip_only=TRUE))$items, "Task 1.1")
})

test_that("existing archives respect naming overrides and preserve their filenames", {
    root <- withr::local_tempdir()
    file <- name_fixture(root)
    archive <- rmd2zip(file, root)
    before <- readBin(archive,"raw",n=file.info(archive)$size)
    hidden <- createQtiTest(archive, task_names="hidden")
    expect_identical(basename(hidden), basename(archive))
    expect_identical(archive_name_titles(hidden)$items, "Task 1.1")
    expect_identical(archive_name_titles(hidden)$manifest, "Test")
    expect_identical(readBin(archive,"raw",n=file.info(archive)$size),before)
    both <- rmd2zip(file,root,task_names="both")
    repeated <- createQtiTest(both,task_names="both")
    expect_identical(archive_name_titles(repeated)$items,"Algebra & sets (source-name)")
    expect_identical(archive_name_titles(repeated)$test,"Algebra & sets (source-name)")
})

test_that("OPAL uploads derive repository names from the selected test title", {
    root <- withr::local_tempdir()
    file <- name_fixture(root)
    local_mocked_bindings(get_password=function(...) list(api_user="tester", api_password="secret"),
                          authLMS=function(...) 200,
                          getLMSResourcesByName=function(...) data.frame(),
                          .package="rqti")
    con <- opal(api_user="tester",endpoint="https://opal.example/")
    captured <- NULL
    local_mocked_bindings(upload_resource=function(file, display_name, ...) {
        captured <<- list(display_name=display_name, titles=archive_name_titles(file))
        structure(list(status_code=200L),class="mock_response")
    }, resp_body_xml=function(...) xml2::read_xml('<repositoryEntry><key>1</key><displayname>name</displayname></repositoryEntry>'),
    .package="rqti")
    withr::local_options(list(rqti.task_names="hidden"))
    upload2LMS(con,file,open_in_browser=FALSE)
    expect_identical(captured$display_name,"Test")
    expect_identical(captured$titles$items,"Task 1.1")
    upload2LMS(con,file,display_name="Explicit resource",task_names="title",open_in_browser=FALSE)
    expect_identical(captured$display_name,"Explicit resource")
    expect_identical(captured$titles$items,"Algebra & sets")
})
