#' Class "TextGap"
#'
#' Class `TextGap` is responsible for creating instances of input
#' fields with text type of answers in question [Entry] type assessment tasks
#' according to the QTI 2.1 standard.
#' @template GapSlotsTemplate
#' @template TextGapSlotsTemplate
#' @seealso [Entry], [NumericGap], [TextGapOpal] and [InlineChoice].
#' @examples
#' tg <- new("TextGap",
#'           response_identifier = "id_gap_1234",
#'           points = 2,
#'           placeholder = "do not put special characters",
#'           expected_length = 20,
#'           solution = c("answer", "answerr", "aanswer"),
#'           case_sensitive = FALSE)
#' @name TextGap-class
#' @rdname TextGap-class
#' @aliases TextGap
#' @include Gap.R
#' @importFrom htmltools tag p span tagList tagAppendChildren
setClass("TextGap", contains = "Gap",
         slots = c(solution = "character",
                   case_sensitive = "logical"),
         prototype = prototype(case_sensitive = FALSE))

setMethod("initialize", "TextGap", function(.Object,...){
    .Object <- callNextMethod()

    if (length(.Object@expected_length) == 0) {
        .Object@expected_length <- size_gap(.Object@solution)
    }

    validObject(.Object)
    .Object
})

#'Create object [TextGap]
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
#'@return An object of class [TextGap]
#'@seealso [entry()][numericGap()][textGapOpal()]
#' @examples
#'tg_min <- textGap("answer")
#'
#'tg <- textGap(solution = "answer",
#'              response_identifier  = "id_gap_1234",
#'              points = 2,
#'              placeholder = "put your answer here",
#'              expected_length = 20,
#'              case_sensitive = TRUE)
#' @rdname textGap_doc
#'@export
textGap <- function(solution,
                    response_identifier = generate_id(type = "gap"),
                    points = 1,
                    placeholder = "",
                    expected_length = NA_integer_,
                    case_sensitive = FALSE){
    params <- as.list(environment())
    params$Class <- "TextGap"
    obj <- do.call("new", params)
    return(obj)
}

#' @rdname textGap_doc
#' @export
gapText <- textGap

#' @rdname getResponse-methods
#' @aliases getResponse,TextGap
setMethod("getResponse", "TextGap", function(object) {
    object
})

#' @rdname createResponseDeclaration-methods
#' @aliases createResponseDeclaration,TextGap
setMethod("createResponseDeclaration", "TextGap", function(object) {
    create_response_declaration_text_entry(object)
})

create_response_declaration_text_entry <- function(object) {
    response <- create_correct_response(object@solution[1])
    mapping <- create_mapping_gap(object)
    children <- tagList(response, mapping)
    tag("responseDeclaration", list(identifier = object@response_identifier,
                                    cardinality = "single",
                                    baseType = "string", children))
}

