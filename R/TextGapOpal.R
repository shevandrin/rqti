#' Class "TextGapOpal"
#'
#' Class `TextGapOpal` is responsible for creating instances of input fields
#' with text type of answers in question [Entry] type assessment tasks according
#' to the QTI 2.1 standard for LMS Opal.
#' @template GapSlotsTemplate
#' @template TextGapSlotsTemplate
#' @slot tolerance A numeric value defining how many characters will be taken
#'   into account to tolerate spelling mistakes in the evaluation of candidate
#'   answers. Default is `0`.
#' @seealso [Entry], [NumericGap], [TextGap] and [InlineChoice].
#' @examples
#' tgo <- new("TextGapOpal",
#'           response_identifier = "id_gap_1234",
#'           points = 2,
#'           placeholder = "do not put special characters",
#'           expected_length = 20,
#'           solution = "answer",
#'           case_sensitive = FALSE,
#'           tolerance = 1)
#' @name TextGapOpal-class
#' @rdname TextGapOpal-class
#' @aliases TextGapOpal
#' @include Gap.R TextGap.R
setClass("TextGapOpal", contains = "TextGap", slots = c(tolerance = "numeric"),
         prototype = prototype(tolerance = 0))

#'Create object [TextGapOpal]
#'
#'@param solution A character vector containing the values considered as correct
#'  answers.
#'@param response_identifier A character value representing an identifier for
#'  the answer. By default, it is generated as 'id_gap_dddd', where dddd
#'  represents random digits.
#'@param points A numeric value, optional, representing the number of points for
#'  this gap. Default is 1
#'@param placeholder A character value, optional, responsible for placing
#'  helpful text in the text input field in the content delivery engine.
#'@param expected_length A numeric value, optional, responsible for setting the
#'  size of the text input field in the content delivery engine.
#'@param case_sensitive A boolean value, determining whether the evaluation of
#'  the correct answer is case sensitive. Default is `FALSE`.
#'@param tolerance A numeric value defining how many characters will be taken
#'  into account to tolerate spelling mistakes in the evaluation of candidate
#'  answers. Default is 0.
#'@return An object of class [TextGapOpal]
#'@seealso [entry()][numericGap()][textGap()]
#' @examples
#'tgo_min <- textGapOpal("answer")
#'
#'tgo <- textGapOpal(solution = "answer",
#'              response_identifier  = "id_gap_1234",
#'              points = 2,
#'              placeholder = "put your answer here",
#'              expected_length = 20,
#'              case_sensitive = TRUE,
#'              tolerance = 2)
#'@export
textGapOpal <- function(solution,
                    response_identifier = character(0),
                    points = 1,
                    placeholder = character(0),
                    expected_length = numeric(0),
                    case_sensitive = FALSE,
                    tolerance = 0){
    params <- as.list(environment())
    params$Class <- "TextGapOpal"
    obj <- do.call("new", params)
    return(obj)
}

#' @rdname createResponseProcessing-methods
#' @aliases createResponseProcessing,TextGapOpal
setMethod("createResponseProcessing", "TextGapOpal", function(object) {
    create_response_processing_text_entry_opal(object)
})
