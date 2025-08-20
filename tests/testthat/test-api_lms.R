
test_that("LMS object can be created for OPAL", {
    skip_on_cran()
    skip_on_ci()
    con <- opal()
    expect_equal(exists("con"), TRUE)
    logged_in <- isUserLoggedIn(con)
    expect_true(logged_in)
})


test_that("LMS OPAL handles missing parameters correctly", {
    skip_on_cran()
    skip_on_ci()
    con <- opal()
    #expect_error(con <- new("Opal", api_user = "fakeEmptyUser"),
    #             "Username not found in credential storage")
    # expect_error(con <- new("Opal", api_user = "fakeEmptyUser"),
    #              "API username is required but not found")
    env_endpoint <- Sys.getenv("RQTI_API_ENDPOINT")
    Sys.setenv("RQTI_API_ENDPOINT" = "")
    expect_error(con <- new("Opal"), "API endpoint is not defined")
    # con <- new("Opal", endpoint = "fakeEmptyEndpoint")
    Sys.setenv("RQTI_API_ENDPOINT" = env_endpoint)
})

test_that("upload2opal works directly", {
    skip_on_cran()
    skip_on_ci()
    con <- opal()
    # create resource from object
    es <- suppressWarnings(essay(identifier = "ForTestAPI"))
    res <- upload2opal(es, display_name = "test_ForTestAPI", open_in_browser = F)
    df <- getLMSResourcesByName(con, display_name = "test_ForTestAPI")
    url <- getLMSResourceURL(con, display_name = "test_ForTestAPI")
    df3 <- getLMSResources()
    expect_equal(nrow(df), 1)
    expect_equal(url, res$url)
})

test_that("Create a resource on Opal, test getting resource, inc. get by name", {
    skip_on_cran()
    skip_on_ci()
    con <- opal()
    # create resource from object
    es <- suppressWarnings(essay(identifier = "ForTestAPI"))
    res <- suppressMessages(upload2LMS(con, es, open_in_browser = FALSE))
    df <- getLMSResourcesByName(con, display_name = "test_ForTestAPI")
    url <- getLMSResourceURL(con, display_name = "test_ForTestAPI")
    df3 <- getLMSResources()
    expect_equal(nrow(df), 1)
    expect_equal(url, res$url)
    expect_true(prod(dim(df3)) > 0)
})

test_that("Get URL", {
    skip_on_cran()
    skip_on_ci()
    con <- opal()
    sut <- getLMSResourceURL(con, "test_ForTestAPI")
    expect_true(grepl("https?://[^\\s]+", sut))
})

test_that("default connections are guessed correctly", {
    skip_on_cran()
    skip_on_ci()
    expect_message(get_default_connetion(), "A connection to the LMS")
})

test_that("qti tests are detected correctly", {
    es <- suppressWarnings(essay(identifier = "ForTestAPI"))
    temp <- tempdir()
    exam <- test(section(es))
    path <- createQtiTest(exam, dir = temp)
    expect_true(is_test(path))
})
