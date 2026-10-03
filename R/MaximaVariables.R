#' Maxima template calculation
#'
#' Stores a Maxima program and the types of its named outputs. The program is
#' not executed in R. Template XML is generated when the containing assessment
#' item is exported. Rmd parsing is not yet supported.
#'
#' @slot code A single non-empty string containing the Maxima program.
#' @slot variables A non-empty named character vector of output types:
#'   `integer`, `float`, or `string`. Each output has single cardinality.
#'   Names must start with an ASCII letter and contain only ASCII letters,
#'   digits, or underscores, so they can be used as Maxima symbols.
#' @slot identifier A single QTI identifier for the intermediate string result.
#'   Defaults to `"all"`; must differ from all output names.
#' @name MaximaVariables-class
#' @rdname MaximaVariables-class
#' @aliases MaximaVariables
#' @exportClass MaximaVariables
#' @include rqti.R
#' @examples
#' variables <- new("MaximaVariables",
#'                  code = "string(['a = 1]);",
#'                  variables = c(a = "integer"))
#' item <- new("Essay", template = list(variables))
setClass("MaximaVariables",
         slots = c(code = "character",
                   variables = "character",
                   identifier = "character"),
         prototype = prototype(identifier = "all"))

setValidity("MaximaVariables", function(object) {
    errors <- character()
    if (length(object@code) != 1L || anyNA(object@code) ||
        !nzchar(trimws(object@code))) {
        errors <- c(errors, "code must be a single non-empty string.")
    }

    variables <- object@variables
    names_valid <- length(variables) > 0L &&
        !is.null(names(variables)) && !anyNA(names(variables)) &&
        all(grepl("^[A-Za-z][A-Za-z0-9_]*$", names(variables)))
    if (!names_valid) {
        errors <- c(errors, paste("variables must have non-empty output names",
                                 "starting with a letter and containing only",
                                 "ASCII letters, digits, or underscores."))
    }
    if (anyDuplicated(names(variables))) {
        errors <- c(errors, "Output names must be unique.")
    }
    if (length(variables) == 0L || anyNA(variables) ||
        !all(variables %in% c("integer", "float", "string"))) {
        errors <- c(errors, "Output types must be integer, float, or string.")
    }

    id <- object@identifier
    if (length(id) != 1L || anyNA(id) ||
        !check_identifier(id, quiet = TRUE)) {
        errors <- c(errors, "identifier must be a single valid QTI identifier.")
    }
    if (any(id %in% names(variables))) {
        errors <- c(errors, "identifier must differ from output names.")
    }
    if (length(errors)) errors else TRUE
})
