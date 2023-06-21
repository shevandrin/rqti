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

setMethod("initialize", "AssessmentSection", function(.Object, ...) {
    .Object <- callNextMethod()

    if (length(.Object@title) == 0) .Object@title <- .Object@identifier

    validObject(.Object)
    .Object
})

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
setGeneric("buildAssessmentSection", function(object, folder = NULL) {
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
          function(object, folder
                   ) {
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
              tag("assessmentItemRef", list(identifier = object@identifier,
                                            href = paste0(object@identifier,
                                                          ".xml")))
          })

#' @rdname buildAssessmentSection-methods
#' @aliases buildAssessementSection,character
setMethod("buildAssessmentSection", signature(object = "character"),
          function(object, folder) {

              # if (is.null(folder) | (dirname(object) != ".")) {
              #     f_path <- file.path(object)
              # } else {
              #     f_path <- file.path(folder, object)
              # }

              f_path <- file.path(object)

              if (file.exists(f_path)) {
                  doc <- xml2::read_xml(f_path)
                  valid <- verify_qti(doc)
                  if (!valid) warning("xml file \'", object, "\' is not valid")
                  id <- xml2::xml_attr(doc, "identifier")

                  file.copy(f_path, folder)
                  message(paste("see assessment item:", file.path(folder, basename(f_path))))
                  tag("assessmentItemRef", list(identifier = id,
                                                href = basename(object)))
              }
              else {
                  warning("File or path \'", object, "\' is not correct. This ",
                  "file will be omitted in test", call. = FALSE,
                  immediate. = TRUE)
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
