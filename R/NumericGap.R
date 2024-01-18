#' Class NumericGap
#'
#' Abstract class `NumericGap` is responsible for creating instances of input
#' fields with numeric type of answer in question Entry type assessment task
#' according to QTI 2.1.
#' @template GapSlotsTemplate
#' @template NumericGapSlotsTemplate
#' @include Gap.R
#' @examples
#' ng <- new("NumericGap",
#'           response_identifier = "gap_1",
#'           solution = 5,
#'           placeholder = "use this format xx.xxx" )
#' @name NumericGap-class
#' @rdname NumericGap-class
#' @aliases NumericGap
#' @exportClass NumericGap
setClass("NumericGap", contains = "Gap",
         slots = c(solution = "numeric",
                   include_lower_bound = "logical",
                   include_upper_bound = "logical",
                   tolerance = "numeric",
                   tolerance_type = "character"),
         prototype = prototype(score = 1,
                               tolerance_type = "absolute",
                               tolerance = 0,
                               include_lower_bound = TRUE,
                               include_upper_bound = TRUE))

setValidity("NumericGap", function(object) {
    types <- c("exact", "absolute", "relative")
    if (length(object@tolerance_type) == 0L) object@tolerance_type = "exact"
    if (!(object@tolerance_type %in% types)) {
        "@value_precision can be \"exact\", \"absolute\", or \"relative\" only"
    } else {
        return(TRUE)
    }
})

setMethod("initialize", "NumericGap", function(.Object, ...) {
    .Object <- callNextMethod()

    if (length(.Object@expected_length) == 0) {
        .Object@expected_length = size_gap(.Object@solution)
    }

    validObject(.Object)
    .Object
})

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
    response <- create_correct_response(object@solution)
    tag("responseDeclaration", list(identifier = object@response_identifier,
                                    cardinality = "single",
                                    baseType = "float", response))
}
