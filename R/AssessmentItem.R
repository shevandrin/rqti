# define general class choice (at some point should contain a more abstract class "exercise")
#' @importFrom ids adjective_animal
#' @include Text.R

setClass("AssessmentItem", slots = c(text = "Text", points = "numeric",
                                     title = "character",
                                     identifier = "character",
                                     qti_version = "character"),
         prototype = prototype(points = 1,
                               identifier = ids::adjective_animal(),
                               qti_version = "v2p1"
                               ))

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

#' @export
setGeneric("createResponseProcessing", function(object) {
    standardGeneric("createResponseProcessing")
})

setMethod("createResponseProcessing", signature(object = "AssessmentItem"),
          function(object) {
})

setMethod("createResponseDeclaration", signature(object = "AssessmentItem"),
          function(object) {
})

setMethod("createOutcomeDeclaration", signature(object = "AssessmentItem"),
          function(object) {
              tagList(make_outcome_declaration("SCORE", value = object@points),
                      make_outcome_declaration("MAXSCORE", value = object@points))
          })
