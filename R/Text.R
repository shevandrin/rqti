# define class Text for formatting a text of question
#' @importFrom htmltools tag p span HTML

setClass("Text", slots = c(content = "list"))

#' @export
setGeneric("createText", function(object) {
    standardGeneric("createText")
})

setMethod("createText", "character", function(object) {
    #make_question_text(object)
    HTML(object)
})


make_question_text <- function(object) {
    content <- strsplit(object@content, "\n")
    tagList(Map(p, content[[1]]))
}
