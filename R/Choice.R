# define general class choice (at some point should contain a more abstract class "exercise")
#' @include AssessmentItem.R
#'
setClass("Choice", contains = "AssessmentItem",
         slots = c(choices = "character", shuffle = "logical",
                   prompt = "character", choice_identifiers = "character"),
         prototype = prototype(shuffle = TRUE, prompt = ""))

# constructor
setMethod("initialize", "Choice", function(.Object, ...) {
    .Object <- callNextMethod()
    .Object@choice_identifiers <- paste0("Choice",
                                         LETTERS[seq(.Object@choices)])
    validObject(.Object)
    .Object
})

setMethod("createResponseProcessing",  "Choice", function(object) {

})
