#' Element asssessmentItemRef for xml testdescription
#'
#' Element assessmentItemRef for xml test description according to QTI 2.1
#'
#'
#' @slot identifier question identifier within a test
#' @slot href path to xml file with assessementItem (task)
#' @name AssessmentItemRef-class
#' @rdname AssessmentItemRef-class
#' @aliases AssessmentItemRef
#' @include AssessmentSection.R
setClass("AssessmentItemRef", slots = c(identifier = "character",
                                        href = "character"),
         prototype = prototype(identifier = generate_id())
         )
AssessmentItemRef <- function(identifier = character(0), href = character(0)) {
    new("AssessmentItemRef", identifier = identifier, href = href)
}

#' @rdname getAssessmentItems-methods
#' @aliases getAssessmentItems,AssessmentItemRef
setMethod("getAssessmentItems", signature(object = "AssessmentItemRef"),
          function(object) {
              href <- object@href
              names(href) <- object@identifier
              return(href)
          })

#' @rdname buildAssessmentSection-methods
#' @aliases buildAssessementSection,AssessmentItemRef
setMethod("buildAssessmentSection", signature(object = "AssessmentItemRef"),
          function(object) {
              tag("assessmentItemRef", list(identifier = object@identifier,
                                            href = object@href))
          })
