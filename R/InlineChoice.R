# define class InlineChoice to specify Dropdowns for numbers

setClass("InlineChoice", contains = "Gap",
         slots = c(options = "character",
                   solution = "numeric",
                   options_identifiers = "character",
                   shuffle = "logical"),
         prototype = list(shuffle = TRUE, solution = 1))

setMethod("initialize", "InlineChoice", function(.Object, ...) {
    .Object <- callNextMethod()
    .Object@options_identifiers <- paste0("Option",
                                         LETTERS[seq(.Object@options)])
    if (is.na(.Object@score)) {
        .Object@score <- 1
    }
    validObject(.Object)
    .Object
})

#' @rdname getResponse-methods
#' @aliases getResponse,InlineChoice
setMethod("getResponse", "InlineChoice", function(object) {
    object
})

#' @rdname createText-methods
#' @aliases createText,InlineChoice
setMethod("createText", "InlineChoice", function(object) {
    make_inline_choice_interaction(object)
})

#' @rdname createResponseDeclaration-methods
#' @aliases createResponseDeclaration,InlineChoice
setMethod("createResponseDeclaration", "InlineChoice", function(object)  {
    create_response_declaration_inline_choice(object)
})

#' @rdname createOutcomeDeclaration-methods
#' @aliases createOutcomeDeclaration,InlineChoice
setMethod("createOutcomeDeclaration", "InlineChoice", function(object)  {
    tagList(make_outcome_declaration(paste0("SCORE_",
                                            object@response_identifier),
                                     value = object@score),
    make_outcome_declaration(paste0("MAXSCORE_", object@response_identifier),
                             value = object@score))
})

#' @rdname createResponseProcessing-methods
#' @aliases createResponseProcessing,InlineChoice
setMethod("createResponseProcessing", "InlineChoice", function(object) {
    create_response_processing_inline_choice(object)
})

create_response_declaration_inline_choice <- function(object) {
    correct_choice_identifier <- object@options_identifiers[object@solution]
    child <- create_correct_response(correct_choice_identifier)
    map_entry <- tag("mapping",
                     list(create_map_entry(object@score,
                                           correct_choice_identifier)))
    tag("responseDeclaration", list(identifier = object@response_identifier,
                                    cardinality = "single",
                                    baseType = "identifier",
                                    tagList(child, map_entry)))
}

create_response_processing_inline_choice <- function(object) {
    # TODO responseProcessing doesn't need to independent task
    # to check is there a need responseProcessing for exam
    child <- tagList(tag("variable",
                         list(identifier = object@response_identifier)),
                     tag("correct",
                         list(identifier = object@response_identifier)))
    match <- tag("match", child)
    base_value <- tag("baseValue", list(baseType = "float", object@score))
    outcome <- tag("setOutcomeValue",
                   list(identifier = paste0("SCORE_",
                                            object@response_identifier),
                        base_value))
    response_if <- tag("responseIf", tagList(match, outcome))
    tag("responseCondition", list(response_if))
}
