# Local preview jobs execute outside R's event loop; httpuv serves ordinary
# items while later polls for completion. No browser isolation is required.
maxima_local_preview_server <- new.env(parent = emptyenv())
maxima_local_preview_server$stop <- NULL

maxima_preview_quote <- function(x) {
    paste0('"', gsub('"', '\\"', gsub("\\", "\\\\", x, fixed = TRUE), fixed = TRUE), '"')
}

validate_maxima_preview_request <- function(request) {
    blocks <- request$blocks
    if (!is.list(blocks) || !length(blocks) || length(blocks) > 100L) {
        stop("Expected between 1 and 100 Maxima blocks.", call. = FALSE)
    }
    scalar <- function(x) is.character(x) && length(x) == 1L && !is.na(x) && nzchar(x)
    for (block in blocks) {
        if (!is.list(block) || !scalar(block$code) || !is.list(block$outputs)) {
            stop("Each Maxima block needs code and an outputs list.", call. = FALSE)
        }
        names <- character()
        for (output in block$outputs) {
            if (!is.list(output) || !scalar(output$name) ||
                !grepl("^[A-Za-z][A-Za-z0-9_]*$", output$name) ||
                !scalar(output$type) || !output$type %in% c("integer", "float", "string")) {
                stop("Invalid Maxima output name or type.", call. = FALSE)
            }
            names <- c(names, output$name)
        }
        if (anyDuplicated(names)) stop("Duplicate Maxima output names.", call. = FALSE)
    }
    libraries <- request$libraries
    if (is.null(libraries)) libraries <- c("distrib", "descriptive", "stats")
    if (is.list(libraries) && !length(libraries)) libraries <- character()
    if (is.list(libraries) && all(vapply(libraries, scalar, logical(1)))) {
        libraries <- unlist(libraries, use.names = FALSE)
    }
    if (!is.character(libraries) || anyNA(libraries) || any(!nzchar(libraries))) {
        stop("Maxima libraries must be an array of names.", call. = FALSE)
    }
    list(blocks = blocks, libraries = libraries)
}

