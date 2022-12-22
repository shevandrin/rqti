# define class TextGap to specify text entries
#' @importFrom htmltools tag p span tagList tagAppendChildren

setClass("TextGap", contains = "Gap",
         slots = c(response = "character", alternatives = "character"))

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

