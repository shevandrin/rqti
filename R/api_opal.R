#' Authentification in OPAL API
#'
#' Function `auth_opal()` performs the necessary authentication steps in OPAL
#' API. If the authentication is successful, the function sets the token value
#' in the system environment and returns the user's identity key in OPAL. The
#' token value is required to access the OPAL API system.
#'
#' @param api_user A character value of the username in the OPAL.
#' @param api_password A character value of the password in the OPAL.
#' @param endpoint A string of endpoint of LMS Opal; by default it is got from
#'  environment variable `RQTI_API_ENDPOINT`. To set a global environment
#'  variable, you need to call `Sys.setenv(RQTI_API_ENDPOINT='xxxxxxxxxxxxxxx')`
#'  or you can put these command into .Renviron.
#'
#' @section Authentication: To use OPAL API, you need to provide your
#'   OPAL-username and password. This package uses system credential store
#'   'keyring' to store user's name and password. After the first successful
#'   access to the OPAL API, there is no need to specify the username and
#'   password again, they will be extracted from the system credential store
#'
#' @return A character string with Opal user id
#'
#' @examplesIf interactive()
#' auth_opal()
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
                message("logging in as ", api_user)
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
        choice <- readline("Press \'y\' to change username/password or any key to exit: ")
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

#'Upload a resource on OPAL
#'
#'Function `upload2opal()` takes full prepared zip archive of QTI-test or
#'QTI-task and uploads it to the OPAL. before calling `upload2opal()`
#'authentication procedure has to be performed. See [auth_opal]
#'
#'@param test A length one character vector of [AssessmentTest],
#'  [AssessmentTestOpal] or [AssessmentItem] objects, Rmd/md or XML files;
#'  required.
#'@param display_name A length one character vector to entitle file in OPAL;
#'  file name without extension by default; optional.
#'@param access An integer value, optional; it is responsible for publication
#'  status, where 1 - only those responsible for this learning resource; 2 -
#'  responsible and other authors; 3 - all registered users; 4 - registered
#'  users and guests. Default is 4.
#'@param overwrite A boolean value; if the value is `TRUE`, if only one file
#'  with the specified display name is found, it will be overwritten. Default is
#'  `TRUE`.
#'@param endpoint A string of endpoint of LMS Opal; by default it is got from
#'  environment variable `RQTI_API_ENDPOINT`. To set a global environment
#'  variable, you need to call `Sys.setenv(RQTI_API_ENDPOINT='xxxxxxxxxxxxxxx')`
#'  or you can put these command into .Renviron.
#'@param open_in_browser A boolean value; optional; it controls whether to open
#'  a URL in default browser. Default is `TRUE.`
#'@param as_survey A boolean value; optional; it controls resource type (test
#'r survey). Default is `FALSE`.
#'@param api_user A character value of the username in the OPAL.
#'@param api_password A character value of the password in the OPAL.
#'@section Authentication: To use OPAL API, you need to provide your
#'  OPAL-username and password. This package uses system credential store
#'  'keyring' to store user's name and password. After the first successful
#'  access to the OPAL API, there is no need to specify the username and
#'  password again, they will be extracted from the system credential store
#'
#'@return A list with the key, display name, and URL of the resource in Opal.
#'@examplesIf interactive()
#'file <- system.file("exercises/sc1.Rmd", package='rqti')
#' upload2opal(file, "task 1", open_in_browser = FALSE)
#'@importFrom utils browseURL menu
#'@importFrom tools file_ext
#'@importFrom curl form_file
#'@export
upload2opal <- function(test, display_name = NULL, access = 4, overwrite = TRUE,
                        endpoint = NULL, open_in_browser = TRUE,
                        as_survey = FALSE,
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

    # get resources with given display_name and as_survey status
    istest = is_test(file)
    rtype <- if (istest && as_survey) {
        "FileResource.SURVEY"
    } else {
        ifelse(istest, "FileResource.TEST", "FileResource.QUESTION")
    }

    rdf <- get_resources_by_name(display_name, endpoint, rtype)

    if (nrow(rdf) > 0 && overwrite) {

        if (nrow(rdf) == 1) {
            curr_type <- rdf$resourceableTypeName
            target_type <- "FileResource.TEST"
            if (!istest) target_type <- "FileResource.QUESTION"
            if (as_survey) target_type <- "FileResource.SURVEY"

            if ((curr_type == "FileResource.TEST" && istest && !as_survey) ||
                (curr_type == "FileResource.QUESTION" && !istest) ||
                (curr_type == "FileResource.SURVEY" && istest && as_survey)) {
               resp <- update_resource(file, rdf$key, endpoint)
            } else {
                stop("Current type and target type of the resouce is not equal.\n",
                      "Current type: ", curr_type, ";\nTarget type:", target_type,
                     "\n Create a new resource by assigning a display_name.\n",
                     "Call upload2opal(... display_name = \"new_name\")",
                     call. = FALSE)
            }
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
                resp <- update_resource(file, menu_options[key], rtype, endpoint)
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
    res <- list(key = key, display_name = displayname, url = url_res)
    message(resp$status_code)
    return(res)
}

#' Get records of all current user's resources on LMS OPAL
#'
#' @param api_user A character value of the username in the OPAL.
#' @param api_password A character value of the password in the OPAL.
#' @param endpoint A string of endpoint of LMS Opal; by default it is got from
#'  environment variable `RQTI_API_ENDPOINT`. To set a global environment
#'  variable, you need to call `Sys.setenv(RQTI_API_ENDPOINT='xxxxxxxxxxxxxxx')`
#'  or you can put these command into .Renviron.
#' @return A dataframe with attributes of user's resources.
#' @examplesIf interactive()
#' df <- get_resources()
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
#' @param display_name A length one character vector to entitle file in OPAL;
#'  file name without extension by default; optional.
#' @param endpoint A string of endpoint of LMS Opal; by default it is got from
#'  environment variable `RQTI_API_ENDPOINT`. To set a global environment
#'  variable, you need to call `Sys.setenv(RQTI_API_ENDPOINT='xxxxxxxxxxxxxxx')`
#'  or you can put these command into .Renviron.
#' @param api_user A character value of the username in the OPAL.
#' @param api_password A character value of the password in the OPAL.
#' @return A string value of URL.
#' @examplesIf interactive()
#' url <- get_resource_url("my test")
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

#' Get elements of the course by courseId
#'
#' @param course_id A length one character vector with course id.
#' @param api_user A character value of the username in the OPAL.
#' @param api_password A character value of the password in the OPAL.
#' @param endpoint A string of endpoint of LMS Opal; by default it is got from
#'  environment variable `RQTI_API_ENDPOINT`. To set a global environment
#'  variable, you need to call `Sys.setenv(RQTI_API_ENDPOINT='xxxxxxxxxxxxxxx')`
#'  or you can put these command into .Renviron.
#' @return A dataframe with the elements of the course (fields: nodeId,
#' shortTitle, shortName, longTitle)
#' @examplesIf interactive()
#' df <- get_course_elements("89068111333293")
#' @export
get_course_elements <- function(course_id, api_user = NULL, api_password = NULL,
                                endpoint = NULL) {
    if (is.null(endpoint)) endpoint <- catch_endpoint()
    # check auth
    if (!is_logged(endpoint) || !is.null(api_user) ||  !is.null(api_password)) {
        user_id <- auth_opal(api_user, api_password)
        if (is.null(user_id)) return(NULL)
    }
    url_elem <- paste0(endpoint, "restapi/repo/courses/", course_id, "/elements")
    req <- request(url_elem) %>%
        req_headers("X-OLAT-TOKEN"=Sys.getenv("X-OLAT-TOKEN"))
    response <- req %>% req_error(is_error = ~ FALSE) %>% req_perform()
    parse <- resp_body_xml(response)
    rlist <- xml2::as_list(parse)

    is_not_neg_one <- function(node) {
        pos <- as.numeric(node$position[[1]])
        return(pos != -1)
    }
    flist <- rlist$courseNodeVOes[sapply(rlist$courseNodeVOes, is_not_neg_one)]
    get_values <- function(item, field) {
        ifelse(length(unlist(item[field])) == 0, NA, item[field])
    }
    ids <- unlist(Map(get_values, flist, "id"), use.names = FALSE)
    shortTitles <- unlist(Map(get_values, flist, "shortTitle"), use.names = FALSE)
    shortNames <- unlist(Map(get_values, flist, "shortName"), use.names = FALSE)
    longTitles <- unlist(Map(get_values, flist, "longTitle"), use.names = FALSE)
    df <- data.frame(nodeId=ids, shortTitle=shortTitles, shortName=shortNames,
                     longTitle=longTitles)
    return(df)
}

#' Get zip with course results by resource id and node id
#'
#' @param resource_id A length one character vector with resource id.
#' @param node_id A length one character vector with node id (test).
#' @param path A length one character vector with path, where the zip should be
#'   stored. Default is working directory.
#' @param rename A boolean value; optional; Set `TRUE` value to take the short
#'   name of the course element for naming zip (results_shortName.zip). `FALSE`
#'   combines in zip name course id and node id. Default is `TRUE`.
#' @param api_user A character value of the username in the OPAL.
#' @param api_password A character value of the password in the OPAL.
#' @param endpoint A string of endpoint of LMS Opal; by default it is got from
#'   environment variable `RQTI_API_ENDPOINT`. To set a global environment
#'   variable, you need to call
#'   `Sys.setenv(RQTI_API_ENDPOINT='xxxxxxxxxxxxxxx')` or you can put these
#'   command into .Renviron.
#' @return It downloads a zip and return a character string with path.
#' @examplesIf interactive()
#' zip_file <- get_course_results("89068111333293", "1617337826161777006")
#' @export
get_course_results <- function(resource_id, node_id, path = ".",
                               rename = TRUE,
                               api_user = NULL, api_password = NULL,
                               endpoint = NULL) {
    if (is.null(endpoint)) endpoint <- catch_endpoint()
    # check auth
    if (!is_logged(endpoint) || !is.null(api_user) ||  !is.null(api_password)) {
        user_id <- auth_opal(api_user, api_password)
        if (is.null(user_id)) return(NULL)
    }

    url_res <- paste0(endpoint, "restapi/repo/courses/", resource_id,
                      "/assessments/", node_id, "/results")
    req <- request(url_res) %>%
        req_headers("X-OLAT-TOKEN"=Sys.getenv("X-OLAT-TOKEN"))
    response <- req %>% req_error(is_error = ~ FALSE) %>% req_perform()
    parse <- resp_body_xml(response)

    ext <- tools::file_ext(path)

    if (ext == "") {
        dir <- path
        if (rename) {
            df <- get_course_elements(resource_id, api_user, api_password, endpoint)
            short_name <- subset(df, df$nodeId == node_id)$shortName
            short_name <- paste(strsplit(short_name, " ")[[1]], collapse = "_")
            file_name <- paste0("results_", short_name, ".zip")
        } else {
            file_name <- paste0("results_", resource_id, "_", node_id, ".zip")
        }
    } else {
        dir <- dirname(path)
        file_name <- basename(path)
    }
    if (!dir.exists(dir)) dir.create(dir, recursive = TRUE)

    data_tag <- xml2::xml_find_first(parse, ".//data")
    if (!is.na(data_tag)) {
        zip_url <- xml2::xml_text(data_tag)
        zip_path <- file.path(dir, file_name)
        result <- download.file(zip_url, zip_path)
        if (result == 0) message("See zip in ", zip_path)
        return(normalizePath(zip_path, winslash = "/"))
    } else {
        message("There is no data about the results.")
        return(NULL)
    }
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

update_resource <- function(file, id, rtype, endpoint = NULL) {
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
    endpoint <- Sys.getenv("RQTI_API_ENDPOINT")
    if (endpoint == "") {
        message("The enviroment variable RQTI_API_ENDPOINT was empty, it was assigned the value \"https://bildungsportal.sachsen.de/opal/\"")
        Sys.setenv(RQTI_API_ENDPOINT="https://bildungsportal.sachsen.de/opal/")
        endpoint <- Sys.getenv("RQTI_API_ENDPOINT")
    }
    return(endpoint)
}
