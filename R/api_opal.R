#' Authentification in OPAL API
#'
#' Function `auth_opal()` performs the necessary authentication steps in OPAL
#' API. If the authentication is successful, the function sets the token value
#' in the system environment and returns the user's identity key in OPAL. The
#' token value is required to access the OPAL API system.
#'
#' @param api_user username on OPAL
#' @param api_password password on OPAL
#' @param endpoint endpoint of LMS Opal; by default it is got from environment
#'   variable `QTI_API_ENDPOINT`. To set a global environment variable, you need
#'   to call `Sys.setenv(QTI_API_ENDPOINT='xxxxxxxxxxxxxxx')` or you can put
#'   these command into .Renviron.
#'
#' @section Authentication: To use OPAL API, you need to provide your
#'   OPAL-username and password. This package uses system credential store
#'   'keyring' to store user's name and password. After the first successful
#'   access to the OPAL API, there is no need to specify the username and
#'   password again, they will be extracted from the system credential store
#'
#' @return A character string with Opal user id
#'
#' @examples
#' \dontrun{
#' auth_opal()
#' }
#' @name auth_opal
#' @rdname auth_opal
#' @importFrom httr2 request req_error req_perform resp_body_xml req_headers
#'   resp_body_json req_method req_body_multipart
#' @import getPass
#' @importFrom keyring key_list key_set_with_value has_keyring_support key_delete key_get
#' @export
auth_opal <- function(api_user = NULL, api_password = NULL, endpoint = NULL) {
    user_id <- NULL
    if (is.null(endpoint)) endpoint <- catch_endpoint()

    if (has_keyring_support()) {
        keys <- key_list("qtiopal")
        if (!is.null(api_user)) {
            keys <- keys[keys$username == api_user,]
        }
        n_keys <- nrow(keys)

        if (n_keys == 0) {
            if (is.null(api_user)) api_user <- readline("Enter Username on Opal: ")
            if (is.null(api_password)) api_password <- getPass("Enter Password: ")
            key_set_with_value("qtiopal", api_user, api_password)
        }

        if (n_keys == 1) {
            # handle options to rewrite or create new user
            api_user <- keys$username
            api_password <- key_get("qtiopal", api_user)
        }

        if (n_keys > 1) {
            menu_options <- c(keys$username, "Abort")
            if (interactive()) {
                key <- menu(title = "Choose a user:", menu_options)
            } else {
                message("Error: Multiple user credentials found in the system credential store.")
                message("Upload halted to prevent unauthorized access.")
                message("Please review and remove excess credentials before attempting to upload again.")
                key <- length(menu_options)
            }
            # abort
            if (key %in% c(length(menu_options), 0)) return(NULL)
            # assign a user
            if (key %in% seq(length(menu_options) - 1)) {
                api_user <- menu_options[key]
                print(api_user)
                api_password <- key_get("qtiopal", api_user)
            }
        }
    } else {
        # OS does not support keyring
        if (is.null(api_user)) api_user <- readline("Your OS does not support keyring. Enter Username on Opal: ")
        if (is.null(api_password)) api_password <- getPass("Enter Password: ")
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
        message("401 Unauthorized")
        cat("Would you like to change username and password?")
        choice <- readline("Press \'y\' to change data or any key to exit: ")
        # Check the user's choice
        if (tolower(choice) == "y") {
            if (has_keyring_support()) {
                key_delete("qtiopal", api_user)
                api_user <- readline("Enter Username on Opal: ")
            }
            user_id <- auth_opal(api_user)
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
#'@param test required; a length one character vector of [AssessmentTest],
#'  [AssessmentTestOpal] or [AssessmentItem] objects, Rmd or md files
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
#'   OPAL-username and password. This package uses system credential store
#'   'keyring' to store user's name and password. After the first successful
#'   access to the OPAL API, there is no need to specify the username and
#'   password again, they will be extracted from the system credential store
#'
#'@return list with key and url
#'@importFrom utils browseURL menu
#'@importFrom tools file_ext
#'@importFrom curl form_file
#'@export
upload2opal <- function(test, display_name = NULL, access = 4, overwrite = TRUE,
                        endpoint = NULL, open_in_browser = TRUE,
                        api_user = NULL, api_password = NULL) {

    if (is.null(endpoint)) endpoint <- catch_endpoint()

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
    rdf <- get_resources_by_name(display_name, endpoint, rtype)

    if (nrow(rdf) > 0 && overwrite) {

        if (nrow(rdf) == 1) {
            resp <- update_resource(file, rdf$key, endpoint)
        } else {
            message("Found files with the same display name: ",
                nrow(rdf))
            menu_options <- c(rdf$key, "Add new as a duplicate", "Abort")
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

#' Get records of all current user's resources on LMS OPAL
#'
#' @param endpoint endpoint of LMS Opal; by default it is got from environment
#'   variable `QTI_API_ENDPOINT`. To set a global environment variable, you need
#'   to call `Sys.setenv(QTI_API_ENDPOINT='xxxxxxxxxxxxxxx')` or you can put
#'   these command into .Renviron.
#' @param api_user username on OPAL
#' @param api_password password on OPAL
#' @return A dataframe with attributes of user's resources.
#' @examples
#' df <- get_resources()
#'
#' @export
get_resources <- function(api_user = NULL, api_password = NULL,
                          endpoint = NULL) {
    if (is.null(endpoint)) endpoint <- catch_endpoint()
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
    rdf <- do.call(rbind.data.frame, rlist)
    return(rdf)
}


get_resources_by_name <- function(display_name, endpoint = NULL, rtype = NULL) {
    if (is.null(endpoint)) endpoint <- catch_endpoint()
    df <- get_resources(endpoint = endpoint)
    if (!is.null(rtype)) {
        rlist <- subset(df, df$resourceableTypeName == rtype)
    }
    rlist <- subset(df, df$displayname == display_name)
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
#' @return A string value of URL.
#' @examples
#' url <- get_resource_url("my test")
#'
#' @export
get_resource_url <- function(display_name, endpoint = NULL,
                        api_user = NULL, api_password = NULL) {

    if (is.null(endpoint)) endpoint <- catch_endpoint()

    # check auth
    if (!is_logged(endpoint) || !is.null(api_user) ||  !is.null(api_password)) {
        user_id <- auth_opal(api_user, api_password)
        if (is.null(user_id)) return(NULL)
    }
    rdf <- get_resources_by_name(display_name, endpoint)
    url <- sapply(rdf$key,
                function(item) paste0(endpoint, "auth/RepositoryEntry/", item))
    return(url)
}

upload_resource <- function(file, display_name, rtype, access,
                            endpoint = NULL) {
    if (is.null(endpoint)) endpoint <- catch_endpoint()
    url_upl <- paste0(endpoint, "restapi/repo/entries")
    req <- request(url_upl) %>% req_method("PUT") %>%
        req_headers("X-OLAT-TOKEN"=Sys.getenv("X-OLAT-TOKEN")) %>%
        req_body_multipart(file = curl::form_file(file),
                 displayname = display_name,
                 access = as.character(access),
                 repoType = rtype)
    response <- req %>% req_error(is_error = ~ FALSE) %>% req_perform()
    if (response$status_code != 200) {
        stop(paste("Status Code:", response$status_code))
    }
    return(response)
}

update_resource <- function(file, id, endpoint = NULL) {
    if (is.null(endpoint)) endpoint <- catch_endpoint()
    url_upd <- paste0(endpoint, "restapi/repo/entries/", id, "/update")
    req <- request(url_upd) %>% req_method("PUT") %>%
        req_headers("X-OLAT-TOKEN"=Sys.getenv("X-OLAT-TOKEN")) %>%
        req_body_multipart(file = curl::form_file(file))
    response <- req %>% req_error(is_error = ~ FALSE) %>% req_perform()
    if (response$status_code != 200) {
        stop(paste("Status Code:", response$status_code))
    }
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
    if (is.null(endpoint)) endpoint <- catch_endpoint()
    url_log <- paste0(endpoint, "restapi/repo/entries/search?myentries=true")
    req <- request(url_log) %>%
        req_headers("X-OLAT-TOKEN"=Sys.getenv("X-OLAT-TOKEN"))
    response <- req %>% req_error(is_error = ~ FALSE) %>% req_perform()
    res <- ifelse(response$status_code == 200, TRUE, FALSE)
    return(res)
}

catch_endpoint <- function() {
    endpoint <- Sys.getenv("QTI_API_ENDPOINT")
    if (endpoint == "") {
        message("The enviroment variable QTI_API_ENDPOINT was empty, it was assigned the value \"https://bildungsportal.sachsen.de/opal/\"")
        Sys.setenv(QTI_API_ENDPOINT="https://bildungsportal.sachsen.de/opal/")
        endpoint <- Sys.getenv("QTI_API_ENDPOINT")
    }
    return(endpoint)
}
