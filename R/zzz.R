.onLoad <- function(libname, pkgname){
    if (interactive()) {
        packageStartupMessage("Welcome to qti.\nStarting QTIJS rendering server.")
        start_server()
    }
}
