#' Class LMS
#'
#' Abstract class `LMS` is represents learning management system.
#' @name LMS-class
#' @rdname LMS-class
#' @aliases LMS
setClass("LMS", slots = c(name = "character",
                          api_user = "character",
                          endpoint = "character"))

#' Authenticate with LMS
#'
#' A generic function to handle authentication with a Learning Management System
#' (LMS).
#' @param object an instance of the S4 object [LMS]
#' @param ... Additional arguments to be passed to the method, if applicable.
#' @docType methods
#' @rdname authLMS-methods
#' @importFrom httr2 request req_error req_perform resp_body_xml req_headers
#'   resp_body_json req_method req_body_multipart
#' @import getPass
#' @importFrom keyring key_list key_set_with_value has_keyring_support key_delete key_get
#' @export
setGeneric("authLMS", function(object, ...) standardGeneric("authLMS"))

#' Check if User is Logged in LMS
#'
#' This method checks whether a user is logged into an LMS (Learning Management System) by
#' sending a request to the LMS server and evaluating the response.
#'
#' @param object An S4 object of class [LMS] that represents a connection to the LMS.
#' @return A logical value (`TRUE` if the user is logged in, `FALSE` otherwise).
#' @docType methods
#' @rdname isUserLoggedIn-methods
#' @export
setGeneric("isUserLoggedIn", function(object) standardGeneric("isUserLoggedIn"))

#' Upload content to LMS
#'
#' This is a generic function that handles the process of uploading content to
#' a Learning Management System (LMS). The content can be in the form of an
#' `AssessmentTest`, `AssessmentTestOpal`, `AssessmentItem` object, or a file in
#' Rmd, Markdown, zip or XML format.
#' @param object An S4 object representing the LMS, such as an instance of the
#'   [LMS] class.
#' @param test An [AssessmentTest], [AssessmentTestOpal] or [AssessmentItem]
#'   objects, or a character string with path to Rmd/md, zip or XML files.
#' @param ... Additional arguments to be passed to the method, if applicable.
#' @docType methods
#' @rdname upload2LMS-methods
#' @export
setGeneric("upload2LMS", function(object, test, ...) standardGeneric("upload2LMS"))

#' Get records of all current user's resources on LMS
#'
#' @param object An S4 object of class [LMS] that represents a connection to the
#'   LMS.
#' @return A dataframe with attributes of user's resources.
#' @examplesIf interactive()
#' df <- getLMSResources()
#' @export
setGeneric("getLMSResources", function(object) standardGeneric("getLMSResources"))

#' Get select records about user resources by name.
#'
#' @param object An S4 object of class [LMS] that represents a connection to the
#'   LMS.
#' @param display_name A string value withe the name of resource.
#' @param rtype A string value with the type of resource. Possible values:
#'   "FileResource.TEST", "FileResource.QUESTION", or "FileResource.SURVEY".
#' @return A dataframe with attributes of user's resources.
#' @examplesIf interactive()
#' df <- getLMSResourcesByName()
#' @export
setGeneric("getLMSResourcesByName", function(object, display_name, rtype = NULL)
    standardGeneric("getLMSResourcesByName"))

#' Create a URL using the resource's display name in LMS
#'
#' @param object An S4 object of class [LMS] that represents a connection to the LMS.
#' @param display_name A length one character vector to entitle file in LMS;
#'  it takes file name without extension by default; optional.
#' @return A string value of URL.
#' @importFrom utils browseURL
#' @export
setGeneric("getLMSResourceURL", function(object, display_name)
    standardGeneric("getLMSResourceURL"))

#' Get elements of the course by courseId from LMS
#'
#' @param object An S4 object of class [LMS] that represents a connection to the LMS.
#' @param course_id A length one character vector with course id.
#' @return A dataframe with the elements of the course.
#' @export
setGeneric("getCourseElements", function(object, course_id)
    standardGeneric("getCourseElements"))

#' Update the referenced learning resource of a course element in the LMS
#'
#' @param object An S4 object of class [LMS] that represents a connection to the LMS.
#' @param course_id A character string with course id in the LMS.
#' @param ... Additional arguments to be passed to the method, if applicable.
#' @return Response of the HTTP request.
#' @export
setGeneric("updateCourseElementResource", function(object, course_id, ...)
    standardGeneric("updateCourseElementResource"))

#' Publish a course on LMS
#'
#' @param object An S4 object of class [LMS] that represents a connection to the LMS.
#' @param course_id A character string with course id in the LMS.
#' @return Status code of the HTTP request.
#' @export
setGeneric("publishCourse", function(object, course_id)
    standardGeneric("publishCourse"))

