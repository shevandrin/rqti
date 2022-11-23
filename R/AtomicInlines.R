# define class AtimicInline for html formatting newlines and images
#' @importFrom htmltools br
#' @include Text.R

setClass("AtomicInline")
setClass("Br", contains = "AtomicInline")

setMethod("createText", "Br", function(object) {
    br()
})

