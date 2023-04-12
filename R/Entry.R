#' Class "Entry"
#'
#' Abstract class `Entry` is responsible for creating assessment task according
#' to QTI 2.1., where question includes one or more instances of text input
#' fields (with numeric or text answers) or dropdown lists.
#' @template ContentEntrySlotTemplate
#' @template AISlotsTemplate
#' @template PointsSlotTemplate
#' @template NoteTasksTemplate
#' @examples
#' entry_gaps <- new("Entry", content = list("<p>In mathematics, the common
#' logarithm is the logarithm with base", new("NumericGap",
#'                                            response_identifier = "numeric_1",
#'                                            response = 10,
#'                                            placeholder = "it is a number"),
#' ". It is also known as the decimal", new("TextGap",
#'                                          response_identifier = "text_1",
#'                                          response = "logarithm",
#'                                          placeholder = "it is a text"),
#'  ".</p>"),
#'                    title = "entry with number and text in answers",
#'                    identifier = "entry_example")
#' entry_dropdown <- new("Entry", content = list("<p>In mathematics, the common
#' logarithm is the logarithm with base", new("InlineChoice",
#'                                            response_identifier = "numeric_1",
#'                                            options = c("10", "7", "11")),
#' ". It is also known as the decimal", new("InlineChoice",
#'                                          response_identifier = "text_1",
#'                                          options = c("logarithm", "limit")),
#'  ".</p>"),
#'                    title = "entry with dropdown lists for answers",
#'                    identifier = "entry_example")
#' @name Entry-class
#' @rdname Entry-class
#' @aliases Entry
#' @exportClass Entry
#' @include AssessmentItem.R
setClass("Entry", contains = "AssessmentItem")
#' @export
Entry <- function(content = list(), identifier = character(),
                  title = character(), prompt = character(),
                  points = numeric()) {
    new("Entry", content = content, identifier = identifier,
        title = title, prompt = prompt, points = points)
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
#'
#' @export
setGeneric("createText", function(object) {
    standardGeneric("createText")
})

#' @rdname createText-methods
#' @aliases createText,character
setMethod("createText", "character", function(object) {
    HTML(object)
})

create_item_body_text_entry <- function(object) {
    create_item_body_entry(object)
}

create_response_declaration_entry <- function(object) {
    answers <- Map(getResponse, object@content)
    answers[sapply(answers, is.null)] <- NULL
    Map(createResponseDeclaration, answers)
}

create_response_processing_entry <- function(object) {
    answers <- Map(getResponse, object@content)
    answers[sapply(answers, is.null)] <- NULL
    processing <- Map(createResponseProcessing, answers)

    conditions <- NULL
    if (length(object@feedback) > 0) {
        #add default condition
        tag_isnull <- Map(make_response_condition, answers)
        if (length(tag_isnull) > 1) {
            tag_isnull <- tag("and", tag_isnull)
        }
        tag_bv <- tag("baseValue", list(baseType = "identifier", "empty"))
        set_ov <- tag("setOutcomeValue",
                      list(identifier = "FEEDBACKBASIC", tag_bv))
        response_if <- tag("responseIf", list(tag_isnull, set_ov))
        tag_lt <- tag("lt", list(tag("variable", list(identifier = "SCORE")),
                                tag("variable", list(identifier = "MAXSCORE"))))
        tag_bv <- tag("baseValue", list(baseType = "identifier", "incorrect"))
        set_ov <- tag("setOutcomeValue",
                      list(identifier = "FEEDBACKBASIC", tag_bv))
        response_elseif <- tag("responseElseIf", list(tag_lt, set_ov))

        tag_bv <- tag("baseValue", list(baseType = "identifier", "correct"))
        set_ov <- tag("setOutcomeValue",
                      list(identifier = "FEEDBACKBASIC", tag_bv))
        response_else <- tag("responseElse", list(set_ov))

        default_cond <- tag("responseCondition",
                            list(response_if, response_elseif,
                                                   response_else))

        #create modal conditions
        resp_conds <- Map(createResponseCondition, object@feedback)
        conditions <- c(default_cond, resp_conds)
    }
    tag("responseProcessing", list(processing, conditions))
}

make_response_condition <- function(object) {
    tag_var <- tag("variable", list(identifier = object@response_identifier))
    tag("isNull", list(tag_var))
}

create_outcome_declaration_entry <- function(object) {
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
    answers <- Map(getResponse, object@content)
    answers[sapply(answers, is.null)] <- NULL
    tagList(Map(createOutcomeDeclaration, answers), feedbacks)
}
