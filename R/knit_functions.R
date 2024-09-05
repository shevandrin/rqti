#' Render an RMD/xml file or rqti-object as qti xml with QTIJS
#'
#' Generates the qti xml file via rmd2xml. The xml is copied into the QTIJS
#' folder of the package which transforms the xml into HTML. Finally, the HTML
#' is displayed and the user can have a preview of the exercise or exam.
#'
#' Requires a running QTIJS server, which can be started with start_server().
#' When loading the package rqti, a server is started automatically.
#'
#' The preview is automatically loaded into the RStudio viewer. Alternatively
#' you  can just open the browser in the corresponding local server which is
#' displayed when rendering. Since the function is supposed to be called via the
#' Knit-Button in RStudio, it defaults to the RStudio viewer pane.
#'
#' Customize knit function in the Rmd file using the following YAML
#' setting after the word knit `knit: rqti::render_qtijs`.
#'
#' @param input (the path to the input Rmd/md/xml document or [AssessmentItem],
#'   [AssessmentTest], [AssessmentTestOpal], [AssessmentSection] object)
#' @param preview_feedback A boolean value; optional. Set `TRUE` value to always
#' display a model feedback (for example, as a model answer). Default is `FALSE`.
#' @param ... required for passing arguments when knitting
#' @return An URL of the corresponding local server to display the rendering
#'   result.
#'
#' @examplesIf interactive()
#' file <- system.file("exercises/sc1.Rmd", package='rqti')
#' render_qtijs(file)
#'
#' @importFrom knitr knit_params
#' @export
render_qtijs <- function(input, preview_feedback = FALSE, ...) {
    clean_qtijs()
    params <- knit_params(readLines(input))
    if (!is.null(params$preview_feedback$value)) {
        preview_feedback = params$preview_feedback$value
    }
    # for render_rmd this has to be checked manually because the Knit Button
    # is tricky to set up
    url <- Sys.getenv("RQTI_URL")
    if (url == "") {
        # Knit Button runs in separate session
        if (!interactive()) {
            stop("Server for QTIJS not running. You can start it manually with start_server()")
        } else {
            url <- prepare_renderer()
        }
    }
    url <- paste0(url, "?mfb=", as.numeric(preview_feedback))
    message("Open browser at: ", url, " for preview")
    prepareQTIJSFiles(input, qtijs_path())
    if (Sys.getenv("RSTUDIO") == "1") {
        rstudioapi::viewer(url)
    }
    current_rmd_fullpath <- normalizePath(input)
    xml_target <- sub("\\.Rmd$", ".xml", current_rmd_fullpath)
    file.copy(file.path(qtijs_path(), "index.xml"), xml_target)
    message("finished rendering")
    return(url)
}

#' Render a single xml file with QTIJS
#'
#' Uses QTIJS to render a single xml file in the RStudio viewer pane with a
#' local server.
#'
#' @param input input file
#' @return nothing, has side effects
#' @export
render_xml <- function(input) {
    url <- prepare_renderer()
    # use index.xml for a single file
    file.copy(input, paste0(qtijs_path(), "/index.xml"))
    if (Sys.getenv("RSTUDIO") == "1") {
        rstudioapi::viewer(url)
    }
}

#' Render a zipped qti archive with QTIJS
#'
#' Uses QTIJS to render a zipped qti archive in the RStudio viewer pane with a
#' local server.
#'
#' @param input input file
#' @return nothing, has side effects
#' @export
render_zip <- function(input) {
    url <- prepare_renderer()
    zip::unzip(input, exdir = qtijs_path())
    if (Sys.getenv("RSTUDIO") == "1") {
        rstudioapi::viewer(url)
    }
}

#' Start QTIJS on a local server
#'
#' This function starts an http server with the QTIJS renderer. The renderer performs the conversion of qti.xml into HTML.
#'
#' The server has to be started manually by the user, otherwise the Knit Button will not work. The Button starts a new session and invoking a server there does not make much sense.
#'
#' @return The URL string for QTIJS server.
#' @examples
#' \dontrun{
#' # Initiated server in qtiViewer folder
#' start_server()
#' # Initiated server in a specific folder provided by the user. This folder
#' # contains the QTI renderer
#' start_server("/pathToTheQtiRenderer/")
#' }
#' @export
start_server <- function() {
    path = qtijs_path()
    # this will kill all servers that were started via
    # servr in the session; maybe this is not necessary
    servr::daemon_stop(which = servr::daemon_list())
    server_info <- servr::httw(dir = path, verbose = F, browser = F)
    message("To stop the server, run stop_server(). If you restart the R session, the server is restarted, too. Call start_server() to manually (re)start the server.\nServing the directory ", path, " at ", server_info$url)
    # only way to get the url when using Knit Button
    Sys.setenv("RQTI_URL" = server_info$url)
    return(server_info$url)
}

#' shortcut for the correct QTIJS path
qtijs_path <- function() {
    fs::path_package("rqti", "QTIJS")
}

#' Prepare QTIJS renderer
#'
#' Starts server for QTIJS, returns path of QTIJS and the url of the server.
prepare_renderer <- function() {
    path <- qtijs_path()
    # start a server if none are there or there is no server url
    if (Sys.getenv("RQTI_URL") == "") {
        start_server()
    }
    # clean up
    clean_qtijs()
    Sys.getenv("RQTI_URL")
}

clean_qtijs <- function() {
    unlink(paste(qtijs_path(), "*.xml", sep = "/"))
}

#' Stop QTIJS local server
#' @return nothing, has side effects
#' @export
stop_server <- function() {
    Sys.setenv(RQTI_URL = "")
    servr::daemon_stop()
}

#' Render Rmd directly in Opal via API
#'
#' @details
#' Customize knit function in the Rmd file using the following YAML setting
#' after the word knit `knit: rqti::render_opal`.
#'
#' @param input (the path to the input Rmd document)
#' @param ... required for passing arguments when knitting
#' @return A list with the key, display name, and URL of the resource in Opal.
#' @examplesIf interactive()
#' file <- system.file("exercises/sc1.Rmd", package='rqti')
#' render_opal(file)
#' @export
render_opal <- function(input, ...) {
    knit_test <- rmd2zip(input)
    result <- upload2opal(knit_test)
    unlink(knit_test)
    return(result)
}
