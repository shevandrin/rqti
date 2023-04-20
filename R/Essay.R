#' Class "Essay"
#'
#' Abstract class `Essay` is responsible for creating essay type of assessment
#' task according to QTI 2.1.
#' @template ContentSlotTemplate
#' @template AISlotsTemplate
#' @template EssaySlotsTemplate
#' @template PointsSlotTemplate
#' @template NoteTasksTemplate
#' @examples
#' es <- new("Essay", content = list("<p>Develop some idea and write it down in
#'                                   the text field</p>"),
#'           title = "essay_example",
#'           max_strings = 100,
#'           points = 3)
#' @name Essay-class
#' @rdname Essay-class
#' @aliases Essay
#' @include AssessmentItem.R
#' @importFrom utils menu
#' @export
setClass("Essay", contains = "AssessmentItem",
         slots = c(expected_length = "numeric",
                   expected_lines = "numeric",
                   max_strings = "numeric",
                   min_strings = "numeric",
                   data_allow_paste = "logical"))
#' @export
Essay <- function(content = list(), identifier = character(),
                  title = character(), prompt = character(),
                  expected_length = numeric(), expected_lines = numeric(),
                  max_strings = numeric(), min_strings = numeric(),
                  data_allow_paste = logical(), points = numeric()) {
    new("Essay", content = content, identifier = identifier,
         title = title, prompt = prompt, expected_length = expected_length,
         expected_lines = expected_lines, max_strings = max_strings,
         min_strings = min_strings, data_allow_paste = data_allow_paste,
         points = points)
}

setMethod("initialize", "Essay", function(.Object, ...) {
    .Object <- callNextMethod()
    if (length(.Object@feedback) > 0) {
       warning("Feedback messages are not meaningful for this type of excercise"
               , immediate. = TRUE, call. = FALSE)}
    validObject(.Object)
    .Object
})

#' @rdname createItemBody-methods
#' @aliases createItemBody,Essay
setMethod("createItemBody",  "Essay", function(object) {
    create_item_body_essay(object)
})
