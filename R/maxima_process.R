# Public configuration uses R options. Internal environment variables let
# separate Knit sessions locate the server and fetch the current options.
maxima_default_executable <- function() {
    choice <- getOption("rqti.maxima")
    if (is.null(choice)) choice <- preview_console_options()$maxima
    if (is.null(choice)) choice <- if (identical(Sys.getenv("RQTI_SERVER_PID"), as.character(Sys.getpid()))) {
        "maxima"
    } else Sys.getenv("RQTI_MAXIMA", "maxima")
    choice
}

# Separate Knit sessions can read the console's current options. The serving
# process must never request its own synchronous endpoint.
preview_console_options <- function() {
    pid <- Sys.getenv("RQTI_SERVER_PID")
    url <- Sys.getenv("RQTI_URL")
    if (!nzchar(pid) || identical(pid, as.character(Sys.getpid())) || !nzchar(url)) return(list())
    response <- tryCatch(curl::curl_fetch_memory(
        paste0(sub("/$", "", url), "/.rqti-maxima/config"),
        handle = curl::new_handle(proxy = "", connecttimeout = 2, timeout = 5)),
        error = function(e) stop("Cannot read current preview settings: ", conditionMessage(e), call. = FALSE))
    if (response$status_code != 200L) stop("Cannot read current preview settings (HTTP ",
                                         response$status_code, ").", call. = FALSE)
    jsonlite::fromJSON(rawToChar(response$content))$options
}

resolve_maxima_executable <- function(executable = maxima_default_executable()) {
    guidance <- paste0("Install Maxima and put it on PATH, or set ",
                       "options(rqti.maxima = '/path/to/maxima') using the full ",
                       "path including the executable (for example maxima.bat on Windows).")
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
