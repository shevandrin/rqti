#' Class "Gap"
#'
#' Abstract class `Gap` is never to be generated, only derived classes
#' [TextGap-class], [NumericGap] and [InlineChoice] are meaningful.
#' @inheritSection AssessmentItem-class Warning
#' @name Gap-class
#' @rdname Gap-class
#' @aliases Gap
setClass("Gap", slots = c(response_identifier = "character", score = "numeric",
                          placeholder = "character",
                          expected_length = "numeric"),
         prototype = prototype(score = 1))

setMethod("initialize", "Gap", function(.Object, ...) {
    .Object <- callNextMethod()

    if (length(.Object@response_identifier) == 0) {
        id <- paste0("gap_", ids::adjective_animal())
        warning("There is no response_identifier in Gap-ohnnbject. A random ",
                " value is assigned: ", id, call. = FALSE)
        .Object@response_identifier <- id
    }

    validObject(.Object)
    .Object
})

#' Get and process a piece of question content
#'
#' Generic function to get and process a different types of question content
#' (text with instances of gaps or dropdown lists) for XML document of
#' specification the question following the QTI schema v2.1
#'
#' @param object an instance of the S4 object (NumericGap, TextGap,
#'   InlineChoice, character)
#' @docType methods
#' @rdname getResponse-methods
#'
#' @export
setGeneric("getResponse", function(object) {
    standardGeneric("getResponse")
})

#' @rdname getResponse-methods
#' @aliases getResponse,character
setMethod("getResponse", "character", function(object) {
})

#' @rdname createText-methods
#' @aliases createText,Gap
setMethod("createText", "Gap", function(object) {
    tag("textEntryInteraction",
        list(responseIdentifier = object@response_identifier,
             expectedLength = object@expected_length,
             placeholderText = object@placeholder))
})

#' @rdname createOutcomeDeclaration-methods
#' @aliases createOutcomeDeclaration,TextGap
setMethod("createOutcomeDeclaration", "Gap", function(object) {
    create_outcome_declaration_gap(object)
})

#' @rdname createResponseProcessing-methods
#' @aliases createResponseProcessing,Gap
setMethod("createResponseProcessing", "Gap", function(object) {
    create_response_processing_gap_basic(object)
})

create_outcome_declaration_gap <- function(object) {
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
