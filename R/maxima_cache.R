# Cache compiled libraries only. Programs, answers and Maxima processes remain
# private to each calculation. All writers use the same cross-process lock.
maxima_cache_state <- new.env(parent = emptyenv())
maxima_cache_state$identities <- list()
maxima_cache_state$held <- list()

maxima_cache_root <- function() {
    root <- getOption("rqti.maxima_cache_dir")
    if (identical(root, FALSE) || (is.null(root) && getRversion() < "4.0")) {
        root <- file.path(tempdir(), "rqti-maxima-libraries")
    } else if (is.null(root)) {
        root <- file.path(tools::R_user_dir("rqti", "cache"), "maxima-libraries")
    }
    if (!is.character(root) || length(root) != 1L || is.na(root) || !nzchar(root)) {
        stop("rqti.maxima_cache_dir must be a directory path or FALSE.", call. = FALSE)
    }
    dir.create(root, recursive = TRUE, showWarnings = FALSE)
    if (!dir.exists(root)) stop("Could not create the Maxima library cache: ", root, call. = FALSE)
    normalizePath(root, winslash = "/", mustWork = TRUE)
}

maxima_wait_process <- function(process, timeout) {
    started <- proc.time()[["elapsed"]]
    while (process$is_alive()) {
        remaining <- timeout - (proc.time()[["elapsed"]] - started)
        if (remaining <= 0) return(FALSE)
        process$wait(max(1L, as.integer(min(remaining, 1) * 1000)))
    }
    TRUE
}

maxima_stop_process <- function(process) {
    # Tree discovery can miss a process immediately after it starts. Kill the
    # direct process/group as well, then reap it before releasing cache locks.
    process$kill_tree()
    process$kill()
    if (!maxima_wait_process(process, 5)) {
        stop("Maxima did not terminate during cleanup.", call. = FALSE)
    }
    invisible(NULL)
}

maxima_cache_identity <- function(executable, timeout) {
    executable <- resolve_maxima_executable(executable)
    info <- file.info(executable)
    stamp <- paste(executable, info$size, as.numeric(info$mtime), R.version$platform)
    cached <- maxima_cache_state$identities[[stamp]]
    if (!is.null(cached)) return(cached)
    work <- tempfile("rqti-maxima-build-")
    dir.create(work)
    on.exit(unlink(work, recursive = TRUE))
    # Isolate the probe too, so it never reads the user's ~/.maxima startup.
    userdir <- file.path(work, "user")
    dir.create(userdir)
    stdout <- file.path(work, "stdout")
    process <- maxima_start_process(executable, args = c("--very-quiet",
        paste0("--userdir=", normalizePath(userdir, winslash = "/")),
        paste0('--batch-string=display2d:false$ printf(true,"__RQTI_CACHE_BUILD__~a~%",',
               'string(makelist(args(build_info())[i],i,1,5)))$ quit();')),
        stdout = stdout, stderr = file.path(work, "stderr"), cleanup_tree = TRUE)
    on.exit(maxima_stop_process(process), add = TRUE, after = FALSE)
    if (!maxima_wait_process(process, timeout)) stop("Maxima build inspection exceeded ", timeout, " seconds.", call. = FALSE)
    lines <- readLines(stdout, warn = FALSE)
    build <- lines[startsWith(lines, "__RQTI_CACHE_BUILD__")]
    if (process$get_exit_status() != 0L || length(build) != 1L) {
        stop("Could not identify the Maxima and Lisp build for the library cache.", call. = FALSE)
    }
    # build_info supplies Maxima version/build date, target, Lisp and Lisp version.
    key <- as.character(openssl::md5(charToRaw(paste(stamp, build))))
    maxima_cache_state$identities[[stamp]] <- key
    key
}

maxima_cache_config <- function(executable, timeout) {
    list(root = maxima_cache_root(), key = maxima_cache_identity(executable, timeout))
}

acquire_maxima_cache <- function(config, timeout, wait = TRUE) {
    started <- proc.time()[["elapsed"]]
    repeat {
        lock <- if (is.null(maxima_cache_state$held[[config$root]])) {
            filelock::lock(file.path(config$root, ".cache.lock"), timeout = 0)
        }
        if (!is.null(lock)) break
        if (!wait) return(NULL)
        if (proc.time()[["elapsed"]] - started >= timeout) {
            stop("Waiting for the Maxima library cache exceeded ", timeout, " seconds.", call. = FALSE)
        }
        # A local preview in this R session must be able to finish and unlock.
        later::run_now(0)
        Sys.sleep(0.05)
    }
    handle <- new.env(parent = emptyenv())
    handle$lock <- lock
    handle$root <- config$root
    handle$path <- file.path(config$root, paste0("v1-", config$key))
    handle$released <- FALSE
    handle$ready_file <- NULL
    maxima_cache_state$held[[config$root]] <- handle
    keep <- FALSE
    on.exit(if (!keep) release_maxima_cache(handle))
    # The root lock also protects maintenance. Retain only the current build:
    # no other rqti calculation can still be using an old build in this root.
    dirs <- list.dirs(config$root, recursive = FALSE, full.names = TRUE)
    owned <- dirs[grepl("^v1-[a-f0-9]{32}$", basename(dirs))]
    unlink(setdiff(owned, handle$path), recursive = TRUE)
    if (dir.exists(handle$path)) {
        used <- file.info(file.path(handle$path, ".last-used"))$mtime
        if (!is.na(used) && as.numeric(difftime(Sys.time(), used, units = "days")) > 30) {
            unlink(handle$path, recursive = TRUE)
        }
    }
    dir.create(handle$path, showWarnings = FALSE)
    if (!dir.exists(handle$path)) stop("Could not create the Maxima build cache.", call. = FALSE)
    handle$path <- normalizePath(handle$path, winslash = "/")
    keep <- TRUE
    handle
}

release_maxima_cache <- function(handle) {
    if (is.null(handle) || handle$released) return(invisible(NULL))
    # Release even if maintenance fails. Keep the separate lock file in place.
    on.exit({
        filelock::unlock(handle$lock)
        maxima_cache_state$held[[handle$root]] <- NULL
        handle$released <- TRUE
    })
    files <- list.files(handle$path, all.files = TRUE, full.names = TRUE,
                        recursive = TRUE, no.. = TRUE)
    size <- sum(file.info(files)$size, na.rm = TRUE)
    if ((!is.null(handle$ready_file) && !file.exists(handle$ready_file)) || size > 64 * 1024^2) {
        unlink(handle$path, recursive = TRUE)
    } else if (dir.exists(handle$path)) {
        # Do not retain startup files or author-generated results in the cache.
        extra <- list.files(handle$path, all.files = TRUE, full.names = TRUE, no.. = TRUE)
        unlink(extra[!basename(extra) %in% c("binary", ".last-used")], recursive = TRUE)
        file.create(file.path(handle$path, ".last-used"), showWarnings = FALSE)
    }
    invisible(NULL)
}
