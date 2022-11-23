# define class TextGap to specify text entries
#' @importFrom htmltools tag p span tagList tagAppendChildren

setClass("TextGap", contains = "Gap",
         slots = c(response = "character", alternatives = "character"),
         prototype = prototype(alternatives = NA_character_))

setMethod("createText", "TextGap", function(object) {
    tag("textEntryInteraction", list(responseIdentifier = object@response_identifier))
})

setMethod("getResponse", "TextGap", function(object) {
    object
})
