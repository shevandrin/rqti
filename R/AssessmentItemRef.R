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
#' @aliases AssessmentItemRef
#' @include AssessmentSection.R
setClass("AssessmentItemRef", slots = c(identifier = "character",
                                        href = "character"),
         prototype = prototype(identifier = ids::adjective_animal())
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

#' @rdname getAssessmentItems-methods
#' @aliases getAssessmentItems,AssessmentItem
setMethod("getAssessmentItems", signature(object = "AssessmentItem"),
          function(object) {
              href <- paste0(object@identifier, ".xml")
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

#' @rdname buildAssessmentSection-methods
#' @aliases buildAssessementSection,AssessmentItem
setMethod("buildAssessmentSection", signature(object = "AssessmentItem"),
          function(object) {
              create_qti_task(object)
              tag("assessmentItemRef", list(identifier = object@identifier,
                                            href = paste0(object@identifier,
                                                          ".xml")))
          })

#' @rdname buildAssessmentSection-methods
#' @aliases buildAssessementSection,character
setMethod("buildAssessmentSection", signature(object = "character"),
          function(object) {
              if (file.exists(object)) {
                  doc <- xml2::read_xml(object)
                  valid <- verify_qti(doc)
                  if (!valid) print(paste("Warning: xml file",
                                          object, "is not valid"))
                  id <- xml2::xml_attr(doc, "identifier")
                  file.copy(object, getwd())
                  tag("assessmentItemRef", list(identifier = id,
                                            href = basename(object)))
              }
              else {
                  print(paste("Warning: File or path", object,
                        "is not correct. This file will be omitted in test"))
                  return(NULL)
              }
          })

#' @rdname getAssessmentItems-methods
#' @aliases getAssessmentItems,character
setMethod("getAssessmentItems", signature(object = "character"),
          function(object) {
              if (file.exists(object)) {
                  href <- basename(object)
                  doc <- xml2::read_xml(object)
                  names(href) <- xml2::xml_attr(doc, "identifier")
                  return(href)
              }
          })
