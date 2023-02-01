# define class MatchTable for building an order type question
setClass("MatchTable", contains = "AssessmentItem",
         slot = list(rows = "character",
                     rows_identifiers = "character",
                     cols = "character",
                     cols_identifiers = "character",
                     answers_identifiers = "character",
                     answers_scores = "numeric",
                     shuffle = "logical"),
         prototype = list(shuffle = TRUE))

# constructor
setMethod("initialize", "MatchTable", function(.Object, ...) {
    .Object <- callNextMethod()
    checker <- .Object@answers_scores
    if (length(checker) == 0) {
        score <- .Object@points / length(.Object@answers_identifiers)
        .Object@answers_scores  <- rep(score,
                                       length(.Object@answers_identifiers))
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
