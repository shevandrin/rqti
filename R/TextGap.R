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
                   solution_variable = "character",
                   case_sensitive = "logical"),
         prototype = prototype(case_sensitive = FALSE))

validate_text_solution <- function(object) {
    reference <- object@solution_variable
    errors <- character()
    if (length(reference)) {
        if (length(reference) != 1L || anyNA(reference) ||
            !check_identifier(reference, quiet = TRUE)) {
            errors <- c(errors, "solution_variable must be a single valid QTI identifier.")
        }
        if (length(object@solution)) {
            errors <- c(errors, "Specify either solution or solution_variable, not both.")
        }
        if (length(object@case_sensitive) != 1L || anyNA(object@case_sensitive)) {
            errors <- c(errors, "case_sensitive must be TRUE or FALSE.")
        }
        if (is(object, "TextGapOpal") &&
            (length(object@tolerance) != 1L || anyNA(object@tolerance) ||
             object@tolerance != 0)) {
            errors <- c(errors, "Dynamic text answers do not support spelling tolerance; use tolerance = 0.")
        }
    }
    if (length(errors)) stop(paste(errors, collapse = " "), call. = FALSE)
    invisible(TRUE)
}

setMethod("initialize", "TextGap", function(.Object,...){
    .Object <- callNextMethod()
    validate_text_solution(.Object)

    el <- .Object@expected_length
    if (any(is.na(el)) || length(el) == 0) {
        .Object@expected_length <- if (length(.Object@solution_variable)) {
            10
        } else {
            size_gap(.Object@solution)
        }
    }

    validObject(.Object)
    .Object
})

#'Create object [TextGap]
#'
#'@param solution A character vector containing the values considered as correct
#'  answers. Omit when using `solution_variable`.
#'@param solution_variable An optional QTI identifier of a `string` template
#'  variable used as the correct answer. Cannot be combined with `solution`.
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
#'@return An object of class [TextGap]
#'@seealso [entry()][numericGap()][textGapOpal()]
#' @examples
#'tg_min <- textGap("answer")
#'dynamic_gap <- textGap(solution_variable = "answer")
#'
#'tg <- textGap(solution = "answer",
#'              response_identifier  = "id_gap_1234",
#'              points = 2,
#'              placeholder = "put your answer here",
#'              expected_length = 20,
#'              case_sensitive = TRUE)
#' @rdname textGap_doc
#'@export
textGap <- function(solution = character(),
                    response_identifier = generate_id(type = "gap"),
                    points = 1,
                    placeholder = "",
                    expected_length = if (length(solution_variable)) 10 else size_gap(solution),
                    case_sensitive = FALSE, solution_variable = character()){
    if (missing(solution) && !length(solution_variable)) {
        stop("Provide solution or solution_variable.", call. = FALSE)
    }
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
    validObject(object)
    validate_text_solution(object)
    response <- mapping <- NULL
    if (!length(object@solution_variable)) {
        response <- create_correct_response(object@solution[1])
        mapping <- create_mapping_gap(object)
    }
    children <- tagList(response, mapping)
    tag("responseDeclaration", list(identifier = object@response_identifier,
                                    cardinality = "single",
                                    baseType = "string", children))
}

#' @rdname createResponseProcessing-methods
#' @aliases createResponseProcessing,TextGap
setMethod("createResponseProcessing", "TextGap", function(object) {
    if (length(object@solution_variable)) {
        create_response_processing_dynamic_text(object)
    } else {
        create_response_processing_gap_basic(object)
    }
})
