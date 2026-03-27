#' Validate an XML document against the QTI schema
#'
#' Validates an XML document against the QTI schema or the extended rqti QTI
#' schema. Input can be either a file path, a character string containing XML,
#' or an `xml2::xml_document`.
#'
#' By default, the function chooses a validation backend automatically. If
#' `xmllint` is available, the input is a file path, and the platform is not
#' Windows, the `xmllint` backend is used. Otherwise, validation falls back to
#' `xml2`.
#'
#' The function returns an object of class `"qti_validation_result"`. By
#' default, that object is also printed in a human-readable form.
#'
#' @param doc A QTI XML document. This can be a file path, a character string
#'   containing XML, or an `xml2::xml_document`.
#' @param extended_schema Logical. Should the extended rqti schema be used?
#'   Defaults to `FALSE`.
#' @param ctx Integer. Number of characters of context shown before and after
#'   the offending XML element in printed snippets. Defaults to `40`.
#' @param color Logical. Should ANSI colors be used in printed output? Defaults
#'   to `TRUE`.
#' @param engine Character string specifying the validation backend. One of
#'   `"auto"`, `"xml2"`, or `"xmllint"`. Defaults to `"auto"`.
#' @param ignore_import Logical. If `TRUE`, warnings related to `<import>`
#'   statements in the schema are ignored. Default is `TRUE` because rqti uses a
#'   locally saved schema instead of downloading from the internet.
#' @param print Logical. Should the validation result be printed before it is
#'   returned? Defaults to `TRUE`.
#'
#' @return An object of class `"qti_validation_result"` with components:
#'   \describe{
#'     \item{valid}{Logical scalar.}
#'     \item{errors}{A list of parsed validation errors.}
#'     \item{engine}{The backend used for validation.}
#'   }
#'
#' @examples
#' \dontrun{
#' f <- system.file("exercises", "sc1d.xml", package = "rqti")
#'
#' res <- verify_qti(f)
#' res$valid
#'
#' x <- xml2::read_xml(f)
#' res2 <- verify_qti(x)
#'
#' summary(res2)
#' }
#'
verify_qti_impl <- function(doc,
                            extended_schema = FALSE,
                            ctx = 40,
                            color = TRUE,
                            engine = c("auto", "xml2", "xmllint"),
                            ignore_import = TRUE,
                            print = TRUE) {
    engine <- match.arg(engine)

    # Handle non-file inputs for potential xmllint use
    if (!is.character(doc) || !file.exists(doc)) {
        # Check if xmllint might be used
        will_use_xmllint <- (
            (engine == "xmllint") ||
                (engine == "auto" && .Platform$OS.type != "windows" && nzchar(Sys.which("xmllint")))
        )

        if (will_use_xmllint) {
            # Write XML document to temporary file for xmllint
            tmp_file <- tempfile(fileext = ".xml")
            # doc is a character string, write directly
            writeLines(doc, tmp_file, useBytes = TRUE)

            doc <- tmp_file  # Assign to doc so it's treated as a path
            on.exit(unlink(tmp_file), add = TRUE)
        }
    }

    # read XML / path handling
    doc_is_path <- is.character(doc) && length(doc) == 1 && file.exists(doc)

    if (doc_is_path) {
        file_in <- normalizePath(doc, mustWork = TRUE)
        xml_lines <- readLines(file_in, warn = FALSE, encoding = "UTF-8")
    } else {
        file_in <- "<xml_document>"
        xml_doc_tmp <- if (inherits(doc, "xml_document")) doc else xml2::read_xml(doc)
        xml_txt <- as.character(xml_doc_tmp)
        xml_lines <- strsplit(xml_txt, "\n", fixed = TRUE)[[1]]
    }

    # schema
    schema_name <- if (extended_schema) "qti_v2p1p2_extension.xsd" else "imsqti_v2p1p2.xsd"
    schema_file <- file.path(system.file(package = "rqti"), schema_name)

    if (!nzchar(schema_file) || !file.exists(schema_file)) {
        stop("Could not find schema file: ", schema_name)
    }

    # colors
    red <- if (isTRUE(color)) "\033[31m" else ""
    blue <- if (isTRUE(color)) "\033[34m" else ""
    reset <- if (isTRUE(color)) "\033[0m" else ""



    # choose engine ---------------------------------------------------------

    xmllint_available <- nzchar(Sys.which("xmllint"))
    if (engine == "auto") {
        engine <- if (.Platform$OS.type != "windows" && xmllint_available && doc_is_path) {
            "xmllint"
        } else {
            "xml2"
        }
    }

    # xmllint backend -------------------------------------------------------

    if (engine == "xmllint") {
        if (.Platform$OS.type == "windows") {
            warning("`xmllint` backend requested on Windows; falling back to `xml2`.")
            engine <- "xml2"
        } else if (!xmllint_available) {
            warning("`xmllint` not found; falling back to `xml2`.")
            engine <- "xml2"
        } else {
            out <- suppressWarnings(system2(
                "xmllint",
                args = c("--noout", "--schema", schema_file, file_in),
                stdout = TRUE,
                stderr = TRUE
            ))

            status <- attr(out, "status")
            has_schema_errors <- any(grepl("Schemas validity error", out, fixed = TRUE))

            if ((is.null(status) || identical(status, 0L)) && !has_schema_errors) {
                res <- make_result(
                    valid = TRUE,
                    errors = list(),
                    engine = "xmllint",
                    color = color
                )
                if (isTRUE(print)) print(res)
                return(invisible(res))
            }

            err_lines <- out[grepl("Schemas validity error", out, fixed = TRUE)]

            if (!length(err_lines)) {
                parsed <- list(list(
                    file = file_in,
                    line = NA_integer_,
                    element = NA_character_,
                    message = paste(out, collapse = " "),
                    allowed = character(0),
                    snippet = NA_character_,
                    raw_message = out
                ))
            } else {
                parsed <- parse_errors(
                    raw_errors = err_lines,
                    xml_lines = xml_lines,
                    file_in = file_in,
                    ctx = ctx,
                    red = red,
                    reset = reset
                )
            }

            if (ignore_import) {
                parsed <- Filter(
                    function(x) !(isTRUE(x$element == "{http://www.w3.org/2001/XMLSchema}import")),
                    parsed
                )
            }

            res <- make_result(
                valid = !length(parsed),
                errors = parsed,
                engine = "xmllint",
                color = color
            )

            if (isTRUE(print)) print(res)
            return(invisible(res))
        }
    }

    # xml2 backend ----------------------------------------------------------

    if (doc_is_path) {
        xml_doc <- xml2::read_xml(file_in)
    } else {
        xml_doc <- if (inherits(doc, "xml_document")) doc else xml2::read_xml(doc)
    }

    schema <- xml2::read_xml(schema_file)
    validation <- xml2::xml_validate(xml_doc, schema)

    if (isTRUE(validation)) {
        res <- make_result(
            valid = TRUE,
            errors = list(),
            engine = "xml2",
            color = color
        )
        if (isTRUE(print)) print(res)
        return(invisible(res))
    }

    raw_errors <- attr(validation, "errors")
    if (is.null(raw_errors)) {
        raw_errors <- as.character(validation)
    }
    raw_errors <- as.character(raw_errors)

    parsed <- parse_errors(
        raw_errors = raw_errors,
        xml_lines = xml_lines,
        file_in = file_in,
        ctx = ctx,
        red = red,
        reset = reset
    )

    if (ignore_import) {
        parsed <- Filter(
            function(x) !(isTRUE(x$element == "{http://www.w3.org/2001/XMLSchema}import")),
            parsed
        )
    }

    res <- make_result(
        valid = !length(parsed),
        errors = parsed,
        engine = "xml2",
        color = color
    )

    if (isTRUE(print)) print(res)
    invisible(res)
}


