#' Check a Maxima program locally
#'
#' Runs a program in a fresh Maxima process. Syntax or runtime failures stop
#' with the original diagnostic. This checks one execution of randomized code;
#' it does not prove every variant works on the target ONYX installation.
#' The ONYX statistics libraries `distrib`, `descriptive`, and `stats` are
#' loaded by default. Supply `libraries` to include others, such as `draw`.
#' No R interface package for Maxima is required.
#'
#' @section Compiled library cache:
#' Compiled libraries are shared with the local preview server across R sessions.
#' On R >= 4.0, the cache is stored under `tools::R_user_dir("rqti", "cache")`.
#' Set `options(rqti.maxima_cache_dir = "/path/to/cache")` to choose a directory,
#' or `options(rqti.maxima_cache_dir = FALSE)` for a session-only cache.
#' Earlier R versions use a session-only cache. Creation is lazy, when libraries
#' are needed. Each calculation still uses a fresh process and temporary programs
#' and results. Build-specific caches are protected by a cross-process lock;
#' preview jobs wait asynchronously. Old builds and caches unused for 30 days
#' are removed, and caches exceeding 64 MiB are discarded after use.
#' Interrupted library loading discards the incomplete cache.
#'
#' @param code A non-empty Maxima program.
#' @param executable Path to the Maxima command-line executable or Windows
#'   `.bat`/`.cmd` launcher, defaulting to option `rqti.maxima`, the choice
#'   inherited from [start_server()] in an RStudio Knit session, or PATH.
#'   Explicit paths may contain spaces and Unicode; do not add shell quotes.
#' @param timeout Maximum execution time in seconds. Defaults to option
#'   `rqti.maxima_timeout`, or 120 seconds (including library startup).
#' @param file,chunk Optional source filename and chunk label for diagnostics.
#' @param libraries Character vector of Maxima libraries to load first.
#' @param outputs If `TRUE`, inspect the program's final `string([...])` return
#'   value and return its named output types. Unsupported types are marked
#'   `"unsupported"`; [maxima_variables()] requires explicit declarations for them.
#' @return Invisibly, `TRUE` on success, or a named type vector if `outputs=TRUE`.
#' @export
maxima_check <- function(code, executable = maxima_default_executable(),
                         timeout = getOption("rqti.maxima_timeout", 120),
                         file = NULL, chunk = NULL,
                         libraries = c("distrib", "descriptive", "stats"),
                         outputs = FALSE) {
    context <- paste0(if (!is.null(file)) paste0(basename(file), ": ") else "",
                      if (!is.null(chunk)) paste0("Maxima chunk '", chunk, "'") else "Maxima program")
    fail <- function(diagnostic) {
        source <- strsplit(code, "\n", fixed = TRUE)[[1L]]
        numbered <- paste0(sprintf("%3d", seq_along(source)), " | ", source)
        stop(structure(list(message = paste0(context, " failed.\n\n",
             diagnostic, "\n\nSource:\n", paste(numbered, collapse = "\n")),
             call = NULL, file = file, chunk = chunk, code = code,
             diagnostic = diagnostic), class = c("rqti_maxima_error", "error", "condition")))
    }
    if (!is.character(code) || length(code) != 1L || is.na(code) || !nzchar(trimws(code))) {
        stop("code must be a single non-empty string.", call. = FALSE)
    }
    executable <- tryCatch(resolve_maxima_executable(executable),
                           error = function(e) fail(conditionMessage(e)))
    if (!is.numeric(timeout) || length(timeout) != 1L || is.na(timeout) ||
        !is.finite(timeout) || timeout <= 0) {
        stop("timeout must be a positive number of seconds.", call. = FALSE)
    }
    if (!is.character(libraries) || anyNA(libraries) || any(!nzchar(libraries))) {
        stop("libraries must be a character vector of library names.", call. = FALSE)
    }
    if (!is.logical(outputs) || length(outputs) != 1L || is.na(outputs)) {
        stop("outputs must be TRUE or FALSE.", call. = FALSE)
    }
    work <- tempfile("rqti-maxima-")
    dir.create(work)
    on.exit(unlink(work, recursive = TRUE), add = TRUE)
    work <- normalizePath(work, winslash = "/")
    program <- file.path(work, "program.mac")
    driver <- file.path(work, "driver.mac")
    completed <- file.path(work, "completed.txt")
    output_types <- file.path(work, "outputs.tsv")
    started <- proc.time()[["elapsed"]]
    cache <- NULL
    if (length(libraries)) {
        cache <- tryCatch(acquire_maxima_cache(maxima_cache_config(executable, timeout),
            max(0, timeout - (proc.time()[["elapsed"]] - started))),
            error = function(e) fail(conditionMessage(e)))
        on.exit(release_maxima_cache(cache), add = TRUE, after = FALSE)
    }
    userdir <- if (is.null(cache)) file.path(work, "user") else cache$path
    dir.create(userdir, showWarnings = FALSE)
    userdir <- normalizePath(userdir, winslash = "/")
    libraries_ready <- file.path(work, "libraries-ready.txt")
    if (!is.null(cache)) cache$ready_file <- libraries_ready
    quote_maxima <- function(x) {
        x <- gsub("\\", "\\\\", x, fixed = TRUE)
        paste0('"', gsub('"', '\\"', x, fixed = TRUE), '"')
    }
    # A final statement also detects unfinished input/comments that some
    # Maxima readers otherwise accept at end of file.
    writeLines(enc2utf8(c(code,
        if (outputs) "rqti_program_result:%$",
        "rqti_program_completed:true$")), program, useBytes = TRUE)
    # Let Maxima parse its own association-list representation. R receives only
    # names and type tags, not executable expressions or sample numeric values.
    detector <- c(
        "rqti_detect(result,path):=block([pairs,name,value,type],",
        "  if not stringp(result) then error(\"Maxima program must return string([...]) with named outputs.\"),",
        "  pairs:parse_string(result),",
        "  if not listp(pairs) or pairs=[] then error(\"Maxima output must be a nonempty association list.\"),",
        "  with_stdout(path, for pair in pairs do (",
        "    if atom(pair) then error(\"Maxima outputs must be named equations, e.g. 'answer = 3.\"),",
        "    if op(pair)#\"=\" then error(\"Maxima outputs must be named equations, e.g. 'answer = 3.\"),",
        "    name:string(lhs(pair)), value:rhs(pair),",
        "    type:if integerp(value) then \"integer\" else if stringp(value) then \"string\"",
        "         else if floatnump(float(value)) then \"float\" else \"unsupported\",",
        "    printf(true,\"~a\t~a~%\",name,type)))",
        ")$")
    writeLines(c(
        "display2d:false$", "loadprint:false$",
        if (outputs) detector,
        paste0("rqti_status:errcatch(",
               if (length(libraries)) paste0("load(", vapply(libraries, quote_maxima, character(1)), "),", collapse = "") else "",
               paste0("with_stdout(", quote_maxima(libraries_ready), ",printf(true,\"ok\")),"),
               if (outputs) "batch(" else "batchload(", quote_maxima(program), ")",
               if (outputs) paste0(",rqti_detect(rqti_program_result,", quote_maxima(output_types), ")"), ")$"),
        paste0("if length(rqti_status)=1 and rqti_program_completed=true then with_stdout(", quote_maxima(completed),
               ",printf(true,\"ok\"))$"),
        "quit();"), driver)
    # Use a relative wait rather than processx::run()'s process start timestamp.
    # On machines with a skewed boot/system clock that timestamp can lie in the
    # future, so run()'s timeout never expires. Files also prevent full output
    # pipes from blocking Maxima while we wait.
    stdout <- file.path(work, "stdout.txt")
    stderr <- file.path(work, "stderr.txt")
    process <- tryCatch(maxima_start_process(executable,
        args = c("--very-quiet", paste0("--userdir=", userdir),
                 paste0("--batch-string=batchload(", quote_maxima(driver), ")$")),
        stdin = NULL, stdout = stdout, stderr = stderr, cleanup_tree = TRUE),
        error = function(e) fail(conditionMessage(e)))
    on.exit(maxima_stop_process(process), add = TRUE, after = FALSE)
    # Wait in short intervals so even very large user timeouts cannot overflow
    # processx's integer millisecond argument.
    remaining <- max(0, timeout - (proc.time()[["elapsed"]] - started))
    if (!maxima_wait_process(process, remaining)) {
        maxima_stop_process(process)
        fail(paste0("Execution exceeded ", timeout, " seconds."))
    }
    result <- list(status = process$get_exit_status(),
        stdout = paste(readLines(stdout, warn = FALSE), collapse = "\n"),
        stderr = paste(readLines(stderr, warn = FALSE), collapse = "\n"))
    if (result$status != 0L || !file.exists(completed) ||
        !identical(readLines(completed, warn = FALSE), "ok")) {
        # Batch echoes the driver invocation; remove it while retaining original
        # parser/runtime messages, their carets, and any program output.
        lines <- strsplit(paste(result$stdout, result$stderr, sep = "\n"), "\n", fixed = TRUE)[[1L]]
        lines <- lines[!grepl("^(;;; Loading|batchload\\()", lines)]
        diagnostic <- trimws(paste(lines, collapse = "\n"))
        if (!nzchar(diagnostic)) diagnostic <- paste("Maxima did not complete the program; exit status", result$status)
        fail(diagnostic)
    }
    if (outputs) {
        if (!file.exists(output_types)) fail("Maxima did not return output metadata.")
        rows <- strsplit(readLines(output_types, warn = FALSE), "\t", fixed = TRUE)
        if (!length(rows) || any(lengths(rows) != 2L)) {
            fail("Maxima output metadata must contain named outputs and types.")
        }
        names <- vapply(rows, `[`, character(1), 1L)
        types <- vapply(rows, `[`, character(1), 2L)
        if (anyDuplicated(names) || any(!grepl("^[A-Za-z][A-Za-z0-9_]*$", names))) {
            fail("Maxima output names must be unique ASCII identifiers starting with a letter.")
        }
        return(setNames(types, names))
    }
    invisible(TRUE)
}

