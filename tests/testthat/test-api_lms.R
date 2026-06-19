# tests/testthat/test-opal-integration.R

library(testthat)

OPAL_TEST_CONNECTION <- NULL

opal_for_test <- function() {
    if (!is.null(OPAL_TEST_CONNECTION)) {
        return(OPAL_TEST_CONNECTION)
    }

    con <- tryCatch(
        suppressWarnings(opal()),
        error = function(e) skip(paste("Could not create OPAL connection:", conditionMessage(e)))
    )

    OPAL_TEST_CONNECTION <<- con
    con
}

skip_if_no_opal <- function() {
    skip_if(Sys.getenv("RQTI_API_USER") == "", "RQTI_API_USER is not set.")
    invisible(opal_for_test())
}

METHODENGURU_COURSE_ID <- "38156107780"
METHODENGURU_RESOURCE_ID <- "1671679683120887006"
METHODENGURU_TEST_DUMMY_NODE_ID <- "1706153362112925006"
METHODENGURU_TEST_DUMMY_SHORT_NAME <- "Test dummy"

methodenguru_fixture <- function() {
    skip_if_no_opal()

    con <- opal_for_test()

    elems <- tryCatch(
        getCourseElements(con, METHODENGURU_RESOURCE_ID),
        error = function(e) skip(paste("Could not retrieve Methodenguru elements:", conditionMessage(e)))
    )

    element <- elems[elems$nodeId == METHODENGURU_TEST_DUMMY_NODE_ID, , drop = FALSE]
    skip_if(nrow(element) == 0, "No Methodenguru course element with the hardcoded Test dummy node id")

    list(
        con = con,
        course_id = METHODENGURU_COURSE_ID,
        resource_id = METHODENGURU_RESOURCE_ID,
        node_id = METHODENGURU_TEST_DUMMY_NODE_ID,
        element = element,
        elements = elems
    )
}

# Stable names reused across test runs
TEST_ITEM_NAME <- "rqti_test_item"
TEST_EXAM_NAME <- "rqti_test_exam"
TEST_OVERWRITE_NAME <- "rqti_test_overwrite"
TEST_SURVEY_NAME <- "rqti_test_survey"
TEST_RTYPE_TEST_NAME <- "rqti_test_rtype_test"
TEST_RTYPE_SURVEY_NAME <- "rqti_test_rtype_survey"
TEST_URL_DIRECT_NAME <- "rqti_test_url_direct"
TEST_URL_METHOD_NAME <- "rqti_test_url_method"
TEST_MISSING_NAME <- "rqti_test_definitely_not_existing"
TEST_METHODENGURU_NAME <- "rqti_methodenguru_test_dummy"

make_test_item <- function(id = TEST_ITEM_NAME) {
    suppressWarnings(essay(identifier = id))
}

make_test_exam <- function(id = TEST_EXAM_NAME) {
    suppressMessages(test(section(make_test_item(id))))
}

opal_upload_response <- function(key = "mock-key", display_name = "mock-resource") {
    httr2::response(
        status_code = 200,
        headers = list("content-type" = "application/xml"),
        body = charToRaw(paste0(
            "<repositoryEntryVO>",
            "<key>", key, "</key>",
            "<displayname>", display_name, "</displayname>",
            "</repositoryEntryVO>"
        ))
    )
}

mock_opal_connection <- function() {
    local_mocked_bindings(
        get_password = function(...) list(api_user = "tester",
                                          api_password = "secret"),
        authLMS = function(...) 200,
        .package = "rqti",
        .env = parent.frame()
    )
    opal(api_user = "tester", endpoint = "https://opal.example/")
}

test_that("opal() creates a valid Opal connection object", {
    skip_if_no_opal()

    con <- opal()

    expect_s4_class(con, "Opal")
    expect_identical(con@name, "Opal")
    expect_true(nzchar(con@endpoint))
    expect_true(isUserLoggedIn(con))
})

test_that("new('Opal') errors when endpoint is unavailable", {
    skip_if_no_opal()

    old_endpoint <- Sys.getenv("RQTI_API_ENDPOINT")
    on.exit(Sys.setenv(RQTI_API_ENDPOINT = old_endpoint), add = TRUE)

    Sys.setenv(RQTI_API_ENDPOINT = "")
    expect_error(new("Opal"), "API endpoint is not defined")
})