#' Print a QTI validation result
#'
#' @param x A `qti_validation_result` object.
#' @param ... Unused.
#'
#' @return The input object, invisibly.
#' @export
#' @method print qti_validation_result
print.qti_validation_result <- function(x, ...) {
    stopifnot(inherits(x, "qti_validation_result"))

    blue <- if (isTRUE(x$color)) "\033[34m" else ""
    reset <- if (isTRUE(x$color)) "\033[0m" else ""

    if (isTRUE(x$valid)) {
        cat("QTI validation: valid")
        if (!is.null(x$engine) && nzchar(x$engine)) {
            cat(" [engine: ", x$engine, "]", sep = "")
        }
        cat("\n")
        return(invisible(x))
    }

    cat("QTI validation: invalid")
    if (!is.null(x$engine) && nzchar(x$engine)) {
        cat(" [engine: ", x$engine, "]", sep = "")
    }
    cat("\n\n")

    for (err in x$errors) {
        loc <- if (!is.na(err$line)) paste0(err$file, ":", err$line) else err$file
        cat(loc, ": ", err$message, "\n", sep = "")

        if (!is.na(err$snippet) && nzchar(err$snippet)) {
            cat("  -> ", err$snippet, "\n", sep = "")
        }

        if (length(err$allowed)) {
            cat("  ", blue, "Allowed tags: ", reset, paste(err$allowed, collapse = ", "), "\n", sep = "")
        }

        cat("\n")
    }

    invisible(x)
}

