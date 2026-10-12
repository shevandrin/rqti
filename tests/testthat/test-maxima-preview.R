withr::local_options(list(rqti.maxima_cache_dir =
    file.path(tempdir(), "rqti-test-maxima-libraries")))

await_preview_job <- function(request, ...) {
    job <- start_maxima_preview_job(request, ...)
    on.exit(cleanup_maxima_preview_job(job))
    job$process$wait(60000)
    maxima_preview_job_result(job)
}

test_that("local preview validates typed blocks before starting Maxima", {
    expect_identical(validate_maxima_preview_request(preview_request())$libraries, character())
    expect_error(validate_maxima_preview_request(list(blocks = list())), "between 1 and 100")
    request <- preview_request(type = "boolean")
    expect_error(validate_maxima_preview_request(request), "name or type")
    request <- preview_request()
    request$blocks[[1]]$outputs[[2]] <- request$blocks[[1]]$outputs[[1]]
    expect_error(validate_maxima_preview_request(request), "Duplicate")
    expect_error(start_maxima_preview_job(preview_request(), executable = ""), "Maxima is required")
})

test_that("local calculation API rejects unrelated origins and missing tokens", {
    app <- make_maxima_preview_app(tempdir(), "http://127.0.0.1:12345")$app
    req <- list(PATH_INFO = "/.rqti-maxima/config", REQUEST_METHOD = "GET")
    config <- app$call(req)
    expect_identical(config$status, 200L)
    expect_false("Access-Control-Allow-Origin" %in% names(config$headers))
    expect_identical(jsonlite::fromJSON(config$body)$backend, "local")
    req$HTTP_ORIGIN <- "https://another-site.example"
    expect_identical(app$call(req)$status, 403L)
    req$HTTP_ORIGIN <- NULL
    req$PATH_INFO <- "/.rqti-maxima/run"
    req$REQUEST_METHOD <- "POST"
    expect_identical(app$call(req)$status, 403L)
    req$HTTP_X_RQTI_MAXIMA <- jsonlite::fromJSON(config$body)$token
    req$CONTENT_TYPE <- "text/plain"
    expect_identical(app$call(req)$status, 415L)
    req$CONTENT_TYPE <- "application/json"
    req$CONTENT_LENGTH <- "1048577"
    expect_identical(app$call(req)$status, 413L)
})

test_that("native preview returns typed values and shares state only within an item", {
    skip_on_cran()
    skip_if(!nzchar(Sys.which("maxima")))
    request <- list(blocks = list(
        list(code = paste0('a:3; string([\'a=a,\'fraction=1/2,\'label=',
            'concat("Grüße ",ascii(34),"x",ascii(34),ascii(10),ascii(92))]);'),
            outputs = list(list(name = "a", type = "integer"),
                list(name = "fraction", type = "float"), list(name = "label", type = "string"))),
        list(code = "string(['answer=a+4]);", outputs = list(list(name = "answer", type = "integer")))),
        libraries = character())
    result <- await_preview_job(request)
    expect_equal(result[[1]]$values$a, 3)
    expect_equal(result[[1]]$values$fraction, 0.5)
    expect_identical(result[[1]]$values$label, 'Grüße "x"\n\\')
    expect_equal(result[[2]]$values$answer, 7)
    expect_error(await_preview_job(preview_request("string(['answer=a+4]);")), "not an integer")
})

test_that("native preview includes source diagnostics and recovers after bad programs", {
    skip_on_cran()
    skip_if(!nzchar(Sys.which("maxima")))
    for (code in c("1/0;", "1+);")) {
        error <- tryCatch(await_preview_job(preview_request(code)), error = identity)
        expect_s3_class(error, "error")
        expect_match(conditionMessage(error), "calculation.*failed")
        expect_match(conditionMessage(error), "Source:")
        expect_match(conditionMessage(error), "negative exponent|delimiter")
    }
    expect_error(await_preview_job(preview_request("string(['answer=1/2]);")), "not an integer")
    expect_equal(await_preview_job(preview_request())[[1]]$values$answer, 7)
})

test_that("local preview randomizes each new item and supports native statistics libraries", {
    skip_on_cran()
    skip_if(!nzchar(Sys.which("maxima")))
    request <- preview_request("string(['answer=random(1000000000)]);")
    a <- await_preview_job(request)[[1]]$values$answer
    b <- await_preview_job(request)[[1]]$values$answer
    expect_false(identical(a, b))
    request <- preview_request("string(['answer=cdf_normal(0,0,1)]);", type = "float")
    request$libraries <- NULL
    expect_equal(await_preview_job(request)[[1]]$values$answer, 0.5)
})

test_that("asynchronous local API times out runaway code and processes its next job", {
    skip_on_cran()
    skip_if(!nzchar(Sys.which("maxima")))
    old <- options(rqti.maxima_timeout=0.3)
    on.exit(options(old))
    preview <- make_maxima_preview_app(tempdir(), "http://127.0.0.1:12345")
    on.exit(preview$stop(), add=TRUE)
    slow <- preview_api_request(preview$app, preview_request("while true do 1;"))
    expect_s3_class(slow, "promise")
    result <- await_preview_response(slow)
    expect_identical(result$status, 408L)
    expect_match(jsonlite::fromJSON(result$body)$error, "exceeded 0.3 seconds")
    options(rqti.maxima_timeout=10)
    followup <- await_preview_response(preview_api_request(preview$app, preview_request()))
    expect_identical(followup$status, 200L)
    expect_equal(jsonlite::fromJSON(followup$body, simplifyVector=FALSE)$results[[1]]$values$answer, 7)
})

test_that("stopping a local preview terminates an active job and replies to queued jobs", {
    skip_on_cran()
    skip_if(!nzchar(Sys.which("maxima")))
    preview <- make_maxima_preview_app(tempdir(), "http://127.0.0.1:12345")
    slow <- preview_api_request(preview$app, preview_request("while true do 1;"))
    queued <- preview_api_request(preview$app, preview_request())
    later::run_now(0.05)
    preview$stop()
    expect_identical(await_preview_response(slow)$status, 503L)
    expect_identical(await_preview_response(queued)$status, 503L)
})
