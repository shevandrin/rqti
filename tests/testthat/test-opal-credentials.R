test_that("OPAL keeps the legacy credential service by default", {
    observed_service <- NULL
    local_mocked_bindings(
        get_password = function(service_name, ...) {
            observed_service <<- service_name
            list(api_user = "tester", api_password = "secret")
        },
        authLMS = function(...) 200,
        .package = "rqti",
        .env = parent.frame()
    )

    con <- opal(api_user = "tester",
                endpoint = "https://exam.tu-chemnitz.de/opal/")

    expect_true(is.na(con@credential_id))
    expect_identical(observed_service, "rqtiopal")
})

test_that("OPAL accepts an explicit credential id", {
    observed_service <- NULL
    local_mocked_bindings(
        get_password = function(service_name, ...) {
            observed_service <<- service_name
            list(api_user = "tester", api_password = "secret")
        },
        authLMS = function(...) 200,
        .package = "rqti",
        .env = parent.frame()
    )

    con <- opal(api_user = "tester", endpoint = "https://opal.example/",
                credential_id = "exam")

    expect_identical(con@credential_id, "exam")
    expect_identical(observed_service, "rqtiopal-exam")
})

test_that("get_password returns the API user under its canonical name", {
    local_mocked_bindings(
        has_keyring_support = function() TRUE,
        key_get = function(...) "secret",
        .package = "rqti",
        .env = parent.frame()
    )

    credentials <- rqti:::get_password("rqtiopal-test", "tester")

    expect_identical(credentials$api_user, "tester")
    expect_identical(credentials$api_password, "secret")
})
