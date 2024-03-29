#' Class "MultipleChoiceTable"
#'
#' Class `MultipleChoiceTable` is responsible for creating assessment tasks
#' according to the QTI 2.1 standard with a table of answer options, where many
#' correct answers in each row and column are possible.
#' @template AISlotsTemplate
#' @template MTSlotsTemplate
#' @slot mapping Do not use directly; values are initialized automatically.
#'   This slot contains a named numeric vector of points, where names correspond
#'   to all possible combinations of row and column identifiers.
#' @examples
#' mt <- new("MultipleChoiceTable",
#'           identifier = "id_task_1234",
#'           title = "Multiple choice table",
#'           content = list("<p>Match table task</p>",
#'                          "<i>table description</i>"),
#'           points = 5,
#'           rows = c("row1", "row2", "row3"),
#'           rows_identifiers = c("a", "b", "c"),
#'           cols = c("alfa", "beta", "gamma"),
#'           cols_identifiers = c("a", "b", "c"),
#'           answers_identifiers = c("a a", "b b", "b c"),
#'           shuffle = TRUE)
#' @name MultipleChoiceTable-class
#' @rdname MultipleChoiceTable-class
#' @aliases MultipleChoiceTable
#' @exportClass MultipleChoiceTable
#' @include AssessmentItem.R MatchTable.R
#' @importFrom stats setNames
setClass("MultipleChoiceTable", contains = "MatchTable",
         slots = list(mapping = "numeric"))

#'Create object [MultipleChoiceTable]
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
#'@return An object of class [MultipleChoiceTable]
#' @examples
#' mt_min <- multipleChoiceTable(content = list("<p>\"Multiple choice table\" task</p>"),
#'                        rows = c("alfa", "beta", "gamma", "alpha"),
#'                        rows_identifiers = c("a", "b", "g", "aa"),
#'                        cols = c("A", "B", "G", "a"),
#'                        cols_identifiers = c("as", "bs", "gs", "aas"),
#'                        answers_identifiers = c("a as", "b bs", "g gs", "aa as", "a aas", "aa aas"))
#'
#' mt <- multipleChoiceTable(identifier = "id_task_1234",
#'                    title = "Table with many possible answers in rows and cols",
#'                    content = list("<p>\"Multiple choice table\" task</p>"),
#'                    prompt = "Plain text, can be used instead of the content",
#'                    rows = c("alfa", "beta", "gamma", "alpha"),
#'                    rows_identifiers = c("a", "b", "g", "aa"),
#'                    cols = c("A", "B", "G", "a"),
#'                    cols_identifiers = c("as", "bs", "gs", "aas"),
#'                    answers_identifiers = c("a as", "b bs", "g gs", "aa as", "a aas", "aa aas"),
#'                    answers_scores = c(1, 0.5, 0.1, 1, 0.5, 1),
#'                    shuffle_rows = FALSE,
#'                    shuffle_cols = TRUE)
#'@export
multipleChoiceTable <- function(identifier = character(0),
                          title = character(0),
                          content = list(),
                          prompt = "",
                          points = 1,
                          rows,
                          rows_identifiers,
                          cols,
                          cols_identifiers,
                          answers_identifiers,
                          answers_scores = numeric(0),
                          shuffle = TRUE,
                          shuffle_rows = TRUE,
                          shuffle_cols = TRUE,
                          feedback = list(),
                          calculator = character(0),
                          files = character(0)) {
    params <- as.list(environment())
    params$Class <- "MultipleChoiceTable"
    obj <- do.call("new", params)
    return(obj)
}

setMethod("initialize", "MultipleChoiceTable", function(.Object, ...) {
    .Object <- callNextMethod()
    number_wrong_options <- length(.Object@rows) * length(.Object@cols) -
        length(.Object@answers_identifiers)
    wrong_scores <- - sum(.Object@answers_scores) / number_wrong_options
    ids <- make_ids_collacations(.Object@rows_identifiers,
                                 .Object@cols_identifiers)
    ordered_ids <- c(.Object@answers_identifiers,
                     setdiff(ids, .Object@answers_identifiers))
    .Object@mapping <- c(.Object@answers_scores, rep(wrong_scores,
                                                     number_wrong_options))
    .Object@mapping <- setNames(.Object@mapping, ordered_ids)
    validObject(.Object)
    .Object
})

#' @rdname createItemBody-methods
#' @aliases createItemBody,MultipleChoiceTable
setMethod("createItemBody",  "MultipleChoiceTable", function(object) {
    create_item_body_match_table(object,
                                 length(object@cols),
                                 length(object@rows))
})

#' @rdname createResponseDeclaration-methods
#' @aliases createResponseDeclaration,MultipleChoiceTable
setMethod("createResponseDeclaration", "MultipleChoiceTable", function(object) {
    create_response_declaration_match_table2(object)
})

create_response_declaration_match_table2 <- function(object) {
    corr_response <- create_correct_response(object@answers_identifiers)
    map_entries <- Map(create_map_entry, object@mapping, names(object@mapping))
    mapping <- tag("mapping", list(defaultValue = 0, map_entries))
    tag("responseDeclaration", list(identifier = "RESPONSE",
                                    cardinality = "multiple",
                                    baseType = "directedPair",
                                    tagList(corr_response, mapping)))
}

make_ids_collacations <- function(x, y){
    res = c()
    for (i in x) {
        for (j in y) {
            res <- c(res, paste(i, j))
        }
    }
    res
}
