withr::local_options(list(rqti.maxima_cache_dir =
    file.path(tempdir(), "rqti-test-maxima-libraries")))

test_that("cache maintenance removes old builds but preserves unrelated directories", {
    root <- tempfile("rqti-cache-maintenance-")
    dir.create(root)
    old <- file.path(root, paste0("v1-", paste(rep("a", 32), collapse = "")))
    other <- file.path(root, "unrelated")
    dir.create(old)
    dir.create(other)
    writeLines("keep", file.path(other, "data"))
    config <- list(root = root, key = paste(rep("b", 32), collapse = ""))
    handle <- acquire_maxima_cache(config, 1)
    on.exit(release_maxima_cache(handle))
    expect_false(dir.exists(old))
    expect_true(file.exists(file.path(other, "data")))
    dir.create(file.path(handle$path, "binary"))
    writeLines("compiled", file.path(handle$path, "binary", "library"))
    writeLines("private answer", file.path(handle$path, "answer"))
    release_maxima_cache(handle)
    expect_true(file.exists(file.path(handle$path, "binary", "library")))
    expect_false(file.exists(file.path(handle$path, "answer")))
    expect_true(file.exists(file.path(handle$path, ".last-used")))
    # A cache unused for a month is replaced on its next acquisition.
    Sys.setFileTime(file.path(handle$path, ".last-used"), Sys.time() - 31 * 86400)
    next_handle <- acquire_maxima_cache(config, 1)
    on.exit(release_maxima_cache(next_handle), add = TRUE)
    expect_false(file.exists(file.path(next_handle$path, "binary", "library")))
})

test_that("incomplete and oversized caches are discarded and their locks released", {
    config <- list(root = tempfile("rqti-cache-bounds-"), key = paste(rep("c", 32), collapse = ""))
    dir.create(config$root)
    handle <- acquire_maxima_cache(config, 1)
    handle$ready_file <- tempfile("not-loaded-")
    release_maxima_cache(handle)
    expect_false(dir.exists(handle$path))
    handle <- acquire_maxima_cache(config, 1)
    con <- file(file.path(handle$path, "large-cache"), "wb")
    seek(con, 64 * 1024^2, origin = "start", rw = "write")
    writeBin(as.raw(0), con)
    close(con)
    release_maxima_cache(handle)
    expect_false(dir.exists(handle$path))
    again <- acquire_maxima_cache(config, 1, wait = FALSE)
    on.exit(release_maxima_cache(again))
    expect_true(is.environment(again))
})

test_that("another R process cannot acquire an active library cache lock", {
    config <- list(root = tempfile("rqti-cache-lock-"), key = paste(rep("d", 32), collapse = ""))
    dir.create(config$root)
    handle <- acquire_maxima_cache(config, 1)
    on.exit(release_maxima_cache(handle))
    script <- tempfile(fileext = ".R")
    output <- tempfile(fileext = ".rds")
    writeLines(c('args <- commandArgs(TRUE)',
        'lock <- filelock::lock(args[[1]],timeout=0)',
        'saveRDS(is.null(lock),args[[2]])'), script)
    child <- processx::process$new(file.path(R.home("bin"), "Rscript"),
        c("--vanilla", script, file.path(config$root, ".cache.lock"), output),
        stdout = "|", stderr = "|")
    on.exit(child$kill_tree(), add = TRUE)
    expect_true(maxima_wait_process(child, 10))
    expect_identical(child$get_exit_status(), 0L)
    expect_true(readRDS(output))
})

test_that("preview preparation errors and cancellation release the cache lock", {
    skip_on_cran()
    skip_if(!nzchar(Sys.which("maxima")))
    config <- list(root = tempfile("rqti-cache-cleanup-"), key = paste(rep("e", 32), collapse = ""))
    dir.create(config$root)
    local_mocked_bindings(maxima_cache_config = function(...) config)
    request <- preview_request()
    request$libraries <- "stringproc"
    # Fail after acquisition, before the process has been launched.
    (function() {
        local_mocked_bindings(maxima_preview_quote = function(...) stop("preparation failed"))
        expect_error(start_maxima_preview_job(request), "preparation failed")
    })()
    available <- acquire_maxima_cache(config, 1, wait = FALSE)
    expect_true(is.environment(available))
    release_maxima_cache(available)
    request$blocks[[1]]$code <- "while true do 1;"
    job <- start_maxima_preview_job(request)
    cleanup_maxima_preview_job(job)
    expect_false(job$process$is_alive())
    available <- acquire_maxima_cache(config, 1, wait = FALSE)
    on.exit(release_maxima_cache(available))
    expect_true(is.environment(available))
    # Repeated cleanup must not unlock the next job's lease.
    cleanup_maxima_preview_job(job)
    expect_null(acquire_maxima_cache(config, 1, wait = FALSE))
    release_maxima_cache(available)
    # Exercise cancellation immediately after process creation, before the
    # child has necessarily exposed the environment used for tree discovery.
    for (i in seq_len(20)) {
        immediate <- start_maxima_preview_job(request)
        cleanup_maxima_preview_job(immediate)
        expect_false(immediate$process$is_alive())
        expect_false(dir.exists(immediate$work))
        available <- acquire_maxima_cache(config, 1, wait = FALSE)
        expect_true(is.environment(available))
        release_maxima_cache(available)
    }
})

