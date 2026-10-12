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
#'   served by the local preview server and to which xml files will be copied. Default is
#'   the folder used by the running preview server, or the installed package's
#'   QTIJS folder when no server is running. Knit sessions inherit the server's
#'   folder even when RStudio uses a development checkout.
#' @param ... required for passing arguments when knitting
#'
#' @return An URL of the corresponding local server to display the rendering
#'   result.
#'
#' @examplesIf interactive()
#'file <- system.file(
#'     "rmarkdown/templates/singlechoice-simple/skeleton/skeleton.Rmd",
#'     package='rqti'
#')
#'render_qtijs(file)
#'
#' @importFrom knitr knit_params
#' @export
render_qtijs <- function(input, preview_feedback = FALSE,
                         qtijs_path = qtijs_preview_path(), ...) {
    # for render_rmd this has to be checked manually because the Knit Button
    # is tricky to set up
    url <- Sys.getenv("RQTI_URL")
    if (url == "") {
        # Knit Button runs in separate session
        if (!interactive()) {
            stop("Server for QTIJS not running. You can start it manually with start_server()")
        } else {
            url <- prepare_renderer(qtijs_path)
        }
    }
    check_qtijs_preview_path(qtijs_path)
    clean_qtijs(qtijs_path)
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
#'   file <- system.file("extdata", "sc1d.xml", package = 'rqti')
#'   render_qtijs(file)
#'
#' @export
render_xml <- function(input, qtijs_path = qtijs_preview_path()) {
    url <- prepare_renderer(qtijs_path)
    # use index.xml for a single file
    file.copy(input, paste0(qtijs_path, "/index.xml"), overwrite = TRUE)
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
render_zip <- function(input, qtijs_path = qtijs_preview_path()) {
    url <- prepare_renderer(qtijs_path)
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
#' @param daemon Run the server in the background. Use TRUE (the default) in
#'   RStudio. FALSE keeps serving until the R process exits, for example in tests.
#' @details Maxima previews use locally installed Maxima through the R server
#'   and work in both the RStudio Viewer and an external browser.
#' @inheritParams render_qtijs
#' @return The URL string of the qtijs server.
#' @examples
#' \dontrun{
#' start_server()
#' }
#' @export
start_server <- function(qtijs_path = qtijs_pkg_path(),
                         daemon = T) {
    qtijs_path <- normalizePath(qtijs_path, mustWork = TRUE)
    # this will kill all servers that were started via
    # servr in the session; maybe this is not necessary
    stop_server()
    url <- start_maxima_local_server(qtijs_path, daemon)
    message("Serving qti.js with local Maxima support at ", url,
            ". To stop the server, run stop_server().")
    # only way to get the url when using Knit Button
    Sys.setenv(RQTI_URL = url, RQTI_QTIJS_PATH = qtijs_path)
    return(url)
}

#' Shortcut for the qtijs path of the rqti package local installation.
#' @examples
#'   qtijs_pkg_path()
#' @export
qtijs_pkg_path <- function() {
    system.file("QTIJS", package = "rqti")
}

# The Knit button starts a separate R session. Both URL and directory must be
# inherited, since that session may load a different installed package copy.
qtijs_preview_path <- function() {
    path <- Sys.getenv("RQTI_QTIJS_PATH")
    if (nzchar(Sys.getenv("RQTI_URL")) && nzchar(path)) path else qtijs_pkg_path()
}

check_qtijs_preview_path <- function(qtijs_path) {
    served_path <- Sys.getenv("RQTI_QTIJS_PATH")
    if (nzchar(Sys.getenv("RQTI_URL")) && nzchar(served_path) &&
        !identical(normalizePath(qtijs_path, mustWork = TRUE),
                   normalizePath(served_path, mustWork = TRUE))) {
        stop("qtijs_path differs from the running preview server's folder. ",
             "Omit qtijs_path to use that folder, or run start_server(qtijs_path) ",
             "in the RStudio console first.", call. = FALSE)
    }
    invisible(qtijs_path)
}

#' Prepare qtijs renderer.
#'
#' Starts server for qtijs, returns path of qtijs and the url of the server.
#' @inheritParams render_qtijs
prepare_renderer <- function(qtijs_path = qtijs_preview_path()) {
    # start a server there is no server url yet
    if (Sys.getenv("RQTI_URL") == "") {
        start_server(qtijs_path)
    }
    check_qtijs_preview_path(qtijs_path)
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
    Sys.unsetenv(c("RQTI_URL", "RQTI_QTIJS_PATH"))
    servr::daemon_stop()
    if (is.function(maxima_local_preview_server$stop)) {
        maxima_local_preview_server$stop()
        maxima_local_preview_server$stop <- NULL
    }
}

#' Render Rmd directly in Opal via API
#'
#' @details
#' Customize knit function in the Rmd file using the following YAML setting
#' after the word knit `knit: rqti::render_opal`.
#'
#' @param input (the path to the input Rmd document)
#' @param ... Arguments supplied by the knitting frontend. Named `endpoint`,
#'   `api_user`, and `credential_id` arguments are forwarded to [opal()].
#' @return A list with the key, display name, and URL of the resource in Opal.
#' @examplesIf interactive()
#'file <- system.file(
#'     "rmarkdown/templates/singlechoice-simple/skeleton/skeleton.Rmd",
#'     package='rqti'
#')
#'render_opal(file)
#' @export
render_opal <- function(input, ...) {
    knit_test <- rmd2zip(input)
    on.exit(unlink(knit_test), add = TRUE)

    dots <- list(...)
    connection_names <- intersect(names(dots),
                                  c("endpoint", "api_user", "credential_id"))
    connection_args <- dots[connection_names]
    con <- do.call(opal, connection_args)
    result <- upload2LMS(con, knit_test)
    return(result)
}
