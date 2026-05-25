test_that("provide_audio() returns object HTML by default", {

    path <- tempfile(fileext = ".wav")

    writeBin(as.raw(c(1, 2, 3)), path)

    result <- provide_audio(path)

    expect_s3_class(result, "knit_asis")
    expect_match(as.character(result), "<object")
    expect_match(as.character(result), "audio/wav")

})

test_that("provide_audio() returns audio HTML when method = 'audio'", {

    path <- tempfile(fileext = ".mp3")

    writeBin(as.raw(c(1, 2, 3)), path)

    result <- provide_audio(path, method = "audio")

    expect_match(as.character(result), "<audio controls=")
    expect_match(as.character(result), "<source")
    expect_match(as.character(result), "audio/mpeg")

})

test_that("provide_audio() fails for missing file", {

    expect_error(
        provide_audio("missing.wav"),
        "File does not exist"
    )

})

test_that("provide_audio() warns for large files", {

    path <- tempfile(fileext = ".wav")

    writeBin(as.raw(rep(1, 1024)), path)

    expect_warning(
        provide_audio(path, warn_size_mb = 0.0001),
        "Embedding it will increase the size"
    )

})
