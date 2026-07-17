generate_id <- function(prefix = "id_", type = "task", digits = 4L) {
    random_digits <- sample(0:9, digits, replace = TRUE)
    id <- paste0(prefix, type, "_", paste0(random_digits, collapse = ""))
    return(id)
}


check_identifier <- function(id, quiet = FALSE) {
    if (!is.character(id) || length(id) != 1) {
        stop("Identifier must be a single character string.", call. = FALSE)
    }

    issues <- character()

    if (!grepl("^[A-Za-z_]", id)) {
        issues <- c(issues, "must start with a letter or '_'")
    }

    if (grepl("[^A-Za-z0-9_.-]", id)) {
        issues <- c(issues,
                    "contains invalid characters (allowed: letters, digits, '_', '-', '.')"
        )
    }

    if (grepl(":", id)) {
        issues <- c(issues, "contains ':' which is not allowed")
    }

    if (grepl("\\s", id)) {
        issues <- c(issues, "contains whitespace")
    }

    if (grepl("[\u00C4\u00E4\u00DF\u00D6\u00F6\u00DC\u00FC]", id)) {
        issues <- c(issues, "contains German umlauts")
    }

    checker <- length(issues) == 0

    if (!checker && !quiet) {
        stop(
            sprintf(
                "Invalid identifier '%s': %s.",
                id,
                paste(issues, collapse = "; ")
            ),
            call. = FALSE
        )
    }

    return(checker)
}


repair_identifier <- function(id) {
    if (!is.character(id) || length(id) != 1) {
        stop("Identifier must be a single character string.", call. = FALSE)
    }

    gsub("\\s+", "_", id)
}


# helper to put default value into slots of classes without na values
replace_na <- function(input) {
    if (length(input) !=0) {
        if(is.na(input)) {
            if (is.character(input)) {
                return(character(0))
            } else {
                return(numeric(0))
            }
        }
    }
    return(input)
}

# define default value for gap size
size_gap <- function(input) {
    num <- nchar(as.character(input[1]))
    size <- ifelse(num <= 2, 1, num-1)
    return(size)
}

# define default value for max words in essay
max_words <- function(input) {
    if (length(input) > 0) {
        answer_str <- paste(input[[1]]@content, collapse = " ")
        length(unlist(strsplit(answer_str, "\\s+"))) * 2
    } else {
        return(NA_integer_)
    }
}

# define default value for expected length in essay
length_expected <- function(input) {
    if (length(input) > 0) {
        answer_str <- paste(input[[1]]@content, collapse = " ")
        nwords <- length(unlist(strsplit(answer_str, "\\s+")))
        n_characters <- 6 * nwords
        ifelse(n_characters < 150, n_characters, 150)
    } else {
        return(NA_integer_)
    }
}

# define default value for expected lines in essay
lines_expected <- function(input) {
    if (length(input) > 0) {
        answer_str <- paste(input[[1]]@content, collapse = " ")
        nwords <- length(unlist(strsplit(answer_str, "\\s+")))
        n_characters <- 6 * nwords
        ifelse(n_characters < 150, 1, round(n_characters / 150) + 2)
    } else {
        return(NA_integer_)
    }
}

# helper to show warning once for recurrent warning messages
warn_once <- local({
    warned <- new.env(parent = emptyenv())

    function(msg, id) {
        if (!exists(id, envir = warned)) {
            assign(id, TRUE, envir = warned)
            warning(msg, call. = FALSE)
        }
    }
})

# Generic helper to validate character slots against a predefined set of
# allowed values, with optional support for NA and empty strings
validate_choice_slot <- function(
        x,
        allowed,
        slot_name,
        allow_na = FALSE,
        allow_empty = FALSE
) {
    if (length(x) == 0L) {
        if (allow_empty) {
            return(NULL)
        }

        return(sprintf(
            "The '%s' slot must contain exactly one value.",
            slot_name
        ))
    }

    if (length(x) != 1L) {
        return(sprintf(
            "The '%s' slot must contain exactly one value.",
            slot_name
        ))
    }

    if (is.na(x)) {
        if (allow_na) {
            return(NULL)
        }

        return(sprintf(
            "The '%s' slot must not be NA.",
            slot_name
        ))
    }

    if (identical(x, "")) {
        if (allow_empty) {
            return(NULL)
        }

        return(sprintf(
            "The '%s' slot must not be an empty string.",
            slot_name
        ))
    }

    if (!x %in% allowed) {
        return(sprintf(
            "The '%s' slot must be one of: %s. Received: '%s'.",
            slot_name,
            paste(sprintf("'%s'", allowed), collapse = ", "),
            x
        ))
    }

    NULL
}


validate_calculator <- function(x) {
    validate_choice_slot(
        x = x,
        allowed = c(
            "simple",
            "simple-calculator",
            "scientific",
            "scientific-calculator"
        ),
        slot_name = "@calculator",
        allow_na = TRUE,
        allow_empty = TRUE
    )
}
