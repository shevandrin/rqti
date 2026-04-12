test_that("AssessmentTestOpenOlat can be created with defaults", {
    task <- new(
        "Essay",
        prompt = "Question",
        identifier = "q1"
    )

    sec <- new(
        "AssessmentSection",
        identifier = "sec1",
        title = "Section 1",
        assessment_item = list(task)
    )

    obj <- new(
        "AssessmentTestOpenOlat",
        section = list(sec),
        identifier = "test1",
        title = "Test 1"
    )

    expect_s4_class(obj, "AssessmentTestOpenOlat")
    expect_s4_class(obj, "AssessmentTest")

    expect_false(obj@cancel)
    expect_false(obj@suspend)
    expect_false(obj@scoreprogress)
    expect_false(obj@questionprogress)
    expect_true(obj@maxscoreitem)
    expect_true(obj@menu)
    expect_true(obj@titles)
    expect_false(obj@notes)
    expect_true(obj@hidelms)
    expect_false(obj@hidefeedbacks)
    expect_false(obj@blockaftersuccess)
    expect_equal(obj@attempts, 1L)
    expect_false(obj@anonym)
    expect_false(obj@manualcorrect)
})


test_that("assessmentTestOpenOlat() forwards custom OpenOlat arguments", {
    task <- new(
        "Essay",
        prompt = "Question",
        identifier = "q1"
    )

    sec <- new(
        "AssessmentSection",
        identifier = "sec1",
        title = "Section 1",
        assessment_item = list(task)
    )

    obj <- assessmentTestOpenOlat(
        section = list(sec),
        identifier = "test1",
        title = "Test 1",
        cancel = TRUE,
        suspend = TRUE,
        scoreprogress = TRUE,
        questionprogress = TRUE,
        maxscoreitem = FALSE,
        menu = FALSE,
        titles = FALSE,
        notes = TRUE,
        hidelms = FALSE,
        hidefeedbacks = TRUE,
        blockaftersuccess = TRUE,
        attempts = 3L,
        anonym = TRUE,
        manualcorrect = TRUE
    )

    expect_s4_class(obj, "AssessmentTestOpenOlat")

    expect_true(obj@cancel)
    expect_true(obj@suspend)
    expect_true(obj@scoreprogress)
    expect_true(obj@questionprogress)
    expect_false(obj@maxscoreitem)
    expect_false(obj@menu)
    expect_false(obj@titles)
    expect_true(obj@notes)
    expect_false(obj@hidelms)
    expect_true(obj@hidefeedbacks)
    expect_true(obj@blockaftersuccess)
    expect_equal(obj@attempts, 3L)
    expect_true(obj@anonym)
    expect_true(obj@manualcorrect)
})


test_that("createConfigurationFile() creates QTI21PackageConfig.xml", {
    task <- new(
        "Essay",
        prompt = "Question",
        identifier = "q1"
    )

    sec <- new(
        "AssessmentSection",
        identifier = "sec1",
        title = "Section 1",
        assessment_item = list(task)
    )

    obj <- assessmentTestOpenOlat(
        section = list(sec),
        identifier = "test1",
        title = "Test 1"
    )

    outdir <- file.path(tempdir(), paste0("rqti-test-", Sys.getpid(), "-", sample.int(1e6, 1)))
    createConfigurationFile(obj, outdir)

    cfg_file <- file.path(outdir, "QTI21PackageConfig.xml")

    expect_true(file.exists(cfg_file))
    expect_gt(file.size(cfg_file), 0)
})


test_that("createConfigurationFile() writes expected XML from object slots", {
    task <- new(
        "Essay",
        prompt = "Question",
        identifier = "q1"
    )

    sec <- new(
        "AssessmentSection",
        identifier = "sec1",
        title = "Section 1",
        assessment_item = list(task)
    )

    obj <- assessmentTestOpenOlat(
        section = list(sec),
        identifier = "test1",
        title = "Test 1",
        cancel = TRUE,
        suspend = TRUE,
        scoreprogress = TRUE,
        questionprogress = TRUE,
        maxscoreitem = FALSE,
        menu = FALSE,
        titles = FALSE,
        notes = TRUE,
        hidelms = FALSE,
        hidefeedbacks = TRUE,
        blockaftersuccess = TRUE,
        attempts = 3L,
        anonym = TRUE,
        manualcorrect = TRUE
    )

    outdir <- file.path(tempdir(), paste0("rqti-test-", Sys.getpid(), "-", sample.int(1e6, 1)))
    createConfigurationFile(obj, outdir)

    cfg_file <- file.path(outdir, "QTI21PackageConfig.xml")
    actual <- readLines(cfg_file, warn = FALSE)

    expected <- exams::openolat_config(
        cancel = obj@cancel,
        suspend = obj@suspend,
        scoreprogress = obj@scoreprogress,
        questionprogress = obj@questionprogress,
        maxscoreitem = obj@maxscoreitem,
        menu = obj@menu,
        titles = obj@titles,
        notes = obj@notes,
        hidelms = obj@hidelms,
        hidefeedbacks = obj@hidefeedbacks,
        blockaftersuccess = obj@blockaftersuccess,
        attempts = obj@attempts,
        anonym = obj@anonym,
        manualcorrect = obj@manualcorrect
    )[["QTI21PackageConfig.xml"]]

    expect_equal(actual, expected)
})


test_that("createConfigurationFile() creates nested output directory if needed", {
    task <- new(
        "Essay",
        prompt = "Question",
        identifier = "q1"
    )

    sec <- new(
        "AssessmentSection",
        identifier = "sec1",
        title = "Section 1",
        assessment_item = list(task)
    )

    obj <- assessmentTestOpenOlat(
        section = list(sec),
        identifier = "test1",
        title = "Test 1"
    )

    outdir <- file.path(
        tempdir(),
        paste0("rqti-test-", Sys.getpid(), "-", sample.int(1e6, 1)),
        "nested",
        "dir"
    )

    expect_false(dir.exists(outdir))

    createConfigurationFile(obj, outdir)

    expect_true(dir.exists(outdir))
    expect_true(file.exists(file.path(outdir, "QTI21PackageConfig.xml")))
})
