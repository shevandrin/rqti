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

#' @rdname createResponseProcessing-methods
#' @aliases createResponseProcessing,TextGapOpal
setMethod("createResponseProcessing", "TextGapOpal", function(object) {
    create_response_processing_text_entry_opal(object)
})
