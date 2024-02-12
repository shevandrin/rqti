.onAttach <- function(libname, pkgname){
    if (interactive()) {
        packageStartupMessage("Welcome to rqti.")
    }
}

.onDetach <- function(libpath) {
    stop_server()
}