resolve_maxima_types <- function(observed, variables = NULL) {
    if (is.null(variables)) {
        unknown <- names(observed)[observed == "unsupported"]
        if (length(unknown)) {
            stop("Cannot infer QTI types for Maxima outputs: ", paste(unknown, collapse = ", "),
                 ". Supply explicit variables types, or return numeric/string values.", call. = FALSE)
        }
        return(observed)
    }
    # Reuse the existing declaration validation, including identifier/type rules.
    validation_id <- "rqti_type_check"
    while (validation_id %in% names(variables)) validation_id <- paste0(validation_id, "_")
    new("MaximaVariables", code = "1;", variables = variables, identifier = validation_id)
    missing <- setdiff(names(variables), names(observed))
    if (length(missing)) {
        stop("Declared Maxima outputs are missing from the return value: ", paste(missing, collapse = ", "), call. = FALSE)
    }
    wrong <- names(variables)[vapply(names(variables), function(name) {
        type <- variables[[name]]
        actual <- observed[[name]]
        if (type == "string") return(FALSE) # ONYX can display lists/symbolic values as strings.
        if (type == "float") return(!actual %in% c("integer", "float"))
        actual != "integer"
    }, logical(1))]
    if (length(wrong)) {
        stop("Maxima output types disagree with their declarations: ", paste(wrong, collapse = ", "), call. = FALSE)
    }
    variables
}

