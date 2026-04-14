# test-knit_functions.R

library(testthat)
library(callr)
library(chromote)

wait_until <- function(expr, timeout = 20, interval = 0.25) {
    deadline <- Sys.time() + timeout

    repeat {
        value <- tryCatch(force(expr), error = function(e) NULL)

        if (isTRUE(value)) {
            return(TRUE)
        }

        if (Sys.time() >= deadline) {
            return(FALSE)
        }

        Sys.sleep(interval)
    }
}

copy_qtijs_dir <- function() {
    src <- system.file("QTIJS", package = "rqti")
    dst <- file.path(tempdir(), paste0("QTIJS-", Sys.getpid()))
    dir.create(dst)
    fls <- list.files(src, full.names = TRUE, recursive = TRUE)
    file.copy(
        from = fls,
        to = dst,
        recursive = TRUE,
        overwrite = TRUE
    )
    return(dst)
}

start_test_server <- function(qtijs_path, port) {
    callr::r_bg(
        func = function(qtijs_path, port) {
            Sys.setenv(R_SERVR_PORT = as.character(port))
            rqti::start_server(qtijs_path, daemon = FALSE)
        },
        args = list(qtijs_path = qtijs_path, port = port),
        supervise = TRUE,
        stdout = "|",
        stderr = "|"
    )
}

read_process_diagnostics <- function(p) {
    list(
        alive = p$is_alive(),
        exit_status = tryCatch(p$get_exit_status(), error = function(e) NA),
        stdout = tryCatch(p$read_output_lines(), error = function(e) character()),
        stderr = tryCatch(p$read_error_lines(), error = function(e) character())
    )
}

get_page_title <- function(b) {
    js <- "
    (function() {
      var el = document.querySelector('title');
      return el ? el.textContent : null;
    })();
  "
    res <- b$Runtime$evaluate(js)
    res$result$value
}

test_that("servr responds", {
    skip_if(Sys.getenv("RQTI_API_USER") == "")
    skip_if_not_installed("chromote")
    skip_if_not_installed("callr")

    port <- httpuv::randomPort()
    base_url <- paste0("http://127.0.0.1:", port)
    url <- paste0(base_url, "/index.html")

    qtijs_path <- copy_qtijs_dir()

    p <- start_test_server(qtijs_path = qtijs_path, port = port)
    on.exit({
        if (p$is_alive()) {
            p$kill()
        }
    }, add = TRUE)

    # Give the child a brief moment to start.
    Sys.sleep(1)

    # Fail early only if the child already died.
    if (!p$is_alive()) {
        diag <- read_process_diagnostics(p)
        fail(
            paste0(
                "Server process died immediately.\n",
                "exit_status: ", diag$exit_status, "\n",
                "stdout:\n", paste(diag$stdout, collapse = "\n"), "\n",
                "stderr:\n", paste(diag$stderr, collapse = "\n")
            )
        )
    }

    Sys.setenv(RQTI_URL = base_url)

    expect_no_error(
        suppressMessages(
            render_qtijs(
                system.file("exercises", "sc1d.Rmd", package = "rqti"),
                qtijs_path = qtijs_path
            )
        )
    )

    b <- tryCatch(
        ChromoteSession$new(),
        error = function(e) {
            skip(paste("Chromote could not start:", conditionMessage(e)))
        }
    )
    on.exit({
        try(b$close(), silent = TRUE)
    }, add = TRUE)

    expect_no_error(b$go_to(url))

    title_ready <- wait_until(
        {
            if (!p$is_alive()) {
                return(FALSE)
            }

            title <- get_page_title(b)
            is.character(title) && trimws(title) == "sc1d"
        },
        timeout = 20,
        interval = 0.25
    )

    current_title <- tryCatch(get_page_title(b), error = function(e) NA_character_)

    if (!title_ready && !identical(trimws(current_title), "sc1d")) {
        diag <- read_process_diagnostics(p)
        fail(
            paste0(
                "Page title did not become 'sc1d'.\n",
                "current_title: ", current_title, "\n",
                "alive: ", diag$alive, "\n",
                "exit_status: ", diag$exit_status, "\n",
                "stdout:\n", paste(diag$stdout, collapse = "\n"), "\n",
                "stderr:\n", paste(diag$stderr, collapse = "\n")
            )
        )
    }

    expect_equal(trimws(current_title), "sc1d")
})
