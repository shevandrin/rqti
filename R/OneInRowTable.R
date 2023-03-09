#' Class "OneInRowTable"
#'
#' Abstract class `OneInRowTable` is responsible for creating assessment task
#' according to QTI 2.1. with table of answer options, where only one right
#' answer in each row is possible
#' \if{html}{\out{<div style="text-align:center">}\figure{oneInRow.png}{options:
#' style="width:250px;max-width:35\%;"}\out{</div>}}
#' @template ContentSlotTemplate
#' @template AISlotsTemplate
#' @template MTSlotsTemplate
#' @template PointsSlotTemplate
#' @examples
#' mt <- new("OneInRowTable", content = list("<p>\"One in row\" table task</p>",
#'                                                 "<i>table description</i>"),
#'           rows = c("row1", "row2", "row3", "row4"),
#'           rows_identifiers = c("a", "b", "c", "d"),
#'           cols = c("alfa", "beta", "gamma"),
#'           cols_identifiers = c("k", "l", "m"),
#'           answers_identifiers = c("a k", "b l", "c l", "d m"),
#'           points = 5,
#'           title = "oneinrow_choice_table",
#'           identifier = "oneinrow_table_example")
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