test_that("getLMSResources returns a non-empty data frame", {
    skip_if_no_opal()

    con <- opal()
    res <- getLMSResources(con)

    expect_s3_class(res, "data.frame")
    expect_true(ncol(res) > 0)
    expect_true(nrow(res) >= 0)
})

test_that("getLMSResourceURL warns and returns NULL for a missing display name", {
    skip_if_no_opal()

    con <- opal()

    expect_warning(
        out <- getLMSResourceURL(con, TEST_MISSING_NAME),
        "No resources found with the specified display name"
    )
    expect_null(out)
})

test_that("upload2opal creates a resource that can be found again", {
    skip_if_no_opal()

    con <- opal()
    display_name <- TEST_ITEM_NAME
    es <- make_test_item(display_name)

    res <- suppressMessages(
        upload2opal(
            es,
            display_name = display_name,
            open_in_browser = FALSE,
            overwrite = TRUE
        )
    )

    by_name <- getLMSResourcesByName(con, display_name = display_name)
    urls <- getLMSResourceURL(con, display_name = display_name)

    expect_type(res, "list")
    expect_true(all(c("key", "display_name", "url") %in% names(res)))
    expect_identical(res$display_name, display_name)
    expect_equal(nrow(by_name), 1)
    expect_identical(urls, res$url)
    expect_true(by_name$key[1] == res$key)
})

test_that("upload2LMS creates a new test resource and can retrieve it by type", {
    skip_if_no_opal()

    con <- opal()
    display_name <- TEST_EXAM_NAME
    exam <- make_test_exam(display_name)

    res <- suppressMessages(
        upload2LMS(
            con,
            exam,
            display_name = display_name,
            open_in_browser = FALSE,
            overwrite = TRUE
        )
    )

    all_hits <- getLMSResourcesByName(con, display_name = display_name)
    test_hits <- getLMSResourcesByName(
        con,
        display_name = display_name,
        rtype = "FileResource.TEST"
    )

    expect_type(res, "list")
    expect_identical(res$display_name, display_name)
    expect_true(nrow(all_hits) >= 1)
    expect_true(nrow(test_hits) >= 1)
    expect_true(res$key %in% test_hits$key)
})

test_that("upload2LMS overwrites an existing test resource when display_name already exists", {
    skip_if_no_opal()

    con <- opal()
    display_name <- TEST_OVERWRITE_NAME

    exam1 <- make_test_exam(paste0(display_name, "_v1"))
    exam2 <- make_test_exam(paste0(display_name, "_v2"))

    first <- suppressMessages(
        upload2LMS(
            con,
            exam1,
            display_name = display_name,
            open_in_browser = FALSE,
            overwrite = TRUE
        )
    )

    second <- suppressMessages(
        upload2LMS(
            con,
            exam2,
            display_name = display_name,
            open_in_browser = FALSE,
            overwrite = TRUE
        )
    )

    hits <- getLMSResourcesByName(
        con,
        display_name = display_name,
        rtype = "FileResource.TEST"
    )

    expect_equal(nrow(hits), 1)
    expect_identical(first$key, second$key)
    expect_identical(as.character(hits$key[1]), first$key)
})

test_that("upload2LMS can create a survey resource", {
    skip_if_no_opal()

    con <- opal()
    display_name <- TEST_SURVEY_NAME
    exam <- make_test_exam(display_name)

    res <- suppressMessages(
        upload2LMS(
            con,
            exam,
            display_name = display_name,
            open_in_browser = FALSE,
            as_survey = TRUE,
            overwrite = TRUE
        )
    )

    survey_hits <- getLMSResourcesByName(
        con,
        display_name = display_name,
        rtype = "FileResource.SURVEY"
    )

    expect_type(res, "list")
    expect_identical(res$display_name, display_name)
    expect_true(nrow(survey_hits) >= 1)
    expect_true(res$key %in% survey_hits$key)
})

