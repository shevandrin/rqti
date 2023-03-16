#' Class "SingleChoice"
#'
#' Abstract class `SingleChoice` is responsible for creating single choice
#' assessment task according to QTI 2.1.
#' @template ContentSlotTemplate
#' @template AISlotsTemplate
#' @template ChoiceSlotsTemplate
#' @template SCSlotsTemplate
#' @template PointsSlotTemplate
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

#' Create object of "[SingleChoice-class]" class
#'
#' @param identifier a character string; some identifier of question
#' @param title a character string; some title of question
#' @param choices a character vector; set of possible answers; by default the
#'   first one is considered as a right response
#' @param choice_identifiers a character vector, optional; set of identifiers of
#'   answer options; can be assigned automatically
#' @param solution a number, optional; the index of the right answer in vector
#'   of choices
#' @param content a list of character items; this character items should be
#'   formatted text that combines question/task description
#' @param points a number, optional; the number of points for the right answer
#' @param shuffle logical, optional; option to mix answer options up, default
#'   'TRUE'
#' @param prompt a character string, optional; text question in one paragraph,
#'   alternative to 'text' parameter
#' @param orientation a character string with two possible values of "vertical"
#'   (default) or "horizontal" placement of answer options
#' @return an object of S4 class "[SingleChoice-class]"
#' @examples
#' sc <- singleChoice(title = "single choice task",
#'                    content = list("<p>Pick up the right option</p>"),
#'                    choices= c("option 1", "option 2", "option 3"),
#'                    identifier = "sc_example")
#'
#' @name singleChoice
#' @rdname singleChoice
#' @export
singleChoice <- function(identifier, choices,
                         title = NA_character_,
                         choice_identifiers = NA_character_,
                         solution = NA_integer_,
                         content = list(),
                         points = NA_integer_,
                         shuffle = logical(0L),
                         prompt = NA_character_,
                         orientation = NA_character_){
    new("SingleChoice",
              identifier = identifier, title = title, choices = choices,
              choice_identifiers = choice_identifiers, solution = solution,
              content = content, points = points, shuffle = shuffle, prompt = prompt,
              orientation = orientation)
}
