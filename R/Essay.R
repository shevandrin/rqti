#' Title
#'
#' @export
#'
setClass("Essay", contains = "AssessmentItem",
         slots = c(expectedLength = "numeric",
                   expectedLines = "numeric",
                   maxStrings = "numeric",
                   minStrings = "numeric",
                   dataAllowPaste = "logical"),
         prototype = prototype(dataAllowPaste = FALSE))

#' @rdname createItemBody-methods
#' @aliases createItemBody,Essay
setMethod("createItemBody",  "Essay", function(object) {
    create_item_body_essay(object)
})
