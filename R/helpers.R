#' Create YAML string for TextGap object
#'
#' @param solution string; contains right answer for this text gap entry
#' @param alternatives string vector, optional; contains a vector of values that
#'   are also considered correct answers
#' @param score numeric, optional; the number of points for this gap; default 1
#' @param expected_length numeric, optional; is responsible to set a size of
#'   text input field in content delivery engine
#' @param placeholder string, optional; is responsible to place some helpful
#'   text in text input field in content delivery engine
#' @param case_sensitive logical, optional; determines whether the evaluation of
#'   the correct answer is case sensitive
#' @param response_identifier string; an identifier for the answer; by default
#'   it is generated automatically
#' @param tolerance numeric, optional; defines how many characters will be
#'   taken into account to tolerate spelling mistake in evaluation of candidate
#'   answer
#' @return string; map yaml
#' @export
gap_text <- function(solution, alternatives = NULL, score = NULL,
                    expected_length = NULL, placeholder = NULL,
                    case_sensitive = NULL, response_identifier = NULL,
                    tolerance = NULL) {
    type <- ifelse(is.null(tolerance), "text", "text_opal")
    params <- as.list(match.call())[-1]
    params <- lapply(params, eval)
    result <- clean_yaml_str(params, type)
    return(result)
}

#' Create YAML string for NumericGap object
#'
#' @param solution numeric; contains right answer for this numeric entry
#' @param score numeric, optional; the number of points for this gap; default 1
#' @param expected_length numeric, optional; is responsible to set a size of
#'   text input field in content delivery engine
#' @param placeholder string, optional; is responsible to place some helpful
#'   text in text input field in content delivery engine
#' @param tolerance numeric, optional; specifies the value for up and low
#'   boundaries of tolerance rate for candidate answer
#' @param response_identifier string; an identifier for thy answer; by default
#'   it is generated automatically
#' @param tolerance_type string, optional; specifies tolerance mode; possible
#'   values:"exact", "absolute", "relative"
#' @param include_lower_bound boolean, optional; specifies whether or not the
#'   lower bound is included in tolerance rate
#' @param include_upper_bound boolean, optional; specifies whether or not the
#'   upper bound is included in tolerance rate
#' @param response_identifier string; an identifier for thy answer; by default
#'   it is generated automatically
#' @return string; map yaml
#' @export
gap_numeric <- function(solution, score = NULL, expected_length = NULL,
                   placeholder = NULL, tolerance = NULL,
                   tolerance_type = NULL, include_lower_bound = NULL,
                   include_upper_bound = NULL, response_identifier = NULL) {

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
#' Create markdown list for answer options
#'
#' @param vect string or numeric vector of answer options for single/multiple
#'   choice task
#' @param solutions numeric, optional; indexes of right answer options in `vect`
#' @param gaps numeric or string vector, optional; provides primitive
#'   description to build gaps in content of Entry task
#' @return markdown list
#' @export
answerlist <- function(vect, solutions = NULL, gaps = NULL) {

    if (!is.null(solutions)) {
        for (s in solutions) vect[s] <- paste0("*", vect[s], "*")
    }

    if (!is.null(gaps)) {
        if (length(vect) != length(gaps)) {
            print("*Error*: Number of Gaps must be equal to number of list
                  items")
        }
        gaps <- paste0(" <<", gaps, ">>")
    }

    md_list <- paste0("- ", vect, gaps)
    return(cat(md_list, sep = "\n"))
}
