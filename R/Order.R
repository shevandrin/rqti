#' Class "Order"
#'
#' Abstract class `Order` is responsible for creating assessment task according
#' to QTI 2.1., where candidate has to place answers in a specific order
#' @template ContentSlotTemplate
#' @template AISlotsTemplate
#' @template OrderSlotsTemplate
#' @template PointsSlotTemplate
#' @template NoteTasksTemplate
#' @examples
#' ord <- new("Order", content = list("<p>put in a right order</p>"),
#'            choices = c("first", "second", "third"),
#'            title = "order",
#'            identifier = "order_example")
#' @name Order-class
#' @rdname Order-class
#' @aliases Order
#' @exportClass Order
#' @include AssessmentItem.R
setClass("Order", contains = "AssessmentItem",
         slot = list(choices = "character",
                     choices_identifiers = "character",
                     shuffle = "logical"),
         prototype = list(shuffle = TRUE))
#' @export
Order <- function(content = list(), identifier = character(),
                  title = character(), prompt = character(),
                  choices = character(), choices_identifiers = character(),
                  shuffle = logical(), points = numeric()) {
    new("Order", content = content, identifier = identifier,
        title = title, prompt = prompt, choices = choices,
        choices_identifiers = choices_identifiers,
        shuffle = shuffle, points = points)
}
# constructor
setMethod("initialize", "Order", function(.Object, ...) {
    .Object <- callNextMethod()
    if (length(.Object@choices_identifiers)==0) {
        .Object@choices_identifiers <- paste0("Choice",
                                              LETTERS[seq(.Object@choices)])
    }
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
    responce_condition <- tag("responseCondition", list(response_if))
    tag("responseProcessing", list(responce_condition))
}
