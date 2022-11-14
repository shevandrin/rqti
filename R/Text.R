# define class Text for formatting a text of question

setClass("Text", slots = c(content = "character"))

#' @export
setGeneric("createText", function(object) {
    standardGeneric("createText")
})

setMethod("createText", "Text", function(object) {
    make_question_text(object)
})

make_question_text <- function(object) {
    print(paste0(object@content, " - this is content"))
}
