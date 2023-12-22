#' Authentification in OPAL API
#'
#' Function `auth_opal()` performs the necessary authentication steps in OPAL
#' API. If the authentication is successful, the function sets the cookie value
#' in the system environment and returns the user's identity key in OPAL. The
#' cookie value is required to access the OPAL API system."
#'
#' @param api_user username on OPAL
#' @param api_password password on OPAL
#' @param endpoint endpoint of LMS Opal; by default it is got from environment
#'   variable `QTI_API_ENDPOINT`. To set a global environment variable, you need
#'   to call `Sys.setenv(QTI_API_ENDPOINT='xxxxxxxxxxxxxxx')` or you can put
#'   these command into .Renviron.
#'
#' @section Authentication: To use OPAL API, you need to provide your
#'  OPAL-username and password. This function can get `api_user` from
#'  environment variables. To set a global environment variable, you need to
#'  call `Sys.setenv(QTI_API_USER ='xxxxxxxxxxxxxxx')` or you can put these
#'  commands into .Renviron. This package uses system credential store 'keyring'
#'  to store user's password.
#'
#' @return user id
#' @name auth_opal
#' @rdname auth_opal
#' @importFrom httr2 request req_error req_perform resp_body_xml req_headers resp_body_json req_method req_body_multipart
#' @import getPass
#' @import keyring
#' @export
auth_opal <- function(api_user = NULL, api_password = NULL, endpoint = NULL) {
    user_id <- NULL

    if (is.null(api_user)) api_user <- Sys.getenv("QTI_API_USER")
    if (is.null(endpoint)) endpoint <- Sys.getenv("QTI_API_ENDPOINT")

    if (api_user == "") {
        api_user <- readline("Enter Username on Opal: ")
        Sys.setenv(QTI_API_USER = api_user)
    }
    if (is.null(api_password)) {
            if (has_keyring_support()) {
            # OS supports keyring
            if (!any(keyring_list()$keyring == "qtiopal")) {
                keyring_create("qtiopal", password = "qtiopal")
            }

            keyring_unlock("qtiopal", "qtiopal")

            if (!any(key_list("qtiopal", "qtiopal")$username == api_user)) {
                key_set("qtiopal", username = api_user, keyring = "qtiopal",
                        prompt = paste0("Password for ", api_user, ":"))
            }
            api_password <- key_get(service = "qtiopal", keyring = 'qtiopal',
                                    username = api_user)

        } else {
            # OS does not support keyring
            api_password <- getPass("Your OS does not support keyring. Enter Password: ")
        }
    }
    url_login <- paste0(endpoint, "restapi/auth/", api_user, "?password=", api_password)
    req <- request(url_login)
    response <- req %>% req_error(is_error = ~ FALSE) %>% req_perform()
    if (response$status_code == 200) {
        parse <- resp_body_xml(response)
        user_id <- xml2::xml_attr(parse, "identityKey")
        token <- response$headers$`X-OLAT-TOKEN`
        Sys.setenv("X-OLAT-TOKEN"=token)
    }
    if (response$status_code == 403) {
        message("Authentification failed. You may need to run a VPN client")
        user_id <-  NULL
        }
    if (response$status_code == 401) {
        if (has_keyring_support()) {
            if (api_user %in% key_list("qtiopal", "qtiopal")$username) {
                key_delete("qtiopal", api_user, "qtiopal")
            }
        }
        message("401 Unauthorized")
        cat("Would you like to change username and password?")
        choice <- readline("Press \'y\' to change data or any key to exit: ")
        # Check the user's choice
        if (tolower(choice) == "y") {
            Sys.unsetenv("QTI_API_USER")
            user_id <- auth_opal()
        }
    }
    return(user_id)
}

