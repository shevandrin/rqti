#' Class "Entry"
#'
#' Class `Entry` is responsible for creating assessment tasks according to the
#' QTI 2.1 standard. These tasks include one or more instances of text input
#' fields (with numeric or text answers) or dropdown lists.
#' @template AISlotsTemplate
#' @seealso [NumericGap], [TextGap], [TextGapOpal], [InlineChoice]
#' @examples
#' entry_gaps <- new("Entry", content = list("<p>In mathematics, the common
#' logarithm is the logarithm with base", new("NumericGap",
#'                                            response_identifier = "numeric_1",
#'                                            solution = 10,
#'                                            placeholder = "it is a number"),
#' ". It is also known as the decimal", new("TextGap",
#'                                          response_identifier = "text_1",
#'                                          solution = "logarithm",
#'                                          placeholder = "it is a text"),
#'  ".</p>"),
#'                    title = "entry with number and text in answers",
#'                    identifier = "entry_example")
#' entry_dropdown <- new("Entry", content = list("<p>In mathematics, the common
#' logarithm is the logarithm with base", new("InlineChoice",
#'                                            response_identifier = "numeric_1",
#'                                            choices = c("10", "7", "11")),
#' ". It is also known as the decimal", new("InlineChoice",
#'                                          response_identifier = "text_1",
#'                                          choices = c("logarithm", "limit")),
#'  ".</p>"),
#'                    title = "entry with dropdown lists for answers",
#'                    identifier = "entry_example")
#' @name Entry-class
#' @rdname Entry-class
#' @aliases Entry
#' @exportClass Entry
#' @include AssessmentItem.R
setClass("Entry", contains = "AssessmentItem")

setMethod("initialize", "Entry", function(.Object, ...) {
    .Object <- callNextMethod()

    is_gap <- sapply(.Object@content, function(x) is(x, "Gap"))
    if (!any(is_gap)) stop("The content of 'Entry' type must include at least one gap instance.", call. = FALSE)

    content_obj <- Map(getResponse, .Object@content)
    content_obj <- Filter(Negate(is.null), content_obj)
    points <- sum(sapply(content_obj, function(x) x@points))
    .Object@points <- points

    # check identifiers
    objs <- .Object@content[is_gap]
    ids <- sapply(objs, getIdentifier)
    if (length(ids) != length(unique(ids))) {
        ids <- paste(ids, collapse = ", ")
        warning("Identifiers of objects in content-slot are non-unique : ",
                ids, call. = FALSE)
    }

    validObject(.Object)
    .Object
})

#'Create object [Entry]
#'
#'@param identifier A character representing the unique identifier of the
#'  assessment task. By default, it is generated as 'id_task_dddd', where dddd
#'  represents random digits.
#'@param title A character representing the title of the XML file associated
#'  with the task. By default, it takes the value of the identifier.
#'@param content A list of character content to form the text of the question,
#'  which can include HTML tags. For tasks of the Entry type, it must also
#'  contain at least one instance of Gap objects, such as `TextGap`,
#'  `TextGapOpal`, `NumericGap`, or `InlineChoice`.
#'@param prompt An optional character representing a simple question text,
#'  consisting of one paragraph. This can supplement or replace content in the
#'  task. Default is "".
#'@param points A numeric value, it is calculated as the sum of the gap points
#'  by default.
#'@param feedback A list containing feedback message-object [ModalFeedback] for
#'  candidates.
#'@param calculator A character, optional, determining whether to show a
#'  calculator to the candidate. Possible values:
#'   * "simple"
#'   * "scientific".
#'@param files A character vector, optional, containing paths to files that will
#'  be accessible to the candidate during the test/exam.
#'@return An object of class [Entry]
#'@seealso [textGap()][numericGap()][textGapOpal()]
#' @examples
#'gap_min <- entry(content = list("Question and Test Interoperability",
#'                                textGap("QTI")))
#'
#'gap <- entry(identifier = "id_task_1234",
#'            title = "Essay Task",
#'                    content = list("Question and Test Interoperability:",
#'                                   textGap("QTI")),
#'                    prompt = "Plain text, can be used instead of content",
#'                    points = 2,
#'                    feedback = list(new("ModalFeedback",
#'                                    content = list("Model answer"))),
#'                    calculator = "scientific-calculator",
#'                    files = "text_book.pdf")
#'@export
entry <- function(identifier = generate_id(),
                  title = identifier,
                  content = list(),
                  prompt = "",
                  points = 1,
                  feedback = list(),
                  calculator = NA_character_,
                  files = NA_character_) {
    params <- as.list(environment())
    params$Class <- "Entry"
    obj <- do.call("new", params)
    return(obj)
}

#' @rdname createItemBody-methods
#' @aliases createItemBody,Entry
setMethod("createItemBody", signature(object = "Entry"),
          function(object) {
              create_item_body_text_entry(object)
          })

#' @rdname createResponseDeclaration-methods
#' @aliases createResponseDeclaration,Entry
setMethod("createResponseDeclaration", signature(object = "Entry"),
          function(object) {
              create_response_declaration_entry(object)
          })

#' @rdname createOutcomeDeclaration-methods
#' @aliases createOutcomeDeclaration,Entry
setMethod("createOutcomeDeclaration", signature(object = "Entry"),
          function(object) {
              create_outcome_declaration_entry(object)
          })

#' @rdname createResponseProcessing-methods
#' @aliases createResponseProcessing,Entry
setMethod("createResponseProcessing", signature(object = "Entry"),
          function(object) {
              create_response_processing_entry(object)
          })

#' Compose a set of html elements to display question in qti-xml document
#'
#' Generic function for creating a set of html elements to display question for
#' XML document of specification the question following the QTI schema v2.1
#'
#' @param object an instance of the S4 object (Gap, InlineChoice, character)
#' @docType methods
#' @rdname createText-methods
#' @export
setGeneric("createText", function(object) standardGeneric("createText"))

create_item_body_text_entry <- function(object) {
    create_item_body_entry(object)
}

create_response_declaration_entry <- function(object) {
    answers <- Map(getResponse, object@content)
    answers[sapply(answers, is.null)] <- NULL
    Map(createResponseDeclaration, answers)
}

create_outcome_declaration_entry <- function(object) {
    feedbacks_declaration <- NULL
    if (length(object@feedback) > 0) {
        feedbacks_declaration <- tagList(make_outcome_declaration("FEEDBACKBASIC",
                                                                  value = "empty",
                                                                  base_type = "identifier"),
                                         make_outcome_declaration("FEEDBACKMODAL",
                                                                  cardinality = "multiple",
                                                                  value = NULL,
                                                                  base_type = "identifier"))
    }

    stand_declaration <- tagList(make_outcome_declaration("SCORE", value = 0),
                                 make_outcome_declaration("MAXSCORE",
                                                          value = object@points),
                                 make_outcome_declaration("MINSCORE", value = 0))
    answers <- Map(getResponse, object@content)
    answers[sapply(answers, is.null)] <- NULL

    gaps_declaration <- Map(createOutcomeDeclaration, answers)
    tagList(stand_declaration, gaps_declaration, feedbacks_declaration)
}