test_that("preview lock contention leaves the event loop responsive and cache survives stop", {
    skip_on_cran()
    skip_if(!nzchar(Sys.which("maxima")))
    root <- tempfile("rqti-cache-async-")
    withr::local_options(list(rqti.maxima_cache_dir = root))
    config <- maxima_cache_config(Sys.which("maxima"), 10)
    lock <- acquire_maxima_cache(config, 1)
    on.exit(release_maxima_cache(lock))
    request <- preview_request()
    request$libraries <- "stringproc"
    preview <- make_maxima_preview_app(tempdir(), "http://127.0.0.1:12345")
    on.exit(preview$stop(), add = TRUE)
    response <- preview_api_request(preview$app, request)
    value <- NULL
    promises::then(response, onFulfilled = function(x) value <<- x)
    tick <- FALSE
    later::later(function() tick <<- TRUE, 0)
    later::run_now(0.05)
    expect_true(tick)
    expect_null(value)
    expect_identical(preview$app$call(list(PATH_INFO = "/.rqti-maxima/config",
        REQUEST_METHOD = "GET"))$status, 200L)
    release_maxima_cache(lock)
    result <- await_preview_response(response)
    expect_identical(result$status, 200L)
    preview$stop()
    expect_true(dir.exists(lock$path))
    expect_true(file.exists(file.path(lock$path, ".last-used")))
})

test_that("compiled cache is reused across independent R sessions with isolated variables", {
    skip_on_cran()
    skip_if(!nzchar(Sys.which("maxima")))
    skip_if_not_installed("pkgload")
    work <- tempfile("rqti-cache-sessions-")
    dir.create(work)
    script <- file.path(work, "child.R")
    writeLines(c(
        'args <- commandArgs(TRUE)',
        'package <- args[[1]]',
        'if (file.exists(file.path(package,"R","maxima_cache.R"))) pkgload::load_all(package,quiet=TRUE) else library(rqti,lib.loc=dirname(package))',
        'options(rqti.maxima_cache_dir=args[[2]])',
        'config <- rqti:::maxima_cache_config(Sys.which("maxima"),30)',
        'rqti::maxima_check("a:7; string([\'answer=a]);",outputs=TRUE)',
        'job <- rqti:::start_maxima_preview_job(list(blocks=list(list(code="string([\'answer=8]);",outputs=list(list(name="answer",type="integer")))),libraries=c("distrib","descriptive","stats")))',
        'stopifnot(job$cache$path==file.path(config$root,paste0("v1-",config$key)))',
        'job$process$wait(30000)',
        'value <- rqti:::maxima_preview_job_result(job)[[1]]$values$answer',
        'rqti:::cleanup_maxima_preview_job(job)',
        'isolated <- identical(unname(rqti::maxima_check("string([\'answer=a]);",outputs=TRUE)),"unsupported")',
        'files <- list.files(file.path(config$root,paste0("v1-",config$key),"binary"),recursive=TRUE,full.names=TRUE)',
        'saveRDS(list(key=config$key,files=files,mtime=file.info(files)$mtime,value=value,isolated=isolated),args[[3]])'
    ), script)
    # Use the shared temporary test cache; no writes to the user's real cache.
    cache <- getOption("rqti.maxima_cache_dir")
    run_child <- function(name) {
        output <- file.path(work, paste0(name, ".rds"))
        child <- processx::process$new(file.path(R.home("bin"), "Rscript"),
            c("--vanilla", script, getNamespaceInfo("rqti", "path"), cache, output),
            stdout = file.path(work, paste0(name, ".log")), stderr = "2>&1",
            cleanup_tree = TRUE)
        on.exit(child$kill_tree())
        expect_true(maxima_wait_process(child, 120))
        log <- paste(readLines(file.path(work, paste0(name, ".log")), warn = FALSE), collapse = "\n")
        expect_identical(child$get_exit_status(), 0L, info = log)
        if (!identical(child$get_exit_status(), 0L)) stop(log)
        readRDS(output)
    }
    first <- run_child("first")
    second <- run_child("second")
    expect_identical(first$key, second$key)
    expect_true(length(first$files) > 0)
    expect_identical(first$files, second$files)
    expect_identical(first$mtime, second$mtime)
    expect_equal(c(first$value, second$value), c(8, 8))
    expect_true(first$isolated && second$isolated)
})
