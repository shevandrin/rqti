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
#' @include ModalFeedback.R
setClass("AssessmentItem", slots = c(identifier = "character",
                                     content = "list", prompt = "character",
                                     points = "numeric",
                                     title = "character",
                                     qti_version = "character",
                                     feedback = "list",
                                     files = "character",
                                     calculator = "character"),
         prototype = prototype(prompt = "",
                               points = 1,
                               identifier = ids::adjective_animal(),
                               qti_version = "v2p1"
                               ))

# constructor
setMethod("initialize", "AssessmentItem", function(.Object, ...) {
    .Object <- callNextMethod()

    if (length(.Object@prompt) == 0) .Object@prompt <- ""
    if (is.na(.Object@prompt)) .Object@prompt <- ""

    if (length(.Object@identifier) == 0) {
        .Object@identifier <- ids::adjective_animal()}
    if (is.na(.Object@identifier)) .Object@identifier <- ids::adjective_animal()

    if (length(.Object@title) == 0) .Object@title <- .Object@identifier

    fix_img <- function(itm) {
        if (is.character(itm)) {
            gsub('(<img[^>]*[^/])>', "\\1/>",itm)
        } else {
            itm
        }
    }
    .Object@content <- lapply(.Object@content, fix_img)

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
setGeneric("createResponseProcessing", function(object) {
    standardGeneric("createResponseProcessing")
})

#' Create XML file for question specification
#'
#' @usage createQtiTask(object,
#'                 dir = NULL,
#'                 verification = FALSE)
#' @param object an instance of the S4 object ([SingleChoice], [MultipleChoice],
#'   [Essay], [Entry], [Order], [OneInRowTable], [OneInColTable],
#'   [MultipleChoiceTable], [DirectedPair]).
#' @param dir string, optional; a folder to store xml file; working directory by
#'   default
#' @param verification boolean, optional; to check validity of xml file, default
#'   `FALSE`
#' @return xml document.
#' @examples
#' \dontrun{
#' essay <- new("Essay", prompt = "Test task", title = "Essay")
#' createQtiTask(essay, "result", "TRUE")
#' }
#' @docType methods
#' @name createQtiTask-methods
#' @rdname createQtiTask-methods
#' @aliases createQtiTask
#' @docType methods
#' @export
setGeneric("createQtiTask", function(object, dir = NULL, verification = FALSE) {
    standardGeneric("createQtiTask")
})

#' Create XML file for exam test specification
#'
#' @usage createQtiTest(object, dir = NULL, verification = FALSE, zip_only =
#'   FALSE)
#' @param object an instance of the [AssessmentTest] or [AssessmentTestOpal] S4
#'   object
#' @param dir string, optional; a folder to store xml file; working directory by
#'   default
#' @param verification boolean, optional; to check validity of xml file, default
#'   `FALSE`
#' @param zip_only boolean, optional; returns only zip file in case of TRUE or
#'   zip, xml and downloads files in case of FALSE value; FALSE by default
#' @return xml document.
#' @examples
#' \dontrun{
#' essay <- new("Essay", prompt = "Test task", title = "Essay",
#'              identifier = "q1")
#' sc <- new("SingleChoice", prompt = "Test task", title = "SingleChoice",
#'           choices = c("A", "B", "C"), identifier = "q2")
#' exam_section <- new("AssessmentSection", identifier = "sec_id",
#'                    title = "section", assessment_item = list(essay, sc))
#' exam <- new("AssessmentTestOpal", identifier = "id_test",
#'            title = "some title", section = list(exam_section))
#' createQtiTest(exam, "exam_folder", "TRUE")
#' }
#' @name createQtiTest-methods
#' @rdname createQtiTest-methods
#' @aliases createQtiTest
#' @docType methods
#' @export
setGeneric("createQtiTest", function(object, dir = NULL, verification = FALSE,
                                     zip_only = FALSE) {
    standardGeneric("createQtiTest")
})

#' Get points from AssessmentItem object
#'
#' @param object an instance of the S4 object ([SingleChoice], [MultipleChoice],
#'   [Essay], [Entry], [Order], [OneInRowTable], [OneInColTable],
#'   [MultipleChoiceTable], [DirectedPair], [TextGap], [NumericGap],
#'   [InlineChoice])
#' @name getPoints-methods
#' @rdname getPoints-methods
#' @aliases getPoints
#' @docType methods
setGeneric("getPoints", function(object) {
    standardGeneric("getPoints")
})

#' Get identifier
#'
#' @param object an instance of the S4 object ([SingleChoice], [MultipleChoice],
#'   [Essay], [Entry], [Order], [OneInRowTable], [OneInColTable],
#'   [MultipleChoiceTable], [DirectedPair], [TextGap], [NumericGap],
#'   [InlineChoice])
#' @name getIdentifier-methods
#' @rdname getIdentifier-methods
#' @aliases getIdentifier
#' @docType methods
setGeneric("getIdentifier", function(object) {
    standardGeneric("getIdentifier")
})

#' Get object
#'
#' @param object an instance of the S4 object ([SingleChoice], [MultipleChoice],
#'   [Essay], [Entry], [Order], [OneInRowTable], [OneInColTable],
#'   [MultipleChoiceTable], [DirectedPair], [TextGap], [NumericGap],
#'   [InlineChoice])
#' @name getObject-methods
#' @rdname getObject-methods
#' @aliases getObject
#' @docType methods
setGeneric("getObject", function(object) {
    standardGeneric("getObject")
})

#' Get list of AssessmentItems for AssessmentSection
#'
#' Generic function for
#'
#' @param object an instance of the S4 object ([AssessmentSection],
#' [AssessmentItem])
#' @docType methods
#' @rdname getAssessmentItems-methods
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
setGeneric("buildAssessmentSection", function(object, folder = NULL) {
    standardGeneric("buildAssessmentSection")
})

#' Get file paths for attachment of test
#'
#' @param object an instance of the S4 object ([SingleChoice], [MultipleChoice],
#'   [Essay], [Entry], [Order], [OneInRowTable], [OneInColTable],
#'   [MultipleChoiceTable], [DirectedPair], [TextGap], [NumericGap],
#'   [InlineChoice])
#' @name getFiles-methods
#' @rdname getFiles-methods
#' @aliases getFiles
#' @docType methods
setGeneric("getFiles", function(object) {
    standardGeneric("getFiles")
})

#' Get value of the slot 'calculator'
#'
#' @param object an instance of the S4 object ([SingleChoice], [MultipleChoice],
#'   [Essay], [Entry], [Order], [OneInRowTable], [OneInColTable],
#'   [MultipleChoiceTable], [DirectedPair], [TextGap], [NumericGap],
#'   [InlineChoice])
#' @name getCalculator-methods
#' @rdname getCalculator-methods
#' @aliases getCalculator
#' @docType methods
setGeneric("getCalculator", function(object) {
    standardGeneric("getCalculator")
})


#' @rdname createQtiTask-methods
#' @aliases createQtiTask,AssessmentItem
setMethod("createQtiTask", signature(object = "AssessmentItem"),
          function(object, dir = NULL, verification = FALSE) {
              create_qti_task(object, dir, verification)
          })

#' @rdname createQtiTest-methods
#' @aliases createQtiTest,AssessmentItem
setMethod("createQtiTest", signature(object = "AssessmentItem"),
          function(object, dir = ".", verification = FALSE, zip_only) {
              test_section <- section(object)
              test_object <- test4opal(test_section,
                                    identifier = paste0("test_", object@identifier))
              create_qti_test(test_object, dir, verification, zip_only)
          })

#' @rdname createResponseProcessing-methods
#' @aliases createResponseProcessing,AssessmentItem
setMethod("createResponseProcessing", signature(object = "AssessmentItem"),
          function(object) {
              create_default_resp_processing(object)
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
              feedbacks <- NULL
              if (length(object@feedback) > 0) {
              feedbacks <- tagList(
                  make_outcome_declaration("FEEDBACKBASIC",
                                           value = "empty",
                                           base_type = "identifier"),
                  make_outcome_declaration("FEEDBACKMODAL",
                                           cardinality = "multiple",
                                           value = "",
                                           base_type = "identifier"))
              }
              points <- sum(object@points[object@points > 0])
              tagList(make_outcome_declaration("SCORE", value = 0),
                      make_outcome_declaration("MAXSCORE",
                                               value = points),
                      make_outcome_declaration("MINSCORE", value = 0),
                      feedbacks)
          })

#' @rdname getPoints-methods
#' @aliases getPoints,AssessmentItem
setMethod("getPoints", signature(object = "AssessmentItem"),
          function(object) {
              points <- object@points
              names(points) <- object@identifier
              return(points)
          })

#' @rdname getIdentifier-methods
#' @aliases getIdentifier,AssessmentItem
setMethod("getIdentifier", signature(object = "AssessmentItem"),
          function(object) {
              return(object@identifier)
          })

#' @rdname getObject-methods
#' @aliases getObject,AssessmentItem
setMethod("getObject", signature(object = "AssessmentItem"),
          function(object) {
              return(object)
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

#' @rdname getFiles-methods
#' @aliases getFiles,AssessmentItem
setMethod("getFiles", signature(object = "AssessmentItem"),
          function(object) {
              return(object@files)
          })

#' @rdname getCalculator-methods
#' @aliases getCalculator,AssessmentItem
setMethod("getCalculator", signature(object = "AssessmentItem"),
          function(object) {
              return(object@calculator)
          })
