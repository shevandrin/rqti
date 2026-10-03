#' Reference to a template variable in item content
#'
#' Use this object in an assessment item's `content` list to display a template
#' variable using QTI `printedVariable`. It does not define an answer field or
#' contribute points. When the complete item is exported, the referenced name
#' must be declared in its `template` list. Both named outputs and intermediate
#' result identifiers can be referenced. Rmd parsing is not yet supported.
#'
#' @slot identifier A single valid QTI identifier of the template variable.
#' @name TemplateVariableRef-class
#' @rdname TemplateVariableRef-class
#' @aliases TemplateVariableRef
#' @exportClass TemplateVariableRef
#' @include Entry.R Gap.R
#' @examples
#' variables <- new("MaximaVariables", code = "string(['a = 1]);",
#'                  variables = c(a = "integer"))
#' reference <- new("TemplateVariableRef", identifier = "a")
#' item <- new("Entry", template = list(variables),
#'             content = list("<p>Enter ", reference, ": ",
#'                            numericGap(1), "</p>"))
#' createItemBody(item)
setClass("TemplateVariableRef", slots = c(identifier = "character"))

setValidity("TemplateVariableRef", function(object) {
    id <- object@identifier
    if (length(id) != 1L || anyNA(id) ||
        !check_identifier(id, quiet = TRUE)) {
        return("identifier must be a single valid QTI identifier.")
    }
    TRUE
})

#' @rdname createText-methods
#' @aliases createText,TemplateVariableRef
setMethod("createText", "TemplateVariableRef", function(object) {
    validObject(object)
    tag("printedVariable", list(identifier = object@identifier))
})

#' @rdname getResponse-methods
#' @aliases getResponse,TemplateVariableRef
setMethod("getResponse", "TemplateVariableRef", function(object) {
    NULL
})

validate_template_references <- function(object) {
    references <- Filter(function(x) is(x, "TemplateVariableRef"), object@content)
    if (!length(references)) return(invisible(TRUE))
    validObject(object)
    ids <- vapply(references, function(reference) {
        validObject(reference)
        reference@identifier
    }, character(1))
    declared <- unlist(lapply(object@template, function(block) {
        c(block@identifier, names(block@variables))
    }), use.names = FALSE)
    missing <- setdiff(ids, declared)
    if (length(missing)) {
        stop("Undeclared template variables in content: ",
             paste(missing, collapse = ", "), call. = FALSE)
    }
    invisible(TRUE)
}
