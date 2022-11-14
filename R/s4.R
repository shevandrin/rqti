# define general class choice (at some point should contain a more abstract class "exercise")
#' @importFrom ids adjective_animal
setClass("Choice", slots = c(text = "character", choices = "character",
                             points = "numeric", title = "character",
                             identifier = "character", shuffle = "logical",
                             prompt = "character", qti_version = "character",
                             choice_identifiers = "character"),
         prototype = prototype(shuffle = TRUE,prompt = "",
                               identifier = ids::adjective_animal(), points = 1,
                               qti_version = "v2p1"))

# constructor
setMethod("initialize", "Choice", function(.Object, ...) {
    .Object <- callNextMethod()
    .Object@choice_identifiers <- paste0("Choice",
                                         LETTERS[seq(.Object@choices)])
     validObject(.Object)
    .Object
})

# define generics

#' @export
setGeneric("createItemBody", function(object) {
  standardGeneric("createItemBody")
})

#' @export
setGeneric("createResponseDeclaration", function(object) {
  standardGeneric("createResponseDeclaration")
})

#' @export
setGeneric("createOutcomeDeclaration", function(object) {
    standardGeneric("createOutcomeDeclaration")
})
