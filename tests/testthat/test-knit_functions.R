test_that("Knit inherits the running server's renderer folder in another session", {
  served <- tempfile("served-renderer-")
  fallback <- tempfile("installed-renderer-")
  dir.create(served)
  dir.create(fallback)
  on.exit(unlink(c(served, fallback), recursive = TRUE))
  writeLines("unchanged installed item", file.path(fallback, "index.xml"))
  withr::local_envvar(c(RQTI_URL = "http://127.0.0.1:12345",
                       RQTI_QTIJS_PATH = served, RSTUDIO = "0"))
  script <- tempfile(fileext = ".R")
  on.exit(unlink(script), add = TRUE)
  package_path <- getNamespaceInfo("rqti", "path")
  load_package <- if (file.exists(file.path(package_path, "R", "knit_functions.R"))) {
    sprintf("pkgload::load_all(%s, quiet = TRUE)", deparse(package_path))
  } else {
    sprintf("library(rqti, lib.loc = %s)", deparse(dirname(package_path)))
  }
  writeLines(c(
    load_package,
    sprintf("stopifnot(identical(rqti:::qtijs_preview_path(), %s))", deparse(served)),
    "rqti::render_qtijs(system.file('extdata', 'sc1d.xml', package = 'rqti'))"
  ), script)
  output <- system2(file.path(R.home("bin"), "Rscript"),
                    c("--vanilla", shQuote(script)), stdout = TRUE, stderr = TRUE)
  expect_null(attr(output, "status"), info = paste(output, collapse = "\n"))
  expect_true(file.exists(file.path(served, "index.xml")))
  expect_match(paste(readLines(file.path(served, "index.xml")), collapse = ""),
               "sc1d")
  expect_identical(readLines(file.path(fallback, "index.xml")),
                   "unchanged installed item")
})

test_that("mismatched renderer folders fail before existing XML is removed", {
  served <- tempfile("served-renderer-")
  other <- tempfile("other-renderer-")
  dir.create(served)
  dir.create(other)
  on.exit(unlink(c(served, other), recursive = TRUE))
  writeLines("existing item", file.path(other, "index.xml"))
  withr::local_envvar(c(RQTI_URL = "http://127.0.0.1:12345",
                       RQTI_QTIJS_PATH = served, RSTUDIO = "0"))
  expect_error(render_qtijs("unused.xml", qtijs_path = other), "differs")
  expect_error(render_xml("unused.xml", qtijs_path = other), "differs")
  expect_error(render_zip("unused.zip", qtijs_path = other), "differs")
  expect_identical(readLines(file.path(other, "index.xml")), "existing item")
})

test_that("preview path falls back to installed assets when no server is running", {
  withr::local_envvar(c(RQTI_URL = "", RQTI_QTIJS_PATH = "/unused"))
  expect_identical(qtijs_preview_path(), qtijs_pkg_path())
})

test_that("render_qtijs works in browser", {
  skip_if(isTRUE(as.logical(Sys.getenv("R_COVR"))),
          "Skipping browser test during covr")
  skip_if(nzchar(Sys.getenv("_R_CHECK_PACKAGE_NAME_")))
  skip_on_ci()
  skip_on_cran()
  skip_if_not(.Platform$OS.type == "unix")

  script <- test_path("../qtijs/test-render_qtijs.sh")

  skip_if_not(file.exists(script))

  result <- system2(
    "bash",
    script,
    stdout = TRUE,
    stderr = TRUE
  )

  status <- attr(result, "status")
  if (is.null(status)) {
    status <- 0
  }

  expect_equal(status, 0)
  expect_true(any(grepl("Title matched: sc1d", result, fixed = TRUE)))
})
