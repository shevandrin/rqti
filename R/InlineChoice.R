#' Class "InlineChoice"
#'
#' Class `InlineChoice` is responsible for creating instances of dropdown lists
#' as answer options in [Entry] type assessment tasks according to the QTI 2.1
#' standard.
#' @template GapSlotsTemplate
#' @template InlineChoiceSlotsTemplate
#' @include Gap.R
#' @examples
#' dd <- new("InlineChoice",
#'           response_identifier = "id_gap_1234",
#'           points = 1,
#'           choices =  c("answer1", "answer2", "answer3"),
#'           solution_index = 1,
#'           choices_identifiers = c("OptionA", "OptionB", "OptionC"),
#'           shuffle = TRUE)
#' @seealso [Entry], [NumericGap], [TextGap], [TextGapOpal]
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
             if (!any(is.character(object@choices), is.numeric(object@choices))) {
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

#'Create object [InlineChoice]
#'
#'@param choices A character vector containing the answers shown in the dropdown
#'  list.
#'@param solution_index A numeric value, optional, representing the index of the
#'  correct answer in the options vector. Default is 1.
#'@param response_identifier A character value representing an identifier for
#'  the answer. By default, it is generated as 'id_gap_dddd', where dddd
#'  represents random digits.
#'@param choices_identifiers A character vector, optional, containing a set of
#'  identifiers for answers. By default, identifiers are generated automatically
#'  according to the template "OptionD", where D is a letter representing the
#'  alphabetical order of the answer in the list.
#'@param points A numeric value, optional, representing the number of points for
#'  this gap. Default is 1
#'@param shuffle A boolean value, optional, determining whether to randomize the
#'  order in which the choices are initially presented to the candidate. Default
#'  is `TRUE`.
#'@param placeholder A character value, optional, responsible for placing
#'  helpful text in the text input field in the content delivery engine.
#'@param expected_length A numeric value, optional, responsible for setting the
#'  size of the text input field in the content delivery engine.
#'@return An object of class [InlineChoice]
#'@seealso [entry()][numericGap()][textGap()][textGapOpal()]
#' @examples
#'dd_min <- inlineChoice(c("answer1", "answer2", "answer3"))
#'
#'dd <- inlineChoice(choices = c("answer1", "answer2", "answer3"),
#'                   solution_index = 2,
#'                   response_identifier  = "id_gap_1234",
#'                   choices_identifiers = c("a", "b", "c"),
#'                   points = 2,
#'                   shuffle = FALSE,
#'                   placeholder = "answers",
#'                   expected_length = 10)
#'@export
inlineChoice <- function(choices,
                         solution_index = 1,
                         response_identifier = character(0),
                         choices_identifiers = character(0),
                         points = 1,
                         shuffle = TRUE,
                         placeholder = character(0),
                         expected_length = numeric(0)){
    params <- as.list(environment())
    params$Class <- "InlineChoice"
    obj <- do.call("new", params)
    return(obj)
}

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
