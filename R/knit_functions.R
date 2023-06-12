#' Render an RMD file as qti xml with QTIJS
#'
#' Generates the qti xml file through the functions of the package exams. The
#' xml is copied into the QTIJS folder which transforms the xml into HTML.
#' Finally, the HTML is displayed and the user can have a preview of the
#' exercise or exam.
#'
#' Requires a running QTIJS server, which can be started with start_server().
#'
#' @param input (the path to the input Rmd document)
#' @param ... required for passing arguments when knitting
#'
#' @examples
#' # Customize knit function in the Rmd file using the following YAML setting
#' # after the word knit:
#' \dontrun{qti::knit}
#'
#' @export
knit_qti_html <- function(input, ...) {
    # naming this function just knit, does not work
    # clean up
    unlink(paste(qtijs_path(), "*.xml", sep = "/"))
    url <- Sys.getenv("QTI_URL")
    print(url)
    if (url == "") {
      stop("Server for QTIJS not running. You can start it manually with start_server()")
    }
    rmd2zip(input, path = qtijs_path())
    rstudioapi::viewer(url)
}

#' Render a single xml file
#'
#' Uses QTIJS to render a single xml file in the RStudio viewer pane with a
#' local server.
#'
#' @param input input file
#' @return nothing, has side effects
#' @export
render_xml <- function(input) {
  renderer <- prepare_renderer()
  # use index.xml for a single file
  file.copy(input, paste0(renderer$path, "/index.xml"))
  rstudioapi::viewer(renderer$url)
}

#' Start QTIJS on a local server
#'
#' This function starts an http server with the QTIJS renderer. The renderer performs the conversion of qti.xml into HTML.
#'
#' The server has to be started manually by the user, otherwise the Knit Button will not work. The Button starts a new session and invoking a server there does not make much sense.
#'
#' @examples
#' \dontrun{
#' # Initiated server in qtiViewer folder
#' start_server()
#' # Initiated server in a specific folder provided by the user. This folder
#'  contains the QTI renderer
#' start_server("/pathToTheQtiRenderer/")
#' }
#' @export
start_server <- function() {
    path = qtijs_path()
    # this will kill all servers that were started via
    # servr in the session; maybe this is not necessary
    servr::daemon_stop(which = servr::daemon_list())
    server_info <- servr::httw(dir = path)
    # only way to get the url when using Knit Button
    Sys.setenv("QTI_URL" = server_info$url)
    return(server_info$url)
}


#' shortcut for the correct QTIJS path
qtijs_path <- function() {
    fs::path_package("qti", "QTIJS")
}
#' Prepare QTIJS renderer
#'
#' Starts server for QTIJS, returns path of QTIJS and the url of the server.
prepare_renderer <- function() {
  path <- qtijs_path()
  # start a server if none are there or there is no server url
  if (length(servr::daemon_list()) == 0 || Sys.getenv("QTI_URL") == "") {
      start_server()
  }
  # clean up
  files_d <- paste(path, "*.xml", sep = "/")
  unlink(files_d)
  return(list(path = path, url = Sys.getenv("QTI_URL")))
}
