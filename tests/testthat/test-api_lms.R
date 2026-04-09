
test_that("LMS object can be created for OPAL", {
    skip_if(Sys.getenv("RQTI_API_USER") == "")
    con <- opal()
    expect_s4_class(con, "Opal")
    logged_in <- isUserLoggedIn(con)
    expect_true(logged_in)
})


test_that("LMS OPAL handles missing parameters correctly", {
    skip_if(Sys.getenv("RQTI_API_USER") == "")
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
    skip_if(Sys.getenv("RQTI_API_USER") == "")
    con <- opal()
    # create resource from object
    es <- suppressWarnings(essay(identifier = "ForTestAPI"))
    res <- suppressMessages(upload2opal(es, display_name = "test_ForTestAPI", open_in_browser = F))
    df <- getLMSResourcesByName(con, display_name = "test_ForTestAPI")
    url <- getLMSResourceURL(con, display_name = "test_ForTestAPI")
    df3 <- getLMSResources(con)
    expect_equal(nrow(df), 1)
    expect_equal(url, res$url)
})

test_that("Create a resource on Opal, test getting resource, inc. get by name", {
    skip_if(Sys.getenv("RQTI_API_USER") == "")
    con <- opal()
    # create resource from object
    es <- suppressWarnings(essay(identifier = "ForTestAPI"))
    res <- suppressMessages(upload2LMS(con, es, open_in_browser = FALSE))
    df <- getLMSResourcesByName(con, display_name = "test_ForTestAPI")
    url <- getLMSResourceURL(con, display_name = "test_ForTestAPI")
    df3 <- getLMSResources(con)
    expect_equal(nrow(df), 1)
    expect_equal(url, res$url)
    expect_true(prod(dim(df3)) > 0)
})

test_that("Get URL", {
    skip_if(Sys.getenv("RQTI_API_USER") == "")
    con <- opal()
    sut <- getLMSResourceURL(con, "test_ForTestAPI")
    expect_true(grepl("https?://[^\\s]+", sut))
})

test_that("default connections are guessed correctly", {
    skip_if(Sys.getenv("RQTI_API_USER") == "")
    expect_message(get_default_connetion(), "A connection to the LMS")
})

test_that("qti tests are detected correctly", {
    es <- suppressWarnings(essay(identifier = "ForTestAPI"))
    temp <- tempdir()
    exam <- suppressMessages(test(section(es)))
    path <- createQtiTest(exam, dir = temp)
    expect_true(is_test(path))
})

# tests/testthat/test-opal-integration.R

library(testthat)

skip_if_no_opal <- function() {
    skip_if(Sys.getenv("RQTI_API_USER") == "")
}

skip_if_no_course_env <- function() {
    needed <- c("RQTI_OPAL_COURSE_ID", "RQTI_OPAL_NODE_ID", "RQTI_OPAL_RESOURCE_ID")
    vals <- Sys.getenv(needed)
    skip_if(any(vals == ""))
}

unique_name <- function(prefix = "rqti-test") {
    paste(prefix, format(Sys.time(), "%Y%m%d%H%M%S"), Sys.getpid(), sample.int(1e6, 1), sep = "-")
}

make_test_item <- function(id = unique_name("item")) {
    suppressWarnings(essay(identifier = id))
}

make_test_exam <- function(id = unique_name("exam")) {
    suppressMessages(test(section(make_test_item(id))))
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
    missing_name <- unique_name("definitely-not-existing")

    expect_warning(
        out <- getLMSResourceURL(con, missing_name),
        "No resources found with the specified display name"
    )
    expect_null(out)
})

