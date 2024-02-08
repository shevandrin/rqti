generate_id <- function(prefix = "id_", type = "task", digits = 4) {
    random_digits <- sample(0:9, digits, replace = TRUE)
    id <- paste0(prefix, type, "_", paste0(random_digits, collapse = ""))
    return(id)
}
