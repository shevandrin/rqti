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
