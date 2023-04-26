#' Class Img
#'
#' Class `Img` is responsible to keep attributes and process images as a part of
#' excericise content
#' @template ImgSlotsTemplate
#' @name Img-class
#' @rdname Img-class
#' @aliases Img
#' @export
setClass("Img", slots = c(src = "character",
                          alt = "character",
                          width = "numeric",
                          height = "numeric"),
         prototype = prototype(alt = "picture"))

#' @rdname createText-methods
#' @aliases createText,Img
setMethod("createText", "Img", function(object) {
    tag("p", list(tag("img",
        list(src = object@src,
             alt = object@alt,
             width = object@width,
             height = object@height))))
})