#' Validate QTI XML
#'
#' S4 generic for validating QTI documents in various formats.
#'
#' @param doc A QTI document (file path, character string, xml_document, or S4 object)
#' @param extended_schema Logical. Use extended rqti schema?
#' @param ctx Integer. Context characters for error snippets.
#' @param color Logical. Use ANSI colors?
#' @param engine Character. Validation backend ("auto", "xml2", "xmllint").
#' @param ignore_import Logical. Ignore import warnings?
#' @param print Logical. Print results?
#'
#' @return A `qti_validation_result` or `qti_validation_results_list` object.
#' @export
setGeneric("verify_qti", function(doc, extended_schema = FALSE, ctx = 40, color = TRUE,
                                  engine = c("auto", "xml2", "xmllint"),
                                  ignore_import = TRUE, print = TRUE) {
    standardGeneric("verify_qti")
})

#' @describeIn verify_qti Validate character input (file path or XML string)
setMethod("verify_qti", signature(doc = "character"),
          function(doc, extended_schema = FALSE, ctx = 40, color = TRUE,
                   engine = c("auto", "xml2", "xmllint"),
                   ignore_import = TRUE, print = TRUE) {
              engine <- match.arg(engine)

              # Check if it's a file path
              if (file.exists(doc)) {
                  # Check if it's an Rmd file
                  if (grepl("\\.Rmd$", doc, ignore.case = TRUE)) {
                      # Create temp XML file
                      tmp_xml <- tempfile(fileext = ".xml")
                      on.exit(unlink(tmp_xml))

                      # Render Rmd to XML
                      tryCatch({
                          rmd2xml(doc, tmp_xml)

                          # Verify the resulting XML
                          verify_qti_impl(tmp_xml, extended_schema, ctx, color, engine, ignore_import, print)

                      }, error = function(e) {
                          stop("Failed to render Rmd file: ", doc, "\nError: ", e$message)
                      })

                  } else {
                      # Handle XML or other file paths
                      verify_qti_impl(doc, extended_schema, ctx, color, engine, ignore_import, print)
                  }

              } else {
                  # Not a file path, treat as XML string content
                  # First validate that it looks like XML
                  doc_trimmed <- trimws(doc)
                  if (!grepl("^<", doc_trimmed)) {
                      stop("Input is not a valid file path or XML string (must start with '<')")
                  }

                  verify_qti_impl(doc, extended_schema, ctx, color, engine, ignore_import, print)
              }
          }
)

