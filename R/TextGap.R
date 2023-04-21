#' Class TextGap
#'
#' Abstract class `TextGap` is responsible for creating instances of input
#' fields with text type of answer in question Entry type assessment task
#' according to QTI 2.1.
#' @template GapSlotsTemplate
#' @template TextGapSlotsTemplate
#' @examples
#' tg <- new("TextGap",
#'           response = "answer",
#'           alternatives = c("answerr", "aanswer"),
#'           placeholder = "do not put special characters" )
#' @name TextGap-class
#' @rdname TextGap-class
#' @aliases TextGap
#' @include Gap.R
#' @importFrom htmltools tag p span tagList tagAppendChildren
setClass("TextGap", contains = "Gap",
         slots = c(response = "character", alternatives = "character",
                   case_sensitive = "logical"),
         prototype = prototype(case_sensitive = TRUE
                               ))
setMethod("initialize", "TextGap", function(.Object,...){
    .Object <- callNextMethod()
    if (length(.Object@score) == 0) .Object@score = 1
    if (length(.Object@case_sensitive) == 0L) .Object@case_sensitive = TRUE
    validObject(.Object)
    .Object
})

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
    # create_response_processing_text_entry(object)
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