start_maxima_preview_job <- function(request,
        executable = getOption("rqti.maxima", Sys.which("maxima")),
        timeout = getOption("rqti.maxima_timeout", 120), cache_wait = TRUE) {
    request <- validate_maxima_preview_request(request)
    if (!is.character(executable) || length(executable) != 1L || is.na(executable) ||
        !nzchar(executable) || !nzchar(Sys.which(executable))) {
        stop("Maxima is required. Install Maxima and put it on PATH, or set options(rqti.maxima = '/path/to/maxima').", call. = FALSE)
    }
    if (!is.numeric(timeout) || length(timeout) != 1L || !is.finite(timeout) || timeout <= 0) {
        stop("timeout must be a positive number of seconds.", call. = FALSE)
    }
    started <- proc.time()[["elapsed"]]
    cache <- NULL
    keep <- FALSE
    if (length(request$libraries)) {
        cache <- acquire_maxima_cache(maxima_cache_config(executable, timeout),
            max(0, timeout - (proc.time()[["elapsed"]] - started)), wait = cache_wait)
        if (is.null(cache)) return(NULL)
    }
    on.exit(if (!keep) release_maxima_cache(cache), add = TRUE)
    work <- tempfile("rqti-maxima-preview-")
    dir.create(work)
    work <- normalizePath(work, winslash = "/")
    on.exit(if (!keep) unlink(work, recursive = TRUE), add = TRUE)
    q <- maxima_preview_quote
    active <- file.path(work, "active.txt")
    completed <- file.path(work, "completed.txt")
    rules <- character()
    for (i in seq_along(request$blocks)) {
        block <- request$blocks[[i]]
        program <- file.path(work, paste0("program-", i, ".mac"))
        writeLines(enc2utf8(c(block$code, "rqti_program_result:%$",
                              "rqti_program_completed:true$")), program, useBytes = TRUE)
        result <- file.path(work, paste0("result-", i, ".json"))
        rules <- c(rules,
            paste0('with_stdout(', q(active), ',printf(true,"', i, '"))'),
            "rqti_program_completed:false", paste0("batch(", q(program), ")"),
            'if rqti_program_completed#true then error("Maxima did not complete the program")',
            'if not stringp(rqti_program_result) then error("Maxima must return string([...])")',
            "rqti_pairs:parse_string(rqti_program_result)",
            'if not listp(rqti_pairs) then error("Maxima outputs must be an association list")',
            'rqti_values:[]')
        for (j in seq_along(block$outputs)) {
            output <- block$outputs[[j]]
            name <- output$name
            rules <- c(rules,
                paste0('rqti_matches:sublist(rqti_pairs,lambda([pair],if atom(pair) then false else if op(pair)#"=" then false else string(lhs(pair))=', q(name), '))'),
                paste0('if length(rqti_matches)#1 then error("Missing or duplicate output: ', name, '")'),
                "rqti_value:rhs(first(rqti_matches))")
            if (output$type == "integer") rules <- c(rules,
                paste0('if not integerp(rqti_value) then error("Output is not an integer: ', name, '")'))
            if (output$type != "string") rules <- c(rules, "rqti_value:float(rqti_value)",
                paste0('if not numberp(rqti_value) then error("Output is not a real number: ', name, '")'))
            rules <- c(rules, "rqti_values:endcons(rqti_value,rqti_values)")
        }
        # Validate before redirecting stdout, so errors retain their original
        # diagnostics rather than being written into an incomplete JSON file.
        serialization <- paste0('with_stdout(', q(result), ',printf(true,"{~a:~a,~a:{",',
            'rqti_json_string("result"),rqti_json_string(rqti_program_result),rqti_json_string("values"))')
        for (j in seq_along(block$outputs)) {
            output <- block$outputs[[j]]
            if (j > 1L) serialization <- c(serialization, 'printf(true,",")')
            stored <- paste0("rqti_values[", j, "]")
            value <- if (output$type == "string") {
                paste0("rqti_json_string(if stringp(", stored, ") then ", stored, " else string(", stored, "))")
            } else stored
            serialization <- c(serialization, paste0('printf(true,"~a:~a",rqti_json_string(', q(output$name), '),', value, ')'))
        }
        rules <- c(rules, serialization, 'printf(true,"}}"))')
    }
    helper <- system.file("maxima", "json.lisp", package = "rqti")
    libraries <- if (length(request$libraries)) {
        paste0("load(", vapply(request$libraries, q, character(1)), ")")
    } else character()
    driver <- file.path(work, "driver.mac")
    libraries_ready <- file.path(work, "libraries-ready.txt")
    if (!is.null(cache)) cache$ready_file <- libraries_ready
    library_marker <- paste0('with_stdout(', q(libraries_ready), ',printf(true,"ok"))')
    seed <- sum(as.integer(openssl::rand_bytes(4)) * 256^(0:3))
    seed_rule <- paste0("set_random_state(make_random_state(", format(seed, scientific = FALSE), "))")
    writeLines(c("display2d:false$", "loadprint:false$", paste0("load(", q(helper), ")$"),
        paste0("rqti_status:errcatch(", paste(c(libraries, library_marker, seed_rule, rules), collapse = ","), ")$"),
        paste0('if length(rqti_status)>0 then with_stdout(', q(completed), ',printf(true,"ok"))$'),
        "quit();"), driver)
    # Preview and knitting share compiled libraries, never variables or answers.
    userdir <- if (is.null(cache)) file.path(work, "user") else cache$path
    dir.create(userdir, recursive = TRUE, showWarnings = FALSE)
    userdir <- normalizePath(userdir, winslash = "/")
    stdout <- file.path(work, "stdout.txt")
    stderr <- file.path(work, "stderr.txt")
    process <- processx::process$new(executable,
        args = c("--very-quiet", paste0("--userdir=", userdir),
                 paste0("--batch-string=batchload(", q(driver), ")$")),
        stdin = NULL, stdout = stdout, stderr = stderr, cleanup_tree = TRUE)
    keep <- TRUE
    list(process = process, work = work, blocks = request$blocks, timeout = timeout,
         started = started, cache = cache)
}

