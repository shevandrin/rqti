# define class Gap to built inline instances
setClass("Img", slots = c(src = "character",
                          alt = "character",
                          width = "numeric",
                          height = "numeric"),
         prototype = prototype(alt = "picture"))
#' @export
Img <- function(src = character(), alt = character(), width = numeric(),
                height = numeric())
                {
    new("Img", src = src, alt = alt, width = width, height = height)
}

setMethod("initialize", "Img", function(.Object, ...) {
    .Object <- callNextMethod()
    if (length(.Object@alt) == 0) .Object@alt <- "picture"
    validObject(.Object)
    .Object
})

#' @rdname createText-methods
#' @aliases createText,Img
setMethod("createText", "Img", function(object) {
    tag("p", list(tag("img",
        list(src = object@src,
             alt = object@alt,
             width = object@width,
             height = object@height))))
})
