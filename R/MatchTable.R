#' Class "MatchTable"
#'
#' Abstract class `MatchTable` is never to be generated, only derived classes
#' OneInRowTable, OneInColTable, MultipleChoiceTable and DirectedPair are
#' meaningful.
#' @template MTSlotsTemplate
#' @slot rows_shuffle boolean, optional; shuffle possible answers in rows,
#'   default `TRUE`
#' @slot cols_shuffle boolean, optional; shuffle possible answers in columns;
#'   defalut `TRUE`
#' @inheritSection AssessmentItem-class Warning
#' @name MatchTaable-classs
#' @rdname MatchTable-class
#' @aliases MatchTable
#' @include AssessmentItem.R
setClass("MatchTable", contains = "AssessmentItem",
         slot = list(rows = "character",
                     rows_identifiers = "character",
                     cols = "character",
                     cols_identifiers = "character",
                     answers_identifiers = "character",
                     answers_scores = "numeric",
                     shuffle = "logical",
                     rows_shuffle = "logical",
                     cols_shuffle = "logical"),
         prototype = list(shuffle = TRUE, points = NA_real_,
         rows_shuffle = TRUE, cols_shuffle = TRUE))
#TODO validation number of items in answer_identifiers must be the same as answer_scores
# constructor
setMethod("initialize", "MatchTable", function(.Object, ...) {
    .Object <- callNextMethod()
    answ_count <- length(.Object@answers_identifiers)

    if (is.na(.Object@points) && length(.Object@answers_scores) == 0) {
        .Object@answers_scores  <- rep(0.5, answ_count)
    }

    if (is.na(.Object@points) && length(.Object@answers_scores) != 0) {
        .Object@points <- sum(.Object@answers_scores)
    }

    if (!is.na(.Object@points) && length(.Object@answers_scores) == 0) {
        score <- .Object@points / answ_count
        print(score)
        .Object@answers_scores  <- rep(score, answ_count)
    }

    validObject(.Object)
    .Object
})

#' @rdname createResponseDeclaration-methods
#' @aliases createResponseDeclaration,MatchTable
setMethod("createResponseDeclaration", signature(object = "MatchTable"),
          function(object) {
              create_response_declaration_match_table(object)
          })

create_response_declaration_match_table <- function(object) {
    corr_response <- create_correct_response(object@answers_identifiers)
    map_entries <- Map(create_map_entry,
                       object@answers_scores,
                       object@answers_identifiers)
    mapping <- tag("mapping", list(defaultValue = 0, map_entries))
    tag("responseDeclaration", list(identifier = "RESPONSE",
                                    cardinality = "multiple",
                                    baseType = "directedPair",
                                    tagList(corr_response, mapping)))
}
