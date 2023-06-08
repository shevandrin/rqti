textgap <- function(response, alternatives = NULL, score = NULL,
                    expected_length = NULL, placeholder = NULL,
                    case_sensitive = NULL, response_identifier = NULL) {
    params <- as.list(match.call())[-1]
    params <- lapply(params, eval)
    result <- clean_yaml_str(params, "text")
    return(result)
}

textgapopal <- function(response, alternatives = NULL, score = NULL,
                        expected_length = NULL, placeholder = NULL,
                        case_sensitive = NULL, response_identifier = NULL,
                        value_precision = NULL) {
    params <- as.list(match.call())[-1]
    params <- lapply(params, eval)
    result <- clean_yaml_str(params, "text_opal")
    return(result)
}

numgap <- function(response, score = NULL, expected_length = NULL,
                   placeholder = NULL, value_precision = NULL,
                   type_precision = NULL, include_lower_bound = NULL,
                   include_upper_bound = NULL) {
    params <- as.list(match.call())[-1]
    params <- lapply(params, eval)
    result <- clean_yaml_str(params, "numeric")
    return(result)
}

clean_yaml_str <- function(params, type){
    if (!is.null(params$alternatives)) {
        params$alternatives <- paste(params$alternatives, collapse = ",")
        params$alternatives <- paste0("[", params$alternatives, "]")
    }

    result <- as.yaml(c(params, type = type), line.sep = "\r")
    result <- gsub("\r", ", ", result)
    result <- gsub(", $", "", result)
    result <- gsub("'", "", result)
    result <- paste0("<<{", result, "}>>")
    return(result)
}
