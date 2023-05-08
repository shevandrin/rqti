#' Authentification in OPAL API
#'
#' Function `auth_opal()` performs the necessary authentication steps in OPAL
#' API. If the authentication is successful, the function sets the cookie value
#' in the system environment and returns the status code. The cookie value is
#' required to access the OPAL API system."
#'
#' @section Authentication: To use OPAL API, you need to provide your OPAL-
#'   username and password. This function will look for API_USER and
#'   API_PASSWORD environment variables. To set a global environment variables,
#'   you need to use the following commands:
#'   `Sys.setenv(API_USER ='xxxxxxxxxxxxxxx')`
#'   `Sys.setenv(API_PASSWORD =  'xxxxxxxxxxxxxxx')`
#'   Another way to assign environment variables in case of regular using is to
#'   create a file named .env in the root directory of your project. The .env
#'   file should contain the environment variables you want to set in the
#'   following format:
#'   `API_USER=xxxxxxxxxxxxxxx`
#'   `API_PASSWORD=xxxxxxxxxxxxxxx`
#'
#' @return status code
#' @name auth_opal
#' @rdname auth_opal
#' @import httr
#' @import dotenv
#' @export
auth_opal <- function() {
    url_login <- paste0("https://bildungsportal.sachsen.de/opal/restapi/auth/",
                        Sys.getenv("API_USER"),
                        "?password=", Sys.getenv("API_PASSWORD"))
    response <- GET(url_login)
    cat(content(response, as = "text", encoding = "UTF-8"))
    cookie_value <- response$cookies$value
    if (length(cookie_value) > 0) Sys.setenv("COOKIE" = cookie_value)
    return(response$status_code)
}


#'Upload test on OPAL
#'
#'Function `upload_opal_test()` takes full prepared zip archive of QTI-test and
#'uploads it to the OPAL. before calling `upload_opal_test()` authentication
#'procedure has been performed. See [auth_opal]
#'
#'@param file required; a length one character vector
#'@param display_name optional; a length one character vector to entitle file in
#'  OPAL; file name without extension by default
#'@param access optional; is responsible for publication status, where 1 - only
#'  those responsible for this learning resource; 2 - responsible and other
#'  authors; 3 - all registered users; 4 - default value, registered users and
#'  guests
#'@param in_browser logical, optional; the parameter that controls whether to
#'  open a URL in default browser; TRUE by default
#'@return status code
#'@importFrom utils browseURL
#'@export
upload_opal_test <- function(file, display_name = NULL, access = 4,
                             in_browser = TRUE) {
    if (!all(file.exists(file))) stop("The file does not exist", call. = FALSE)

    if (is.null(display_name)) display_name <- gsub("\\..*", "", basename(file))

    url_task <- "https://bildungsportal.sachsen.de/opal/restapi/repo/entries"
    body <- list(file = upload_file(file),
                 displayname = display_name,
                 access = access,
                 repoType = "FileResource.TEST")
    response <- PUT(url_task, set_cookies(JSESSIONID = Sys.getenv("COOKIE")),
                    body = body, encode = "multipart")
    parse <- content(response, as = "parse", encoding = "UTF-8")
    url_test <- NULL
    if ((in_browser) & (!is.null(parse$key)) ){
        url_test <- paste0("https://bildungsportal.sachsen.de/opal/auth/",
                           "RepositoryEntry/", parse$key)
        browseURL(url_test)
    }
    res <- list(status_code = response$status_code, key = parse$key,
                url = url_test)
    return(res)
}


#'Upload task(question) on OPAL
#'
#'Function `upload_opal_task()` takes full prepared zip archive of QTI-test and
#'uploads it to the OPAL. before calling `upload_opal_task()` authentication
#'procedure has been performed. See [auth_opal]
#'
#'@param file required; a length one character vector
#'@param display_name optional; a length one character vector to entitle file in
#'  OPAL; file name without extension by default
#'@return status code
#'@export
upload_opal_task <- function(file, display_name = NULL) {
    if (!all(file.exists(file))) stop("The file does not exist", call. = FALSE)

    if (is.null(display_name)) display_name <- gsub("\\..*", "", basename(file))

    url_task <- "https://bildungsportal.sachsen.de/opal/restapi/repo/entries"
    body <- list(file = upload_file(file),
                 displayname = display_name,
                 repoType = "FileResource.QUESTION")
    response <- PUT(url_task, set_cookies(JSESSIONID = Sys.getenv("COOKIE")),
                    body = body, encode = "multipart")
    cat(content(response, as = "text", encoding = "UTF-8"))
    return(response$status_code)
}
