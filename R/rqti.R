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
