#' Class "OneInColTable"
#'
#' Class `OneInColTable` is responsible for creating assessment tasks according
#' to the QTI 2.1 standard with a table of answer options, where only one
#' correct answer in each column is possible.
#' @template AISlotsTemplate
#' @template MTSlotsTemplate
#' @examples
#' mt <- new("OneInColTable",
#'           identifier = "id_task_1234",
#'           title = "One in Col choice table",
#'           content = list("<p>\"One in col\" table task</p>",
#'                          "<i>table description</i>"),
#'           points = 5,
#'           rows = c("row1", "row2", "row3", "row4"),
#'           rows_identifiers = c("a", "b", "c", "d"),
#'           cols = c("alfa", "beta", "gamma"),
#'           cols_identifiers = c("k", "l", "m"),
#'           answers_identifiers = c("a k", "d l", 'd m'),
#'           shuffle = TRUE)
#' @name OneInColTable-class
#' @rdname OneInColTable-class
#' @aliases OneInColTable
#' @exportClass OneInColTable
#' @include AssessmentItem.R MatchTable.R
setClass("OneInColTable", contains = "MatchTable")

#' @rdname createItemBody-methods
#' @aliases createItemBody,OneInColTable
setMethod("createItemBody",  "OneInColTable", function(object) {
    create_item_body_match_table(object, length(object@cols), 1)
})
