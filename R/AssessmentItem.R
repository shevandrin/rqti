#' Root element assessmentItem for xml task description
#'
#' Root element assessmentItem for xml task description according to QTI 2.1
#'
#' @importFrom ids adjective_animal
#' @slot text an object Text with
#'
#' @slot points Number of points for the whole task
#' @slot title Title of the file
#' @slot identifier file id
#' @slot qti_version qti information model version
#' @name AssessmentItem-class
#' @rdname AssessmentItem-class
#' @include Text.R
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

#' Create an element itemBody of a qti-xml document
#'
#' Generic function for creating itemBody element for XML document of
#' specification the question following the QTI schema v2.1
#'
#' @param object an instance of the S4 object (SingleChoice, MultipleChoice,
#'   Entry, Order, OneInRowTable, OneInColTable, MultipleChoiceTable,
#'   DirectedPair)
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
#' @param object an instance of the S4 object (Entry, InlineChoice, MatchTable,
#'   MultipleChoice, MultipleChoiceTable, NumericGap, Order, SingleChoice,
#'   TextGap)
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
#' @param object an instance of the S4 object (AssessmentItem, Entry,
#'   InlineChoice, MultipleChoice, NumericGap, TextGap)
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
#' @param object an instance of the S4 object (Choice, Entry, Gap, InlineChoice,
#'   NumericGap, Order)
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
