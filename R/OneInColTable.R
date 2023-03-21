#' Class "OneInColTable"
#'
#' Abstract class `OneInColTable` is responsible for creating assessment task
#' according to QTI 2.1. with table of answer options, where only one right
#' answer in each colum is possible
#' \if{html}{\out{<div style="text-align:center">}\figure{oneInCol.png}{options:
#' style="width:250px;max-width:35\%;"}\out{</div>}}
#' @template ContentSlotTemplate
#' @template AISlotsTemplate
#' @template MTSlotsTemplate
#' @template PointsSlotTemplate
#' @template NoteTasksTemplate
#' @examples
#' mt <- new("OneInColTable", content = list("<p>\"One in col\" table task</p>",
#'                                                 "<i>table description</i>"),
#'           rows = c("row1", "row2", "row3", "row4"),
#'           rows_identifiers = c("a", "b", "c", "d"),
#'           cols = c("alfa", "beta", "gamma"),
#'           cols_identifiers = c("k", "l", "m"),
#'           answers_identifiers = c("a k", "d l", 'd m'),
#'           points = 5,
#'           title = "oneincol_choice_table",
#'           identifier = "oneincol_table_example")
#' @name OneInColTable-class
#' @rdname OneInColTable-class
#' @aliases OneInColTable
#' @exportClass OneInColTable
#' @include AssessmentItem.R MatchTable.R
setClass("OneInColTable", contains = "MatchTable")
#' @export
OneInColTable <- function(content = list(), identifier = character(),
                          title = character(), prompt = character(),
                          rows = character(), rows_identifiers = character(),
                          cols = character(), cols_identifiers = character(),
                          answers_identifiers = character(),
                          answers_scores = numeric(), shuffle = logical(),
                          points = numeric()) {
    new("OneInColTable", content = content, identifier = identifier,
        title = title, prompt = prompt, rows = rows,
        rows_identifiers = rows_identifiers, cols = cols,
        cols_identifiers = cols_identifiers,
        answers_identifiers = answers_identifiers,
        answers_scores = answers_scores, shuffle = shuffle, points = points)
}
#' @rdname createItemBody-methods
#' @aliases createItemBody,OneInColTable
setMethod("createItemBody",  "OneInColTable", function(object) {
    create_item_body_match_table(object, length(object@cols), 1)
})