test_that("getLMSResourcesByName filters correctly by resource type", {
    skip_if_no_opal()

    con <- opal()

    exam_test <- make_test_exam(TEST_RTYPE_TEST_NAME)
    exam_survey <- make_test_exam(TEST_RTYPE_SURVEY_NAME)

    suppressMessages(
        upload2LMS(
            con,
            exam_test,
            display_name = TEST_RTYPE_TEST_NAME,
            open_in_browser = FALSE,
            as_survey = FALSE,
            overwrite = TRUE
        )
    )

    suppressMessages(
        upload2LMS(
            con,
            exam_survey,
            display_name = TEST_RTYPE_SURVEY_NAME,
            open_in_browser = FALSE,
            as_survey = TRUE,
            overwrite = TRUE
        )
    )

    test_hits <- getLMSResourcesByName(con, TEST_RTYPE_TEST_NAME, "FileResource.TEST")
    survey_hits <- getLMSResourcesByName(con, TEST_RTYPE_SURVEY_NAME, "FileResource.SURVEY")

    expect_true(nrow(test_hits) >= 1)
    expect_true(nrow(survey_hits) >= 1)
    expect_true(all(test_hits$resourceableTypeName == "FileResource.TEST"))
    expect_true(all(survey_hits$resourceableTypeName == "FileResource.SURVEY"))
})

test_that("upload2opal and upload2LMS return URLs that look valid", {
    skip_if_no_opal()

    con <- opal()

    res1 <- suppressMessages(
        upload2opal(
            make_test_item(TEST_URL_DIRECT_NAME),
            display_name = TEST_URL_DIRECT_NAME,
            open_in_browser = FALSE,
            overwrite = TRUE
        )
    )

    res2 <- suppressMessages(
        upload2LMS(
            con,
            make_test_exam(TEST_URL_METHOD_NAME),
            display_name = TEST_URL_METHOD_NAME,
            open_in_browser = FALSE,
            overwrite = TRUE
        )
    )

    expect_true(grepl("https?://[^\\s]+", res1$url))
    expect_true(grepl("https?://[^\\s]+", res2$url))
})

test_that("default connection can be guessed", {
    skip_if_no_opal()
    expect_message(get_default_connetion(), "A connection to the LMS")
})

test_that("qti test archives are detected correctly", {
    es <- make_test_item("ForTestAPI")
    exam <- suppressMessages(test(section(es)))
    path <- createQtiTest(exam, dir = tempdir())
    expect_true(is_test(path))
})

test_that("upload2LMS sends survey resources with survey target type", {
    con <- mock_opal_connection()
    uploaded <- NULL

    local_mocked_bindings(
        getLMSResourcesByName = function(object, display_name, rtype = NULL) {
            data.frame(key = character(),
                       displayname = character(),
                       resourceableTypeName = character())
        },
        upload_resource = function(file, display_name, rtype, access,
                                   endpoint = NULL) {
            uploaded <<- list(file = file, display_name = display_name,
                              rtype = rtype, access = access,
                              endpoint = endpoint)
            opal_upload_response("survey-key", display_name)
        },
        update_resource = function(...) stop("unexpected update"),
        .package = "rqti"
    )

    res <- suppressMessages(upload2LMS(
        con,
        make_test_exam("mock_survey"),
        display_name = "mock_survey",
        open_in_browser = FALSE,
        as_survey = TRUE
    ))

    expect_identical(uploaded$rtype, "FileResource.SURVEY")
    expect_identical(uploaded$display_name, "mock_survey")
    expect_identical(res$key, "survey-key")
})

test_that("upload2LMS rejects overwriting a resource with a different type", {
    con <- mock_opal_connection()

    local_mocked_bindings(
        getLMSResourcesByName = function(object, display_name, rtype = NULL) {
            data.frame(key = "survey-key",
                       displayname = display_name,
                       resourceableTypeName = "FileResource.SURVEY")
        },
        upload_resource = function(...) stop("unexpected upload"),
        update_resource = function(...) stop("unexpected update"),
        .package = "rqti"
    )

    expect_error(
        suppressMessages(upload2LMS(
            con,
            make_test_exam("mock_test"),
            display_name = "mock_existing_survey",
            open_in_browser = FALSE,
            as_survey = FALSE
        )),
        "Current type and target type of the resource is not equal"
    )
})

