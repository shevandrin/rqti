#' Element asssessmentItemRef for xml testdescription
#'
#' Element assessmentItemRef for xml test description according to QTI 2.1
#'
#' @importFrom ids adjective_animal
#'
#' @slot identifier question identifier within a test
#' @slot href path to xml file with assessementItem (task)
#' @name AssessmentItemRef-class
#' @rdname AssessmentItemRef-class
#' @include AssessmentSection.R
setClass("AssessmentItemRef", slots = c(identifier = "character",
                                        href = "character"),
         prototype = prototype(identifier = ids::adjective_animal())
         )

#' @rdname getAssessmentItems-methods
#' @aliases getAssessmentItems,AssessmentItemRef
setMethod("getAssessmentItems", signature(object = "AssessmentItemRef"),
          function(object) {
              # object@identifier
              href <- object@href
              names(href) <- object@identifier
              return(href)
          })

#' @rdname buildAssessmentSection-methods
#' @aliases buildAssessementSection,AssessmentItemRef
setMethod("buildAssessmentSection", signature(object = "AssessmentItemRef"),
          function(object) {
              create_assessment_refs(object)
          })
