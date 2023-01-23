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

#TODO check whether it is needed for character object
#' #' @rdname getAssessmentItems-methods
#' #' @aliases getAssessmentItems, character
#' setMethod("getAssessmentItems", signature(object = "character"),
#'           function(object) {
#'               object
#'           })

#TODO check whether it is needed for list object
#' #' @rdname getAssessmentItems-methods
#' #' @aliases getAssessmentItems,list
#' setMethod("getAssessmentItems", signature(object = "list"),
#'           function(object) {
#'               unlist(object)
#'           })

#' @rdname buildAssessmentSection-methods
#' @aliases buildAssessementSection,AssessmentItemRef
setMethod("buildAssessmentSection", signature(object = "AssessmentItemRef"),
          function(object) {
              create_assessment_refs(object)
          })
