#' LMS Class
#'
#' The `LMS` class is an abstract representation of a Learning Management System (LMS).
#' It provides a foundation for defining LMS-specific implementations.
#'
#' @slot name A character string representing the name or identifier of the LMS.
#' @slot api_user A character string containing the username for authentication.
#' @slot endpoint A character string specifying the LMS API endpoint. By default,
#'   this value is retrieved from the environment variable `RQTI_API_ENDPOINT`.
#'   To set this variable globally, use:
#'   `Sys.setenv(RQTI_API_ENDPOINT = 'your_endpoint')`,
#'   or add it to your `.Renviron` file for persistence across sessions.
#'
#' @name LMS-class
#' @rdname LMS-class
#' @aliases LMS
setClass("LMS", slots = c(name = "character",
                          api_user = "character",
                          endpoint = "character"))

setMethod("initialize", "LMS", function(.Object, ...) {
    .Object <- callNextMethod()

    if (length(.Object@endpoint) == 0) .Object@endpoint <- NA_character_
    if (is.na(.Object@endpoint)) {
        endpoint <- Sys.getenv("RQTI_API_ENDPOINT")
        if (endpoint == "") {
            stop(
                "The API endpoint is not defined. ",
                "Please ensure the endpoint is provided either:\n",
                "1. As an \"endpoint\" slot value in the object, or\n",
                "2. As an environment variable named 'RQTI_API_ENDPOINT'.\n",
                "Example: Sys.setenv(RQTI_API_ENDPOINT = 'https://api.example.com')",
                call. = FALSE)
        }
        .Object@endpoint <- endpoint
    }

    api_user <- .Object@api_user
    if (length(api_user) == 0) api_user <- NULL

    api_user <- get_password(service_name = paste0("rqti", tolower(.Object@name)),
                            api_user = api_user)$api_user
    if (is.null(api_user)) {
        stop(
            "The API username is required but not found.\n",
            "No users for this service exist in the OS credential storage or have been created.")
    }

    .Object@api_user <- api_user
    st_code <- authLMS(.Object)
    if (st_code != 200) {
        warning("Connector object was created, but the authentication attempt failed with status code ", st_code, ".")
    }

    validObject(.Object)
    .Object
})

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

#' Authenticate with LMS
#'
#' A generic function to handle authentication with LMS.
#' @param object an instance of the S4 object [Opal], [LMS]
#' @docType methods
#' @rdname authLMS-methods
#' @export
setMethod("authLMS", "LMS", function(object, ...) {

    args <- list(...)
    api_user <- ifelse("api_user" %in% names(args), args$api_user, object@api_user)
    if (length(api_user) == 0 ) api_user <- NULL

    endpoint <- object@endpoint
    api_password <- get_password(paste0("rqti", tolower(object@name)),
                                 api_user)$api_password

    url_login <- paste0(endpoint, "restapi/auth/", api_user, "?password=", api_password)
    req <- request(url_login)
    response <- req %>% req_error(is_error = ~ FALSE) %>% req_perform()
    if (response$status_code == 200) {
        parse <- resp_body_xml(response)
        token <- response$headers$`X-OLAT-TOKEN`
        Sys.setenv("X-OLAT-TOKEN"=token)
    }
    return(response$status_code)
})


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

#' Upload content to LMS
#'
#' This is a method that handles the process of uploading content to
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
setMethod("upload2LMS", "LMS", function(object, test, ...) {
    login_status <- authLMS(object)
    if (login_status != 200) {
        message("Login failed with status code: ", login_status)
        message("Unable to log in. Please check your credentials or connection.")
        return(NULL)
    }
})

#' Get records of all current user's resources on LMS
#'
#' @param object An S4 object of class [LMS] that represents a connection to the
#'   LMS.
#' @return A dataframe with attributes of user's resources.
#' @examplesIf interactive()
#' df <- getLMSResources()
#' @export
setGeneric("getLMSResources", function(object) standardGeneric("getLMSResources"))


#' Get records of all current user's resources on LMS
#'
#' This function retrieves data about all resources associated with the current user on the Learning Management System (LMS).
#' If no LMS connection object is provided, it attempts to guess the connection using default settings (e.g., environment variables).
#' If the connection cannot be established, an error is thrown.
#'
#' @param object An S4 object of class [LMS] that represents a connection to the
#'   LMS.
#' @return A dataframe with attributes of user's resources.
#' @examplesIf interactive()
#' df <- getLMSResources()
#' @export
setMethod("getLMSResources", signature(object = "missing"), function(object) {
    connection <- guess_connection()

    if (is.null(connection)) {
        stop("Failed to create a default LMS connection. Please check your environment variables or provide a connection object.")
    }

    return(getLMSResources(connection))
})

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

#' Get select records about user resources by name.
#'
#' This function retrieves data about a user's resource by its name on Learning Management System (LMS).
#' If no LMS connection object is provided, it attempts to guess the connection using default settings (e.g., environment variables).
#' If the connection cannot be established, an error is thrown.
#'
#' @param object An S4 object of class [LMS] that represents a connection to the
#'   LMS.
#' @param display_name A string value withe the name of resource.
#' @param rtype A string value with the type of resource. Possible values:
#'   "FileResource.TEST", "FileResource.QUESTION", or "FileResource.SURVEY".
#' @return A dataframe with attributes of user's resources.
#' @examplesIf interactive()
#' df <- getLMSResourcesByName("task_name")
#' @export
setMethod("getLMSResourcesByName", signature(object = "missing"),
          function(object, display_name, rtype = NULL) {
    connection <- guess_connection()

    if (is.null(connection)) {
      stop("Failed to create a default LMS connection. Please check your environment variables or provide a connection object.")
    }

    return(getLMSResourcesByName(connection, display_name = display_name,
                                 rtype = rtype))
})

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

#' @importFrom utils menu
get_password <- function(service_name, api_user = NULL, psw = NULL) {

    api_user <- if (!is.null(api_user) && is.na(api_user)) NULL else api_user

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

# check if this is a test using the manifest file
is_test <- function(file) {
    zip_con <- unz(file, "imsmanifest.xml")
    file_content <- readLines(zip_con, n = -1L)
    close(zip_con)
    result <- grepl("imsqti_test_xmlv2p1", file_content)
    return(any(result))
}

# creates LMS object using some traits in env
guess_connection <- function() {
    endpoint <- Sys.getenv("RQTI_API_ENDPOINT", unset = NA)

    if (is.na(endpoint) || nchar(endpoint) == 0) {
        message("No endpoint found in environment variables.")
        return(NULL)
    }

    if (!grepl("opal", endpoint, ignore.case = TRUE)) {
        message("Cannot detect LMS Opal by endpoint: ", endpoint)
        return(NULL)
    }

    new("Opal")
}
