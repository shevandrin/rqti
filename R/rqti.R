generate_id <- function(prefix = "id_", type = "task", digits = 4L) {
    random_digits <- sample(0:9, digits, replace = TRUE)
    id <- paste0(prefix, type, "_", paste0(random_digits, collapse = ""))
    return(id)
}

check_identifier <- function(id, quiet = FALSE) {
    checker = grepl("^[A-Za-z]", id)
    checker <- checker & !grepl("[\u00C4\u00E4\u00DF\u00D6\u00F6\u00DC\u00FC]", id)
    checker <- checker & !grepl("\\s", id)

    if (!checker && !quiet) {
        stop("The identifier must start with a letter and not contain spaces",
        " or umlauts. Error value: ", id, call. = FALSE)
    }
    return(checker)
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
