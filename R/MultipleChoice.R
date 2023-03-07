#' Class "MultipleChoice"
#'
#' Abstract class `MuiltipleChoice` is responsible for creating multiple choice
#' assessment task according to QTI 2.1.
#' @template AISlotsTemplate
#' @template ChoiceSlotsTemplate
#' @template MCSlotsTemplate
#' @examples
#' mc <- new("MultipleChoice",
#'           content = list("<p>Pick up the right options</p>"),
#'           choices = c("option 1", "option 2", "option 3", "option 4"),
#            orientation = "vertical",
#'           title = "single_choice_task",
#'           shuffle = FALSE,
#'           points = c(0.5, 0,5, 0, 0),
#'           identifier = "mc_example")
#' @name MultipleChoice-class
#' @rdname MultipleChoice-class
#' @aliases MultipleChoice
#' @include AssessmentItem.R Choice.R
#' @exportClass MultipleChoice
#' @import methods
#' @importFrom stats setNames
setClass("MultipleChoice", contains = "Choice",
         slots = list(mapping = "numeric", lower_bound = "numeric",
                      upper_bound = "numeric", default_value = "numeric",
                      maxscore = "numeric"),
         prototype = list(lower_bound = 0, default_value = 0))

# constructor
setMethod("initialize", "MultipleChoice", function(.Object, ...) {
    .Object <- callNextMethod()
    .Object@mapping <- setNames(.Object@points, .Object@choice_identifiers)
    .Object@upper_bound <- ifelse(length(.Object@upper_bound) == 0,
                                  sum(.Object@points[.Object@points > 0]),
                                  .Object@upper_bound)
    .Object@maxscore <- sum(.Object@points[.Object@points > 0])
    validObject(.Object)
    .Object
})

#' @rdname createItemBody-methods
#' @aliases createItemBody,MultipleChoice
setMethod("createItemBody", signature(object = "MultipleChoice"),
          function(object) {
              create_item_body_multiplechoice(object)
          })

#' @rdname createResponseDeclaration-methods
#' @aliases createResponseDeclaration,MultipleChoice
setMethod("createResponseDeclaration", signature(object = "MultipleChoice"),
          function(object) {
              create_response_declaration_multiple_choice(object)
          })

#' @rdname createOutcomeDeclaration-methods
#' @aliases createOutcomeDeclaration,MultipleChoice
setMethod("createOutcomeDeclaration", signature(object = "MultipleChoice"),
          function(object) {
              create_outcome_declaration_multiple_choice(object)
          })
# helpers
create_item_body_multiplechoice <- function(object) {
    create_item_body_choice(object, max_choices = 0)
}

create_response_declaration_multiple_choice <- function(object) {
    correct_choice_identifier <- names(object@mapping[object@mapping > 0])
    correct_response <- create_correct_response(correct_choice_identifier)
    mapping <- create_mapping(object)
    tag("responseDeclaration", list(identifier = "RESPONSE",
                                    cardinality = "multiple",
                                    baseType = "identifier",
                                    correct_response, mapping))
}

create_outcome_declaration_multiple_choice <- function(object) {
    make_outcome_declaration("MAXSCORE", value = object@maxscore)
}
