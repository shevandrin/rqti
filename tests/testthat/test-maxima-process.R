test_that("explicit paths bypass Sys.which, including spaces and Unicode", {
    path <- file.path(withr::local_tempdir(), "Maxima long path ä (test)", "maxima.bat")
    dir.create(dirname(path))
    file.create(path)
    local_mocked_bindings(Sys.which = function(...) stop("unexpected PATH lookup"), .package = "base")
    expect_identical(resolve_maxima_executable(path), normalizePath(path, winslash = "/"))
    expect_error(resolve_maxima_executable(dirname(path)), "executable not found")
})

test_that("bare command names use PATH, with option and Knit environment precedence", {
    path <- file.path(withr::local_tempdir(), "maxima")
    file.create(path)
    local_mocked_bindings(Sys.which = function(x) {
        expect_identical(x, "maxima")
        setNames(path, x)
    }, .package = "base")
    withr::local_options(list(rqti.maxima = NULL))
    withr::local_envvar(c(RQTI_MAXIMA = NA))
    expect_identical(resolve_maxima_executable(), normalizePath(path, winslash = "/"))
    Sys.setenv(RQTI_MAXIMA = path)
    expect_identical(maxima_default_executable(), path)
    options(rqti.maxima = "console choice")
    expect_identical(maxima_default_executable(), "console choice")
})

test_that("Windows batch launchers use cmd call with separate arguments", {
    path <- "C:/Program Files/Maxima (test)/bin/maxima.BAT"
    args <- c("--very-quiet", "--userdir=C:/Users/Test User/cache",
              '--batch-string=batchload("C:/Test User/driver.mac")$')
    command <- maxima_process_command(path, args, windows = TRUE)
    expect_identical(command$command, Sys.getenv("COMSPEC", "cmd.exe"))
    expect_identical(command$args, c("/d", "/c", "call", path, args))
    expect_identical(maxima_process_command("maxima.exe", args, windows = TRUE),
                     list(command = "maxima.exe", args = args))
    expect_identical(maxima_process_command(path, args, windows = FALSE),
                     list(command = path, args = args))
})

test_that("the preview server passes its executable choice to a separate R session", {
    withr::local_envvar(c(RQTI_MAXIMA = NA, RQTI_URL = NA, RQTI_QTIJS_PATH = NA))
    path <- file.path(withr::local_tempdir(), "Maxima chosen launcher.bat")
    file.create(path)
    withr::local_options(list(rqti.maxima = path))
    local_mocked_bindings(start_maxima_local_server = function(...) "http://127.0.0.1:12345")
    withr::defer(stop_server())
    start_server(tempdir())
    child <- processx::run(file.path(R.home("bin"), "Rscript"),
        c("--vanilla", "-e", 'cat(Sys.getenv("RQTI_MAXIMA"))'))
    expect_identical(child$stdout, normalizePath(path, winslash = "/"))
    stop_server()
    expect_identical(Sys.getenv("RQTI_MAXIMA"), "")
})

test_that("Windows batch launchers execute from paths and arguments with spaces", {
    skip_if(.Platform$OS.type != "windows")
    path <- file.path(withr::local_tempdir(), "Maxima long path (test)")
    dir.create(path)
    launcher <- file.path(path, "maxima.cmd")
    writeLines(c("@echo off", "echo %~1"), launcher)
    process <- maxima_start_process(resolve_maxima_executable(launcher), "argument with spaces",
                                    stdout = "|", stderr = "|")
    on.exit(maxima_stop_process(process))
    expect_true(maxima_wait_process(process, 10))
    expect_identical(process$get_exit_status(), 0L)
    expect_identical(process$read_output_lines(), "argument with spaces")
})

test_that("Maxima checks and cached previews use an explicit launcher path", {
    skip_on_cran()
    skip_if(.Platform$OS.type == "windows")
    executable <- unname(Sys.which("maxima"))
    skip_if(!nzchar(executable))
    path <- file.path(withr::local_tempdir(), "Maxima long path ä (test)")
    dir.create(path)
    launcher <- file.path(path, "maxima")
    writeLines(c("#!/bin/sh", paste("exec", shQuote(executable), '"$@"')), launcher)
    Sys.chmod(launcher, "0755")
    withr::local_options(list(rqti.maxima = launcher, rqti.maxima_cache_dir = file.path(path, "cache")))
    # Mimic a platform where Sys.which cannot resolve this existing full path.
    local_mocked_bindings(Sys.which = function(...) "", .package = "base")
    expect_identical(maxima_check("string(['answer=7]);", outputs = TRUE), c(answer = "integer"))
    request <- preview_request()
    request$libraries <- c("distrib", "descriptive", "stats")
    job <- start_maxima_preview_job(request)
    on.exit(cleanup_maxima_preview_job(job), add = TRUE)
    expect_true(maxima_wait_process(job$process, 120))
    expect_equal(maxima_preview_job_result(job)[[1]]$values$answer, 7)
})
