#' Class "MultipleChoiceTable"
#'
#' Abstract class `MultipleChoiceTable` is responsible for creating assessment
#' task according to QTI 2.1. with table of answer options, where many right
#' answers in each row and column are possible
#' \if{html}{\out{<div style="text-align:center">}\figure{multipleTable.png}{options:
#' style="width:250px;max-width:35\%;"}\out{</div>}}
#' @template ContentSlotTemplate
#' @template AISlotsTemplate
#' @template MTSlotsTemplate
#' @template MCTSlotsTemplate
#' @template NoteTasksTemplate
#' @examples
#' mt <- new("MultipleChoiceTable", content = list("<p>Match table task</p>",
#'                                                 "<i>table description</i>"),
#'           rows = c("row1", "row2", "row3"),
#'           rows_identifiers = c("a", "b", "c"),
#'           cols = c("alfa", "beta", "gamma"),
#'           cols_identifiers = c("a", "b", "c"),
#'           answers_identifiers = c("a a", "b b", "b c"),
#'           points = 5,
#'           title = "multiple_choice_table",
#'           identifier = "mc_table_example")
#' @name MultipleChoiceTable-class
#' @rdname MultipleChoiceTable-class
#' @aliases MultipleChoiceTable
#' @exportClass MultipleChoiceTable
#' @include AssessmentItem.R MatchTable.R
#' @importFrom stats setNames
setClass("MultipleChoiceTable", contains = "MatchTable",
         slots = list(mapping = "numeric"))
#' @export
MultipleChoiceTable <- function(content = list(), identifier = character(),
                                title = character(), prompt = character(),
                                rows = character(), rows_identifiers = character(),
                                cols = character(), cols_identifiers = character(),
                                answers_identifiers = character(),
                                answers_scores = numeric(), shuffle = logical(),
                                points = numeric()) {
    new("MultipleChoiceTable", content = content, identifier = identifier,
        title = title, prompt = prompt, rows = rows,
        rows_identifiers = rows_identifiers, cols = cols,
        cols_identifiers = cols_identifiers,
        answers_identifiers = answers_identifiers,
        answers_scores = answers_scores, shuffle = shuffle, points = points)
}
# constructor
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
