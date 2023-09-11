#' Authentification in OPAL API
#'
#' Function `auth_opal()` performs the necessary authentication steps in OPAL
#' API. If the authentication is successful, the function sets the cookie value
#' in the system environment and returns the status code. The cookie value is
#' required to access the OPAL API system."
#'
#' @section Authentication: To use OPAL API, you need to provide your OPAL-
#'   username and password. This function will look for api_user and
#'   api_password environment variables. To set a global environment variables,
#'   you need to use the following commands:
#'   `Sys.setenv(api_user ='xxxxxxxxxxxxxxx')`
#'   `Sys.setenv(api_password =  'xxxxxxxxxxxxxxx')`
#'   Another way to assign environment variables in case of regular using is to
#'   create a file named .env in the root directory of your project. The .env
#'   file should contain the environment variables you want to set in the
#'   following format:
#'   `api_user=xxxxxxxxxxxxxxx`
#'   `api_password=xxxxxxxxxxxxxxx`
#'
#' @return user id
#' @name auth_opal
#' @rdname auth_opal
#' @import httr
#' @import keyring
#' @export
auth_opal <- function() {
    user_id <- NULL

    api_user <- getOption("api_user")
    if (is.null(api_user)) {
        api_user <- readline("Please enter your USERNAME for access API: ")
        options("api_user" = api_user)
    }

    api_password <- try(key_get(service = "opal", username = api_user))

    if (is(api_password, "try-error")) {
        print(paste0("Credentials for usrer \'", api_user, "\' NOT FOUND"))
        print(key_list())
        api_password <- register_user()
    }

    url_login <- paste0("https://bildungsportal.sachsen.de/opal/restapi/auth/",
                          api_user, "?password=", api_password)

    response <- GET(url_login)
    if (response$status_code == 200) {
        parse <- content(response, as = "text", encoding = "UTF-8")
        user_id <- xml2::xml_attr(read_xml(parse), "identityKey")
        cookie_value <- response$cookies$value
        Sys.setenv("COOKIE" = cookie_value)
        }
    if (response$status_code == 403) {
        message("Authentification failed. You may need to run a VPN client")
        }
    if (response$status_code == 401) {
        message("401 Unauthorized")
        choice <- readline("If you want to change the password in the credential
        store, please choose y/n")
        # Check the user's choice
        if (tolower(choice) == "y") {
            message("The old password will be deleted from the credential
                    store.")
            # clear the storing keys
            data <- key_list()
            key_delete(data$service, data$username)
            register_user()
            auth_opal()

        } else {
            message("You chose not to change the password. Please check and run
                    the VPN client.")
        }
    }
    return(user_id)
}

# Store your password in an operating system (credential store)
#' @import getPass
#' @import keyring
register_user <- function() {
    username <- readline("Enter Username: ")
    password <- getPass("Enter Password: ")

    # Store password in the operating system (credential store)
    key_set_with_value(service = "opal", username = username,
                       password = password)
    options("api_user" = username)
    cat("\n Your password has been saved in your OS. Please remember your
        username that will be needed to access Opal API.\n")
    return(password)
}


#'Upload resource on OPAL
#'
#'Function `upload2opal()` takes full prepared zip archive of QTI-test or
#'QTI-task and uploads it to the OPAL. before calling `upload2opal()`
#'authentication procedure has to be performed. See [auth_opal]
#'
#'@param file required; a length one character vector
#'@param display_name optional; a length one character vector to entitle file in
#'  OPAL; file name without extension by default
#'@param in_browser logical, optional; the parameter that controls whether to
#'  open a URL in default browser; TRUE by default
#'@param access optional; is responsible for publication status, where 1 - only
#'  those responsible for this learning resource; 2 - responsible and other
#'  authors; 3 - all registered users; 4 - default value, registered users and
#'  guests
#'@param overwrite logical; if only one file with the specified display name is
#'  found, it will be overwritten
#'@param endpoint endpoint
#'@return list with key and url
#'@importFrom utils browseURL
#'@export
upload2opal <- function(file, display_name = NULL, access = 4, overwrite = TRUE,
                        endpoint =  paste0("https://bildungsportal.sachsen.de/",
                                           "opal/"), in_browser = TRUE) {

    if (!all(file.exists(file))) stop("The file does not exist", call. = FALSE)
    if (is.null(display_name)) display_name <- gsub("\\..*", "", basename(file))

    # check auth
    if (!is_logged(endpoint)) auth_opal()
    if (!interactive()) display_name <- paste0("knit_", display_name)
    # check if we have a test with display name
    url_res <- paste0(endpoint, "restapi/repo/entries/search?myentries=true")
    resp_search <- GET(url_res, set_cookies(JSESSIONID = Sys.getenv("COOKIE")),
                    encode = "multipart")
    if (is_logged(endpoint)) {
        rlist <- content(resp_search, as = "parse", encoding = "UTF-8")
        rtype <- ifelse(is_test(file), "FileResource.TEST",
                        "FileResource.QUESTION")
        filtered_rlist <- purrr::keep(rlist, ~ .x$resourceableTypeName == rtype)
        filtered_rlist <- purrr::keep(rlist, ~ .x$displayname == display_name)
        if (length(filtered_rlist) > 0) {

            if (length(filtered_rlist) == 1 && overwrite) {
                response <- update_resource(file, filtered_rlist[[1]]$key,
                                            endpoint)
            } else {
                message("Found files with the same display name: ",
                    length(filtered_rlist))
                menu_options <- c(sapply(filtered_rlist, function(x) x$key),
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
                response <- update_resource(file, menu_options[key], endpoint)
                }
            }
        }
        # create new resource
        if (!exists("response")) {
         response <- upload_resource(file, display_name, rtype, access,
                                        in_browser, endpoint)
        }

        parse <- content(response, as = "parse", encoding = "UTF-8")
        if ((in_browser) && (!is.null(parse$key))) {
            url_res <- paste0("https://bildungsportal.sachsen.de/opal/auth/",
                               "RepositoryEntry/", parse$key)
            browseURL(url_res)
        }
        res <- list(key = parse$key, display_name = parse$displayname,
                    url = url_res)
        print(response$status_code)
        return(res)
    } else {
        return(NULL)
        }
}

upload_resource <- function(file, display_name, rtype, access, in_browser,
                            endpoint) {


    url_upl <- paste0(endpoint, "restapi/repo/entries")
    body <- list(file = upload_file(file),
                 displayname = display_name,
                 access = access,
                 repoType = rtype)
    response <- PUT(url_upl, set_cookies(JSESSIONID = Sys.getenv("COOKIE")),
                    body = body, encode = "multipart")
    return(response)
}

# open url with resource by id
opent <- function(id) {
    url_test <- paste0("https://bildungsportal.sachsen.de/opal/auth/",
                       "RepositoryEntry/", id)
    browseURL(url_test)
}

# update resource
update_resource <- function(file, id, endpoint) {
    url_upd <- paste0(endpoint, "restapi/repo/entries/", id,
                      "/update")
    body <- list(file = upload_file(file))
    response <- PUT(url_upd, set_cookies(JSESSIONID = Sys.getenv("COOKIE")),
                    body = body, encode = "multipart")
    return(response)
}

# check whether it is a test by manifest file
is_test <- function(file) {
    zip_con <- unz(file, "imsmanifest.xml")
    file_content <- readLines(zip_con, n = -1L)
    close(zip_con)
    result <- grepl("imsqti_test_xmlv2p1", file_content)
    return(any(result))
}

is_logged <- function(endpoint) {
    url_log <- paste0(endpoint, "restapi/repo/entries/search?myentries=true")
    response <- GET(url_log, set_cookies(JSESSIONID = Sys.getenv("COOKIE")),
                       encode = "multipart")
    res <- ifelse(response$status_code == 200, TRUE, FALSE)
    return(res)
}
