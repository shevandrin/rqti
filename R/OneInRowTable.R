# define class OneInRowTable to specify match table that supports
# choosing one option in each row, but many in each column

setClass("OneInRowTable", contains = "MatchTable")

#' @rdname createItemBody-methods
#' @aliases createItemBody,OneInRowTable
setMethod("createItemBody",  "OneInRowTable", function(object) {
    create_item_body_match_table(object, 1, 2)
})
