#' Class "SingleChoice"
#'
#' Abstract class `SingleChoice` is responsible for creating single choice
#' assessment task according to QTI 2.1.
#' @template AISlotsTemplate
#' @template ChoiceSlotsTemplate
#' @template SCSlotsTemplate
#' @examples
#' sc <- new("SingleChoice",
#'           content = list("<p>Pick up the right option</p>"),
#'           choices = c("option 1", "option 2", "option 3", "option 4"),
#            orientation = "vertical",
#'           title = "single_choice_task",
#'           shuffle = FALSE,
#'           points = 2,
#'           identifier = "sc_example")
#' @name SingleChoice-class
#' @rdname SingleChoice-class
#' @aliases SingleChoice
#' @exportClass SingleChoice
#' @include AssessmentItem.R Choice.R
setClass("SingleChoice", contains = "Choice",
         slots = list(solution = "numeric"), prototype = list(solution = 1))

# constructor
setMethod("initialize", "SingleChoice", function(.Object, ...) {
    .Object <- callNextMethod()
    if (length(.Object@solution) == 0 | is.na(.Object@solution)) {
        .Object@solution <- 1}
    validObject(.Object)
    .Object
})

#' @rdname createItemBody-methods
#' @aliases createItemBody,SingleChoice
setMethod("createItemBody", signature(object = "SingleChoice"),
          function(object) {
              create_item_body_single_choice(object)
          })

#' @rdname createResponseDeclaration-methods
#' @aliases createResponseDeclaration,SingleChoice
setMethod("createResponseDeclaration", signature(object = "SingleChoice"),
          function(object) {
              create_response_declaration_single_choice(object)
          })

# actual functions
create_item_body_single_choice <- function(object) {
    create_item_body_choice(object, max_choices = 1)
}

create_response_declaration_single_choice <- function(object) {
    correct_choice_identifier <- object@choice_identifiers[object@solution]
    child <- create_correct_response(correct_choice_identifier)
    tag("responseDeclaration", list(identifier = "RESPONSE",
                                    cardinality = "single",
                                    baseType = "identifier",
                                    child))
}
