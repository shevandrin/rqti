#' Class LMS OPAL
#'
#' Abstract class `Opal` is represents learning management system.
#' @name Opal-class
#' @rdname Opal-class
#' @aliases Opal
#' @include LMS.R
setClass("Opal", contains = "LMS",
         prototype = list(name = "Opal"))

#' Check if User is Logged in LMS Opal
#'
#' This method checks whether a user is logged into an LMS Opal by
#' sending a request to the LMS server and evaluating the response.
#'
#' @param object An S4 object of class [Opal] that represents a connection to the LMS.
#' @return A logical value (`TRUE` if the user is logged in, `FALSE` otherwise).
#' @docType methods
#' @rdname isUserLoggedIn-methods
#' @export
setMethod("isUserLoggedIn", "Opal", function(object) {

    url_log <- paste0(object@endpoint, "restapi/repo/entries/search?myentries=true")
    req <- request(url_log) %>%
        req_headers("X-OLAT-TOKEN"=Sys.getenv("X-OLAT-TOKEN"))
    response <- req %>% req_error(is_error = ~ FALSE) %>% req_perform()
    is_logged_in <- response$status_code == 200
    return(is_logged_in)
})


#' Upload content to LMS Opal
#'
#' This is a generic function that handles the process of uploading content to
#' LMS Opal. The content can be in the form of an `AssessmentTest`,
#' `AssessmentTestOpal`, `AssessmentItem` object, or a file in Rmd, Markdown,
#' zip or XML format.
#' @param object An S4 object representing the LMS, such as an instance of the
#'   [Opal] class.
#' @param test An [AssessmentTest], [AssessmentTestOpal] or [AssessmentItem]
#'   objects, or a character string with path to Rmd/md, zip or XML files.
#' @param display_name A length one character vector to entitle resource in OPAL;
#'  file name without extension or identifier of the object by default; optional.
#' @param access An integer value, optional; it is responsible for publication
#'  status, where 1 - only those responsible for this learning resource; 2 -
#'  responsible and other authors; 3 - all registered users; 4 - registered
#'  users and guests. Default is 4.
#' @param overwrite A boolean value. If `TRUE`, and a file with the specified
#'   display name already exists, it will be overwritten. Default is `TRUE`.
#' @param open_in_browser A boolean value; optional; it controls whether to open
#'  a URL in default browser. Default is `TRUE.`
#' @param as_survey A boolean value, optional. If `TRUE`, the resource will be
#'   treated as a survey; if `FALSE`, as a test. Default is `FALSE`.
#' @docType methods
#' @rdname upload2LMS-methods
#' @export
setMethod("upload2LMS", "Opal", function(object, test, display_name = NULL,
                                         access = 4, overwrite = TRUE,
                                         open_in_browser = TRUE,
                                         as_survey = FALSE) {

    if (!isUserLoggedIn(object)) {
        login_status <- authLMS(object)
        if (login_status != 200) return(NULL)
    }

    file <- createQtiTest(test, dir = tempdir(), zip_only = TRUE)
    if (is.null(display_name)) display_name <- gsub("\\..*", "", basename(file))

    # get resources with given display_name and as_survey status
    istest = is_test(file)
    rtype <- if (istest && as_survey) {
        "FileResource.SURVEY"
    } else {
        ifelse(istest, "FileResource.TEST", "FileResource.QUESTION")
    }

    rdf <- getLMSResourcesByName(object, display_name, rtype)

    if (nrow(rdf) > 0 && overwrite) {

        if (nrow(rdf) == 1) {
            curr_type <- rdf$resourceableTypeName
            target_type <- "FileResource.TEST"
            if (!istest) target_type <- "FileResource.QUESTION"
            if (as_survey) target_type <- "FileResource.SURVEY"

            if ((curr_type == "FileResource.TEST" && istest && !as_survey) ||
                (curr_type == "FileResource.QUESTION" && !istest) ||
                (curr_type == "FileResource.SURVEY" && istest && as_survey)) {
                resp <- update_resource(file, rdf$key, endpoint = object@endpoint)
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
                resp <- update_resource(file, menu_options[key], rtype,
                                        endpoint = object@endpoint)
            }
        }
    }

    if (!exists("resp")) {
        resp <- upload_resource(file, display_name, rtype, access, object@endpoint)
    }
    parse <- resp_body_xml(resp)
    key <- xml_find_first(parse, "key") %>% xml_text()
    displayname <- xml_find_first(parse, "displayname") %>% xml_text()

    url_res <- paste0(object@endpoint, "auth/", "RepositoryEntry/", key)
    if ((open_in_browser) && (!is.null(key))) {
        browseURL(url_res)
    }
    res <- list(key = key, display_name = displayname, url = url_res)
    message(resp$status_code)
    return(res)
})

