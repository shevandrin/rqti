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

#' Create object [SingleChoice]
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
#' @param solution A numeric value, optional. Represents the index of the
#'   correct answer in the choices slot. By default, the first item in the
#'   choices slot is considered the correct answer. Default is 1.
#' @param content A list of character content to form the text of the question,
#'   which can include HTML tags.
#' @param prompt An optional character representing a simple question text,
#'   consisting of one paragraph. This can supplement or replace content in the
#'   task. Default is "".
#' @param points A numeric value, optional, representing the number of points
#'   for the entire task. Default is 1.
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
#' @return An object of class [SingleChoice]
#' @examples
#' sc_min <- singleChoice(prompt = "Question?",
#'                        choices = c("Answer1", "Answer2", "Answer3"))
#'
#' sc <- singleChoice(identifier = "id_task_1234",
#'                    title = "Single Choice Task",
#'                    content = list("<p>Pick up the right option</p>"),
#'                    prompt = "Plain text, can be used instead of content",
#'                    points = 2,
#'                    feedback = list(new("WrongFeedback",
#'                                    content = list("Wrong answer"))),
#'                    calculator = "scientific-calculator",
#'                    files = "text_book.pdf",
#'                    choices = c("option 1", "option 2", "option 3"),
#'                    choice_identifiers = c("ChoiceA", "ChoiceB", "ChoiceC"),
#'                    shuffle = TRUE,
#'                    orientation = "vertical",
#'                    solution = 2)
#'
#' @export
singleChoice <- function(identifier = generate_id(),
                         title = identifier,
                         choices,
                         choice_identifiers = paste0("Choice", LETTERS[seq(choices)]),
                         solution = 1,
                         content = list(),
                         prompt = "",
                         points = 1,
                         feedback = list(),
                         orientation = "vertical",
                         shuffle = TRUE,
                         calculator = NA_character_,
                         files = NA_character_) {
    params <- as.list(environment())
    params$Class <- "SingleChoice"
    obj <- do.call("new", params)
    return(obj)
}

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
