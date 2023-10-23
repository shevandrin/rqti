#' Create YAML string for TextGap object
#'
#' @param solution string vector; contains a vector of values that
#'   are considered as correct answers
#' @param tolerance numeric, optional; defines how many characters will be
#'   taken into account to tolerate spelling mistake in evaluation of candidate
#'   answer
#' @param case_sensitive logical, optional; determines whether the evaluation of
#'   the correct answer is case sensitive; default `FALSE`
#' @param points numeric, optional; the number of points for this gap; default 1
#' @param response_identifier string; an identifier for the answer; by default
#'   it is generated automatically
#' @param expected_length numeric, optional; is responsible to set a size of
#'   text input field in content delivery engine
#' @param placeholder string, optional; is responsible to place some helpful
#'   text in text input field in content delivery engine
#' @return string; map yaml
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
#' @param solution numeric; contains right answer for this numeric entry
#' @param tolerance numeric, optional; specifies the value for up and low
#'   boundaries of tolerance rate for candidate answer
#' @param tolerance_type string, optional; specifies tolerance mode; possible
#'   values:"exact", "absolute", "relative"
#' @param points numeric, optional; the number of points for this gap; default 1
#' @param response_identifier string; an identifier for the answer; by default
#'   it is generated automatically
#' @param include_lower_bound boolean, optional; specifies whether or not the
#'   lower bound is included in tolerance rate
#' @param include_upper_bound boolean, optional; specifies whether or not the
#'   upper bound is included in tolerance rate
#' @param expected_length numeric, optional; is responsible to set a size of
#'   text input field in content delivery engine
#' @param placeholder string, optional; is responsible to place some helpful
#'   text in text input field in content delivery engine
#' @return string; map yaml
#' @export
gap_numeric <- function(solution, tolerance = NULL, tolerance_type = "exact",
                        points = 1, response_identifier = NULL,
                        include_lower_bound = TRUE, include_upper_bound = TRUE,
                        expected_length = size_gap(solution), placeholder = NULL) {

    params <- as.list(environment())
    params <- Filter(Negate(is.null), params)
    if (!is.null(params$tolerance) & (params$tolerance_type == 'exact')) {
        params$tolerance_type <- "absolute" }
    result <- clean_yaml_str(params, params$solution, "numeric")
    return(result)
}

#' Create YAML string for InlineChoice object (dropdown list)
#'
#' @param choices numeric or character vector; contains values of possible
#'   answers. If you use a named vector, the names will be used as identifiers
#' @param solution_index integer, optional; the number of right answer in the
#'   `choices` vector, default `1`
#' @param points numeric, optional; the number of points for this gap; default
#'   `1`
#' @param shuffle boolean, optional; is responsible to randomize the order in
#'   which the choices are initially presented to the candidate; default `TRUE`
#' @param response_identifier string; an identifier for the answer; by default
#'   it is generated automatically
#' @return string; map yaml
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
    solution <- paste(solution, collapse = ",")
    if (type == "InlineChoice") {
        params$choices <- paste0("[", solution, "]")
    } else {
        params$solution <- paste0("[", solution, "]")
    }

    if (!is.null(params$choices_identifiers)) {
        choices_identifiers <- paste(params$choices_identifiers, collapse = ",")
        params$choices_identifiers <- paste0("[", choices_identifiers, "]")
    }

    result <- as.yaml(c(params, type = type), line.sep = "\r")
    result <- gsub("\r", ", ", result)
    result <- gsub(", $", "", result)
    result <- gsub("'", "", result)
    result <- paste0("<gap>{", result, "}</gap>")
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
mdlist <- function(vect, solutions = NULL, gaps = NULL) {

    if (!is.null(solutions)) {
        for (s in solutions) vect[s] <- paste0("*", vect[s], "*")
    }

    if (!is.null(gaps)) {
        if (length(vect) != length(gaps)) {
            print("*Error*: Number of Gaps must be equal to number of list
                  items")
        }
        gaps <- paste0(" <gap>", gaps, "</gap>")
    }

    md_list <- paste0("- ", vect, gaps, collapse = "\n")
    return(md_list)
}

size_gap <- function(input) {
    num <- nchar(as.character(input[1]))
    size <- ifelse(num <= 2, 1, num-1)
    return(size)
}