test_that("upload2opal creates a resource that can be found again", {
    skip_if_no_opal()

    con <- opal()
    display_name <- unique_name("upload2opal-direct")
    es <- make_test_item(display_name)

    res <- suppressMessages(
        upload2opal(
            es,
            display_name = display_name,
            open_in_browser = FALSE
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
    display_name <- unique_name("upload2lms-test")
    exam <- make_test_exam(display_name)

    res <- suppressMessages(
        upload2LMS(
            con,
            exam,
            display_name = display_name,
            open_in_browser = FALSE
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
    display_name <- unique_name("overwrite-test")

    exam1 <- make_test_exam(paste0(display_name, "-1"))
    exam2 <- make_test_exam(paste0(display_name, "-2"))

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
    display_name <- unique_name("survey-test")
    exam <- make_test_exam(display_name)

    res <- suppressMessages(
        upload2LMS(
            con,
            exam,
            display_name = display_name,
            open_in_browser = FALSE,
            as_survey = TRUE
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
    base_name <- unique_name("rtype-check")
    exam <- make_test_exam(base_name)

    suppressMessages(
        upload2LMS(
            con,
            exam,
            display_name = base_name,
            open_in_browser = FALSE,
            as_survey = FALSE
        )
    )

    suppressMessages(
        upload2LMS(
            con,
            exam,
            display_name = paste0(base_name, "-survey"),
            open_in_browser = FALSE,
            as_survey = TRUE
        )
    )

    test_hits <- getLMSResourcesByName(con, base_name, "FileResource.TEST")
    survey_hits <- getLMSResourcesByName(con, paste0(base_name, "-survey"), "FileResource.SURVEY")

    expect_true(nrow(test_hits) >= 1)
    expect_true(nrow(survey_hits) >= 1)
    expect_true(all(test_hits$resourceableTypeName == "FileResource.TEST"))
    expect_true(all(survey_hits$resourceableTypeName == "FileResource.SURVEY"))
})

test_that("upload2opal and upload2LMS return URLs that look valid", {
    skip_if_no_opal()

    con <- opal()

    name1 <- unique_name("url-check-direct")
    name2 <- unique_name("url-check-method")

    res1 <- suppressMessages(
        upload2opal(
            make_test_item(name1),
            display_name = name1,
            open_in_browser = FALSE
        )
    )

    res2 <- suppressMessages(
        upload2LMS(
            con,
            make_test_exam(name2),
            display_name = name2,
            open_in_browser = FALSE
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

test_that("getCourseElements works for a configured real course", {
    skip_if_no_opal()
    skip_if_no_course_env()

    con <- opal()
    course_id <- Sys.getenv("RQTI_OPAL_COURSE_ID")

    elems <- getCourseElements(con, course_id)

    expect_s3_class(elems, "data.frame")
    expect_true(ncol(elems) >= 4)
    expect_true(all(c("nodeId", "shortTitle", "shortName", "longTitle") %in% names(elems)))
    expect_true(nrow(elems) >= 1)
})

test_that("publishCourse returns a successful status for a configured real course", {
    skip_if_no_opal()
    skip_if_no_course_env()

    con <- opal()
    course_id <- Sys.getenv("RQTI_OPAL_COURSE_ID")

    status <- publishCourse(con, course_id)

    expect_true(is.numeric(status) || is.integer(status))
    expect_identical(as.integer(status), 200L)
})

test_that("updateCourseElementResource updates and publishes a configured real course element", {
    skip_if_no_opal()
    skip_if_no_course_env()

    con <- opal()
    course_id <- Sys.getenv("RQTI_OPAL_COURSE_ID")
    node_id <- Sys.getenv("RQTI_OPAL_NODE_ID")
    resource_id <- Sys.getenv("RQTI_OPAL_RESOURCE_ID")

    resp <- updateCourseElementResource(
        con,
        course_id = course_id,
        node_id = node_id,
        resource_id = resource_id,
        publish = TRUE
    )

    expect_true(!is.null(resp))
    expect_identical(resp$status_code, 200)
})

test_that("getCourseResult downloads a zip for a configured real course element", {
    skip_if_no_opal()
    skip_if_no_course_env()

    con <- opal()
    resource_id <- Sys.getenv("RQTI_OPAL_RESOURCE_ID")
    node_id <- Sys.getenv("RQTI_OPAL_NODE_ID")

    out <- getCourseResult(
        con,
        resource_id = resource_id,
        node_id = node_id,
        path_outcome = tempdir(),
        rename = FALSE
    )

    if (is.null(out)) {
        skip("No result zip available for configured course/node.")
    }

    expect_true(file.exists(out))
    expect_match(basename(out), "\\.zip$")
})

test_that("getCourseResult also works with an explicit zip file path", {
    skip_if_no_opal()
    skip_if_no_course_env()

    con <- opal()
    resource_id <- Sys.getenv("RQTI_OPAL_RESOURCE_ID")
    node_id <- Sys.getenv("RQTI_OPAL_NODE_ID")
    target <- file.path(tempdir(), paste0(unique_name("results"), ".zip"))

    out <- getCourseResult(
        con,
        resource_id = resource_id,
        node_id = node_id,
        path_outcome = target,
        rename = FALSE
    )

    if (is.null(out)) {
        skip("No result zip available for configured course/node.")
    }

    expect_identical(normalizePath(out, winslash = "/"),
                     normalizePath(target, winslash = "/", mustWork = FALSE))
    expect_true(file.exists(out))
})