maxima_preview_job_result <- function(job) {
    if (job$process$is_alive()) stop("Maxima job is still running.", call. = FALSE)
    if (identical(job$process$get_exit_status(), 0L) &&
        file.exists(file.path(job$work, "completed.txt"))) {
        return(lapply(seq_along(job$blocks), function(i) {
            jsonlite::fromJSON(file.path(job$work, paste0("result-", i, ".json")), simplifyVector = FALSE)
        }))
    }
    read <- function(name) {
        path <- file.path(job$work, name)
        if (file.exists(path)) readLines(path, warn = FALSE, encoding = "UTF-8") else character()
    }
    diagnostic <- c(read("stdout.txt"), read("stderr.txt"))
    diagnostic <- diagnostic[!grepl("^(;;; Loading|batchload\\(|read and interpret )", diagnostic)]
    diagnostic <- trimws(paste(diagnostic, collapse = "\n"))
    if (!nzchar(diagnostic)) diagnostic <- "Maxima did not complete the program."
    index <- suppressWarnings(as.integer(read("active.txt")))
    if (length(index) != 1L || is.na(index) || !index %in% seq_along(job$blocks)) index <- 1L
    block <- job$blocks[[index]]
    label <- if (is.character(block$identifier) && length(block$identifier) == 1L) block$identifier else as.character(index)
    source <- strsplit(block$code, "\n", fixed = TRUE)[[1L]]
    stop("Maxima template '", label, "' failed.\n\n", diagnostic,
         "\n\nSource:\n", paste0(sprintf("%3d", seq_along(source)), " | ", source, collapse = "\n"), call. = FALSE)
}

cleanup_maxima_preview_job <- function(job) {
    maxima_stop_process(job$process)
    release_maxima_cache(job$cache)
    unlink(job$work, recursive = TRUE)
}

maxima_preview_response <- function(status, value) {
    list(status = as.integer(status), headers = list(
        `Content-Type` = "application/json; charset=utf-8", `Cache-Control` = "no-store"),
        body = as.character(jsonlite::toJSON(value, auto_unbox = TRUE, digits = NA)))
}

