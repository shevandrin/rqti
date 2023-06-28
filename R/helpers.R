#' Create YAML string for TextGap object
#'
#' @param solution string vector; contains a vector of values that
#'   are considered as correct answers
#' @param tolerance numeric, optional; defines how many characters will be
#'   taken into account to tolerate spelling mistake in evaluation of candidate
#'   answer
#' @param case_sensitive logical, optional; determines whether the evaluation of
#'   the correct answer is case sensitive; default `TRUE`
#' @param score numeric, optional; the number of points for this gap; default 1
#' @param response_identifier string; an identifier for the answer; by default
#'   it is generated automatically
#' @param expected_length numeric, optional; is responsible to set a size of
#'   text input field in content delivery engine
#' @param placeholder string, optional; is responsible to place some helpful
#'   text in text input field in content delivery engine
#' @return string; map yaml
#' @export
gap_text <- function(solution, tolerance = NULL, case_sensitive = TRUE,
                     score = 1, response_identifier = NULL,
                     expected_length = NULL, placeholder = NULL) {
    # define gap-type
    type <- ifelse(is.null(tolerance), "text", "text_opal")
    # get users values
    params <- as.list(match.call())[-1]
    params <- lapply(params, eval)
    # get default values
    defaults <- formals(gap_text)
    # combine users and default values
    params <- combine_params(params, defaults)
    # build map yaml string
    result <- clean_yaml_str(params, type)
    return(result)
}

#' Create YAML string for NumericGap object
#'
#' @param solution numeric; contains right answer for this numeric entry
#' @param tolerance numeric, optional; specifies the value for up and low
#'   boundaries of tolerance rate for candidate answer
#' @param tolerance_type string, optional; specifies tolerance mode; possible
#'   values:"exact", "absolute", "relative"
#' @param score numeric, optional; the number of points for this gap; default 1
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
                        score = 1, response_identifier = NULL,
                        include_lower_bound = TRUE, include_upper_bound = TRUE,
                        expected_length = NULL, placeholder = NULL) {

    # get users values
    params <- as.list(match.call())[-1]
    params <- lapply(params, eval)
    if (!is.null(params$tolerance) & (is.null(params$tolerance_type))) {
        params$tolerance_type <- "absolute" }
    # get default values
    defaults <- formals(gap_numeric)
    # combine users and default values
    params <- combine_params(params, defaults)
    # build map yaml string
    result <- clean_yaml_str(params, "numeric")
    return(result)
}

#' Create YAML string for InlineChoice object (dropdown list)
#'
#' @param solution numeric or character vector; contains values of possible
#'   answers
#' @param answer_index integer, optional; the number of right answer in the
#'   `solution` vector, default `1`
#' @param score numeric, optional; the number of points for this gap; default
#'   `1`
#' @param shuffle boolean, optional; is responsible to randomize the order in
#'   which the choices are initially presented to the candidate; default `TRUE`
#' @param response_identifier string; an identifier for the answer; by default
#'   it is generated automatically
#' @param choices_identifiers character vector, optional; a set of identifiers
#'   for answers; by default identifiers are generated automatically
#' @return string; map yaml
#' @export
dropdown <- function(solution, answer_index = 1, score = 1, shuffle = TRUE,
                     response_identifier = NULL, choices_identifiers = NULL) {

    # get users values
    params <- as.list(match.call())[-1]
    params <- lapply(params, eval)
    # get default values
    defaults <- formals(dropdown)
    # combine users and default values
    params <- combine_params(params, defaults)
    # build map yaml string
    result <- clean_yaml_str(params, "InlineChoice")
    return(result)
}

clean_yaml_str <- function(params, type){

    solution <- paste(params$solution, collapse = ",")
    params$solution <- paste0("[", solution, "]")

    result <- as.yaml(c(params, type = type), line.sep = "\r")
    result <- gsub("\r", ", ", result)
    result <- gsub(", $", "", result)
    result <- gsub("'", "", result)
    result <- paste0("<<{", result, "}>>")
    return(result)
}

combine_params <- function(params, defaults) {
    params_keys <- names(params)
    defaults <- Filter(function(x) length(x) != 0, defaults)
    defaults_keys <- names(defaults)
    diff_keys <- setdiff(defaults_keys, params_keys)
    defaults <- defaults[diff_keys]
    # combine users and default values
    params <- c(params, defaults)
    return(params)
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
        gaps <- paste0(" <<", gaps, ">>")
    }

    md_list <- paste0("- ", vect, gaps)
    return(cat(md_list, sep = "\n"))
}
