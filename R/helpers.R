#' Create YAML string for TextGap object
#'
#' @param solution A character vector containing values considered as correct
#'   answers.
#' @param tolerance An integer value, optional; defines the number of characters
#'   to tolerate spelling mistakes in evaluating candidate answers.
#' @param case_sensitive A boolean, optional; determines whether the evaluation
#'   of the correct answer is case sensitive. Default is `FALSE`.
#' @param points A numeric value, optional; the number of points for this gap.
#'   Default is 1.
#' @param response_identifier A character string (optional) representing an
#'   identifier for the answer.
#' @param expected_length An integer value, optional; sets the size of the text
#'   input field in the content delivery engine.
#' @param placeholder A character string, optional; places helpful text in the
#'   text input field in the content delivery engine.
#' @return A character string mapped as yaml.
#' @examples
#' gap_text(c("Solution", "Solutions"), tolerance = 2)
#'
#' @seealso [gap_numeric()], [dropdown()], [mdlist()]
#' @export
gap_text <- function(solution, tolerance = NULL, case_sensitive = FALSE,
                     points = 1, response_identifier = NULL,
                     expected_length = size_gap(solution), placeholder = NULL) {

    params <- as.list(environment())
    params <- Filter(Negate(is.null), params)
    # define gap-type
    type <- ifelse(is.null(tolerance), "text", "text_opal")
    result <- clean_yaml_str(params, params$solution, type)
    return(result)
}

#' Create YAML string for NumericGap object
#'
#' @param solution A numeric value; contains right answer for this numeric
#'   entry.
#' @param tolerance A numeric value, optional; specifies the value for up and
#'   low boundaries of tolerance rate for candidate answer. Default is 0.
#' @param tolerance_type A character string, optional; specifies tolerance mode;
#'   possible values:"exact", "absolute" (by default), "relative".
#' @param points A numeric value, optional; the number of points for this gap.
#'   Default is 1.
#' @param response_identifier A character string, optional; an identifier for
#'   the answer.
#' @param include_lower_bound A boolean, optional; specifies whether or not the
#'   lower bound is included in tolerance rate.
#' @param include_upper_bound A boolean, optional; specifies whether or not the
#'   upper bound is included in tolerance rate.
#' @param expected_length An integer value, optional; is responsible to set a
#'   size of text input field in content delivery engine.
#' @param placeholder A character string, optional; is responsible to place some
#'   helpful text in text input field in content delivery engine.
#' @return A character string mapped as yaml.
#' @examples
#' gap_numeric(5.0, tolerance = 10, tolerance_type = "relative")
#'
#' @seealso [gap_text()], [dropdown()], [mdlist()]
#' @export
gap_numeric <- function(solution, tolerance = 0, tolerance_type = "absolute",
                        points = 1, response_identifier = NULL,
                        include_lower_bound = TRUE, include_upper_bound = TRUE,
                        expected_length = size_gap(solution),
                        placeholder = NULL) {

    params <- as.list(environment())
    params <- Filter(Negate(is.null), params)
    result <- clean_yaml_str(params, params$solution, "numeric")
    return(result)
}

#' Create YAML string for InlineChoice object (dropdown list)
#'
#' @param choices A numeric or character vector; contains values of possible
#'   answers. If you use a named vector, the names will be used as identifiers.
#' @param solution_index An integer value, optional; the number of right answer
#'   in the `choices` vector. Default is `1`.
#' @param points A numeric value, optional; the number of points for this gap.
#'   Default is `1`.
#' @param shuffle A boolean, optional; is responsible to randomize the order in
#'   which the choices are initially presented to the candidate. Default is
#'   `TRUE`.
#' @param response_identifier A character string, optional; an identifier for
#'   the answer.
#' @return A character string mapped as yaml.
#' @seealso [gap_text()], [gap_numeric()], [mdlist()]
#' @examples
#' dropdown(c("Option A", "Option B"), response_identifier = "task_dd_list")
#'
#' @export
dropdown <- function(choices, solution_index = 1, points = 1, shuffle = TRUE,
                     response_identifier = NULL) {

    params <- as.list(environment())
    params <- Filter(Negate(is.null), params)
    ids <- names(choices)
    if (!is.null(ids)) params$choices_identifiers <- ids
    result <- clean_yaml_str(params, params$choices, "InlineChoice")
    return(result)
}

clean_yaml_str <- function(params, solution, type){
    x <- c(params, list(type = type))

    fmt_value <- function(v) {
        if (length(v) > 1) {
            v <- as.character(v)
            v <- gsub("'", "", v, fixed = TRUE)
            v <- trimws(v)
            return(paste0("[", paste(v, collapse = ","), "]"))
        }

        if (is.logical(v)) {
            return(ifelse(isTRUE(v), "yes", "no"))
        }

        if (is.numeric(v)) {
            return(as.character(v))
        }

        v <- as.character(v)
        v <- gsub("\r|\n", " ", v)
        v <- gsub("\\s+", " ", v)
        v <- gsub("'", "", v, fixed = TRUE)
        trimws(v)
    }
    parts <- mapply(
        FUN = function(k, v) paste0(k, ": ", fmt_value(v)),
        k = names(x),
        v = x,
        SIMPLIFY = TRUE,
        USE.NAMES = FALSE
    )
    return(paste0("<gap>{", paste(parts, collapse = ", "), "}</gap>"))
}


