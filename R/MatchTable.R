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

# constructor
setMethod("initialize", "MatchTable", function(.Object, ...) {
    .Object <- callNextMethod()
    answ_count <- length(.Object@answers_identifiers)

    if (length(.Object@answers_scores) == 0) {
        score <- .Object@points / answ_count
        .Object@answers_scores  <- rep(score, answ_count)
    }

    if (is.na(.Object@points)) {
        .Object@points <- sum(.Object@answers_scores)
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
