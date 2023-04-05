#' Class AssessmentSection
#'
#' Class `AssessmentSection` is responsible for forming a section in test xml
#' specification according to QTI 2.1
#' @template ASSlotsTemplate
#' @examples
#' sc1 <- new("SingleChoice", prompt = "Test task", title = "SC",
#'              identifier = "q1", choices = c("a", "b", "c"))
#' sc2 <- new("SingleChoice", prompt = "Test task", title = "SC",
#'              identifier = "q2", choices = c("A", "B", "C"))
#' sc3 <- new("SingleChoice", prompt = "Test task", title = "SC",
#'              identifier = "q3", choices = c("aa", "bb", "cc"))
#' exam_section <- new("AssessmentSection", identifier = "sec_id",
#'                    title = "section", assessment_item = list(sc1, sc2, sc3),
#'                    selection = 2)
#' @name AssessmentSection-class
#' @rdname AssessmentSection-class
#' @aliases AssessmentSection
#' @importFrom ids adjective_animal
setClass("AssessmentSection", slots = c(identifier = "character",
                                     title = "character",
                                     time_limits = "numeric",
                                     visible = "logical",
                                     assessment_item = "list",
                                     shuffle = "logical",
                                     selection = "numeric",
                                     max_attempts = "numeric",
                                     allow_comment = "logical"),
         prototype = prototype(identifier = ids::adjective_animal(),
                               visible = TRUE,
                               time_limits = NA_integer_,
                               shuffle = FALSE,
                               selection = NA_integer_,
                               max_attempts = NA_integer_,
                               allow_comment = NA
         ))
#' @export
AssessmentSection <- function(identifier = character(),
                           title = character(), time_limits = numeric(),
                           visible = logical(),
                           assessment_item = list(), shuffle = logical(),
                           selection = numeric(), max_attempts = numeric(),
                           allow_comment = logical()
){
    new("AssessmentSection", identifier = identifier,
        title = title, time_limits = time_limits,
        visible = visible, assessment_item = assessment_item, shuffle = shuffle,
        selection = selection, max_attempts = max_attempts,
        allow_comment = allow_comment)
}
#' Get list of AssessmentItems for AssessmentSection
#'
#' Generic function for
#'
#' @param object an instance of the S4 object (AssessmentSection)
#' @docType methods
#' @rdname getAssessmentItems-methods
#'
#' @export
setGeneric("getAssessmentItems", function(object) {
    standardGeneric("getAssessmentItems")
})

#' Build tags for AssessmentSection in assessmentTest
#'
#' Generic function for tags that contains assessementSection in assessnetTest
#'
#' @param object an instance of the S4 object ([AssessmentSection],
#' [AssessmentItemRef] and all types of [AssessmentItem])
#' @param folder string; a folder to store xml file
#' @docType methods
#' @rdname buildAssessmentSection-methods
#'
#' @export
setGeneric("buildAssessmentSection", function(object, folder) {
    standardGeneric("buildAssessmentSection")
})

#' @rdname getAssessmentItems-methods
#' @aliases getAssessmentItems,AssessmentSection
setMethod("getAssessmentItems", signature(object = "AssessmentSection"),
          function(object) {
              Map(getAssessmentItems, object@assessment_item)
          })

#' @rdname buildAssessmentSection-methods
#' @aliases buildAssessmentSection,AssessmentSection
setMethod("buildAssessmentSection", signature(object = "AssessmentSection"),
          function(object, folder) {
              create_section_test(object, folder)
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
#' @aliases buildAssessementSection,AssessmentItem
setMethod("buildAssessmentSection", signature(object = "AssessmentItem"),
          function(object, folder) {
              res <- create_qti_task(object, folder)
              print(res)
              tag("assessmentItemRef", list(identifier = object@identifier,
                                            href = paste0(object@identifier,
                                                          ".xml")))
          })

#' @rdname buildAssessmentSection-methods
#' @aliases buildAssessementSection,character
setMethod("buildAssessmentSection", signature(object = "character"),
          function(object, folder) {
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