test_that("upload2LMS derives display_name when it is NULL", {
    con <- mock_opal_connection()
    uploaded <- NULL

    local_mocked_bindings(
        getLMSResourcesByName = function(object, display_name, rtype = NULL) {
            data.frame(key = character(),
                       displayname = character(),
                       resourceableTypeName = character())
        },
        upload_resource = function(file, display_name, rtype, access,
                                   endpoint = NULL) {
            uploaded <<- list(file = file, display_name = display_name,
                              rtype = rtype)
            opal_upload_response("null-display-key", display_name)
        },
        update_resource = function(...) stop("unexpected update"),
        .package = "rqti"
    )

    res <- suppressMessages(upload2LMS(
        con,
        make_test_exam("mock_null_display"),
        display_name = NULL,
        open_in_browser = FALSE
    ))

    expect_false(is.null(uploaded$display_name))
    expect_identical(
        uploaded$display_name,
        tools::file_path_sans_ext(basename(uploaded$file))
    )
    expect_identical(res$display_name, uploaded$display_name)
})

test_that("upload2LMS sends standalone question archives with question target type", {
    con <- mock_opal_connection()
    uploaded <- NULL
    question_zip <- suppressMessages(createQtiTask(
        make_test_item("mock_question"),
        dir = tempdir(),
        zip = TRUE
    ))

    local_mocked_bindings(
        getLMSResourcesByName = function(object, display_name, rtype = NULL) {
            data.frame(key = character(),
                       displayname = character(),
                       resourceableTypeName = character())
        },
        upload_resource = function(file, display_name, rtype, access,
                                   endpoint = NULL) {
            uploaded <<- list(file = file, display_name = display_name,
                              rtype = rtype)
            opal_upload_response("question-key", display_name)
        },
        update_resource = function(...) stop("unexpected update"),
        .package = "rqti"
    )

    res <- suppressMessages(upload2LMS(
        con,
        question_zip,
        display_name = "mock_question",
        open_in_browser = FALSE
    ))

    expect_false(is_test(question_zip))
    expect_identical(uploaded$rtype, "FileResource.QUESTION")
    expect_identical(res$key, "question-key")
})

test_that("getCourseElements works for the Methodenguru course", {
    skip_if_no_opal()

    con <- opal_for_test()
    course_id <- METHODENGURU_RESOURCE_ID

    elems <- getCourseElements(con, course_id)

    expect_s3_class(elems, "data.frame")
    expect_true(ncol(elems) >= 4)
    expect_true(all(c("nodeId", "shortTitle", "shortName", "longTitle") %in% names(elems)))
    expect_true(nrow(elems) >= 1)
})

test_that("Methodenguru course ids and Test dummy element can be resolved", {
    fx <- methodenguru_fixture()

    expect_identical(fx$course_id, METHODENGURU_COURSE_ID)
    expect_identical(fx$resource_id, METHODENGURU_RESOURCE_ID)
    expect_true(nzchar(fx$course_id))
    expect_true(nzchar(fx$resource_id))
    expect_s3_class(fx$elements, "data.frame")
    expect_true(all(c("nodeId", "shortTitle", "shortName", "longTitle") %in% names(fx$elements)))
    expect_identical(fx$element$shortName[[1]], METHODENGURU_TEST_DUMMY_SHORT_NAME)
    expect_true(nzchar(fx$node_id))
})

test_that("getCourseGroups downloads Methodenguru groups", {
    fx <- methodenguru_fixture()

    groups <- getCourseGroups(fx$con, fx$resource_id)

    expect_s3_class(groups, "data.frame")
    expect_true(all(c(
        "key", "name", "description", "minParticipants", "maxParticipants",
        "invitationEnabled", "signoutEnabled"
    ) %in% names(groups)))
})

