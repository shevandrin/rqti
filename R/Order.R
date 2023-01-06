# define class Order for building an order type question
setClass("Order", contains = "AssessmentItem",
         slot = list(choices = "character",
                     choices_identifiers = "character",
                     shuffle = "logical"),
         prototype = list(shuffle = TRUE))

# constructor
setMethod("initialize", "Order", function(.Object, ...) {
    .Object <- callNextMethod()
    .Object@choices_identifiers <- paste0("Choice",
                                         LETTERS[seq(.Object@choices)])
    validObject(.Object)
    .Object
})

#' @rdname createItemBody-methods
#' @aliases createItemBody,Order
setMethod("createItemBody", signature(object = "Order"),
          function(object) {
              create_item_body_order(object)
          })

#' @rdname createResponseDeclaration-methods
#' @aliases createResponseDeclaration,Order
setMethod("createResponseDeclaration", signature(object = "Order"),
          function(object) {
              create_response_declaration_order(object)
          })

#' @rdname createResponseProcessing-methods
#' @aliases createResponseProcessing,Order
setMethod("createResponseProcessing", signature(object = "Order"),
          function(object) {
              create_response_processing_order(object)
          })

create_response_declaration_order <- function(object) {
        child <- create_correct_response(object@choices_identifiers)
        tag("responseDeclaration", list(identifier = "RESPONSE",
                                        cardinality = "ordered",
                                        baseType = "identifier",
                                        child))
}

create_response_processing_order <- function(object) {
    child <- tagList(tag("variable", list(identifier = "RESPONSE")),
                     tag("correct", list(identifier = "RESPONSE")))
    match <- tag("match", child)
    base_value <- tag("baseValue", list(baseType = "float", object@points))
    outcome <- tag("setOutcomeValue", list(identifier = "SCORE", base_value))
    response_if <- tag("responseIf", tagList(match, outcome))
    tag("responseCondition", list(response_if))
}
