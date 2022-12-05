# define class OneInColTable to specify match table that supports
# choosing one option in each column, but many in each row

setClass("OneInColTable", contains = "MatchTable")

setMethod("createItemBody",  "OneInColTable", function(object) {
    create_item_body_match_table(object, 2, 1)
})
