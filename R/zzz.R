.onAttach <- function(libname, pkgname){
    if (interactive()) {
        packageStartupMessage("Welcome to qti.")
        if (Sys.getenv("QTI_AUTOSTART_SERVER") != FALSE) {
            message("Starting QTIJS rendering server.")
            start_server()
        }
    }
}

.onDetach <- function(libpath) {
    stop_server()
}
