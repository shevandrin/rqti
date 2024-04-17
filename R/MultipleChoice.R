#' Class "MultipleChoice"
#'
#' Class `MultipleChoice` is responsible for creating multiple choice
#' assessment task according to QTI 2.1.
#' @template AISlotsTemplate
#' @template ChoiceSlotsTemplate
#' @examples
#' mc <- new("MultipleChoice",
#'           identifier = "id_task_1234",
#'           title = "Multiple Choice Task",
#'           content = list("<p>Pick up the right options</p>"),
#'           prompt = "Plain text, can be used instead of content",
#'           points = c(1, -1, 1, -1),
#'           feedback = list(new("WrongFeedback", content = list("Wrong answer"))),
#'           calculator = "scientific-calculator",
#'           files = "text_book.pdf",
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

#' Create object [MultipleChoice]
#'
#' @param identifier A character representing the unique identifier of the
#'   assessment task. By default, it is generated as 'id_task_dddd', where dddd
#'   represents random digits.
#' @param title A character representing the title of the XML file associated
#'   with the task. By default, it takes the value of the identifier.
#' @param choices A character vector defining a set of answer options in the
#'   question.
#' @param choice_identifiers A character vector, optional, containing a set of
#'   identifiers for answers. By default, identifiers are generated
#'   automatically according to the template "ChoiceD", where D is a letter
#'   representing the alphabetical order of the answer in the list.
#' @param content A list of character content to form the text of the question,
#'   which can include HTML tags.
#' @param prompt An optional character representing a simple question text,
#'   consisting of one paragraph. This can supplement or replace content in the
#'   task. Default is "".
#' @param points A numeric vector, required. Each number in this vector
#'   determines the number of points that will be awarded to a candidate if they
#'   select the corresponding answer. The order of the scores must match the
#'   order of the choices. It is possible to assign negative values to incorrect
#'   answers. All answers with a positive score are considered correct.
#' @param feedback A list containing feedback messages for candidates. Each
#'   element of the list should be an instance of either [ModalFeedback],
#'   [CorrectFeedback], or [WrongFeedback] class.
#' @param orientation A character, determining whether to place answers in
#'   vertical or horizontal mode. Possible values:
#'   * "vertical" - Default,
#'   * "horizontal".
#' @param shuffle A boolean value indicating whether to randomize the order in
#'   which the choices are initially presented to the candidate. Default is
#'   `TRUE.`
#' @param calculator A character, optional, determining whether to show a
#'   calculator to the candidate. Possible values:
#'   * "simple-calculator"
#'   * "scientific-calculator".
#' @param files A character vector, optional, containing paths to files that
#'   will be accessible to the candidate during the test/exam.
#' @return An object of class [MultipleChoice]
#' @examples
#'mc_min <- multipleChoice(choices = c("option1", "option2", "option3"),
#'                         points = c(0, 0.5, 0.5))
#'
#'mc <- multipleChoice(identifier = "id_task_1234",
#'                    title = "Multiple Choice Task",
#'                    content = list("<p>Pick up the right options</p>"),
#'                    prompt = "Plain text, can be used instead of content",
#'                    points = c(0, 0.5, 0.5),
#'                    feedback = list(new("WrongFeedback",
#'                                    content = list("Wrong answer"))),
#'                    calculator = "scientific-calculator",
#'                    files = "text_book.pdf",
#'                    choices = c("option 1", "option 2", "option 3"),
#'                    choice_identifiers = c("ChoiceA", "ChoiceB", "ChoiceC"),
#'                    shuffle = TRUE,
#'                    orientation = "vertical")
#'
#' @export
multipleChoice <- function(identifier = character(0),
                         title = character(0),
                         choices,
                         choice_identifiers = character(0),
                         content = list(),
                         prompt = "",
                         points = 1,
                         feedback = list(),
                         orientation = "vertical",
                         shuffle = TRUE,
                         calculator = character(0),
                         files = character(0)) {
    params <- as.list(environment())
    params$Class <- "MultipleChoice"
    obj <- do.call("new", params)
    return(obj)
}

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
