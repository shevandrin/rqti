#' Class "OneInRowTable"
#'
#' Class `OneInRowTable` is responsible for creating assessment tasks according
#' to the QTI 2.1 standard with a table of answer options, where only one
#' correct answer in each row is possible.
#' @template AISlotsTemplate
#' @template MTSlotsTemplate
#' @examples
#' mt <- new("OneInRowTable",
#'           identifier = "id_task_1234",
#'           title = "One in Row choice table",
#'           content = list("<p>\"One in row\" table task</p>",
#'                          "<i>table description</i>"),
#'           points = 5,
#'           rows = c("row1", "row2", "row3", "row4"),
#'           rows_identifiers = c("a", "b", "c", "d"),
#'           cols = c("alfa", "beta", "gamma"),
#'           cols_identifiers = c("k", "l", "m"),
#'           answers_identifiers = c("a k", "b l", "c l", "d m"),
#'           shuffle = TRUE)
#' @name OneInRowTable-class
#' @rdname OneInRowTable-class
#' @aliases OneInRowTable
#' @exportClass OneInRowTable
#' @include AssessmentItem.R MatchTable.R
setClass("OneInRowTable", contains = "MatchTable")

#'Create object [OneInRowTable]
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
#'  the entire task. It can also be calculated as the sum of points for
#'  individual answers, when provided. Default is 1.
#'@param rows A character vector specifying answer options defined in rows of
#'  the table.
#'@param rows_identifiers A character vector, optional, specifies identifiers of
#'  the rows of the table
#'@param cols A character vector specifying answer options defined in columns of
#'  the table.
#'@param cols_identifiers A character vector, optional, specifies identifiers of
#'  the columns of the table.
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
#'@param calculator A character, optional, determining whether to show a
#'  calculator to the candidate. Possible values:
#'   * "simple-calculator"
#'   * "scientific-calculator".
#'@param files A character vector, optional, containing paths to files that will
#'  be accessible to the candidate during the test/exam.
#'@return An object of class [OneInRowTable]
#' @examples
#' rt_min <- oneInRowTable(content = list("<p>\"One in row table\" task</p>"),
#'                        rows = c("alfa", "beta", "gamma", "alpha"),
#'                        rows_identifiers = c("a", "b", "g", "aa"),
#'                        cols = c("A", "B", "G"),
#'                        cols_identifiers = c("as", "bs", "gs"),
#'                        answers_identifiers = c("a as", "b bs", "g gs", "aa as"))
#'
#' rt <- oneInRowTable(identifier = "id_task_1234",
#'                    title = "Table with one answer per row",
#'                    content = list("<p>\"One in row table\" task</p>"),
#'                    prompt = "Plain text, can be used instead of the content",
#'                    rows = c("alfa", "beta", "gamma", "alpha"),
#'                    rows_identifiers = c("a", "b", "g", "aa"),
#'                    cols = c("A", "B", "G"),
#'                    cols_identifiers = c("as", "bs", "gs"),
#'                    answers_identifiers = c("a as", "b bs", "g gs", "aa as"),
#'                    answers_scores = c(1, 0.5, 0.1, 1),
#'                    shuffle_rows = FALSE,
#'                    shuffle_cols = TRUE)
#'@export
oneInRowTable <- function(identifier = generate_id(),
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
                          calculator = NA_character_,
                          files = NA_character_) {
    params <- as.list(environment())
    params$Class <- "OneInRowTable"
    obj <- do.call("new", params)
    return(obj)
}

#' @rdname createItemBody-methods
#' @aliases createItemBody,OneInRowTable
setMethod("createItemBody",  "OneInRowTable", function(object) {
    create_item_body_match_table(object, 1, length(object@rows))
})
