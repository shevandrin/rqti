#' Class "Essay"
#'
#' Class `Essay` is responsible for creating essay type of assessment
#' task according to QTI 2.1.
#' @template AISlotsTemplate
#' @template EssaySlotsTemplate
#' @note If 'ModalFeedback' is given, default values for slots related to the
#'   text input field are calculated automatically.
#' @examples
#' es <- new("Essay",
#'           identifier = "id_task_1234",
#'           title = "Essay Task",
#'           content = list("<p>Develop some idea and write it down in
#'                                   the text field</p>"),
#'           prompt = "Write your answer in text field",
#'           points = 1,
#'           feedback = list(),
#'           calculator = "scientific-calculator",
#'           files = "text_book.pdf",
#'           expected_length = 100,
#'           expected_lines = 5,
#'           words_max = 200,
#'           words_min = 10,
#'           data_allow_paste = FALSE)
#' @name Essay-class
#' @rdname Essay-class
#' @aliases Essay
#' @include AssessmentItem.R
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
        warning("The data_allow_paste property only works on LMS Opal.",
                call. = FALSE)
    }

    if (length(.Object@feedback) == 1) {
        answer_str <- paste(.Object@feedback[[1]]@content, collapse = " ")
        nwords <- length(unlist(strsplit(answer_str, "\\s+")))
        # set default max count of words
        if (length(.Object@words_max) == 0) .Object@words_max <- nwords * 2
        # set default size as expected length parameter
        n_characters <- 6*nwords
        if (length(.Object@expected_length) == 0) {
            if (n_characters < 150) {
            .Object@expected_length <- n_characters
            .Object@expected_lines <- 1 }
            if (n_characters > 150) {
                .Object@expected_length <- 150
                .Object@expected_lines <- round(n_characters/150)+2}
        }
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

