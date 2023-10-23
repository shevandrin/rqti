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
#'           words_max = 100,
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
                   words_max = "numeric",
                   words_min = "numeric",
                   data_allow_paste = "logical"))

setMethod("initialize", "Essay", function(.Object, ...) {
    .Object <- callNextMethod()

    # detect not general feedback to throw an error
    not_general_fb <- c("CorrectFeedback", "WrongFeedback")
    log_fb <- sapply(.Object@feedback, function(x) class(x) %in% not_general_fb)
    if (any(log_fb)) {
       stop("Only general feedback is possible for this type of task",
            call. = FALSE)
    }

    # warning for data_allow_paste
    if (length(.Object@data_allow_paste) > 0) {
        warning("The data_allow_paste property only works on LMS Opal.")
    }

    validObject(.Object)
    .Object
})

#' @rdname createItemBody-methods
#' @aliases createItemBody,Essay
setMethod("createItemBody",  "Essay", function(object) {
    create_item_body_essay(object)
})

#' @rdname createResponseDeclaration-methods
#' @aliases createResponseDeclaration,Essay
setMethod("createResponseDeclaration", signature(object = "Essay"),
          function(object) {
              tag("responseDeclaration", list(identifier = "RESPONSE",
                                              cardinality = "single",
                                              baseType = "string"))
          })

#' @rdname createResponseProcessing-methods
#' @aliases createResponseProcessing,Essay
setMethod("createResponseProcessing", signature(object = "Essay"),
          function(object) {
          })
