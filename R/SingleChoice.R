#' Class "SingleChoice"
#'
#' Class `SingleChoice` is responsible for creating single-choice assessment
#' tasks according to the QTI 2.1 standard.
#'
#' @examples
#' sc <- new("SingleChoice",
#'           identifier = "id_task_1234",
#'           title = "Single Choice Task",
#'           content = list("<p>Pick up the right option</p>"),
#'           prompt = "Plain text, can be used instead of content",
#'           points = 2,
#'           feedback = list(new("WrongFeedback", content = list("Wrong answer")),
#'           qti_version = "v2p1"),
#'           calculator = "scientific-calculator",
#'           files = "text_book.pdf",
#'           qti_version = "v2p1",
#'           choices = c("option 1", "option 2", "option 3", "option 4"),
#'           choice_identifiers = c("ChoiceA", "ChoiceB", "ChoiceC", "ChoiceD"),
#'           shuffle = TRUE,
#'           orientation = "vertical",
#'           solution = 2)
#'
#' @template AISlotsTemplate
#' @template ChoiceSlotsTemplate
#' @template SCSlotsTemplate
#' @name SingleChoice-class
#' @rdname SingleChoice-class
#' @aliases SingleChoice
#' @exportClass SingleChoice
#' @include AssessmentItem.R Choice.R
setClass("SingleChoice", contains = "Choice",
         slots = list(solution = "numeric"), prototype = list(solution = 1))

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

#' @rdname createResponseProcessing-methods
#' @aliases createResponseProcessing,SingleChoice
setMethod("createResponseProcessing", signature(object = "SingleChoice"),
          function(object) {
              create_default_resp_processing_sc(object)
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