#'Upload resource on OPAL
#'
#'Function `upload2opal()` takes full prepared zip archive of QTI-test or
#'QTI-task and uploads it to the OPAL. before calling `upload2opal()`
#'authentication procedure has to be performed. See [auth_opal]
#'
#'@param test required; a length one character vector or [AssessmentTest] or
#'  [AssessmentTestOpal] objects
#'@param display_name optional; a length one character vector to entitle file in
#'  OPAL; file name without extension by default
#'@param access optional; is responsible for publication status, where 1 - only
#'  those responsible for this learning resource; 2 - responsible and other
#'  authors; 3 - all registered users; 4 - default value, registered users and
#'  guests
#'@param overwrite logical; if only one file with the specified display name is
#'  found, it will be overwritten
#' @param endpoint endpoint of LMS Opal; by default it is got from environment
#'   variable `QTI_API_ENDPOINT`. To set a global environment variable, you need
#'   to call `Sys.setenv(QTI_API_ENDPOINT='xxxxxxxxxxxxxxx')` or you can put
#'   these command into .Renviron.
#'@param open_in_browser logical, optional; the parameter that controls whether
#'  to open a URL in default browser; TRUE by default
#'@param api_user username on OPAL
#'@param api_password password on OPAL
#'@section Authentication: To use OPAL API, you need to provide your
#'  OPAL-username and password. This function can get `api_user` from
#'  environment variables. To set a global environment variable, you need to
#'  call `Sys.setenv(QTI_API_USER ='xxxxxxxxxxxxxxx')` or you can put these
#'  commands into .Renviron. This package uses system credential store 'keyring'
#'  to store user's password.
#'
#'@return list with key and url
#'@importFrom utils browseURL
#'@importFrom tools file_ext
#'@importFrom curl form_file
#'@export
upload2opal <- function(test, display_name = NULL, access = 4, overwrite = TRUE,
                        endpoint = NULL, open_in_browser = TRUE,
                        api_user = NULL, api_password = NULL) {

    if (is.null(endpoint)) endpoint <- Sys.getenv("QTI_API_ENDPOINT")

    file <- createQtiTest(test, dir = tempdir(), zip_only = TRUE)

    if (is.null(display_name)) display_name <- gsub("\\..*", "", basename(file))

    # check auth
    if (!is_logged(endpoint) || !is.null(api_user) ||  !is.null(api_password)) {
        user_id <- auth_opal(api_user, api_password, endpoint)
        if (is.null(user_id)) return(NULL)
    }

    if (!interactive()) display_name <- paste0("knit_", display_name)

    # get resources with given display_name
    rtype <- ifelse(is_test(file), "FileResource.TEST", "FileResource.QUESTION")
    rlist <- get_resources_by_name(display_name, endpoint, rtype)

    if (length(rlist) > 0 && overwrite) {

        if (length(rlist) == 1) {
            resp <- update_resource(file, rlist[[1]]$key, endpoint)
        } else {
            message("Found files with the same display name: ",
                length(rlist))
            menu_options <- c(sapply(rlist, function(x) x$key),
                            "Add new as a duplicate", "Abort")
            if (interactive()) {
                key <- menu(title = "Choose a key:", menu_options)
            } else {
                key <- length(menu_options) - 1
            }
                # abort uploading
            if (key %in% c(length(menu_options), 0)) return(NULL)
                # update the resource
            if (key %in% seq(length(menu_options) - 2)) {
                resp <- update_resource(file, menu_options[key], endpoint)
                }
        }
    }
        # create new resource
    if (!exists("resp")) {
        resp <- upload_resource(file, display_name, rtype, access, endpoint)
    }
    parse <- resp_body_xml(resp)
    key <- xml_find_first(parse, "key") %>% xml_text()
    displayname <- xml_find_first(parse, "displayname") %>% xml_text()

    url_res <- paste0(endpoint, "auth/", "RepositoryEntry/", key)
    if ((open_in_browser) && (!is.null(key))) {
            browseURL(url_res)
        }
    res <- list(key = key, display_name = displayname,
                    url = url_res)
    print(resp$status_code)
    return(res)
}

#' Get list of all user's resources on LMS OPAL
#'
#' @param endpoint endpoint of LMS Opal; by default it is got from environment
#'   variable `QTI_API_ENDPOINT`. To set a global environment variable, you need
#'   to call `Sys.setenv(QTI_API_ENDPOINT='xxxxxxxxxxxxxxx')` or you can put
#'   these command into .Renviron.
#' @param api_user username on OPAL
#' @param api_password password on OPAL
#' @export
get_resources <- function(api_user = NULL, api_password = NULL,
                          endpoint = NULL) {
    if (is.null(endpoint)) endpoint <- Sys.getenv("QTI_API_ENDPOINT")
    # check auth
    if (!is_logged(endpoint) || !is.null(api_user) ||  !is.null(api_password)) {
        user_id <- auth_opal(api_user, api_password)
        if (is.null(user_id)) return(NULL)
    }
    url_res <- paste0(endpoint, "restapi/repo/entries/search?myentries=true")
    req <- request(url_res) %>%
        req_headers("X-OLAT-TOKEN"=Sys.getenv("X-OLAT-TOKEN"))
    response <- req %>% req_error(is_error = ~ FALSE) %>% req_perform()
    rlist <- resp_body_json(response)
    return(rlist)
}