#' @describeIn verify_qti Validate xml_document objects
setMethod("verify_qti", signature(doc = "xml_document"),
          function(doc, extended_schema = FALSE, ctx = 40, color = TRUE,
                   engine = c("auto", "xml2", "xmllint"),
                   ignore_import = TRUE, print = TRUE) {
              # Handle xml_document - convert to character
              verify_qti_impl(as.character(doc), extended_schema, ctx, color, engine, ignore_import, print)
          }
)

#' @describeIn verify_qti Validate assessmentItem objects
setMethod("verify_qti", signature(doc = "AssessmentItem"),
          function(doc, extended_schema = FALSE, ctx = 40, color = TRUE,
                   engine = c("auto", "xml2", "xmllint"),
                   ignore_import = TRUE, print = TRUE) {
              engine <- match.arg(engine)
              tmp_file <- tempfile(fileext = ".xml")
              on.exit(unlink(tmp_file))

              createQtiTask(doc, tmp_file)
              verify_qti(tmp_file, extended_schema, ctx, color, engine, ignore_import, print)
          }
)

#' @describeIn verify_qti Validate assessmentTest objects
setMethod("verify_qti", signature(doc = "AssessmentTest"),
          function(doc, extended_schema = FALSE, ctx = 40, color = TRUE,
                   engine = c("auto", "xml2", "xmllint"),
                   ignore_import = TRUE, print = TRUE) {
              engine <- match.arg(engine)
              tmp_dir <- tempfile(pattern = "test_")
              dir.create(tmp_dir)
              on.exit(unlink(tmp_dir, recursive = TRUE))

              createQtiTest(doc, tmp_dir)
              xml_files <- list.files(tmp_dir, pattern = "\\.xml$", full.names = TRUE, recursive = TRUE)
              xml_files <- xml_files[!grepl("manifest\\.xml$", xml_files, ignore.case = TRUE)]

              results <- lapply(xml_files, function(f) {
                  verify_qti(f, extended_schema, ctx, color, engine, ignore_import, print = FALSE)
              })

              names(results) <- basename(xml_files)

              if (isTRUE(print)) {
                  cat("QTI Validation Results - Assessment Test\n")
                  cat("Files:", length(results), "\n")
                  cat("Valid:", sum(sapply(results, function(x) isTRUE(x$valid))), "\n\n")
                  for (i in seq_along(results)) {
                      cat("===", names(results)[i], "===\n")
                      print(results[[i]])
                      cat("\n")
                  }
              }

              invisible(structure(results, class = c("qti_validation_results_list", "list")))
          }
)

#' Print validation results list
#' @keywords internal
print.qti_validation_results_list <- function(x, ...) {
    invisible(x)
}

extract_attribute <- function(msg) {
    m <- regexec("attribute '([^']+)'", msg, perl = TRUE)
    r <- regmatches(msg, m)[[1]]
    if (length(r) >= 2) {
        attr <- r[2]
        # Strip namespace prefix if present
        attr <- sub(".*}", "", attr)
        attr
    } else {
        NA_character_
    }
}

# helpers ---------------------------------------------------------------

extract_line <- function(msg) {
    pats <- c(
        ":(\\d+):",
        "^[^:]+:(\\d+):",
        "^(\\d+):"
    )

    for (p in pats) {
        m <- regexec(p, msg, perl = TRUE)
        r <- regmatches(msg, m)[[1]]
        if (length(r) >= 2) {
            return(as.integer(r[2]))
        }
    }

    NA_integer_
}

extract_element <- function(msg) {
    m <- regexec("Element '([^']+)'", msg, perl = TRUE)
    r <- regmatches(msg, m)[[1]]
    if (length(r) >= 2) {
        elem <- r[2]
        # Strip namespace prefix if present
        elem <- sub(".*}", "", elem)  # Removes everything up to and including the last }
        elem
    } else {
        NA_character_
    }
}

