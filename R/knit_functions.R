#' Generate a HTML representation of a RMD file
#'
#' Choosing a specific Rmd file the function generates the qti.xml for it through the functions of the package exams, after the XML is copied into the QTI Engine which transforms the qti.xml into HTML format. Finally, the HTML is displayed and the user can have a preview of the exercise or exam.
#'
#' @param input (the path to the input Rmd document)
#' @param ... other arguments that are currently ignored
#'
#' @examples
#' # Customize knit function in the Rmd file using the following YAML setting after the word knit:
#' qti::knit_qti_html
#' @export
knit_qti_html <- function(input, ...) {
  qti_port <- Sys.getenv("QTI_PORT")
  url_engine <- paste("http://localhost",qti_port, sep = ":")
  if (RCurl::url.exists(url_engine) == TRUE) {
    qti_engine_d <- Sys.getenv("QTI_FOLDER")
    files_d <- paste(qti_engine_d,"*.xml", sep = "/")
    unlink(files_d)
    exams::exams2qti21(input, dir = qti_engine_d, zip = FALSE)
    rstudioapi::viewer(url_engine)
  }
  else {
    print(paste("QTI Engine not available in ", url_engine, ". Start the server with function start_server()"))
  }
}

#' Start QTI Engine in a server
#'
#' The function starts a server in the folder that contains the js QTI Engine that performs the conversion of qti.xml into HTML.
#'
#' @param qti_engine_f filepath to the js QTI Engine. Can be empty to indicate that the server can be initiated in the package folder.
#'
#' @examples
#' # Initiated server in qtiViewer folder
#' start_server()
#' # Initiated server in a specific folder provided by the user. This folder contains the js QTI Engine
#' start_server("/pathToTheQtiEngine/")
#'
#' @export
start_server <- function(qti_engine_f) {
  servr::daemon_stop(which = servr::daemon_list())
  if (missing(qti_engine_f)){
    package_d <- paste(fs::path_package("qtiViewer"),"QTI_Engine", sep = "/")
  }
  else{
    package_d <- paste(qti_engine_f)
  }

  if (file.exists(package_d)){
    server_info <- servr::httw(dir = package_d)
    port_s <- server_info[2]
    Sys.setenv(QTI_PORT = port_s$port)
    Sys.setenv(QTI_FOLDER = package_d)
  }
  else{
    print("QTI Engine not found in directory")
  }
}


