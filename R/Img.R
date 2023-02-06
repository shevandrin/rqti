# define class Gap to built inline instances
setClass("Img", slots = c(src = "character",
                          alt = "character",
                          width = "numeric",
                          height = "numeric"),
         prototype = prototype(alt = "picture"))

#' @rdname createText-methods
#' @aliases createText,Img
setMethod("createText", "Img", function(object) {
    tag("div", list(tag("img",
        list(src = object@src,
             alt = object@alt,
             width = object@width,
             height = object@height))))
})
