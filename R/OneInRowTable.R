#' Class "OneInRowTable"
#'
#' Class `OneInRowTable` is responsible for creating assessment tasks according
#' to the QTI 2.1 standard with a table of answer options, where only one
#' correct answer in each row is possible.
#' \if{html}{\out{<div style="text-align:center">}\figure{oneInRow.png}{options:
#' style="width:250px;max-width:35\%;"}\out{</div>}}
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

#' @rdname createItemBody-methods
#' @aliases createItemBody,OneInRowTable
setMethod("createItemBody",  "OneInRowTable", function(object) {
    create_item_body_match_table(object, 1, length(object@rows))
})
