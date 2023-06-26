#' Class InlineChoice
#'
#' Abstract class `InlineChoice` is responsible for creating instances of
#' dropdown lists as answer options in question Entry type assessment task
#' according to QTI 2.1.
#' @template GapSlotsTemplate
#' @template InlineChoiceSlotsTemplate
#' @include Gap.R
#' @examples
#' ng <- new("InlineChoice",
#'           solution=  c("answer1", "answer2", "answer3"),
#'           response_identifier = "dropdown_gap_example")
#' @name InlineChoice-class
#' @rdname InlineChoice-class
#' @aliases InlineChoice
#' @exportClass InlineChoice
setClass("InlineChoice", contains = "Gap",
         slots = c(solution = "ANY",
                   answer_index = "numeric",
                   choices_identifiers = "character",
                   shuffle = "logical"),
         prototype = list(shuffle = TRUE, answer_index = 1))

setMethod("initialize", "InlineChoice", function(.Object, ...) {
    .Object <- callNextMethod()
    if (length(.Object@choices_identifiers) == 0) {
        .Object@choices_identifiers <- paste0("Option",
                                              LETTERS[seq(.Object@solution)])
    }

    if (length(.Object@score) == 0) .Object@score <- 1
    if (is.na(.Object@score)) .Object@score <- 1
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
    correct_choice_identifier <- object@choices_identifiers[object@answer_index]
    child <- create_correct_response(correct_choice_identifier)
    map_entry <- tag("mapping",
                     list(create_map_entry(object@score,
                                           correct_choice_identifier)))
    tag("responseDeclaration", list(identifier = object@response_identifier,
                                    cardinality = "single",
                                    baseType = "identifier",
                                    tagList(child, map_entry)))
}
