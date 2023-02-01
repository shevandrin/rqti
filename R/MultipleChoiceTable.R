# define class MultipleChoiceTable to specify match table that supports
# choosing many options in rows and columns
#' @importFrom stats setNames
setClass("MultipleChoiceTable", contains = "MatchTable",
         slots = list(mapping = "numeric"))

# constructor
setMethod("initialize", "MultipleChoiceTable", function(.Object, ...) {
    .Object <- callNextMethod()
    number_wrong_options <- length(.Object@rows) * length(.Object@cols) - length(.Object@answers_identifiers)
    wrong_scores <- - sum(.Object@answers_scores) / number_wrong_options
    ids <- make_ids_collacations(.Object@rows_identifiers, .Object@cols_identifiers)
    ordered_ids <- c(.Object@answers_identifiers, setdiff(ids, .Object@answers_identifiers))
    .Object@mapping <- c(.Object@answers_scores, rep(wrong_scores, number_wrong_options))
    .Object@mapping <- setNames(.Object@mapping, ordered_ids)
    validObject(.Object)
    .Object
})

#' @rdname createItemBody-methods
#' @aliases createItemBody,MultipleChoiceTable
setMethod("createItemBody",  "MultipleChoiceTable", function(object) {
    create_item_body_match_table(object,
                                 length(object@cols),
                                 length(object@rows))
})

#' @rdname createResponseDeclaration-methods
#' @aliases createResponseDeclaration,MultipleChoiceTable
setMethod("createResponseDeclaration", "MultipleChoiceTable", function(object) {
    create_response_declaration_match_table2(object)
})

create_response_declaration_match_table2 <- function(object) {
    corr_response <- create_correct_response(object@answers_identifiers)
    map_entries <- Map(create_map_entry, object@mapping, names(object@mapping))
    mapping <- tag("mapping", list(defaultValue = 0, map_entries))
    tag("responseDeclaration", list(identifier = "RESPONSE",
                                    cardinality = "multiple",
                                    baseType = "directedPair",
                                    tagList(corr_response, mapping)))
}

make_ids_collacations <- function(x, y){
    res = c()
    for (i in x) {
        for (j in y) {
            res <- c(res, paste(i, j))
        }
    }
    res
}
