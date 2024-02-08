#' Class "MultipleChoice"
#'
#' Class `MultipleChoice` is responsible for creating multiple choice
#' assessment task according to QTI 2.1.
#' @template AISlotsTemplate
#' @template ChoiceSlotsTemplate
#' @examples
#' sc <- new("MultipleChoice",
#'           identifier = "id_task_1234",
#'           title = "Multiple Choice Task",
#'           content = list("<p>Pick up the right options</p>"),
#'           prompt = "Plain text, can be used instead of content",
#'           points = c(1, -1, 1, -1),
#'           feedback = list(new("WrongFeedback", content = list("Wrong answer")),
#'           qti_version = "v2p1"),
#'           calculator = "scientific-calculator",
#'           files = "text_book.pdf",
#'           qti_version = "v2p1",
#'           choices = c("option 1", "option 2", "option 3", "option 4"),
#'           choice_identifiers = c("ChoiceA", "ChoiceB", "ChoiceC", "ChoiceD"),
#'           shuffle = TRUE,
#'           orientation = "vertical")
#' @name MultipleChoice-class
#' @rdname MultipleChoice-class
#' @aliases MultipleChoice
#' @include AssessmentItem.R Choice.R
#' @exportClass MultipleChoice
#' @import methods
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

#' @rdname getPoints-methods
#' @aliases getPoints,MultipleChoice
setMethod("getPoints", signature(object = "MultipleChoice"),
          function(object) {
              return(sum(object@points[object@points > 0]))
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
