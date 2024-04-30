#' Class "DirectedPair"
#'
#' Class `DirectedPair` is responsible for creating assessment tasks according
#' to the QTI 2.1 standard, where a candidate has to make binary associations
#' between answer options.
#' @template AISlotsTemplate
#' @template MTSlotsTemplate
#' @slot orientation A character, optional, determining whether to place answers
#'   in vertical or horizontal mode. Possible values:
#'   * "vertical" - Default.
#'   * "horizontal"
#' @examples
#' dp <- new("DirectedPair",
#'           identifier = "id_task_1234",
#'           title = "Directed pair",
#'           content = list("<p>\"Directed pairs\" task</p>"),
#'           points = 5,
#'           rows = c("row1", "row2", "row3"),
#'           rows_identifiers = c("a", "b", "c"),
#'           cols = c("alfa", "beta", "gamma"),
#'           cols_identifiers = c("k", "l", "m"),
#'           answers_identifiers = c("a k", "b l", 'c m'),
#'           shuffle = TRUE,
#'           orientation = "vertical")
#' @name DirectedPair-class
#' @rdname DirectedPair-class
#' @aliases DirectedPair
#' @exportClass DirectedPair
#' @include AssessmentItem.R MatchTable.R
setClass("DirectedPair", contains = "MatchTable",
         slots = c(orientation = "character"),
         prototype = prototype(orientation = "vertical"))

#'Create object [DirectedPair]
#'
#'@param identifier A character representing the unique identifier of the
#'  assessment task. By default, it is generated as 'id_task_dddd', where dddd
#'  represents random digits.
#'@param title A character representing the title of the XML file associated
#'  with the task. By default, it takes the value of the identifier.
#'@param content A list of character content to form the text of the question,
#'  which can include HTML tags.
#'@param prompt An optional character representing a simple question text,
#'  consisting of one paragraph. This can supplement or replace content in the
#'  task. Default is "".
#'@param points A numeric value, optional, representing the number of points for
#'  the entire task. Default is 1.
#'@param rows A character vector specifying answer options as the first elements
#'  in couples.
#'@param rows_identifiers A character vector, optional, specifies identifiers of
#'  the first elements in couples.
#'@param cols A character vector specifying answer options as the second
#'  elements in couples.
#'@param cols_identifiers A character vector, optional, specifies identifiers of
#'  the second elements in couples.
#'@param answers_identifiers A character vector specifying couples of
#'  identifiers that combine the correct answers.
#'@param answers_scores A numeric vector, optional, where each number determines
#'  the number of points awarded to a candidate if they select the corresponding
#'  answer. If not assigned, the individual values for correct answers are
#'  calculated from the task points and the number of correct options.
#'@param shuffle A boolean value, optional, determining whether to randomize the
#'  order in which the choices are initially presented to the candidate. Default
#'  is `TRUE.`
#'@param shuffle_rows A boolean value, optional, determining whether to
#'  randomize the order of the choices only for the first elements of the answer
#'  tuples. Default is `TRUE.`
#'@param shuffle_cols A boolean value, optional, determining whether to
#'  randomize the order of the choices only for the second elements of the
#'  answer tuples. Default is `TRUE.`
#'@param feedback A list containing feedback message-object [ModalFeedback] for
#'  candidates.
#'@param orientation A character, optional, determining whether to place answers
#'  in vertical or horizontal mode. Possible values:
#' * "vertical" - Default.
#' * "horizontal".
#'@param calculator A character, optional, determining whether to show a
#'  calculator to the candidate. Possible values:
#'   * "simple"
#'   * "scientific".
#'@param files A character vector, optional, containing paths to files that will
#'  be accessible to the candidate during the test/exam.
#'@return An object of class [DirectedPair]
#' @examples
#' dp_min <- directedPair(content = list("<p>\"Directed pairs\" task</p>"),
#'                        rows = c("alfa", "beta", "gamma"),
#'                        rows_identifiers = c("a", "b", "g"),
#'                        cols = c("A", "B", "G;"),
#'                        cols_identifiers = c("as", "bs", "gs"),
#'                        answers_identifiers = c("a as", "b bs", 'g gs'))
#'
#' dp <- directedPair(identifier = "id_task_1234",
#'                    title = "Directed Pair Task",
#'                    content = list("<p>\"Directed pairs\" task</p>"),
#'                    prompt = "Plain text, can be used instead of the content",
#'                    rows = c("alfa", "beta", "gamma"),
#'                    rows_identifiers = c("a", "b", "g"),
#'                    cols = c("A", "B", "G"),
#'                    cols_identifiers = c("as", "bs", "gs"),
#'                    answers_identifiers = c("a as", "b bs", "g gs"),
#'                    answers_scores = c(1, 0.5, 0.1),
#'                    shuffle_rows = FALSE,
#'                    shuffle_cols = TRUE,
#'                    orientation = "horizontal")
#'@export
directedPair <- function(identifier = generate_id(),
                         title = identifier,
                         content = list(),
                         prompt = "",
                         points = 1,
                         rows,
                         rows_identifiers,
                         cols,
                         cols_identifiers,
                         answers_identifiers,
                         answers_scores = NA_real_,
                         shuffle = TRUE,
                         shuffle_rows = TRUE,
                         shuffle_cols = TRUE,
                         feedback = list(),
                         orientation = "vertical",
                         calculator = NA_character_,
                         files = NA_character_) {
    params <- as.list(environment())
    params$Class <- "DirectedPair"
    obj <- do.call("new", params)
    return(obj)
}

#' @rdname createItemBody-methods
#' @aliases createItemBody,DirectedPair
setMethod("createItemBody",  "DirectedPair", function(object) {
    if (object@orientation == "horizontal") ort <- "horizontal" else ort <- NULL
    create_item_body_match_table(object, 1, 1, 0, ort)
})
