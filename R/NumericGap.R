#' Class "NumericGap"
#'
#' Class `NumericGap` is responsible for creating instances of input fields with
#' numeric type of answers in question [Entry] type assessment tasks according
#' to the QTI 2.1 standard.
#' @template GapSlotsTemplate
#' @template NumericGapSlotsTemplate
#' @include Gap.R
#' @seealso [Entry], [TextGap], [TextGapOpal] and [InlineChoice].
#' @examples
#' ng <- new("NumericGap",
#'           response_identifier = "id_gap_1234",
#'           points = 1,
#'           placeholder = "use this format xx.xxx",
#'           solution = 5,
#'           tolerance = 1,
#'           tolerance_type = "relative",
#'           include_lower_bound = TRUE,
#'           include_upper_bound = TRUE)
#' @examples
#' dynamic_gap <- new("NumericGap", response_identifier = "answer",
#'                    solution_variable = "c")
#' variables <- new("MaximaVariables", code = "string(['c = 3]);",
#'                  variables = c(c = "integer"))
#' item <- new("Entry", content = list("<p>Answer: ", dynamic_gap, "</p>"),
#'             template = list(variables))
#' createTemplateProcessing(item)
#' @name NumericGap-class
#' @rdname NumericGap-class
#' @aliases NumericGap
#' @exportClass NumericGap
setClass("NumericGap", contains = "Gap",
         slots = c(solution = "numeric",
                   solution_variable = "character",
                   include_lower_bound = "logical",
                   include_upper_bound = "logical",
                   tolerance = "numeric",
                   tolerance_type = "character"),
         prototype = prototype(score = 1,
                               solution_variable = character(),
                               tolerance_type = "absolute",
                               tolerance = 0,
                               include_lower_bound = TRUE,
                               include_upper_bound = TRUE))

setValidity("NumericGap", function(object) {
    errors <- character()
    reference <- object@solution_variable
    if (length(reference) > 0L) {
        if (length(reference) != 1L || anyNA(reference) ||
            !check_identifier(reference, quiet = TRUE)) {
            errors <- c(errors, "solution_variable must be a single valid QTI identifier.")
        }
        if (length(object@solution)) {
            errors <- c(errors, "Specify either solution or solution_variable, not both.")
        }
    }
    types <- c("exact", "absolute", "relative")
    if (length(object@tolerance_type) == 0L) object@tolerance_type <- "exact"
    if (length(object@tolerance_type) != 1L || anyNA(object@tolerance_type) ||
        !object@tolerance_type %in% types) {
        errors <- c(errors, "tolerance_type must be exact, absolute, or relative.")
    }
    if (length(errors)) errors else TRUE
})

setMethod("initialize", "NumericGap", function(.Object, ...) {
    .Object <- callNextMethod()

    el <- .Object@expected_length
    if (any(is.na(el)) || length(el) == 0) {
        .Object@expected_length <- if (length(.Object@solution_variable)) {
            10
        } else {
            size_gap(.Object@solution)
        }
    }

    validObject(.Object)
    .Object
})

#'Create object [NumericGap]
#'
#'@param solution A numeric value containing the correct answer for this numeric
#'  entry. Omit when using `solution_variable`.
#'@param solution_variable An optional QTI identifier of an `integer` or `float`
#'  template variable used as the correct answer. Cannot be combined with a
#'  non-empty `solution`. Defaults to `character()`.
#'@param response_identifier A character value representing an identifier for
#'  the answer. By default, it is generated as 'id_gap_dddd', where dddd
#'  represents random digits.
#'@param points A numeric value, optional, representing the number of points for
#'  this gap. Default is 1
#'@param placeholder A character value, optional, used to place
#'  helpful text in the text input field in the content delivery engine. Default
#'  is "".
#'@param expected_length A numeric value, optional, used to set the
#'  size of the text input field in the content delivery engine. Default value
#'  is adjusted by solution size, or 10 for a dynamic answer.
#'@param tolerance A numeric value, optional, specifying the value for the upper
#'  and lower boundaries of the tolerance rate for candidate answers. Default is
#'  0.
#'@param tolerance_type A character value, optional, specifying the tolerance
#'  mode. Possible values:
#'  * "exact"
#'  * "absolute" - Default.
#'  * "relative"
#'@param include_lower_bound A boolean value, optional, specifying whether the
#'  lower bound is included in the tolerance rate. Default is `TRUE`.
#'@param include_upper_bound A boolean value, optional, specifying whether the
#'  upper bound is included in the tolerance rate. Default is `TRUE`.
#'@return An object of class [NumericGap]
#'@seealso [entry()][textGap()][textGapOpal()]
#' @examples
#'ng_min <- numericGap(5.1)
#'dynamic_gap <- numericGap(solution_variable = "c")
#'
#'ng <- numericGap(solution = 5.1,
#'                 response_identifier  = "id_gap_1234",
#'                 points = 2,
#'                 placeholder = "put your answer here",
#'                 expected_length = 4,
#'                 tolerance = 5,
#'                 tolerance_type = "relative")
#'@rdname numericGap_doc
#'@export
numericGap <- function(solution = numeric(),
                    response_identifier = generate_id(type = "gap"),
                    points = 1,
                    placeholder = "",
                    expected_length = if (length(solution_variable)) 10 else size_gap(solution),
                    tolerance = 0,
                    tolerance_type = "absolute",
                    include_lower_bound = TRUE,
                    include_upper_bound = TRUE,
                    solution_variable = character()) {
    if (missing(solution) && !length(solution_variable)) {
        stop("Provide solution or solution_variable.", call. = FALSE)
    }
    params <- as.list(environment())
    params$Class <- "NumericGap"
    obj <- do.call("new", params)
    return(obj)
}

#' @rdname numericGap_doc
#' @export
gapNumeric <- numericGap

#' @rdname getResponse-methods
#' @aliases getResponse,NumericGap
setMethod("getResponse", "NumericGap", function(object) {
    object
})

#' @rdname createResponseDeclaration-methods
#' @aliases createResponseDeclaration,NumericGap
setMethod("createResponseDeclaration", "NumericGap", function(object) {
    create_response_declaration_num_entry(object)
})

#' @rdname createResponseProcessing-methods
#' @aliases createResponseProcessing,NumericGap
setMethod("createResponseProcessing", "NumericGap", function(object) {
    create_response_processing_num_entry(object)
})

create_response_declaration_num_entry <- function(object) {
    validObject(object)
    response <- if (!length(object@solution_variable)) {
        create_correct_response(object@solution)
    }
    tag("responseDeclaration", list(identifier = object@response_identifier,
                                    cardinality = "single",
                                    baseType = "float", response))
}
