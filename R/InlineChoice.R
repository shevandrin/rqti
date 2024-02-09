#' Class "InlineChoice"
#'
#' Class `InlineChoice` is responsible for creating instances of dropdown lists
#' as answer options in [Entry] type assessment tasks according to the QTI 2.1
#' standard.
#' @template GapSlotsTemplate
#' @template InlineChoiceSlotsTemplate
#' @include Gap.R
#' @examples
#' ng <- new("InlineChoice",
#'           response_identifier = "id_gap_1234",
#'           points = 1,
#'           choices =  c("answer1", "answer2", "answer3"),
#'           solution_index = 1,
#'           choices_identifiers = c("OptionA", "OptionB", "OptionC"),
#'           shuffle = TRUE)
#' @name InlineChoice-class
#' @rdname InlineChoice-class
#' @aliases InlineChoice
#' @exportClass InlineChoice
setClass("InlineChoice", contains = "Gap",
         slots = c(choices = "ANY",
                   solution_index = "numeric",
                   choices_identifiers = "character",
                   shuffle = "logical"),
         prototype = list(shuffle = TRUE, solution_index = 1),
         validity = function(object) {
          if (!any(is.character(object@choices), is.numeric(object@choices))){
                stop("slot \'choices\' must be of type \'character'\ or \'numeric\'")
           }
         })

setMethod("initialize", "InlineChoice", function(.Object, ...) {
    .Object <- callNextMethod()
    if (length(.Object@choices_identifiers) == 0) {
        .Object@choices_identifiers <- paste0("Option",
                                              LETTERS[seq(.Object@choices)])
    }

    if (length(.Object@points) == 0) .Object@points <- 1
    if (is.na(.Object@points)) .Object@points <- 1
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

create_response_declaration_inline_choice <- function(object) {
    correct_choice_identifier <- object@choices_identifiers[object@solution_index]
    child <- create_correct_response(correct_choice_identifier)
    map_entry <- tag("mapping",
                     list(create_map_entry(object@points,
                                           correct_choice_identifier)))
    tag("responseDeclaration", list(identifier = object@response_identifier,
                                    cardinality = "single",
                                    baseType = "identifier",
                                    tagList(child, map_entry)))
}
