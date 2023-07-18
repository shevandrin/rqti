#' Class "MultipleChoice"
#'
#' Abstract class `MuiltipleChoice` is responsible for creating multiple choice
#' assessment task according to QTI 2.1.
#' @template ContentSlotTemplate
#' @template AISlotsTemplate
#' @template ChoiceSlotsTemplate
#' @template MCSlotsTemplate
#' @template NoteTasksTemplate
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
setClass("MultipleChoice", contains = "Choice")

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

#' @rdname getPoints-methods
#' @aliases getPoints,MultipleChoice
setMethod("getPoints", signature(object = "MultipleChoice"),
          function(object) {
              return(sum(object@points))
          })

# helpers
create_item_body_multiplechoice <- function(object) {
    create_item_body_choice(object, max_choices = 0)
}

create_response_declaration_multiple_choice <- function(object) {
    correct_choice_identifier <- object@choice_identifiers[object@points > 0]
    correct_response <- create_correct_response(correct_choice_identifier)
    mapping <- create_mapping(object)
    tag("responseDeclaration", list(identifier = "RESPONSE",
                                    cardinality = "multiple",
                                    baseType = "identifier",
                                    correct_response, mapping))
}

create_outcome_declaration_multiple_choice <- function(object) {
    max_score <- sum(object@points[object@points > 0])
    make_outcome_declaration("MAXSCORE", value = max_score)
}