extract_allowed <- function(msg) {
    allowed <- character(0)

    m1 <- regexec("Expected is one of \\(([^)]*)\\)", msg, perl = TRUE)
    r1 <- regmatches(msg, m1)[[1]]
    if (length(r1) >= 2) {
        allowed <- trimws(strsplit(r1[2], ",", fixed = TRUE)[[1]])
    }

    allowed <- gsub("^.*:", "", allowed)
    allowed <- trimws(allowed)
    allowed[nzchar(allowed)]
}

clean_message <- function(msg) {
    msg <- gsub("\\{[^}]+\\}", "", msg)
    msg <- sub(".*Schemas validity error ?: ?", "", msg)
    msg <- sub("This element is not expected\\.", "not expected.", msg)
    msg <- sub("\\s*Expected is one of \\([^)]*\\)\\.?", "", msg)
    msg <- sub("\\s*Expected is \\([^)]*\\)\\.?", "", msg)
    msg <- sub("\\s*Expected:.*$", "", msg)
    trimws(msg)
}

make_snippet <- function(xml_lines, line, elem, attr, ctx, red, reset) {
    snippet <- NA_character_

    if (!is.na(line) && line >= 1 && line <= length(xml_lines)) {
        line_text <- xml_lines[line]

        # Determine what to search for: attribute or element
        search_target <- if (!is.na(attr) && nzchar(attr)) attr else elem

        if (!is.na(search_target) && nzchar(search_target)) {
            # Search for the target in the line
            pos <- regexpr(search_target, line_text, fixed = TRUE)[1]

            if (pos > 0) {
                start <- max(1, pos - ctx)
                end <- min(nchar(line_text), pos + nchar(search_target) + ctx + 10)
                snippet <- substr(line_text, start, end)
            } else {
                snippet <- substr(line_text, 1, min(nchar(line_text), 2 * ctx + 40))
            }

            # Highlight the target with red
            if (!is.na(snippet) && nzchar(snippet)) {
                # For attributes, we want to highlight just the attribute name
                # Pattern: attributeName= or attributeName =
                if (!is.na(attr) && nzchar(attr)) {
                    attr_pattern <- paste0(attr, "\\s*=")
                    snippet <- gsub(
                        attr_pattern,
                        paste0(red, attr, reset, "="),
                        snippet,
                        perl = TRUE
                    )
                } else if (!is.na(elem) && nzchar(elem)) {
                    # For elements, highlight the tag name
                    tag_pattern <- paste0("<", elem, "(\\s|/|>)")
                    snippet <- gsub(
                        tag_pattern,
                        paste0(red, "<", elem, reset, "\\1"),
                        snippet,
                        perl = TRUE
                    )
                }
            }
        } else {
            snippet <- substr(line_text, 1, min(nchar(line_text), 2 * ctx + 40))
        }
    }

    snippet
}

make_result <- function(valid, errors, engine, color) {
    structure(
        list(
            valid = valid,
            errors = errors,
            engine = engine,
            color = isTRUE(color)
        ),
        class = "qti_validation_result"
    )
}

parse_errors <- function(raw_errors, xml_lines, file_in, ctx, red, reset) {
    lapply(raw_errors, function(msg) {
        line <- extract_line(msg)
        elem <- extract_element(msg)
        attr <- extract_attribute(msg)  # Add this
        allowed <- extract_allowed(gsub("\\{[^}]+\\}", "", msg))
        message <- clean_message(msg)
        snippet <- make_snippet(xml_lines, line, elem, attr, ctx, red, reset)

        list(
            file = file_in,
            line = line,
            element = elem,
            attribute = attr,  # Add this
            message = message,
            allowed = allowed,
            snippet = snippet,
            raw_message = msg
        )
    })
}
