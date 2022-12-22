# define class NumericGap to specify entries for numbers

setClass("NumericGap", contains = "Gap",
         slots = c(response = "numeric", type_precision = "character",
                   value_precision = "numeric"))

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
    SCORE <- make_outcome_declaration(paste0("SCORE_", object@response_identifier), value = 0)
    MAXSCORE <- make_outcome_declaration(paste0("MAXSCORE_", object@response_identifier), value = 1)
    tagList(SCORE, MAXSCORE)
}

create_response_processing_num_entry <- function(object) {
    tolerance_str <- paste(object@value_precision, object@value_precision)
    child <- tagList(tag("variable", list(identifier = object@response_identifier)),
                     tag("correct", list(identifier = object@response_identifier)))
    equal_tag <- tag("equal", list(toleranceMode = "absolute",
                                   tolerance = tolerance_str,
                                   includeLowerBound = "true",
                                   includeUpperBound = "true",
                                   child))
    var_outcome <- tag("variable", list(identifier = paste0("MAXSCORE_", object@response_identifier)))
    outcome_tag <- tag("setOutcomeValue", list(identifier = paste0("SCORE_",  object@response_identifier), var_outcome))
    if_tag <- tag("responseIf", list(equal_tag, outcome_tag))
    response_condition <- tag("responseCondition", list(if_tag))
}
