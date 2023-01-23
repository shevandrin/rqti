# define class TextGap to specify text entries
#' @importFrom htmltools tag p span tagList tagAppendChildren

setClass("TextGap", contains = "Gap",
         slots = c(response = "character", alternatives = "character",
                   case_sensitive = "logical"),
         prototype = prototype(type_precision = "absolute",
                               value_precision = 0,
                               case_sensitive = TRUE))

#' @rdname getResponse-methods
#' @aliases getResponse,TextGap
setMethod("getResponse", "TextGap", function(object) {
    object
})

#' @rdname createResponseDeclaration-methods
#' @aliases createResponseDeclaration,TextGap
setMethod("createResponseDeclaration", "TextGap", function(object) {
    create_response_declaration_text_entry(object)
})

#' @rdname createOutcomeDeclaration-methods
#' @aliases createOutcomeDeclaration,TextGap
setMethod("createOutcomeDeclaration", "TextGap", function(object) {
    create_outcome_declaration_text_entry(object)
})

#' @rdname createResponseProcessing-methods
#' @aliases createResponseProcessing,TextGap
setMethod("createResponseProcessing", "TextGap", function(object) {
    create_response_processing_text_entry(object)
})

create_response_declaration_text_entry <- function(object) {
    response <- create_correct_response(object@response)
    mapping <- create_mapping_gap(object)
    children <- tagList(response, mapping)
    tag("responseDeclaration", list(identifier = object@response_identifier,
                                    cardinality = "single",
                                    baseType = "string", children))
}

create_outcome_declaration_text_entry <- function(object) {

}

create_response_processing_text_entry <- function(object) {
    child <- tagList(tag("variable",
                         list(identifier = object@response_identifier)),
                     tag("correct",
                         list(identifier = object@response_identifier)))
    equal_tag <- tag("equal", list(toleranceMode = object@type_precision,
                                   tolerance = object@value_precision,
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
