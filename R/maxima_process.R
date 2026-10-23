# RStudio's Knit process inherits environment variables, but not R options.
maxima_default_executable <- function() {
    getOption("rqti.maxima", Sys.getenv("RQTI_MAXIMA", "maxima"))
}

resolve_maxima_executable <- function(executable = maxima_default_executable()) {
    guidance <- paste0("Install Maxima and put it on PATH, or set ",
                       "options(rqti.maxima = '/path/to/maxima').")
    if (!is.character(executable) || length(executable) != 1L ||
        is.na(executable) || !nzchar(executable)) {
        stop("Maxima is required. ", guidance, call. = FALSE)
    }
    path <- path.expand(executable)
    # Sys.which() on Windows may require DOS short names. An existing explicit
    # path needs no PATH lookup and must retain its long/Unicode components.
    if (!file.exists(path) && !grepl("[/\\\\:]", path)) path <- unname(Sys.which(path))
    if (!nzchar(path) || !file.exists(path) || dir.exists(path)) {
        stop("Maxima executable not found: ", executable, ". ", guidance, call. = FALSE)
    }
    normalizePath(path, winslash = "/", mustWork = TRUE)
}

maxima_process_command <- function(executable, args,
                                   windows = .Platform$OS.type == "windows") {
    # processx documents explicit cmd.exe + call for batch files whose path
    # and arguments both contain spaces (as Maxima's Windows launcher does).
    if (windows && grepl("\\.(bat|cmd)$", executable, ignore.case = TRUE)) {
        return(list(command = Sys.getenv("COMSPEC", "cmd.exe"),
                    args = c("/d", "/c", "call", executable, args)))
    }
    list(command = executable, args = args)
}

maxima_start_process <- function(executable, args, ...) {
    command <- maxima_process_command(executable, args)
    processx::process$new(command$command, args = command$args, ...)
}
