# define class Gap to built inline instances

setClass("Gap", slots = c(response_identifier = "character", score = "numeric",
                          placeholder = "character",
                          expected_length = "numeric"),
         prototype = prototype(score = NA_integer_,
                               placeholder = NA_character_,
                               expected_length = NA_integer_))

#' @export
setGeneric("getResponse", function(object) {
    standardGeneric("getResponse")
})
setMethod("getResponse", "character", function(object) {
})
setMethod("getResponse", "Br", function(object) {
})
