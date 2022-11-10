# define general class choice (at some point should contain a more abstract class "exercise")

setClass("choice", slots = c(text = "character", choices = "character",
                             points = "numeric", title = "character",
                             identifier = "character", shuffle = "logical",
                             prompt = "character", qti_version = "character",
                             choice_identifiers = "character"),
         prototype = prototype(shuffle = TRUE,prompt = "",
                               identifier = ids::adjective_animal(), points = 1,
                               qti_version = "v2p1"))

# constructor
setMethod("initialize", "choice", function(.Object, ...) {
    .Object <- callNextMethod()
    .Object@choice_identifiers <- paste0("Choice",
                                         LETTERS[seq(.Object@choices)])
     validObject(.Object)
    .Object
})

# define generics

#' @export
setGeneric("create_item_body", function(object) {
  standardGeneric("create_item_body")
})

#' @export
setGeneric("create_response_declaration", function(object) {
  standardGeneric("create_response_declaration")
})

#' @export
setGeneric("create_outcome_declaration", function(object) {
    standardGeneric("create_outcome_declaration")
})
