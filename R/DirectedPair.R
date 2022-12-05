# define class DitrectedPair to specify match table that supports
# choosing associations as a cuple of two options
#' @include MatchTable.R

setClass("DirectedPair", contains = "MatchTable")

# TODO provide validation that cols is equal to rows

setMethod("createItemBody",  "DirectedPair", function(object) {
    create_item_body_match_table(object, 1, 1)
})
