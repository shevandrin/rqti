# test-knit_functions
library(testthat)
library(callr)
library(chromote)

test_that("servr responds", {
    testthat::skip_on_cran()
    testthat::skip_on_ci()

    # we need to test it in temp directory, otherwise we cannot copy files
    # which is necessary for rendering
    src <- fs::path_package("QTIJS", package = "rqti")
    dst <- file.path(tempdir(), "QTIJS")
    dir.create(dst, showWarnings = FALSE)
    qtijs_path <- dst
    # Copy *contents* of src into dst
    file.copy(
        list.files(src, full.names = TRUE),
        dst,
        recursive = TRUE
    )

    # start server in background process, otherwise it will block? see servr
    # config doc parameter daemon
    p <- callr::r_bg(function(qtijs_path) {
        pkgload::load_all()
        # hard code to use later, otherwise random port could be chosen
        # and we cannot access it.
        Sys.setenv(R_SERVR_PORT = 4321)
        # must turn off daemon in this case?
        start_server(qtijs_path, daemon = F)

    }, supervise = TRUE, args = list(qtijs_path = qtijs_path))

    # ensure cleanup even if later on.exit() calls are added
    on.exit(p$kill(), add = TRUE)

    # Sys.sleep(3)  # give server time to start
    url <- "http://127.0.0.1:4321/index.html"

    Sys.setenv(RQTI_URL="http://127.0.0.1:4321")
    render_qtijs(fs::path_package("exercises", "sc1d.Rmd",
                                        package = "rqti"),
                       qtijs_path = qtijs_path)

    # now we can simply use chromote
    b <- ChromoteSession$new()
    on.exit(b$close(), add = TRUE)

    b$go_to(url)

    # wait until the title is exactly "sc1d" or 10s are over
    js <- "
    (function() {
    var el = document.querySelector('title');
    return el ? el.textContent : null;
    })();
    "

    found_text <- NULL
    deadline <- Sys.time() + 10
    repeat {
        res <- b$Runtime$evaluate(js)
        found_text <- res$result$value
        if (identical(found_text, "sc1d")) break
        if (Sys.time() > deadline) break
        Sys.sleep(0.25)
    }

    expect_equal(found_text, "sc1d")
    p$kill()
})