#' Get records of all current user's resources on LMS Opal
#'
#' @param object An S4 object of class [Opal] that represents a connection to the LMS.
#' @return A dataframe with attributes of user's resources.
#' @examplesIf interactive()
#' df <- getLMSResources()
#' @export
setMethod("getLMSResources", "Opal", function(object){

    if (!isUserLoggedIn(object)) {
        login_status <- authLMS(object)
        if (login_status != 200) return(NULL)
    }

    url_res <- paste0(object@endpoint, "restapi/repo/entries/search?myentries=true")
    req <- request(url_res) %>%
        req_headers("X-OLAT-TOKEN"=Sys.getenv("X-OLAT-TOKEN"))
    response <- req %>% req_error(is_error = ~ FALSE) %>% req_perform()
    rlist <- resp_body_json(response)
    rdf <- do.call(rbind.data.frame, rlist)
    return(rdf)
})

#' Get selected records of the current user's resources on LMS Opal by display
#' name.
#'
#' @param object An S4 object of class [Opal] that represents a connection to
#'   the LMS.
#' @param display_name A string value withe the name of resource.
#' @param rtype A string value with the type of resource. Possible values:
#'   "FileResource.TEST", "FileResource.QUESTION", or "FileResource.SURVEY".
#' @return A dataframe with attributes of user's resources.
#' @examplesIf interactive()
#' df <- getLMSResourcesByName()
#' @export
setMethod("getLMSResourcesByName", "Opal", function(object, display_name,
                                                    rtype = NULL){

    if (!isUserLoggedIn(object)) {
        login_status <- authLMS(object)
        if (login_status != 200) return(NULL)
    }

    df <- getLMSResources(object)
    rlist <- subset(df, df$displayname == display_name)
    if (!is.null(rtype)) {
        rlist <- subset(rlist, rlist$resourceableTypeName == rtype)
    }
    return(rlist)
})

#' Create a URL using the resource's display name in LMS Opal
#'
#' @param object An S4 object of class [Opal] that represents a connection to the LMS.
#' @param display_name A length one character vector to entitle file in OPAL;
#'  it takes file name without extension by default; optional.
#' @return A string value of URL.
#' @export
setMethod("getLMSResourceURL", "Opal", function(object, display_name) {

    if (!isUserLoggedIn(object)) {
        login_status <- authLMS(object)
        if (login_status != 200) return(NULL)
    }

    rdf <- getLMSResourcesByName(object, display_name)
    if (length(rdf$key) == 0) {
        warning("No resources found with the specified display name.")
        return(NULL)
    }

    url <- sapply(rdf$key,
                  function(item) paste0(object@endpoint, "auth/RepositoryEntry/", item))
    return(url)
})

#' Retrieve Data About Course Elements from LMS Opal
#'
#' This function retrieves and returns data about the elements of a specified course
#' from the LMS Opal system. The data includes information such as the node ID,
#' short title, short name, and long title of each element.
#' @param object An S4 object of class [Opal] that represents a connection to the LMS.
#' @param course_id A length one character vector with course id.
#' @return A dataframe with the data of the elements of the course (fields: nodeId,
#' shortTitle, shortName, longTitle) on LMS Opal.
#' @export
setMethod("getCourseElements", "Opal", function(object, course_id) {

    if (!isUserLoggedIn(object)) {
        login_status <- authLMS(object)
        if (login_status != 200) return(NULL)
    }

    url_elem <- paste0(object@endpoint, "restapi/repo/courses/", course_id, "/elements")
    req <- request(url_elem) %>%
        req_headers("X-OLAT-TOKEN"=Sys.getenv("X-OLAT-TOKEN"))
    response <- req %>% req_error(is_error = ~ FALSE) %>% req_perform()

    parsed_response <- resp_body_xml(response)
    rlist <- xml2::as_list(parsed_response)$courseNodeVOes

    # Helper function to filter elements based on position
    filter_valid_elements <- function(node) {
        position <- as.numeric(node$position[[1]])
        return(position != -1)
    }
    flist <- rlist[sapply(rlist, filter_valid_elements)]

    # Helper function to extract specific fields
    get_values <- function(item, field) {
        value <- unlist(item[[field]], use.names = FALSE)
        return(ifelse(length(value) == 0, NA, value))
    }

    ids <- unlist(Map(get_values, flist, "id"))
    shortTitles <- unlist(Map(get_values, flist, "shortTitle"))
    shortNames <- unlist(Map(get_values, flist, "shortName"))
    longTitles <- unlist(Map(get_values, flist, "longTitle"))
    df <- data.frame(nodeId=ids,
                     shortTitle=shortTitles,
                     shortName=shortNames,
                     longTitle=longTitles)
    return(df)
})

