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

#' @importFrom yaml as.yaml
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
#' @param vect A string or numeric vector of answer options for single/multiple
#'   choice task.
#' @param solutions An integer value, optional; indexes of right answer options
#'   in `vect`.
#' @param gaps numeric or string vector, optional; provides primitive
#'  gap description if there is a need to build a list of gaps.
#' @return markdown list
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
