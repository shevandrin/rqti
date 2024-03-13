#' Class "MatchTable"
#'
#' Abstract class `MatchTable` is not meant to be instantiated directly;
#' instead, it serves as a base for derived classes such as [OneInRowTable],
#' [OneInColTable], [MultipleChoiceTable], and [DirectedPair].
#' @template AISlotsTemplate
#' @template MTSlotsTemplate
#' @seealso [OneInRowTable], [OneInColTable], [MultipleChoiceTable],
#'   [DirectedPair]
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
                shuffle_rows = "logical",
                shuffle_cols = "logical"),
    prototype = list(shuffle = TRUE,
                     points = NA_real_,
                     shuffle_rows = TRUE,
                     shuffle_cols = TRUE)
)

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
        .Object@answers_scores  <- rep(score, answ_count)
    }

    nids <- length(.Object@answers_identifiers)
    nscr <- length(.Object@answers_scores)
    if (nids != nscr) {
        stop("Error: \'answers_identifiers\' and \'answers_scores\' must have the same number of items.")
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
