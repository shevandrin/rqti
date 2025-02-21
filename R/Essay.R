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
    if (length(.Object@data_allow_paste) > 0 & interactive()) {
        warning("The data_allow_paste property only works on LMS Opal and OpenOlat.",
                call. = FALSE)
    }

    if (length(.Object@words_max) == 0) .Object@words_max <- max_words(.Object@feedback)
    if (length(.Object@expected_length) == 0) .Object@expected_length <- length_expected(.Object@feedback)
    if (length(.Object@expected_lines) == 0) .Object@expected_lines <- lines_expected(.Object@feedback)

    .Object@expected_length <- replace_na(.Object@expected_length)
    .Object@expected_lines <- replace_na(.Object@expected_lines)
    .Object@words_max <- replace_na(.Object@words_max)
    .Object@words_min <- replace_na(.Object@words_min)

    validObject(.Object)
    .Object
})

#'Create object [Essay]
#'
#'@param identifier A character representing the unique identifier of the
#'  assessment task. By default, it is generated as 'id_task_dddd', where dddd
#'  represents random digits.
#'@param title A character representing the title of the XML file associated
#'  with the task. By default, it takes the value of the identifier.
#'@param content A character string or a list of character strings to form the
#'   text of the question, which may include HTML tags.
#'@param prompt An optional character representing a simple question text,
#'  consisting of one paragraph. This can supplement or replace content in the
#'  task. Default is "".
#'@param points A numeric value, optional, representing the number of points for
#'  the entire task. Default is 1.
#'@param feedback A list containing feedback message-object [ModalFeedback] for
#'  candidates.
#'@param expected_length A numeric, optional. Responsible for setting the size
#'  of the text input field in the content delivery engine. By default it will
#'  be calculated according to model answer in the slot `content` of
#'  `ModalFeedback`.
#'@param expected_lines A numeric, optional. Responsible for setting the number
#'  of rows of the text input field in the content delivery engine. By default
#'  it will be calculated according to model answer in the slot `content` of
#'  `ModalFeedback`.
#'@param words_max A numeric, optional. Responsible for setting the maximum
#'  number of words that a candidate can write in the text input field. By
#'  default it will be calculated according to model answer in the slot
#'  `content` of `ModalFeedback`.
#'@param words_min A numeric, optional. Responsible for setting the minimum
#'  number of words that a candidate should write in the text input field.
#'@param data_allow_paste A boolean, optional. Determines whether it is possible
#'  for a candidate to copy text into the text input field. Default is FALSE.
#'@param calculator A character, optional, determining whether to show a
#'  calculator to the candidate. Possible values:
#'   * "simple"
#'   * "scientific".
#'@param files A character vector, optional, containing paths to files that will
#'  be accessible to the candidate during the test/exam.
#'@return An object of class [Essay]
#' @examples
#'es_min <- essay(content = list("<h2>Open question</h2>", "Write your answer here"))
#'
#'es <- essay(identifier = "id_task_1234",
#'            title = "Essay Task",
#'            content = "<h2>Open question</h2> Write your answer here",
#'            prompt = "Plain text, can be used instead of content",
#'            points = 2,
#'            expected_length = 100,
#'            expected_lines = 5,
#'            words_max = 100,
#'            words_min = 1,
#'            data_allow_paste = TRUE,
#'            feedback = list(new("ModalFeedback",
#'                             content = list("Model answer"))),
#'            calculator = "scientific-calculator",
#'            files = "text_book.pdf")
#'@export
essay <- function(identifier = generate_id(),
                  title = identifier,
                  content = list(),
                  prompt = "",
                  points = 1,
                  feedback = list(),
                  expected_length = length_expected(feedback),
                  expected_lines = lines_expected(feedback),
                  words_max = max_words(feedback),
                  words_min = NA_integer_,
                  data_allow_paste = FALSE,
                  calculator = NA_character_,
                  files = NA_character_) {
    params <- as.list(environment())
    if (is.character(params$content)) params$content <- list(params$content)
    params$Class <- "Essay"
    obj <- do.call("new", params)
    return(obj)
}

#' @rdname createItemBody-methods
#' @aliases createItemBody,Essay
setMethod("createItemBody", signature(object = "Essay"),
          function(object) {
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
