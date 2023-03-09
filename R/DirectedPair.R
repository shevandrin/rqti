#' Class "DirectedPair"
#'
#' Abstract class `DirectedPair` is responsible for creating assessment task
#' according to QTI 2.1., where a candidate has to make binary associations
#' between answer options
#' \if{html}{\out{<div style="text-align:center">}\figure{directedPair.png}{options:
#' style="width:150px;max-width:25\%;"}\out{</div>}}
#' \if{latex}{\figure{directedPair.png}{options: width=5cm}}
#' @template ContentSlotTemplate
#' @template AISlotsTemplate
#' @template MTSlotsTemplate
#' @template PointsSlotTemplate
#' @examples
#' dp <- new("DirectedPair", content = list("<p>\"Directed pairs\" task</p>"),
#'           rows = c("row1", "row2", "row3"),
#'           rows_identifiers = c("a", "b", "c"),
#'           cols = c("alfa", "beta", "gamma"),
#'           cols_identifiers = c("k", "l", "m"),
#'           answers_identifiers = c("a k", "b l", 'c m'),
#'           points = 5,
#'           title = "directed_pair",
#'           identifier = "directed_pair_example")
#' @name DirectedPair-class
#' @rdname DirectedPair-class
#' @aliases DirectedPair
#' @exportClass DirectedPair
#' @include AssessmentItem.R MatchTable.R
setClass("DirectedPair", contains = "MatchTable")

# TODO provide validation that cols is equal to rows

#' @rdname createItemBody-methods
#' @aliases createItemBody,DirectedPair
setMethod("createItemBody",  "DirectedPair", function(object) {
    create_item_body_match_table(object, 1, 1)
})
