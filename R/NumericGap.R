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
#'           response = 5,
#'           placeholder = "use this format xx.xxx" )
#' @name NumericGap-class
#' @rdname NumericGap-class
#' @aliases NumericGap
#' @exportClass NumericGap
setClass("NumericGap", contains = "Gap",
         slots = c(response = "numeric",
                   include_lower_bound = "logical",
                   include_upper_bound = "logical",
                   value_precision = "numeric",
                   type_precision = "character"),
         prototype = prototype(type_precision = "exact",
                               include_lower_bound = TRUE,
                               include_upper_bound = TRUE,
                               score = 1))
#' @export
NumericGap <- function(response_identifier = character(),
                        score = numeric(), placeholder = character(),
                        expected_length = numeric(),
                        response = numeric(), value_precision = numeric(),
                        type_precision = character(),
                        include_lower_bound = logical(),
                        include_upper_bound = logical()
){
    new("NumericGap", response_identifier = response_identifier,
        score = score, placeholder = placeholder,
        expected_length = expected_length,
        response = response, value_precision = value_precision,
        type_precision = type_precision,
        include_lower_bound = include_lower_bound,
        include_upper_bound = include_upper_bound)
}
setValidity("NumericGap", function(object) {
    types <- c("exact", "absolute", "relative")
    if (length(object@type_precision) == 0L) object@type_precision = "exact"
    if (!(object@type_precision %in% types)) {
        "@value_precision can be \"exact\", \"absolute\", or \"relative\" only"
    } else {
        return(TRUE)
    }
}
)

setMethod("initialize", "NumericGap", function(.Object,...){
    .Object <- callNextMethod()
    if (length(.Object@score) == 0) .Object@score = 1
    if (length(.Object@type_precision) == 0L) .Object@type_precision = "exact"
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

#' @rdname createOutcomeDeclaration-methods
#' @aliases createOutcomeDeclaration,NumericGap
setMethod("createOutcomeDeclaration", "NumericGap", function(object) {
    create_outcome_declaration_num_entry(object)
})

#' @rdname createResponseProcessing-methods
#' @aliases createResponseProcessing,NumericGap
setMethod("createResponseProcessing", "NumericGap", function(object) {
    create_response_processing_num_entry(object)
})

create_response_declaration_num_entry <- function(object) {
    response <- create_correct_response(object@response)
    tag("responseDeclaration", list(identifier = object@response_identifier,
                                    cardinality = "single",
                                    baseType = "float", response))
}

create_outcome_declaration_num_entry <- function(object) {
    SCORE <- make_outcome_declaration(paste0("SCORE_",
                                             object@response_identifier),
                                      value = 0)
    MAXSCORE <- make_outcome_declaration(paste0("MAXSCORE_",
                                                object@response_identifier),
                                         value = object@score)
    MINSCORE <- make_outcome_declaration(paste0("MINSCORE_",
                                                object@response_identifier),
                                         value = 0)
    tagList(SCORE, MAXSCORE, MINSCORE)
}

create_response_processing_num_entry <- function(object) {
    tolerance_str <- paste(object@value_precision, object@value_precision)
    child <- tagList(tag("variable",
                         list(identifier = object@response_identifier)),
                     tag("correct",
                         list(identifier = object@response_identifier)))
    equal_tag <- tag("equal", list(toleranceMode = object@type_precision,
                                   tolerance = tolerance_str,
                                   includeLowerBound =
                                       tolower(object@include_lower_bound),
                                   includeUpperBound =
                                       tolower(object@include_upper_bound),
                                   child))
    var_outcome <- tag("variable",
                       list(identifier = paste0("MAXSCORE_",
                                                object@response_identifier)))
    outcome_tag <- tag("setOutcomeValue",
                       list(identifier = paste0("SCORE_",
                                                object@response_identifier),
                            var_outcome))
    if_tag <- tag("responseIf", list(equal_tag, outcome_tag))
    tag("responseCondition", list(if_tag))
}
