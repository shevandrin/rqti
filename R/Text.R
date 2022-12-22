# define class Text for formatting a text of question
#' @importFrom htmltools tag p span HTML

setClass("Text", slots = c(content = "list"))

#' Compose a set of html elements to display question in qti-xml document
#'
#' Generic function for creating a set of html elements to display question for
#' XML document of specification the question following the QTI schema v2.1
#'
#' @param object an instance of the S4 object (Gap, InlineChoice, character)
#' @docType methods
#' @rdname createText-methods
#'
#' @export
setGeneric("createText", function(object) {
    standardGeneric("createText")
})

#' @rdname createText-methods
#' @aliases createText,character
setMethod("createText", "character", function(object) {
    HTML(object)
})
