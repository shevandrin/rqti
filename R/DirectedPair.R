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

#' @rdname createItemBody-methods
#' @aliases createItemBody,DirectedPair
setMethod("createItemBody",  "DirectedPair", function(object) {
    if (object@orientation == "horizontal") ort <- "horizontal" else ort <- NULL
    create_item_body_match_table(object, 1, 1, 0, ort)
})
