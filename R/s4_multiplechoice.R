setClass("multiplechoice", contains = "choice",
         slots = list(mapping = "numeric", lower_bound = "numeric",
                      upper_bound = "numeric", default_value = "numeric"),
         prototype = list(lower_bound = 0, default_value = 0))

# constructor
setMethod("initialize", "multiplechoice", function(.Object, ...) {
    .Object <- callNextMethod()
    .Object@mapping <- setNames(.Object@points, .Object@choice_identifiers)
    .Object@upper_bound <- ifelse(length(.Object@upper_bound) == 0,
                                  sum(.Object@points[.Object@points > 0]),
                                  .Object@upper_bound)
     validObject(.Object)
    .Object
})

# set generics for mpc
setMethod("create_item_body", signature(object = "multiplechoice"),
          function(object) {
              create_item_body_multiplechoice(object)
          })

setMethod("create_response_declaration", signature(object = "multiplechoice"),
          function(object) {
              create_response_declaration_multiple_choice(object)
          })

# helpers
create_item_body_multiplechoice <- function(object) {
    create_item_body_choice(object, max_choices = 0)
}

create_response_declaration_multiple_choice <- function(object) {
    correct_choice_identifier <- names(object@mapping[object@mapping > 0])
    correct_response <- create_correct_response(correct_choice_identifier)
    mapping <- create_mapping(object)
    tag("responseDeclaration", list(identifier = "RESPONSE",
                                    cardinality = "single",
                                    baseType = "identifier",
                                    correct_response, mapping))
}
