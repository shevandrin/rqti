.onAttach <- function(libname, pkgname){
    if (interactive()) {
        packageStartupMessage("Welcome to qti.")
    }
}

.onDetach <- function(libpath) {
    stop_server()
}