#' Get zip with course results by resource id and node id
#'
#' @param object An S4 object of class [LMS] that represents a connection to the LMS.
#' @param resource_id A length one character vector with resource id.
#' @param node_id A length one character vector with node id (test).
#' @param path_outcome A length one character vector with path, where the zip should be
#'   stored. Default is working directory.
#' @param ... Additional arguments to be passed to the method, if applicable.
#' @return It downloads a zip and return a character string with path.
#' @examplesIf interactive()
#' zip_file <- getCourseResult("89068111333293", "1617337826161777006")
#' @export
setGeneric("getCourseResult", function(object, resource_id, node_id, path_outcome = ".", ...)
    standardGeneric("getCourseResult"))

get_password <- function(service_name, api_user = NULL, psw = NULL) {

    if (!has_keyring_support()) {
        warning("OS does not support key ring storage")
    }

    if (is.null(api_user) && !is.null(psw)) {
        stop("API user must be provided when a password is supplied.", call. = FALSE)
    }

    if (!is.null(api_user)) {
        user_exist <- any(key_list(service_name)$username == api_user)

        if (!user_exist) {
            if (interactive()) {
                message("Username not found in credential storage.")
                key <- menu(title = "Create a new user?", c("Yes", "No"))

                if (key == 1) {
                    if (is.null(psw)) psw <- getPass("Enter Password: ")
                    key_set_with_value(service_name, api_user, psw)
                } else {
                    return(NULL)
                }
            } else {
                stop("Username not found in credential storage.", call. = FALSE)
            }
        }

        if (is.null(psw)) {
            psw = key_get(service_name, api_user)
        } else {
            key_set_with_value(service_name, api_user, psw)
        }

    } else {
        keys <- key_list(service_name)
        number_keys <- nrow(keys)

        if (number_keys == 0) {
            api_user <- readline(paste0("Enter Username:"))
            psw <- getPass("Enter Password: ")
            key_set_with_value(service_name, api_user, psw)
        } else if (number_keys == 1) {
            api_user <- keys$username
            psw <- key_get(service_name, keys$username)
        } else {
            menu_options <- c(keys$username, "Abort")
            if (interactive()) {
                key <- menu(title = "Choose a user:", choices = menu_options)
            } else {
                message("Multiple user credentials found. Please review.")
                return(NULL)
            }
            # abort
            if (key %in% c(length(menu_options), 0)) {
                return(NULL)
            } else {
                api_user <- menu_options[key]
                message("Selected username: ", api_user)
                psw <- key_get(service_name, api_user)
            }
        }
    }

    return(list(api_username = api_user, api_password = psw))
}

#' @importFrom utils menu
process_init_credentials <- function(object, service_name = "rqtiolat", endpoint = NULL, api_user) {

    creds <- get_password(service_name, api_user)
    if (is.null(creds)) stop("Failed to retrieve credentials.", call. = FALSE)

    response <- 0
    max_retries <- 5
    attempts <- 0

    while (response != 200 && attempts < max_retries) {
        api_user <- creds$api_username
        response <- authLMS(object, api_user = api_user, api_password = creds$api_password)

        if (is.null(response)) stop("This method is not implemented yet.")

        if (response != 200) {
            message("Authorization failed. Status code: ", response)

            if (!interactive()) {
                stop("Non-interactive session: change credentials in OS credential storage.", call. = FALSE)
            }

            # Interactive credential update
            key <- menu(title = "Choose an option:", choices = c("Change password for username",
                                                                 "Try with other username",
                                                                 "Try with other username and password",
                                                                 "Abort"))

            creds <- handle_credential_update(key, api_user, creds, service_name)
            if (is.null(creds)) stop("Authorization aborted by user.", call. = FALSE)
        }

        attempts <- attempts + 1
    }

    if (response != 200) stop("Authorization failed after multiple attempts.", call. = FALSE)
    return(creds$api_username)
}

handle_credential_update <- function(key, api_user, creds, service_name) {
    switch (key,
        '1' = {# Change password for current username
            api_password <- getPass("Enter new password: ")
            },
        '2' = {# Use a different username
            api_user <- NULL
            api_password <- NULL
            },
        '3' = {# Use new username and password
            api_user <- readline("Enter Username: ")
            api_password <- getPass("Enter Password: ")
            },
        '4' = {# Abort
            return(NULL)
            }
    )
    creds <- get_password(service_name, api_user, api_password)
    return(creds)
}

# check if this is a test using the manifest file
is_test <- function(file) {
    zip_con <- unz(file, "imsmanifest.xml")
    file_content <- readLines(zip_con, n = -1L)
    close(zip_con)
    result <- grepl("imsqti_test_xmlv2p1", file_content)
    return(any(result))
}
