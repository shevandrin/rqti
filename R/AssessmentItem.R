#' Class AssessmentItem
#'
#' Abstract class `AssessmentItem` is responsible for creating a root element
#' 'assessmentItem' in XML task description according to QTI 2.1. This class is
#' not meant to be instantiated directly; instead, it serves as a base for
#' derived classes.
#' @template AISlotsTemplate
#' @name AssessmentItem-class
#' @rdname AssessmentItem-class
#' @aliases AssessmentItem
#' @include ModalFeedback.R rqti.R QtiMetadata.R
setClass("AssessmentItem", slots = c(identifier = "character",
                                     title = "character",
                                     content = "list",
                                     prompt = "character",
                                     points = "numeric",
                                     feedback = "list",
                                     files = "character",
                                     calculator = "character",
                                     metadata = "QtiMetadata"),
         prototype = prototype(prompt = "",
                               points = 1))

setMethod("initialize", "AssessmentItem", function(.Object, ...) {
    .Object <- callNextMethod()

    if (length(.Object@prompt) == 0) .Object@prompt <- ""
    if (is.na(.Object@prompt)) .Object@prompt <- ""

    if (length(.Object@identifier) == 0) .Object@identifier <- generate_id()
    if (is.na(.Object@identifier)) .Object@identifier <- generate_id()
    check_identifier(.Object@identifier)

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
#'   [Essay], [Entry], [Ordering], [OneInRowTable], [OneInColTable],
#'   [MultipleChoiceTable], [DirectedPair])
#' @docType methods
#' @rdname createItemBody-methods
setGeneric("createItemBody", function(object) standardGeneric("createItemBody"))

#' Create an element responseDeclaration of a qti-xml document
#'
#' Generic function for creating responseDeclaration element for XML document of
#' specification the question following the QTI schema v2.1
#'
#' @param object an instance of the S4 object ([SingleChoice], [MultipleChoice],
#'   [Entry], [Ordering], [OneInRowTable], [OneInColTable],
#'   [MultipleChoiceTable], [DirectedPair], [TextGap], [NumericGap],
#'   [InlineChoice])
#' @docType methods
#' @rdname createResponseDeclaration-methods
setGeneric("createResponseDeclaration",
           function(object) standardGeneric("createResponseDeclaration"))

#' Create an element outcomeDeclaration of a qti-xml document
#'
#' Generic function for creating outcomeDeclaration element for XML document of
#' specification the question following the QTI schema v2.1
#'
#' @param object an instance of the S4 object ([SingleChoice], [MultipleChoice],
#'   [Essay], [Entry], [Ordering], [OneInRowTable], [OneInColTable],
#'   [MultipleChoiceTable], [DirectedPair], [TextGap], [NumericGap],
#'   [InlineChoice])
#' @docType methods
#' @rdname createOutcomeDeclaration-methods
setGeneric("createOutcomeDeclaration",
           function(object) standardGeneric("createOutcomeDeclaration"))

#' Create an element responseProcessing of a qti-xml document
#'
#' Generic function for creating responseProcessing element for XML document of
#' specification the question following the QTI schema v2.1
#'
#' @param object an instance of the S4 object ([SingleChoice], [MultipleChoice],
#'   [Essay], [Entry], [Ordering], [OneInRowTable], [OneInColTable],
#'   [MultipleChoiceTable], [DirectedPair], [TextGap], [NumericGap],
#'   [InlineChoice])
#' @docType methods
#' @rdname createResponseProcessing-methods
setGeneric("createResponseProcessing",
           function(object) standardGeneric("createResponseProcessing"))

#' Create XML or zip file for question specification
#'
#' @usage createQtiTask(object, dir = NULL, verification = FALSE, zip = FALSE)
#' @param object An instance of the S4 object ([SingleChoice], [MultipleChoice],
#'   [Essay], [Entry], [Ordering], [OneInRowTable], [OneInColTable],
#'   [MultipleChoiceTable], [DirectedPair]).
#' @param dir A character value, optional; a folder to store xml file; working
#'   directory is used by default.
#' @param verification A boolean value, optional; to check validity of xml file.
#'   Default is `FALSE`.
#' @param zip A boolean value, optional; the `TRUE` value allows to create a
#'   zip archive with the manifest and task files inside. Default is `FALSE`.
#' @return A path to xml or zip file.
#' @examples
#' essay <- new("Essay", prompt = "Test task", title = "Essay")
#' \dontrun{
#' # creates folder with XML (side effect)
#' createQtiTask(essay, "result")
#' # creates folder with zip (side effect)
#' createQtiTask(essay, "result", zip = TRUE)
#' }
#' @name createQtiTask-methods
#' @rdname createQtiTask-methods
#' @aliases createQtiTask
#' @docType methods
#' @export
setGeneric("createQtiTask",
           function(object, dir = NULL,
                    verification = FALSE,
                    zip = FALSE) standardGeneric("createQtiTask"))

#' Create zip-archive of the qti test specification
#'
#' @usage createQtiTest(object, dir = NULL, verification = FALSE, zip_only =
#'   FALSE)
#' @param object An instance of the [AssessmentTest], [AssessmentTestOpal] or
#'   [AssessmentItem] S4 object.
#' @param dir A character value, optional; a folder to store xml file; working
#'   directory is used by default.
#' @param verification A boolean value, optional; to check validity of xml
#'   files. Default is `FALSE`.
#' @param zip_only A boolean value, optional; returns only zip file in case of
#'   `TRUE` or zip, xml and downloads files in case of `FALSE` value. Default is
#' `FALSE`.
#' @return  A path to zip and xml files.
#' @examples
#' essay <- new("Essay", prompt = "Test task", title = "Essay",
#'              identifier = "q1")
#' sc <- new("SingleChoice", prompt = "Test task", title = "SingleChoice",
#'           choices = c("A", "B", "C"), identifier = "q2")
#' exam_section <- new("AssessmentSection", identifier = "sec_id",
#'                    title = "section", assessment_item = list(essay, sc))
#' exam <- new("AssessmentTestOpal", identifier = "id_test",
#'            title = "some title", section = list(exam_section))
#' \dontrun{
#' # creates folder with zip (side effect)
#' createQtiTest(exam, "exam_folder", "TRUE")
#' }
#' @name createQtiTest-methods
#' @rdname createQtiTest-methods
#' @aliases createQtiTest
#' @docType methods
#' @export
setGeneric("createQtiTest",
           function(object, dir = NULL, verification = FALSE,
                    zip_only = FALSE) standardGeneric("createQtiTest"))

#' Get points from AssessmentItem object
#'
#' @param object an instance of the S4 object ([SingleChoice], [MultipleChoice],
#'   [Essay], [Entry], [Ordering], [OneInRowTable], [OneInColTable],
#'   [MultipleChoiceTable], [DirectedPair], [TextGap], [NumericGap],
#'   [InlineChoice])
#' @name getPoints-methods
#' @rdname getPoints-methods
#' @aliases getPoints
#' @docType methods
setGeneric("getPoints", function(object) standardGeneric("getPoints"))

#' Get identifier
#'
#' @param object an instance of the S4 object ([SingleChoice], [MultipleChoice],
#'   [Essay], [Entry], [Ordering], [OneInRowTable], [OneInColTable],
#'   [MultipleChoiceTable], [DirectedPair], [TextGap], [NumericGap],
#'   [InlineChoice])
#' @name getIdentifier-methods
#' @rdname getIdentifier-methods
#' @aliases getIdentifier
#' @docType methods
setGeneric("getIdentifier", function(object) standardGeneric("getIdentifier"))

#' Get object
#'
#' @param object an instance of the S4 object ([SingleChoice], [MultipleChoice],
#'   [Essay], [Entry], [Ordering], [OneInRowTable], [OneInColTable],
#'   [MultipleChoiceTable], [DirectedPair], [TextGap], [NumericGap],
#'   [InlineChoice])
#' @name getObject-methods
#' @rdname getObject-methods
#' @aliases getObject
#' @docType methods
setGeneric("getObject", function(object) standardGeneric("getObject"))

#' Get list of AssessmentItems for AssessmentSection
#'
#' Generic function for
#'
#' @param object an instance of the S4 object ([AssessmentSection],
#' [AssessmentItem])
#' @docType methods
#' @rdname getAssessmentItems-methods
setGeneric("getAssessmentItems",
           function(object) standardGeneric("getAssessmentItems"))

#' Build tags for AssessmentSection in assessmentTest
#'
#' Generic function for tags that contains assessementSection in assessnetTest
#'
#' @param object an instance of the S4 object ([AssessmentSection] and all types
#'   of [AssessmentItem])
#' @param folder string; a folder to store xml file
#' @param verify boolean, optional; check validity of xml file, default `FALSE`
#' @docType methods
#' @rdname buildAssessmentSection-methods
setGeneric("buildAssessmentSection",
           function(object, folder = NULL,
                    verify = FALSE) standardGeneric("buildAssessmentSection"))

#' Get file paths for attachment of test
#'
#' @param object an instance of the S4 object ([SingleChoice], [MultipleChoice],
#'   [Essay], [Entry], [Ordering], [OneInRowTable], [OneInColTable],
#'   [MultipleChoiceTable], [DirectedPair], [TextGap], [NumericGap],
#'   [InlineChoice])
#' @name getFiles-methods
#' @rdname getFiles-methods
#' @aliases getFiles
#' @docType methods
setGeneric("getFiles", function(object) standardGeneric("getFiles"))

#' Get value of the slot 'calculator'
#'
#' @param object an instance of the S4 object ([SingleChoice], [MultipleChoice],
#'   [Essay], [Entry], [Ordering], [OneInRowTable], [OneInColTable],
#'   [MultipleChoiceTable], [DirectedPair], [TextGap], [NumericGap],
#'   [InlineChoice])
#' @name getCalculator-methods
#' @rdname getCalculator-methods
#' @aliases getCalculator
#' @docType methods
setGeneric("getCalculator", function(object) standardGeneric("getCalculator"))

#' Prepare files to render them with QTIJS
#'
#' @param object an instance of [AssessmentItem], [AssessmentTest],
#'   [AssessmentTestOpal], [AssessmentSection], or string path to xml, rmd or md
#'   files
#' @param dir QTIJS path
#' @name prepareQTIJSFiles-methods
#' @rdname prepareQTIJSFiles-methods
#' @aliases prepareQTIJSFiles
#' @docType methods
setGeneric("prepareQTIJSFiles",
           function(object, dir = NULL) standardGeneric("prepareQTIJSFiles"))

#' Get list of contributors values
#'
#' @param object an instance of the S4 object ([SingleChoice], [MultipleChoice],
#'   [Essay], [Entry], [Ordering], [OneInRowTable], [OneInColTable],
#'   [MultipleChoiceTable], [DirectedPair], [TextGap], [NumericGap],
#'   [InlineChoice])
#' @name getContributors-methods
#' @rdname getContributors-methods
#' @aliases getContributors
#' @docType methods
setGeneric("getContributors", function(object) standardGeneric("getContributors"))

#' @rdname getContributors-methods
#' @aliases getContributors,AssessmentItem
setMethod("getContributors", signature(object = "AssessmentItem"),
          function(object) {
              return(object@metadata@contributor)
          })

#' @rdname createQtiTask-methods
#' @aliases createQtiTask,AssessmentItem
setMethod("createQtiTask", signature(object = "AssessmentItem"),
          function(object, dir = NULL, verification = FALSE, zip = FALSE) {
              ifelse(zip, create_task_zip(object, dir, verification),
                     create_qti_task(object, dir, verification))
          })

#' @rdname createQtiTest-methods
#' @aliases createQtiTest,AssessmentItem
setMethod("createQtiTest", signature(object = "AssessmentItem"),
          function(object, dir = ".", verification = FALSE, zip_only) {
              test_section <- section(object)
              test_object <- test4opal(test_section,
                                       identifier = paste0("test_",
                                                           object@identifier))
              create_qti_test(test_object, dir, verification, zip_only)
          })

#' @rdname createResponseProcessing-methods
#' @aliases createResponseProcessing,AssessmentItem
setMethod("createResponseProcessing", signature(object = "AssessmentItem"),
    function(object) create_default_resp_processing(object)
)

#' @rdname createResponseDeclaration-methods
#' @aliases createResponseDeclaration,AssessmentItem
setMethod("createResponseDeclaration", signature(object = "AssessmentItem"),
    function(object) {}
)

#' @rdname createOutcomeDeclaration-methods
#' @aliases createOutcomeDeclaration,AssessmentItem
setMethod("createOutcomeDeclaration", signature(object = "AssessmentItem"),
          function(object) {
              feedbacks <- NULL
              if (length(object@feedback) > 0) {
                  feedbacks <- tagList(make_outcome_declaration("FEEDBACKBASIC",
                                                                value = "empty",
                                                                base_type = "identifier"),
                                       make_outcome_declaration("FEEDBACKMODAL",
                                                                cardinality = "multiple",
                                                                value = NULL,
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

#' @rdname prepareQTIJSFiles-methods
#' @aliases prepareQTIJSFiles,AssessmentItem
setMethod("prepareQTIJSFiles", signature(object = "AssessmentItem"),
          function(object, dir = "") {
              suppressMessages(createQtiTask(object,
                                             file.path(dir, "index.xml")))
          })

#' @rdname createMetadata-methods
#' @aliases createMetadata,AssessmentItem
setMethod("createMetadata", signature(object = "AssessmentItem"),
          function(object) {
              create_metadata(object)
          })
