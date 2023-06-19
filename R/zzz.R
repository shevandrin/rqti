.onAttach <- function(libname, pkgname){
    if (interactive()) {
        packageStartupMessage("Welcome to qti.\nStarting QTIJS rendering server.")
        start_server()
    }
}

.onDetach <- function(libpath) {
    stop_server()
}