#' Update the referenced learning resource of a course element in the LMS Opal
#'
#' @param object An S4 object of class [LMS] that represents a connection to the
#'   LMS.
#' @param course_id A character string with the course ID. You can find this in
#'   the course's details (Resource ID) in the LMS.
#' @param node_id A character string with the course element ID. This can be
#'   found, for example, in the course editor under the "Title and Description"
#'   tab of the respective course element in the LMS Opal.
#' @param resource_id A character string wiht the ID of the resource. This can
#'   be found in the details view of the desired resource within the LMS.
#' @param publish A boolean value that determines whether the course should be
#'   published after the resource is updated. If `TRUE` (default), the course
#'   will be published immediately after the update. If `FALSE`, the course will
#'   not be published automatically, leaving it in an unpublished state until
#'   manual publication.
#' @return The response of the HTTP request made to update the resource. If the
#'   course is published, an additional message about the publishing status is
#'   returned.
#' @export
setMethod("updateCourseElementResource", "Opal", function(object, course_id,
                                                          node_id, resource_id,
                                                          publish = TRUE) {

    if (!isUserLoggedIn(object)) {
        login_status <- authLMS(object)
        if (login_status != 200) return(NULL)
    }

    url_res <- paste0(object@endpoint, "restapi/repo/courses/", course_id,
                      "/elements/", node_id,
                      "/test/update?testResourceableId=", resource_id)
    req <- request(url_res) %>%
        req_headers("X-OLAT-TOKEN"=Sys.getenv("X-OLAT-TOKEN")) %>% req_method("PUT")
    response <- req %>% req_error(is_error = ~ FALSE) %>% req_perform()

    if (response$status_code == 200 && publish) {
        message("Update status code: ", response$status_code)
        upd_response <- publishCourse(object, course_id)
        message("Publishing status code: ", upd_response)
    }

    return(response)
})

#' Publish a course on LMS Opal
#'
#' @param object An S4 object of class [Opal] that represents a connection to the LMS.
#' @param course_id A character string with course id in the LMS.
#' @return Status code of the HTTP request.
#' @export
setMethod("publishCourse", "Opal", function(object, course_id) {

    if (!isUserLoggedIn(object)) {
        login_status <- authLMS(object)
        if (login_status != 200) return(NULL)
    }

    url_res <- paste0(object@endpoint, "restapi/repo/courses/", course_id, "/publish")
    req <- request(url_res) %>%
        req_headers("X-OLAT-TOKEN"=Sys.getenv("X-OLAT-TOKEN")) %>% req_method("POST")
    response <- req %>% req_error(is_error = ~ FALSE) %>% req_perform()
    return(response$status_code)
})

#' Get zip with course results by resource id and node id
#'
#' @param object An S4 object of class [Opal] that represents a connection to the LMS.
#' @param resource_id A length one character vector with resource id.
#' @param node_id A length one character vector with node id (test).
#' @param path_outcome A length one character vector with path, where the zip should be
#'   stored. Default is working directory.
#' @param rename A boolean value; optional; Set `TRUE` value to take the short
#'   name of the course element for naming zip (results_shortName.zip). `FALSE`
#'   combines in zip name course id and node id. Default is `TRUE`.
#' @return It downloads a zip and return a character string with path.
#' @importFrom tools file_ext
#' @export
setMethod("getCourseResult", "Opal", function(object, resource_id, node_id, path_outcome = ".", rename = TRUE){
    params <- as.list(environment())

    if (!isUserLoggedIn(object)) {
        login_status <- authLMS(object)
        if (login_status != 200) return(NULL)
    }

    url_res <- paste0(object@endpoint, "restapi/repo/courses/", resource_id,
                      "/assessments/", node_id, "/results")
    req <- request(url_res) %>%
        req_headers("X-OLAT-TOKEN"=Sys.getenv("X-OLAT-TOKEN"))
    response <- req %>% req_error(is_error = ~ FALSE) %>% req_perform()

    parsed_response <- resp_body_xml(response)

    ext <- tools::file_ext(path_outcome)

    if (ext == "") {
        dir <- path_outcome
        if (rename) {
            df <- getCourseElements(object, resource_id)
            short_name <- subset(df, df$nodeId == node_id)$shortName
            short_name <- paste(strsplit(short_name, " ")[[1]], collapse = "_")
            file_name <- paste0("results_", short_name, ".zip")
        } else {
            file_name <- paste0("results_", resource_id, "_", node_id, ".zip")
        }
    } else {
        dir <- dirname(path_outcome)
        file_name <- basename(path_outcome)
    }
    if (!dir.exists(dir)) dir.create(dir, recursive = TRUE)

    data_tag <- xml2::xml_find_first(parsed_response, ".//data")
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
})

#' @importFrom curl form_file
upload_resource <- function(file, display_name, rtype, access,
                            endpoint = NULL) {

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


#'Upload a resource on OPAL
#'
#'Function `upload2opal()` takes full prepared zip archive of QTI-test or
#'QTI-task and uploads it to the OPAL.
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
#'@return A list with the key, display name, and URL of the resource in Opal.
#'@examplesIf interactive()
#'file <- system.file("exercises/sc1.Rmd", package='rqti')
#' upload2opal(file, "task 1", open_in_browser = FALSE)
#'@export
upload2opal <- function(test, display_name = NULL, access = 4, overwrite = TRUE,
                        endpoint = NULL, open_in_browser = TRUE,
                        as_survey = FALSE,
                        api_user = NULL) {
    api_user = ifelse(is.null(api_user), NA_character_, api_user)
    endpoint = ifelse(is.null(endpoint), NA_character_, endpoint)
    conn <- new("Opal", api_user = api_user, endpoint = endpoint)
    upload2LMS(conn, test, display_name, access, overwrite)

}