#' Create a markdown list for answer options
#'
#' @param vect A string or numeric vector of answer options for single/multiple
#'   choice task.
#' @param solutions An integer value, optional; indexes of right answer options
#'   in `vect`.
#' @param gaps numeric or string vector, optional; provides primitive
#'  gap description if there is a need to build a list of gaps.
#' @return A markdown list.
#' @seealso [gap_text()], [gap_numeric()], [dropdown()]
#' @examples
#' #list for multiple choice task
#' mdlist(c("A", "B", "C"), c(2, 3))
#' # it returns:
#' #- A
#' #- *B*
#' #- *C*
#' #list of gaps
#' mdlist(c("A", "B", "C"), c(2, 3), c(1, 2, 3))
#' # it returns:
#' #- A <gap>1</gap>
#' #- *B* <gap>2</gap>
#' #- *C* <gap>3</gap>
#' @export
mdlist <- function(vect, solutions = NULL, gaps = NULL) {

    if (!is.null(solutions)) {
        for (s in solutions) vect[s] <- paste0("*", vect[s], "*")
    }

    if (!is.null(gaps)) {
        if (length(vect) != length(gaps)) {
            stop("Number of Gaps must be equal to number of list items",
                 call. = FALSE)
        }
        gaps <- paste0(" <gap>", gaps, "</gap>")
    }

    md_list <- paste0("- ", vect, gaps, collapse = "\n")
    return(md_list)
}


#' Embed a local file as a downloadable hyperlink in R Markdown
#'
#' Designed for inline use in R Markdown, e.g.
#' `` `r provide_file("attachment.pdf")` ``.
#'
#' The function reads a local file, encodes it as Base64, and returns an
#' HTML anchor tag with a data: URI. This allows the file to be embedded
#' directly into the rendered output instead of being referenced externally.
#'
#' @param path Path to the local file.
#' @param label Text shown to the user. Defaults to the file name.
#' @param mime MIME type. If NULL, it is guessed from the extension.
#' @param download Logical. If TRUE, adds the HTML download attribute.
#' @param warn_size_mb Warn if file is larger than this many MB.
#' @importFrom base64enc base64encode
#' @return knitr_asis object with an HTML hyperlink.
#' @export
provide_file <- function(path,
                         label = basename(path),
                         mime = NULL,
                         download = TRUE,
                         warn_size_mb = 5) {
    if (!is.character(path) || length(path) != 1 || !nzchar(path)) {
        stop("`path` must be a non-empty character string.", call. = FALSE)
    }

    if (!file.exists(path)) {
        stop("File does not exist: ", path, call. = FALSE)
    }

    size <- file.info(path)$size

    if (!is.null(warn_size_mb)) {
        size_mb <- size / 1024^2
        if (is.finite(size_mb) && size_mb > warn_size_mb) {
            warning(
                sprintf(
                    "File '%s' is %.2f MB. Embedding it will increase the size of the generated XML/HTML.",
                    basename(path), size_mb
                ),
                call. = FALSE
            )
        }
    }

    if (is.null(mime)) {
        mime <- guess_mime_type(path)
    }

    raw  <- readBin(path, "raw", size)
    encoded <- base64enc::base64encode(raw)
    href <- paste0("data:", mime, ";base64,", encoded)

    html <- paste0(
        '<a href="', html_escape(href), '"',
        if (isTRUE(download)) {
            paste0(' download="', html_escape(basename(path)), '"')
        } else {
            ""
        },
        '>',
        html_escape(label),
        '</a>'
    )

    knitr::asis_output(html)
}

guess_mime_type <- function(path) {
    ext <- tolower(tools::file_ext(path))

    types <- c(
        pdf  = "application/pdf",
        txt  = "text/plain",
        csv  = "text/csv",
        tsv  = "text/tab-separated-values",
        html = "text/html",
        htm  = "text/html",
        xml  = "application/xml",
        json = "application/json",
        zip  = "application/zip",
        r    = "text/plain",
        rmd  = "text/markdown",
        md   = "text/markdown",
        png  = "image/png",
        jpg  = "image/jpeg",
        jpeg = "image/jpeg",
        gif  = "image/gif",
        svg  = "image/svg+xml",
        mp3  = "audio/mpeg",
        mp4  = "video/mp4"
    )

    if (ext %in% names(types)) {
        types[[ext]]
    } else {
        "application/octet-stream"
    }
}

html_escape <- function(x) {
    x <- gsub("&", "&amp;", x, fixed = TRUE)
    x <- gsub("<", "&lt;", x, fixed = TRUE)
    x <- gsub(">", "&gt;", x, fixed = TRUE)
    x <- gsub('"', "&quot;", x, fixed = TRUE)
    x
}
