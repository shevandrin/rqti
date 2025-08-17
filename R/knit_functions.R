#' Render an Rmd/md/xml file or rqti-object as qti xml with qtijs.
#'
#' Generates the qti xml file via rmd2xml. The xml is copied into the qtijs
#' folder which transforms the xml into HTML. Finally, the HTML is displayed and
#' the user sees a preview of the exercise or test.
#'
#' Requires a running qtijs server, which can be started with start_server().
#'
#' The preview is automatically loaded into the RStudio viewer pane if run in
#' RStudio. Alternatively you  can just open the browser at the corresponding
#' local server url which is displayed after rendering is finished. Since the
#' function is supposed to be called via the Knit-Button in RStudio, it defaults
#' to the RStudio viewer pane.
#'
#' Customize knit function in the Rmd file using the following YAML setting
#' after the word knit `knit: rqti::render_qtijs`.
#'
#' @param input The path to the input Rmd/md/xml document or an
#'   [AssessmentItem], [AssessmentTest], [AssessmentTestOpal],
#'   [AssessmentSection] object.
#' @param preview_feedback A boolean value; optional. Set `TRUE` value to always
#'   display feedback (for example, as a modal answer). Default is `FALSE`.
#' @param qtijs_path The path to the qtijs renderer (qti.js), which will be
#'   started with servr::httw and to which xml files will be copied. Default is
#'   the QTIJS folder in the R package rqti local installation via the helper
#'   qtijs_pkg_path().
#' @param ... required for passing arguments when knitting
#'
#' @return An URL of the corresponding local server to display the rendering
#'   result.
#'
#' @examplesIf interactive()
#'   file <- system.file("exercises/sc1.Rmd", package = 'rqti')
#'   render_qtijs(file)
#'
#' @importFrom knitr knit_params
#' @export
render_qtijs <- function(input, preview_feedback = FALSE,
                         qtijs_path = qtijs_pkg_path(), ...) {
    clean_qtijs(qtijs_path)
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
    preparation <- prepareQTIJSFiles(input, qtijs_path)
    if (!is.null(preparation)) preview_feedback <- preparation
    url <- paste0(url, "?mfb=", as.numeric(preview_feedback))
    message("Open browser at: ", url, " for preview")

    if (Sys.getenv("RSTUDIO") == "1") {
        rstudioapi::viewer(url)
    }
    message("finished rendering")
    return(url)
}

#' Render a single xml file with qtijs.
#'
#' Uses qtijs to render a single xml file in the RStudio viewer pane with a
#' local server.
#'
#' @inheritParams render_qtijs
#' @return nothing, has side effects
#' @examplesIf interactive()
#'   file <- system.file("exercises/sc1d.xml", package = 'rqti')
#'   render_qtijs(file)
#'
#' @export
render_xml <- function(input, qtijs_path = qtijs_pkg_path()) {
    url <- prepare_renderer()
    # use index.xml for a single file
    file.copy(input, paste0(qtijs_path, "/index.xml"))
    if (Sys.getenv("RSTUDIO") == "1") {
        rstudioapi::viewer(url)
    }
}

#' Render a zipped qti archive with qtijs.
#'
#' Uses qtijs to render a zipped qti archive in the RStudio viewer pane with a
#' local server.
#'
#' @inheritParams render_qtijs
#' @return nothing, has side effects
#' @export
render_zip <- function(input, qtijs_path = qtijs_pkg_path()) {
    url <- prepare_renderer()
    zip::unzip(input, exdir = qtijs_path)
    if (Sys.getenv("RSTUDIO") == "1") {
        rstudioapi::viewer(url)
    }
}

#' Start qtijs renderer as a local server.
#'
#' This function starts an http server with the qtijs renderer. The renderer
#' performs the conversion of qti.xml into HTML.
#'
#' The server has to be started manually by the user, otherwise the Knit-Button
#' will not work. The Knit-Button starts a new session and invoking a server
#' there does not work. You can automatically start the server via an .RProfile
#' file on start up.
#' @param daemon This parameter is forwarded to `servr::httw` and should always be
#'   TRUE (the default). FALSE is only used for testing purposes when called via
#'   `callr::bg()`
#' @inheritParams render_qtijs
#' @return The URL string of the qtijs server.
#' @examples
#' \dontrun{
#' start_server()
#' }
#' @export
start_server <- function(qtijs_path = qtijs_pkg_path(),
                         daemon = T) {
    # this will kill all servers that were started via
    # servr in the session; maybe this is not necessary
    servr::daemon_stop(which = servr::daemon_list())
    server_info <- servr::httw(dir = qtijs_path, verbose = F, browser = F,
                               daemon = daemon)
    message("To stop the server, run stop_server(). If you restart the R session, the server is restarted, too. Call start_server() to manually (re)start the server.\nServing the directory ", qtijs_path, " at ", server_info$url)
    # only way to get the url when using Knit Button
    Sys.setenv("RQTI_URL" = server_info$url)
    return(server_info$url)
}

#' Shortcut for the qtijs path of the rqti package local installation.
#' @examples
#'   qtijs_pkg_path()
#' @export
qtijs_pkg_path <- function() {
    fs::path_package("rqti", "QTIJS")
}

#' Prepare qtijs renderer.
#'
#' Starts server for qtijs, returns path of qtijs and the url of the server.
#' @inheritParams render_qtijs
prepare_renderer <- function(qtijs_path = qtijs_pkg_path()) {
    # start a server there is no server url yet
    if (Sys.getenv("RQTI_URL") == "") {
        start_server(qtijs_path)
    }
    # clean up
    clean_qtijs(qtijs_path)
    Sys.getenv("RQTI_URL")
}

#Remove all xml files from qtijs renderer folder.
clean_qtijs <- function(qtijs_path = qtijs_pkg_path()) {
    unlink(paste(qtijs_path, "*.xml", sep = "/"))
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
#'   file <- system.file("exercises/sc1.Rmd", package = 'rqti')
#'   render_opal(file)
#' @export
render_opal <- function(input, ...) {
    knit_test <- rmd2zip(input)
    con <- new("Opal")
    result <- upload2LMS(con, knit_test)
    unlink(knit_test)
    return(result)
}
