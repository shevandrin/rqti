#' Class AssessmentItem
#'
#' Abstract class `AssessmentItem` is responsible for creating a root element
#' 'assessmentItem' in xml task description according to QTI 2.1. This class is
#' never to be generated, only derived classes meaningful.
#' @importFrom ids adjective_animal
#' @template AISlotsTemplate
#' @section Warning: This class is not useful in itself, but some classes derive
#'   from it.
#' @name AssessmentItem-class
#' @rdname AssessmentItem-class
#' @aliases AssessmentItem
setClass("AssessmentItem", slots = c(content = "list", prompt = "character",
                                     points = "numeric",
                                     title = "character",
                                     identifier = "character",
                                     qti_version = "character"),
         prototype = prototype(prompt = "",
                               points = 1,
                               identifier = ids::adjective_animal(),
                               qti_version = "v2p1"
                               ))
# constructor
setMethod("initialize", "AssessmentItem", function(.Object, ...) {
    .Object <- callNextMethod()

    if (length(.Object@points) == 0) .Object@points <- 1
    if (length(.Object@points) == 1) {
        if (is.na(.Object@points)) .Object@points <- 1}

    if (length(.Object@prompt) == 0) .Object@prompt <- ""
    if (is.na(.Object@prompt)) .Object@prompt <- ""

    if (length(.Object@identifier) == 0) {
        .Object@identifier <- ids::adjective_animal()}
    if (is.na(.Object@identifier)) .Object@identifier <- ids::adjective_animal()

    if (length(.Object@title) == 0) .Object@title <- .Object@identifier

    validObject(.Object)
    .Object
})
#' Create an element itemBody of a qti-xml document
#'
#' Generic function for creating itemBody element for XML document of
#' specification the question following the QTI schema v2.1
#'
#' @param object an instance of the S4 object ([SingleChoice], [MultipleChoice],
#'   [Essay], [Entry], [Order], [OneInRowTable], [OneInColTable],
#'   [MultipleChoiceTable], [DirectedPair])
#' @docType methods
#' @rdname createItemBody-methods
#'
#' @export
setGeneric("createItemBody", function(object) {
    standardGeneric("createItemBody")
})

#' Create an element responseDeclaration of a qti-xml document
#'
#' Generic function for creating responseDeclaration element for XML document of
#' specification the question following the QTI schema v2.1
#'
#' @param object an instance of the S4 object ([SingleChoice], [MultipleChoice],
#'   [Entry], [Order], [OneInRowTable], [OneInColTable],
#'   [MultipleChoiceTable], [DirectedPair], [TextGap], [NumericGap],
#'   [InlineChoice])
#' @docType methods
#' @rdname createResponseDeclaration-methods
#'
#' @export
setGeneric("createResponseDeclaration", function(object) {
    standardGeneric("createResponseDeclaration")
})

#' Create an element outcomeDeclaration of a qti-xml document
#'
#' Generic function for creating outcomeDeclaration element for XML document of
#' specification the question following the QTI schema v2.1
#'
#' @param object an instance of the S4 object ([SingleChoice], [MultipleChoice],
#'   [Essay], [Entry], [Order], [OneInRowTable], [OneInColTable],
#'   [MultipleChoiceTable], [DirectedPair], [TextGap], [NumericGap],
#'   [InlineChoice])
#' @docType methods
#' @rdname createOutcomeDeclaration-methods
#'
setGeneric("createOutcomeDeclaration", function(object) {
    standardGeneric("createOutcomeDeclaration")
})

#' Create an element responseProcessing of a qti-xml document
#'
#' Generic function for creating responseProcessing element for XML document of
#' specification the question following the QTI schema v2.1
#'
#' @param object an instance of the S4 object ([SingleChoice], [MultipleChoice],
#'   [Essay], [Entry], [Order], [OneInRowTable], [OneInColTable],
#'   [MultipleChoiceTable], [DirectedPair], [TextGap], [NumericGap],
#'   [InlineChoice])
#' @docType methods
#' @rdname createResponseProcessing-methods
#'
setGeneric("createResponseProcessing", function(object) {
    standardGeneric("createResponseProcessing")
})

setMethod("createResponseProcessing", signature(object = "AssessmentItem"),
          function(object) {
})

#' @rdname createResponseDeclaration-methods
#' @aliases createResponseDeclaration,AssessmentItem
setMethod("createResponseDeclaration", signature(object = "AssessmentItem"),
          function(object) {
})

#' @rdname createOutcomeDeclaration-methods
#' @aliases createOutcomeDeclaration,AssessmentItem
setMethod("createOutcomeDeclaration", signature(object = "AssessmentItem"),
          function(object) {
              tagList(make_outcome_declaration("SCORE", value = 0),
                      make_outcome_declaration("MAXSCORE",
                                               value = object@points),
                      make_outcome_declaration("MINSCORE", value = 0))
          })
