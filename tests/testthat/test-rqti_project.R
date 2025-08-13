
test_that("Project template creates expected files", {
    tmpdir <- tempdir()

    rqti:::rqti_project(tmpdir, templates = "YES", render = "OPAL",
                        start_server = "TRUE")
    src <- file.path(tmpdir, "main.R")
    lines <- readLines(src)
    lines <- lines[!grepl("render_|upload2", lines)]
    lines <- append(lines, "library(rqti)", 0)
    writeLines(lines, file.path(tmpdir, "main2.R"))
    source(file.path(tmpdir, "main2.R"), chdir = TRUE)

    # future improvements: check xml validity or created test
    expect_true(file.exists(file.path(tmpdir, "upload/test_demo.xml")))
    expect_true(file.exists(file.path(tmpdir, "upload/test_demo.zip")))
})
