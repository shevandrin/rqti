#' Class "Order"
#'
#' Class `Order` is responsible for creating assessment task according
#' to QTI 2.1., where candidate has to place answers in a specific order
#' @template AISlotsTemplate
#' @template OrderSlotsTemplate
#' @examples
#' ord <- new("Order",
#'            identifier = "id_task_1234",
#'            title = "order",
#'            content = list("<p>Put these items in a right order</p>"),
#'            prompt = "",
#'            points = 2,
#'            feedback = list(),
#'            choices = c("first", "second", "third"),
#'            choices_identifiers = c("ChoiceA", "ChoiceB", "ChoiceC"),
#'            shuffle = TRUE,
#'            points_per_answer = TRUE)
#' @name Order-class
#' @rdname Order-class
#' @aliases Order
#' @exportClass Order
#' @include AssessmentItem.R
setClass("Order", contains = "AssessmentItem",
         slot = list(choices = "character",
                     choices_identifiers = "character",
                     shuffle = "logical",
                     points_per_answer = "logical"),
         prototype = list(shuffle = TRUE, points_per_answer = TRUE))

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
              points_cond <- createResponseCondition(object)
              rp <- create_default_resp_processing_order(object)
              tagAppendChildren(rp, points_cond)
          })

create_response_declaration_order <- function(object) {
        child <- create_correct_response(object@choices_identifiers)
        tag("responseDeclaration", list(identifier = "RESPONSE",
                                        cardinality = "ordered",
                                        baseType = "identifier",
                                        child))
}

setMethod("createResponseCondition", signature(object = "Order"),
          function(object) {
              if (object@points_per_answer) {
                answ_points <- object@points / length(object@choices)
                indexes <- seq(length(object@choices))
                resp_cond <- Map(create_condition_points, answ_points, indexes)
                return(resp_cond)
              }
})

create_condition_points <- function(answ_points, index) {
    var_tag <- tag("variable", list(identifier = "RESPONSE"))
    index1 <- tag("index", list(n = index, var_tag))
    corr_tag <- tag("correct", list(identifier = "RESPONSE"))
    index2 <- tag("index", list(n = index, corr_tag))
    match_tag <- tag("match", list(index1, index2))
    var_tag <- tag("variable", list(identifier = "SCORE"))
    val_tag <- tag("baseValue", list(baseType = "float", answ_points))
    sum_tag <- tag("sum", list(var_tag, val_tag))
    set_out_value <- tag("setOutcomeValue", list(identifier = "SCORE",
                                                 sum_tag))
    response_if <- tag("responseIf", list(match_tag, set_out_value))
    resp_cond <- tag("responseCondition", list(response_if))
    return(resp_cond)
}
