test_that("OPAL derives an endpoint service and retains the legacy fallback", {
    old_credential_id <- Sys.getenv("RQTI_API_CREDENTIAL_ID",
                                    unset = NA_character_)
    on.exit({
        if (is.na(old_credential_id)) {
            Sys.unsetenv("RQTI_API_CREDENTIAL_ID")
        } else {
            Sys.setenv(RQTI_API_CREDENTIAL_ID = old_credential_id)
        }
    }, add = TRUE)
    Sys.unsetenv("RQTI_API_CREDENTIAL_ID")

    observed_service <- NULL
    observed_fallback <- NULL
    local_mocked_bindings(
        get_password = function(service_name, ...,
                                fallback_service_names = character()) {
            observed_service <<- service_name
            observed_fallback <<- fallback_service_names
            list(api_user = "tester", api_password = "secret")
        },
        authLMS = function(...) 200,
        .package = "rqti",
        .env = parent.frame()
    )

    con <- opal(api_user = "tester",
                endpoint = "https://exam.tu-chemnitz.de/opal/")

    expect_true(is.na(con@credential_id))
    expect_identical(observed_service,
                     "rqtiopal-exam.tu-chemnitz.de-opal")
    expect_identical(observed_fallback, "rqtiopal")
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

test_that("endpoint-specific credentials take precedence over legacy ones", {
    local_mocked_bindings(
        has_keyring_support = function() TRUE,
        key_get = function(service, username) {
            if (service == "rqtiopal-opal.example-opal") return("endpoint-secret")
            if (service == "rqtiopal") return("legacy-secret")
            stop("unknown service")
        },
        .package = "rqti",
        .env = parent.frame()
    )

    credentials <- rqti:::get_password(
        "rqtiopal-opal.example-opal",
        "tester",
        fallback_service_names = "rqtiopal"
    )

    expect_identical(credentials$api_password, "endpoint-secret")
    expect_identical(credentials$credential_service,
                     "rqtiopal-opal.example-opal")
})

test_that("legacy credentials remain a transparent fallback", {
    local_mocked_bindings(
        has_keyring_support = function() TRUE,
        key_get = function(service, username) {
            if (service == "rqtiopal") return("legacy-secret")
            stop("credential not found")
        },
        .package = "rqti",
        .env = parent.frame()
    )

    credentials <- rqti:::get_password(
        "rqtiopal-opal.example-opal",
        "tester",
        fallback_service_names = "rqtiopal"
    )

    expect_identical(credentials$api_password, "legacy-secret")
    expect_identical(credentials$credential_service, "rqtiopal")
})

test_that("first-time credential setup still asks for username and password", {
    stored <- NULL
    local_mocked_bindings(
        readline = function(prompt) "new-user",
        .package = "base"
    )
    local_mocked_bindings(
        has_keyring_support = function() TRUE,
        key_list = function(service) data.frame(username = character()),
        getPass = function(prompt) "new-secret",
        key_set_with_value = function(service, username, password) {
            stored <<- list(service = service, username = username,
                            password = password)
        },
        .package = "rqti",
        .env = parent.frame()
    )

    credentials <- rqti:::get_password("rqtiopal-opal.example-opal")

    expect_identical(credentials$api_user, "new-user")
    expect_identical(credentials$api_password, "new-secret")
    expect_identical(stored, list(
        service = "rqtiopal-opal.example-opal",
        username = "new-user",
        password = "new-secret"
    ))
})

test_that("credential service is derived deterministically from endpoint", {
    expect_identical(
        rqti:::credential_service_from_endpoint(
            "Opal", " HTTPS://Exam.TU-Chemnitz.de/opal/// "
        ),
        "rqtiopal-exam.tu-chemnitz.de-opal"
    )
    expect_identical(
        rqti:::credential_service_from_endpoint(
            "Opal", "https://exam.tu-chemnitz.de/opal/", "custom"
        ),
        "rqtiopal-custom"
    )
})

test_that("set_opal_credentials stores under the endpoint-derived service", {
    observed <- NULL
    local_mocked_bindings(
        key_set = function(service, username, ...) {
            observed <<- list(service = service, username = username)
            invisible(NULL)
        },
        .package = "keyring"
    )

    service <- set_opal_credentials(
        "https://exam.tu-chemnitz.de/opal/",
        "tester"
    )

    expect_identical(service, "rqtiopal-exam.tu-chemnitz.de-opal")
    expect_identical(observed, list(
        service = "rqtiopal-exam.tu-chemnitz.de-opal",
        username = "tester"
    ))
})

test_that("OPAL normalizes its endpoint once during initialization", {
    local_mocked_bindings(
        get_password = function(...) list(api_user = "tester",
                                          api_password = "secret"),
        authLMS = function(...) 200,
        .package = "rqti",
        .env = parent.frame()
    )

    con <- opal(api_user = "tester",
                endpoint = " https://opal.example/opal/// ")

    expect_identical(con@endpoint, "https://opal.example/opal/")
})

test_that("credential id can be selected for implicit connections by environment", {
    old_credential_id <- Sys.getenv("RQTI_API_CREDENTIAL_ID",
                                    unset = NA_character_)
    on.exit({
        if (is.na(old_credential_id)) {
            Sys.unsetenv("RQTI_API_CREDENTIAL_ID")
        } else {
            Sys.setenv(RQTI_API_CREDENTIAL_ID = old_credential_id)
        }
    }, add = TRUE)
    Sys.setenv(RQTI_API_CREDENTIAL_ID = "exam")

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

    con <- opal(api_user = "tester", endpoint = "https://opal.example/")

    expect_identical(con@credential_id, "exam")
    expect_identical(observed_service, "rqtiopal-exam")
})

test_that("authLMS accepts non-XML success bodies and stores a private token", {
    captured_req <- NULL
    con <- with_mocked_bindings(
        opal(api_user = "tester",
             endpoint = "https://opal.example/opal/",
             credential_id = "exam"),
        get_password = function(...) list(api_user = "tester",
                                          api_password = "secret"),
        authLMS = function(...) 200,
        .package = "rqti"
    )

    local_mocked_bindings(
        get_password = function(...) list(api_user = "tester",
                                          api_password = "secret"),
        req_perform = function(req) {
            captured_req <<- req
            httr2::response(
                status_code = 200,
                headers = list("content-type" = "text/plain",
                               "X-OLAT-TOKEN" = "connection-token"),
                body = charToRaw("OK")
            )
        },
        .package = "rqti"
    )

    expect_identical(authLMS(con), 200L)
    expect_identical(rqti:::lms_token(con), "connection-token")
    expect_identical(captured_req$url,
                     "https://opal.example/opal/restapi/auth/login")
    expect_identical(captured_req$method, "POST")
    expect_identical(captured_req$headers$username, "tester")
    expect_identical(captured_req$headers$password, "secret")
})

test_that("authLMS rejects a successful response without a token", {
    con <- with_mocked_bindings(
        opal(api_user = "tester", endpoint = "https://opal.example/"),
        get_password = function(...) list(api_user = "tester",
                                          api_password = "secret"),
        authLMS = function(...) 200,
        .package = "rqti"
    )
    con@session$token <- "stale-token"

    local_mocked_bindings(
        get_password = function(...) list(api_user = "tester",
                                          api_password = "secret"),
        req_perform = function(req) httr2::response(
            status_code = 200,
            headers = list("content-type" = "text/plain"),
            body = charToRaw("OK")
        ),
        .package = "rqti"
    )

    expect_error(authLMS(con), "no X-OLAT-TOKEN header")
    expect_identical(rqti:::lms_token(con), "")
})

test_that("OPAL connections keep independent authentication tokens", {
    first <- with_mocked_bindings(
        opal(api_user = "tester", endpoint = "https://first.example/"),
        get_password = function(...) list(api_user = "tester",
                                          api_password = "secret"),
        authLMS = function(...) 200,
        .package = "rqti"
    )
    second <- with_mocked_bindings(
        opal(api_user = "tester", endpoint = "https://second.example/"),
        get_password = function(...) list(api_user = "tester",
                                          api_password = "secret"),
        authLMS = function(...) 200,
        .package = "rqti"
    )

    first@session$token <- "first-token"
    second@session$token <- "second-token"

    expect_identical(rqti:::lms_token(first), "first-token")
    expect_identical(rqti:::lms_token(second), "second-token")
})

test_that("render_opal forwards named connection arguments", {
    observed_args <- NULL
    archive <- tempfile(fileext = ".zip")
    writeBin(charToRaw("archive"), archive)

    local_mocked_bindings(
        rmd2zip = function(input) archive,
        opal = function(...) {
            observed_args <<- list(...)
            structure(list(), class = "mock_opal")
        },
        upload2LMS = function(object, test, ...) "uploaded",
        .package = "rqti"
    )

    result <- render_opal(
        "question.Rmd",
        encoding = "UTF-8",
        endpoint = "https://exam.example/opal/",
        api_user = "tester",
        credential_id = "exam"
    )

    expect_identical(result, "uploaded")
    expect_identical(observed_args, list(
        endpoint = "https://exam.example/opal/",
        api_user = "tester",
        credential_id = "exam"
    ))
})