# Only installed for the duration of one rqti conversion. No global template
# collector or persistent Maxima session is shared between documents.
setup_maxima_knitting <- function(file, collector) {
    collector$references <- list()
    reference_prefix <- paste0("RQTIMAXIMA", gsub("[^A-Za-z0-9]", "", basename(tempfile())), "REF")
    old_engines <- knitr::knit_engines$get()
    old_hooks <- knitr::knit_hooks$get()
    old_option_hooks <- knitr::opts_hooks$get()
    # Installing a custom inline hook before knit() otherwise prevents knitr
    # from initializing its default Markdown hooks (including image output).
    if (identical(old_hooks, knitr::knit_hooks$get(default = TRUE))) {
        knitr::render_markdown()
    }
    previous_cache_hook <- old_option_hooks$cache
    knitr::opts_hooks$set(cache = function(options) {
        if (is.function(previous_cache_hook)) options <- previous_cache_hook(options)
        if (identical(options$engine, "maxima") &&
            (isTRUE(options$cache > 0) || !isTRUE(options$eval))) {
            stop("Maxima template chunks must use eval=TRUE and cache=FALSE so local checks always run.", call. = FALSE)
        }
        options
    })
    knitr::knit_engines$set(maxima = function(options) {
        if (length(collector$blocks)) {
            stop("Only one Maxima chunk is supported per Rmd exercise. Combine the calculations into one chunk returning all named outputs.", call. = FALSE)
        }
        if (isTRUE(options$cache > 0) || !isTRUE(options$eval)) {
            stop("Maxima template chunks must use eval=TRUE and cache=FALSE so local checks always run.", call. = FALSE)
        }
        identifier <- options$maxima_identifier
        if (is.null(identifier)) identifier <- paste0("maxima_", options$label)
        code <- paste(options$code, collapse = "\n")
        observed <- maxima_check(code, file = file, chunk = options$label, outputs = TRUE)
        types <- resolve_maxima_types(observed, options$variables)
        block <- maxima_variables(code, types, identifier)
        collector$blocks <- c(collector$blocks, list(block))
        ""
    })
    previous_inline <- old_hooks$evaluate.inline
    knitr::knit_hooks$set(evaluate.inline = function(code, envir) {
        value <- previous_inline(code, envir)
        if (is(value, "TemplateVariableRef")) {
            validObject(value)
            # HTML is escaped inside Pandoc math. An alphanumeric placeholder
            # survives both Markdown and TeX, including dollar-delimited math.
            marker <- paste0(reference_prefix, length(collector$references) + 1L, "END")
            collector$references[[marker]] <- value
            return(knitr::asis_output(marker))
        }
        value
    })
    function() {
        knitr::knit_engines$restore(old_engines)
        knitr::knit_hooks$restore(old_hooks)
        knitr::opts_hooks$restore(old_option_hooks)
    }
}

restore_maxima_references <- function(content, references) {
    if (!length(references)) return(content)
    pattern <- paste(names(references), collapse = "|")
    result <- list()
    used <- character()
    for (part in content) {
        if (!is.character(part)) {
            result <- c(result, list(part))
            next
        }
        matches <- gregexpr(pattern, part)[[1L]]
        if (matches[1L] < 0L) {
            result <- c(result, list(part))
            next
        }
        cursor <- 1L
        for (j in seq_along(matches)) {
            start <- matches[j]
            size <- attr(matches, "match.length")[j]
            if (start > cursor) result <- c(result, list(substr(part, cursor, start - 1L)))
            marker <- substr(part, start, start + size - 1L)
            used <- c(used, marker)
            result <- c(result, list("<span>", references[[marker]], "</span>"))
            cursor <- start + size
        }
        if (cursor <= nchar(part)) result <- c(result, list(substr(part, cursor, nchar(part))))
    }
    if (length(setdiff(names(references), used))) {
        stop("Maxima values must appear in question body content; references in choices are not yet supported.", call. = FALSE)
    }
    result
}
