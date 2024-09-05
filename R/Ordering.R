#' Class "Ordering"
#'
#' Class `Ordering` is responsible for creating assessment task according
#' to QTI 2.1., where candidate has to place answers in a specific order
#' @template AISlotsTemplate
#' @template OrderSlotsTemplate
#' @examples
#' ord <- new("Ordering",
#'            identifier = "id_task_1234",
#'            title = "order",
#'            content = list("<p>Put these items in a right order</p>"),
#'            prompt = "",
#'            points = 2,
#'            feedback = list(),
#'            choices = c("first", "second", "third"),
#'            choices_identifiers = c("ChoiceA", "ChoiceB", "ChoiceC"),
#'            shuffle = TRUE,
#'            points_per_answer = TRUE)
#' @name Ordering-class
#' @rdname Ordering-class
#' @aliases Ordering
#' @exportClass Ordering
#' @include AssessmentItem.R
setClass("Ordering", contains = "AssessmentItem",
         slot = list(choices = "character",
                     choices_identifiers = "character",
                     shuffle = "logical",
                     points_per_answer = "logical"),
         prototype = list(shuffle = TRUE, points_per_answer = TRUE))

setMethod("initialize", "Ordering", function(.Object, ...) {
    .Object <- callNextMethod()
    if (length(.Object@choices_identifiers)==0) {
        .Object@choices_identifiers <- paste0("Choice",
                                              LETTERS[seq(.Object@choices)])
    }
    validObject(.Object)
    .Object
})

#' Create object [Ordering]
#'
#' @param identifier A character representing the unique identifier of the
#'   assessment task. By default, it is generated as 'id_task_dddd', where dddd
#'   represents random digits.
#' @param title A character representing the title of the XML file associated
#'   with the task. By default, it takes the value of the identifier.
#' @param choices A character vector containing the answers. The order of
#'   answers in the vector represents the correct response for the task.
#' @param choices_identifiers A character vector, optional, containing a set of
#'   identifiers for answers. By default, identifiers are generated
#'   automatically according to the template "ChoiceD", where D is a letter
#'   representing the alphabetical order of the answer in the list.
#' @param content A character string or a list of character strings to form the
#'   text of the question, which may include HTML tags.
#' @param prompt An optional character representing a simple question text,
#'   consisting of one paragraph. This can supplement or replace content in the
#'   task. Default is "".
#' @param points A numeric value, optional, representing the number of points
#'   for the entire task. Default is 1.
#' @param points_per_answer A boolean value indicating the scoring method. If
#'   `TRUE`, each selected answer will be scored individually. If `FALSE`, only
#'   fully correct answers will be scored with the maximum score. Default is
#'   `TRUE`.
#' @param shuffle A boolean value indicating whether to randomize the order in
#'   which the choices are initially presented to the candidate. Default is
#'   `TRUE`.
#' @param feedback A list containing feedback messages for candidates. Each
#'   element of the list should be an instance of either [ModalFeedback],
#'   [CorrectFeedback], or [WrongFeedback] class.
#' @param calculator A character, optional, determining whether to show a
#'   calculator to the candidate. Possible values:
#'   * "simple"
#'   * "scientific".
#' @param files A character vector, optional, containing paths to files that
#'   will be accessible to the candidate during the test/exam.
#' @return An object of class [Ordering]
#' @examples
#' ord_min <- ordering(prompt = "Set the right order:",
#'                        choices = c("Step1", "Step2", "Step3"))
#'
#' ord <- ordering(identifier = "id_task_1234",
#'              title = "Order Task",
#'              choices = c("Step1", "Step2", "Step3"),
#'              choices_identifiers = c("a", "b", "c"),
#'              content = "<p>Set the right order</p>",
#'              prompt = "Plain text, can be used instead of content",
#'              points = 2,
#'              points_per_answer = FALSE,
#'              shuffle = FALSE,
#'              feedback = list(new("WrongFeedback",
#'                                    content = list("Wrong answer"))),
#'              calculator = "scientific-calculator",
#'              files = "text_book.pdf")
#'
#' @export
ordering <- function(identifier = generate_id(),
                  title = identifier,
                  choices,
                  choices_identifiers = paste0("Choice", LETTERS[seq(choices)]),
                  content = list(),
                  prompt = "",
                  points = 1,
                  points_per_answer = TRUE,
                  shuffle = TRUE,
                  feedback = list(),
                  calculator = NA_character_,
                  files = NA_character_) {
    params <- as.list(environment())
    if (is.character(params$content)) params$content <- list(params$content)
    params$Class <- "Ordering"
    obj <- do.call("new", params)
    return(obj)
}

#' @rdname createItemBody-methods
#' @aliases createItemBody,Ordering
setMethod("createItemBody", signature(object = "Ordering"),
          function(object) {
              create_item_body_order(object)
          })

#' @rdname createResponseDeclaration-methods
#' @aliases createResponseDeclaration,Ordering
setMethod("createResponseDeclaration", signature(object = "Ordering"),
          function(object) {
              create_response_declaration_order(object)
          })

#' @rdname createResponseProcessing-methods
#' @aliases createResponseProcessing,Ordering
setMethod("createResponseProcessing", signature(object = "Ordering"),
          function(object) {
              create_default_resp_processing_order(object)
          })

create_response_declaration_order <- function(object) {
    child <- create_correct_response(object@choices_identifiers)
    tag("responseDeclaration", list(identifier = "RESPONSE",
                                    cardinality = "ordered",
                                    baseType = "identifier",
                                    child))
}

setMethod("createResponseCondition", signature(object = "Ordering"),
    function(object) {
        if (object@points_per_answer) {
            counts <- length(object@choices)
            answ_points <- round(object@points / counts, 3)
            answ_points <- rep(answ_points, counts - 1)
            answ_points <- c(answ_points, object@points - sum(answ_points))
            indexes <- seq(length(object@choices))
            resp_cond <- Map(create_condition_points, answ_points, indexes)
            return(resp_cond)
        }
    }
)

create_condition_points <- function(answ_points, index) {
    var_tag <- tag("variable", list(identifier = "RESPONSE"))
    index1 <- tag("index", list(n = index, var_tag))
    corr_tag <- tag("correct", list(identifier = "RESPONSE"))
    index2 <- tag("index", list(n = index, corr_tag))
    match_tag <- tag("match", list(index1, index2))
    var_tag <- tag("variable", list(identifier = "SCORE"))
    val_tag <- tag("baseValue", list(baseType = "float", answ_points))
    sum_tag <- tag("sum", list(var_tag, val_tag))
    set_out_value <- tag("setOutcomeValue", list(identifier = "SCORE",
                                                 sum_tag))
    response_if <- tag("responseIf", list(match_tag, set_out_value))
    resp_cond <- tag("responseCondition", list(response_if))
    return(resp_cond)
}
