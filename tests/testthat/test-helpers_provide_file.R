test_that("provide_file() returns knitr asis output", {
    tmp <- tempfile(fileext = ".txt")
    writeLines("hello world", tmp)

    res <- provide_file(tmp)

    expect_s3_class(res, "knit_asis")
})


test_that("provide_file() uses file name as default label", {
    tmp <- tempfile(fileext = ".txt")
    writeLines("hello world", tmp)

    res <- provide_file(tmp)

    expect_match(as.character(res), basename(tmp), fixed = TRUE)
})


test_that("provide_file() uses custom label when provided", {
    tmp <- tempfile(fileext = ".txt")
    writeLines("hello world", tmp)

    res <- provide_file(tmp, label = "Download file")

    expect_match(as.character(res), "Download file", fixed = TRUE)
    expect_no_match(as.character(res), paste0(">", basename(tmp), "<"))
})


test_that("provide_file() embeds text files with guessed MIME type", {
    tmp <- tempfile(fileext = ".txt")
    writeLines("hello world", tmp)

    res <- provide_file(tmp)
    html <- as.character(res)

    expect_match(html, 'href="data:text/plain;base64,', fixed = TRUE)
})


test_that("provide_file() uses explicit MIME type when provided", {
    tmp <- tempfile(fileext = ".txt")
    writeLines("hello world", tmp)

    res <- provide_file(tmp, mime = "application/octet-stream")
    html <- as.character(res)

    expect_match(html, 'href="data:application/octet-stream;base64,', fixed = TRUE)
})


test_that("provide_file() includes download attribute by default", {
    tmp <- tempfile(fileext = ".pdf")
    writeLines("dummy content", tmp)

    res <- provide_file(tmp)
    html <- as.character(res)

    expect_match(
        html,
        paste0('download="', basename(tmp), '"'),
        fixed = TRUE
    )
})


test_that("provide_file() omits download attribute when download = FALSE", {
    tmp <- tempfile(fileext = ".pdf")
    writeLines("dummy content", tmp)

    res <- provide_file(tmp, download = FALSE)
    html <- as.character(res)

    expect_no_match(html, 'download="')
})


test_that("provide_file() errors for missing file", {
    expect_error(
        provide_file("file_that_does_not_exist.pdf"),
        "File does not exist"
    )
})


test_that("provide_file() errors for invalid path input", {
    expect_error(
        provide_file(character()),
        "`path` must be a non-empty character string.",
        fixed = TRUE
    )

    expect_error(
        provide_file(c("a", "b")),
        "`path` must be a non-empty character string.",
        fixed = TRUE
    )

    expect_error(
        provide_file(123),
        "`path` must be a non-empty character string.",
        fixed = TRUE
    )
})


test_that("provide_file() HTML-escapes label text", {
    tmp <- tempfile(fileext = ".txt")
    writeLines("hello world", tmp)

    res <- provide_file(tmp, label = '<click & "save">')
    html <- as.character(res)

    expect_match(html, "&lt;click &amp; &quot;save&quot;&gt;", fixed = TRUE)
})


test_that("provide_file() embeds correct Base64 payload", {
    tmp <- tempfile(fileext = ".txt")
    writeLines("hello", tmp)

    expected <- base64enc::base64encode(tmp)

    res <- provide_file(tmp)
    html <- as.character(res)

    expect_match(
        html,
        paste0("base64,", expected),
        fixed = TRUE
    )
})
