skip_on_cran()
skip_on_covr()
skip_on_ci()

con <- new("Opal",
           endpoint = "https://bildungsportal.sachsen.de/opal/")

test_that("Create LMS objects", {
    expect_equal(exists("con"), TRUE)
})

test_that("Create a resource on Opal, test getting resource, inc. get by name", {
    # create resource from object
    es <- suppressWarnings(essay(identifier = "ForTestAPI"))
    suppressMessages(upload2LMS(con, es, open_in_browser = FALSE))
    df <- getLMSResourcesByName(con, display_name = "test_ForTestAPI")
    expect_equal(nrow(df), 1)
})

test_that("Get URL", {
    sut = getLMSResourceURL(con, "test_ForTestAPI")
    expect_true(grepl("https?://[^\\s]+", sut))
})
