#' Authentification in OPAL API
#'
#' Function `auth_opal()` performs the necessary authentication steps in OPAL
#' API. If the authentication is successful, the function sets the cookie value
#' in the system environment and returns the user's identity key in OPAL. The
#' cookie value is required to access the OPAL API system."
#'
#' @param api_user username on OPAL
#' @param api_password password on OPAL
#' @param cached boolean; if `TRUE` (default) it keeps password in environment
#'   variable
#'
#' @section Authentication: To use OPAL API, you need to provide your
#'   OPAL-username and password. This function can get `api_user` and
#'   `api_password` from environment variables. To set a global environment
#'   variable, you need to call `Sys.setenv(API_USER ='xxxxxxxxxxxxxxx')` and
#'   `Sys.setenv(API_PASSWORD ='xxxxxxxxxxxxxxx')`or you can put these commands
#'   into .Rprofile.
#'
#' @return user id
#' @name auth_opal
#' @rdname auth_opal
#' @import httr
#' @import getPass
#' @export
auth_opal <- function(api_user = NULL, api_password = NULL, cached = TRUE) {
    user_id <- NULL
    if (is.null(api_user)) api_user <- Sys.getenv("API_USER")
    if (is.null(api_password)) api_password <- Sys.getenv("API_PASSWORD")

    if (api_user == "") {
        api_user <- readline("Enter Username on Opal: ")
        Sys.setenv(API_USER = api_user)
    }

    if (api_password == "") {
        api_password <- getPass(paste0("Enter password for user ",
                                       api_user, ": "))
        if (cached) Sys.setenv(API_PASSWORD = api_password)
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
        user_id <-  NULL
        }
    if (response$status_code == 401) {
        message("401 Unauthorized")
        cat("Would you like to try with other username and password?")
        choice <- readline("Press \'y\' to change data or any key to exit: ")
        # Check the user's choice
        if (tolower(choice) == "y") {
            Sys.unsetenv("API_USER")
            Sys.unsetenv("API_PASSWORD")
            auth_opal()
        }
        user_id <-  NULL
    }
    return(user_id)
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
#'@param access optional; is responsible for publication status, where 1 - only
#'  those responsible for this learning resource; 2 - responsible and other
#'  authors; 3 - all registered users; 4 - default value, registered users and
#'  guests
#'@param overwrite logical; if only one file with the specified display name is
#'  found, it will be overwritten
#'@param endpoint endpoint
#'@param open_in_browser logical, optional; the parameter that controls whether to
#'  open a URL in default browser; TRUE by default
#' @param api_user username on OPAL
#' @param api_password password on OPAL
#' @param cached boolean; if `TRUE` (default) it keeps password in environment
#'   variable
#' @section Authentication: To use OPAL API, you need to provide your
#'   OPAL-username and password. This function can get `api_user` and
#'   `api_password` from environment variables. To set a global environment
#'   variable, you need to call `Sys.setenv(api_user ='xxxxxxxxxxxxxxx')` and
#'   `Sys.setenv(api_password ='xxxxxxxxxxxxxxx')`or you can put these commands
#'   into .Rprofile.
#'
#'@return list with key and url
#'@importFrom utils browseURL
#'@export
upload2opal <- function(file, display_name = NULL, access = 4, overwrite = TRUE,
                        endpoint =  paste0("https://bildungsportal.sachsen.de/",
                                           "opal/"), open_in_browser = TRUE,
                        api_user = NULL, api_password = NULL, cached = TRUE) {

    if (!all(file.exists(file))) stop("The file does not exist", call. = FALSE)
    if (is.null(display_name)) display_name <- gsub("\\..*", "", basename(file))

    # check auth
    if (!is_logged(endpoint)) {
        auth_opal(api_user = NULL, api_password = NULL, cached = TRUE)
    }
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
        url_res <- paste0("https://bildungsportal.sachsen.de/opal/auth/",
                               "RepositoryEntry/", parse$key)
        if ((open_in_browser) && (!is.null(parse$key))) {
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