test_that("getGroupUsers downloads participants for Methodenguru groups", {
    fx <- methodenguru_fixture()
    groups <- getCourseGroups(fx$con, fx$resource_id)

    if (nrow(groups) == 0) {
        skip("No Methodenguru groups available.")
    }

    users <- getGroupUsers(fx$con, groups$key)

    expect_s3_class(users, "data.frame")
    expect_true(all(c(
        "group_id", "user_id", "user_login", "user_first_name",
        "user_last_name", "user_email"
    ) %in% names(users)))
    expect_true(nrow(users) >= 0)
})

test_that("getCourseAssessment downloads Methodenguru assessment data", {
    fx <- methodenguru_fixture()

    assessment <- getCourseAssessment(fx$con, fx$resource_id, fx$node_id)

    if (is.null(assessment)) {
        skip("No Methodenguru assessment data available or accessible.")
    }

    expect_s3_class(assessment, "data.frame")
    expect_true(all(c(
        "identity_key", "user_id", "user_login", "user_first_name",
        "user_last_name", "user_email", "score", "max_score", "passed",
        "attempts"
    ) %in% names(assessment)))
})

test_that("getCourseResult downloads Methodenguru Test dummy result data", {
    fx <- methodenguru_fixture()

    expect_identical(fx$element$shortName[[1]], METHODENGURU_TEST_DUMMY_SHORT_NAME)

    out <- getCourseResult(
        fx$con,
        resource_id = fx$resource_id,
        node_id = fx$elements$nodeId[fx$elements$shortName == "TestDummy2"],
        path_outcome = tempdir(),
        rename = TRUE
    )

    if (is.null(out)) {
        skip("No Methodenguru result zip available for Test dummy.")
    }

    expect_true(file.exists(out))
    expect_match(basename(out), "^results_TestDummy2\\.zip$")
})

test_that("Methodenguru Test dummy can be updated with a new test resource", {
    fx <- methodenguru_fixture()
    exam <- make_test_exam(TEST_METHODENGURU_NAME)

    uploaded <- suppressMessages(
        upload2LMS(
            fx$con,
            exam,
            display_name = TEST_METHODENGURU_NAME,
            open_in_browser = FALSE,
            overwrite = TRUE
        )
    )

    resp <- updateCourseElementResource(
        fx$con,
        course_id = fx$resource_id,
        node_id = fx$node_id,
        resource_id = uploaded$key,
        publish = TRUE
    )

    expect_type(uploaded, "list")
    expect_true(nzchar(uploaded$key))
    expect_identical(as.integer(resp$status_code), 200L)
    expect_identical(fx$element$shortName[[1]], METHODENGURU_TEST_DUMMY_SHORT_NAME)
})

test_that("course assessment XML is parsed into score data", {
    xml <- xml2::read_xml(
        paste0(
            "<assessableResultsVOes>",
            "<assessableResultsVO>",
            "<identityKey>4434478786</identityKey>",
            "<userVO>",
            "<key>4431478786</key>",
            "<firstName>Natalie</firstName>",
            "<lastName>Nutzer</lastName>",
            "<email>natalie.nutzer@beispiel.de</email>",
            "</userVO>",
            "<score>15.0</score>",
            "<maxScore>25.0</maxScore>",
            "<passed>true</passed>",
            "<attempts>4</attempts>",
            "</assessableResultsVO>",
            "</assessableResultsVOes>"
        )
    )

    assessment <- parse_course_assessment_response(xml)

    expect_s3_class(assessment, "data.frame")
    expect_identical(
        names(assessment),
        c(
            "identity_key", "user_id", "user_login", "user_first_name",
            "user_last_name", "user_email", "score", "max_score", "passed",
            "attempts"
        )
    )
    expect_equal(nrow(assessment), 1)
    expect_identical(assessment$identity_key, "4434478786")
    expect_identical(assessment$user_id, "4431478786")
    expect_true(is.na(assessment$user_login))
    expect_identical(assessment$user_first_name, "Natalie")
    expect_identical(assessment$user_last_name, "Nutzer")
    expect_identical(assessment$user_email, "natalie.nutzer@beispiel.de")
    expect_equal(assessment$score, 15)
    expect_equal(assessment$max_score, 25)
    expect_true(assessment$passed)
    expect_identical(assessment$attempts, 4L)
})