make_maxima_preview_app <- function(qtijs_path, origin) {
    state <- new.env(parent = emptyenv())
    state$jobs <- list()
    state$next_id <- 0L
    state$stopped <- FALSE
    state$active <- NULL
    state$queue <- character()
    token <- paste(format(openssl::rand_bytes(32)), collapse = "")
    reply_error <- function(status, message) maxima_preview_response(status, list(error = message))
    call <- function(req) {
        path <- req$PATH_INFO
        if (identical(req$HTTP_SEC_FETCH_SITE, "cross-site") ||
            (!is.null(req$HTTP_ORIGIN) && !identical(req$HTTP_ORIGIN, origin))) {
            return(reply_error(403, "This API is available only to this local preview."))
        }
        if (path == "/.rqti-maxima/config" && req$REQUEST_METHOD == "GET") {
            return(maxima_preview_response(200, list(backend = "local",
                endpoint = "/.rqti-maxima/run", token = token)))
        }
        if (path != "/.rqti-maxima/run") return(reply_error(404, "Not found"))
        if (req$REQUEST_METHOD != "POST") return(reply_error(405, "Use POST"))
        if (!identical(req$HTTP_X_RQTI_MAXIMA, token)) return(reply_error(403, "Invalid preview token"))
        if (is.null(req$CONTENT_TYPE) || !grepl("^application/json($|;)", req$CONTENT_TYPE)) {
            return(reply_error(415, "Expected application/json"))
        }
        if (!is.null(req$CONTENT_LENGTH)) {
            size <- suppressWarnings(as.numeric(req$CONTENT_LENGTH))
            if (length(size) != 1L || is.na(size) || !is.finite(size) || size < 0) {
                return(reply_error(400, "Invalid request length."))
            }
            if (size > 1024 * 1024) {
                return(reply_error(413, "Maxima programs exceed the 1 MB preview limit."))
            }
        }
        request <- tryCatch({
            bytes <- req$rook.input$read(1024 * 1024 + 1L)
            if (length(bytes) > 1024 * 1024) stop("Maxima programs exceed the 1 MB preview limit.")
            request <- jsonlite::fromJSON(rawToChar(bytes), simplifyVector = FALSE)
            validate_maxima_preview_request(request)
        }, error = identity)
        if (inherits(request, "error")) return(reply_error(400, conditionMessage(request)))
        state$next_id <- state$next_id + 1L
        id <- as.character(state$next_id)
        state$queue <- c(state$queue, id)
        promises::promise(function(resolve, reject) {
            job <- NULL
            cache_wait_started <- NULL
            poll <- function() {
                finish <- function(response) {
                    if (!is.null(job)) cleanup_maxima_preview_job(job)
                    state$jobs[[id]] <- NULL
                    state$queue <- state$queue[state$queue != id]
                    if (identical(state$active, id)) state$active <- NULL
                    resolve(response)
                }
                tryCatch({
                    if (state$stopped) return(finish(reply_error(503, "Preview server stopped.")))
                    if (is.null(job)) {
                        if (!is.null(state$active) || !identical(state$queue[[1L]], id)) {
                            later::later(poll, delay = 0.05)
                            return(invisible(NULL))
                        }
                        if (is.null(cache_wait_started)) cache_wait_started <<- proc.time()[["elapsed"]]
                        limit <- getOption("rqti.maxima_timeout", 120)
                        if (proc.time()[["elapsed"]] - cache_wait_started >= limit) {
                            return(finish(reply_error(408, "Waiting for the Maxima library cache timed out.")))
                        }
                        created <- tryCatch(start_maxima_preview_job(request, cache_wait = FALSE), error = identity)
                        if (inherits(created, "error")) return(finish(reply_error(400, conditionMessage(created))))
                        if (is.null(created)) {
                            later::later(poll, delay = 0.05)
                            return(invisible(NULL))
                        }
                        job <<- created
                        state$active <- id
                        state$queue <- state$queue[-1L]
                        state$jobs[[id]] <- job
                    }
                    if (!job$process$is_alive()) {
                        result <- tryCatch(maxima_preview_job_result(job), error = identity)
                        if (inherits(result, "error")) return(finish(reply_error(422, conditionMessage(result))))
                        return(finish(maxima_preview_response(200, list(results = result))))
                    }
                    if (proc.time()[["elapsed"]] - job$started >= job$timeout) {
                        return(finish(reply_error(408, paste0("Maxima execution exceeded ", job$timeout, " seconds."))))
                    }
                    later::later(poll, delay = 0.05)
                }, error = function(e) finish(reply_error(500, conditionMessage(e))))
            }
            later::later(poll, delay = 0.01)
        })
    }
    stop <- function() {
        state$stopped <- TRUE
        for (job in state$jobs) cleanup_maxima_preview_job(job)
        state$jobs <- list()
    }
    list(app = list(staticPaths = list(
        "/" = httpuv::staticPath(qtijs_path, fallthrough = TRUE),
        "/.rqti-maxima" = httpuv::excludeStaticPath()), call = call), stop = stop)
}

start_maxima_local_server <- function(qtijs_path, daemon) {
    config <- servr::server_config(qtijs_path, host = "127.0.0.1", daemon = TRUE,
                                  browser = FALSE, verbose = FALSE)
    preview <- make_maxima_preview_app(qtijs_path, config$url)
    config$start_server(preview$app)
    maxima_local_preview_server$stop <- function() {
        preview$stop()
        config$stop_server()
    }
    if (!daemon) {
        message("Serving qti.js with local Maxima support at ", config$url)
        repeat { httpuv::service(); Sys.sleep(0.01) }
    }
    config$url
}
