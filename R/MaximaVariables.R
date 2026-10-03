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

#' Describe a Maxima calculation and its outputs
#'
#' Creates a [MaximaVariables] object for an assessment item's `template` list.
#' This function stores the program without executing it. The exported XML uses
#' OPAL/ONYX MAXIMA operators; validation requires the extended rqti schema.
#' Rmd integration is not yet supported.
#'
#' @param code A single non-empty string containing the Maxima program. It must
#'   return a string representation of associations for the named outputs.
#' @param variables A non-empty named character vector of QTI output types:
#'   `integer`, `float`, or `string`. Names start with an ASCII letter and contain
#'   only ASCII letters, digits, or underscores. All outputs have single
#'   cardinality.
#' @param identifier The QTI identifier for the intermediate string result.
#'   Defaults to `"all"`. Use distinct identifiers for multiple blocks.
#' @return A [MaximaVariables] object.
#' @seealso [template_value()], [numericGap()], [entry()]
#' @export
#' @examples
#' calculation <- maxima_variables(
#'     code = "block([a,b,c], a: random(100), b: random(100),
#'              c: a + b, string(['a = a, 'b = b, 'c = c]));",
#'     variables = c(a = "integer", b = "integer", c = "integer")
#' )
#' item <- entry(
#'     identifier = "addition",
#'     template = list(calculation),
#'     content = list("<p>", template_value("a"), " + ", template_value("b"),
#'                    " = ", numericGap(solution_variable = "c"), "</p>")
#' )
#' createTemplateDeclaration(item)
#' createTemplateProcessing(item)
#' createItemBody(item)
maxima_variables <- function(code, variables, identifier = "all") {
    new("MaximaVariables", code = code, variables = variables,
        identifier = identifier)
}