#'@importFrom purrr keep
get_resources_by_name <- function(display_name, endpoint = NULL, rtype = NULL) {
    if (is.null(endpoint)) endpoint <- Sys.getenv("QTI_API_ENDPOINT")
    rlist <- get_resources(endpoint = endpoint)
    if (!is.null(rtype)) {
        rlist <- keep(rlist, ~ .x$resourceableTypeName == rtype)
    }
    rlist <- keep(rlist, ~ .x$displayname == display_name)
    return(rlist)
}

#' Create a URL using the resource's display name in LMS OPAL
#'
#' @param display_name character; target display_name
#' @param endpoint endpoint of LMS Opal; by default it is got from environment
#'   variable `QTI_API_ENDPOINT`. To set a global environment variable, you need
#'   to call `Sys.setenv(QTI_API_ENDPOINT='xxxxxxxxxxxxxxx')` or you can put
#'   these command into .Renviron.
#' @param api_user username on OPAL
#' @param api_password password on OPAL
#' @export
get_resource_url <- function(display_name, endpoint = NULL,
                        api_user = NULL, api_password = NULL) {

    if (is.null(endpoint)) endpoint <- Sys.getenv("QTI_API_ENDPOINT")

    # check auth
    if (!is_logged(endpoint) || !is.null(api_user) ||  !is.null(api_password)) {
        user_id <- auth_opal(api_user, api_password)
        if (is.null(user_id)) return(NULL)
    }
    rlist <- get_resources_by_name(display_name, endpoint)
    keys <- unlist(lapply(rlist, function(item) item$key))
    url <- sapply(keys,
                function(item) paste0(endpoint, "auth/RepositoryEntry/", item))
    return(url)
}

upload_resource <- function(file, display_name, rtype, access,
                            endpoint = NULL) {
    if (is.null(endpoint)) endpoint <- Sys.getenv("QTI_API_ENDPOINT")
    url_upl <- paste0(endpoint, "restapi/repo/entries")
    req <- request(url_upl) %>% req_method("PUT") %>%
        req_headers("X-OLAT-TOKEN"=Sys.getenv("X-OLAT-TOKEN")) %>%
        req_body_multipart(file = curl::form_file(file),
                 displayname = display_name,
                 access = as.character(access),
                 repoType = rtype)
    response <- req %>% req_error(is_error = ~ FALSE) %>% req_perform()
    return(response)
}

update_resource <- function(file, id, endpoint = NULL) {
    if (is.null(endpoint)) endpoint <- Sys.getenv("QTI_API_ENDPOINT")
    url_upd <- paste0(endpoint, "restapi/repo/entries/", id, "/update")
    req <- request(url_upd) %>% req_method("PUT") %>%
        req_headers("X-OLAT-TOKEN"=Sys.getenv("X-OLAT-TOKEN")) %>%
        req_body_multipart(file = curl::form_file(file))
    response <- req %>% req_error(is_error = ~ FALSE) %>% req_perform()
    return(response)
}

# check if this is a test using the manifest file
is_test <- function(file) {
    zip_con <- unz(file, "imsmanifest.xml")
    file_content <- readLines(zip_con, n = -1L)
    close(zip_con)
    result <- grepl("imsqti_test_xmlv2p1", file_content)
    return(any(result))
}

is_logged <- function(endpoint = NULL) {
    if (is.null(endpoint)) endpoint <- Sys.getenv("QTI_API_ENDPOINT")
    url_log <- paste0(endpoint, "restapi/repo/entries/search?myentries=true")
    req <- request(url_log) %>%
        req_headers("X-OLAT-TOKEN"=Sys.getenv("X-OLAT-TOKEN"))
    response <- req %>% req_error(is_error = ~ FALSE) %>% req_perform()
    res <- ifelse(response$status_code == 200, TRUE, FALSE)
    return(res)
}
