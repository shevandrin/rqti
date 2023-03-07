#' Class "Essay"
#'
#' Abstract class `Essay` is responsible for creating essay type of assessment
#' task according to QTI 2.1.
#' @template AISlotsTemplate
#' @template EssaySlotsTemplate
#' @examples
#' es <- new("Essay", content = list("<p>Devolop some idea and write it down in
#'                                   the text field</p>"),
#'           title = "essay_example",
#'           max_strings = 100,
#'           points = 3)
#' @name Essay-class
#' @rdname Essay-class
#' @aliases Essay
#' @include AssessmentItem.R
#' @export
setClass("Essay", contains = "AssessmentItem",
         slots = c(expected_length = "numeric",
                   expected_lines = "numeric",
                   max_strings = "numeric",
                   min_strings = "numeric",
                   data_allow_paste = "logical"))

#' @rdname createItemBody-methods
#' @aliases createItemBody,Essay
setMethod("createItemBody",  "Essay", function(object) {
    create_item_body_essay(object)
})
