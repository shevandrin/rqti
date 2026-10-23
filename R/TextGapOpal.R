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
#'  answers. Omit when using `solution_variable`.
#'@param solution_variable An optional QTI identifier of a `string` template
#'  variable used as the correct answer. Requires `tolerance = 0` and cannot be
#'  combined with `solution`.
#'@param response_identifier A character value representing an identifier for
#'  the answer. By default, it is generated as 'id_gap_dddd', where dddd
#'  represents random digits.
#'@param points A numeric value, optional, representing the number of points for
#'  this gap. Default is 1
#'@param placeholder A character value, optional, used to place
#'  helpful text in the text input field in the content delivery engine. Default
#'  is "".
#'@param expected_length A numeric value, optional, used to set the
#'  size of the text input field in the content delivery engine. Default value
#'  is adjusted by solution size, or 10 for a dynamic answer.
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
#' @rdname textGapOpal_doc
#'@export
textGapOpal <- function(solution = character(),
                    response_identifier = generate_id(type = "gap"),
                    points = 1,
                    placeholder = "",
                    expected_length = if (length(solution_variable)) 10 else size_gap(solution),
                    case_sensitive = FALSE,
                    tolerance = 0, solution_variable = character()){
    if (missing(solution) && !length(solution_variable)) {
        stop("Provide solution or solution_variable.", call. = FALSE)
    }
    params <- as.list(environment())
    params$Class <- "TextGapOpal"
    obj <- do.call("new", params)
    return(obj)
}

#' @rdname textGapOpal_doc
#' @export
gapTextOpal <- textGapOpal

#' @rdname createResponseProcessing-methods
#' @aliases createResponseProcessing,TextGapOpal
setMethod("createResponseProcessing", "TextGapOpal", function(object) {
    if (length(object@solution_variable)) {
        create_response_processing_dynamic_text(object)
    } else {
        create_response_processing_text_entry_opal(object)
    }
})
