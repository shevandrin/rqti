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

