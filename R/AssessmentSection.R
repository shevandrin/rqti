#' Class "AssessmentSection"
#'
#' Class `AssessmentSection` is responsible for forming a section in the test
#' XML specification according to QTI 2.1.
#' @template ASSlotsTemplate
#' @seealso [section()], [test()], [test4opal()], [AssessmentTest],
#'   [AssessmentTestOpal].
#' @examples
#' sc1 <- new("SingleChoice", prompt = "Example task 1", title = "SC1",
#'              identifier = "q1", choices = c("a", "b", "c"))
#' sc2 <- new("SingleChoice", prompt = "Example task 2", title = "SC2",
#'              identifier = "q2", choices = c("A", "B", "C"))
#' sc3 <- new("SingleChoice", prompt = "Example task 3", title = "SC3",
#'              identifier = "q3", choices = c("aa", "bb", "cc"))
#' exam_section <- new("AssessmentSection",
#'                     identifier = "sec_id",
#'                     title = "Section",
#'                     time_limit = 20,
#'                     visible = FALSE,
#'                     assessment_item = list(sc1, sc2, sc3),
#'                     shuffle = FALSE,
#'                     selection = 1,
#'                     max_attempts = 1,
#'                     allow_comment = FALSE)
#' @name AssessmentSection-class
#' @rdname AssessmentSection-class
#' @aliases AssessmentSection
setClass("AssessmentSection", slots = c(identifier = "character",
                                        title = "character",
                                        time_limit = "numeric",
                                        visible = "logical",
                                        assessment_item = "list",
                                        shuffle = "logical",
                                        selection = "numeric",
                                        max_attempts = "numeric",
                                        allow_comment = "logical"),
    prototype = prototype(visible = TRUE,
                          time_limit = NA_integer_,
                          shuffle = FALSE,
                          selection = NA_integer_,
                          max_attempts = NA_integer_,
                          allow_comment = TRUE)
)

setMethod("initialize", "AssessmentSection", function(.Object, ...) {
    .Object <- callNextMethod()

    if (length(.Object@identifier) == 0) {
        .Object@identifier <- generate_id(type = "section")
    }

    if (length(.Object@title) == 0) .Object@title <- .Object@identifier

    # check identifiers
    ids <- sapply(.Object@assessment_item, getIdentifier)
    if (length(ids) != length(unique(ids))) {
        ids <- paste(ids, collapse = ", ")
        stop("Items of section id:", .Object@identifier,
             " contain non-unique values: ", ids, call. = FALSE)
    }
    check_identifier(.Object@identifier)

    # check selection value
    if (!is.na(.Object@selection)) {
        if (.Object@selection > length(.Object@assessment_item)) {
            warning(paste0("value of selection (", .Object@selection,
                           ") must be less than number of items in ",
                           "assessment_item slot (",
                           length(.Object@assessment_item),
                           "). Selection is assigned to ",
                           length(.Object@assessment_item) - 1))
            .Object@selection <- length(.Object@assessment_item) - 1
        }
    }

    select  <- .Object@selection
    if (!is.na(select)) if (select == 0) .Object@selection <- NA_integer_

    validObject(.Object)
    .Object
})


#' Create an object [AssessmentSection]
#'
#' Create an [AssessmentSection] `rqti`-object as part of a test content
#' @param assessment_item A list containing [AssessmentSection] and/or
#'   Assessment item objects, such as [SingleChoice], [MultipleChoice], [Essay],
#'   [Entry], [Ordering], [OneInRowTable], [OneInColTable],
#'   [MultipleChoiceTable], and [DirectedPair].
#' @param identifier A character value indicating the identifier of the test
#'   file. By default, it is generated as 'id_section_dddd', where dddd
#'   represents random digits.
#' @param title A character value, optional, representing the file title. By
#'   default, it takes the value of the `identifier`.
#' @param selection An integer value, optional, defining how many children of
#'   the section are delivered in the test. Default is `NA_integer_`, meaning
#'   "no selection".
#' @param time_limit An integer value, optional, controlling the amount of time
#'   in munutes a candidate is allowed for this part of the test.
#' @param visible A boolean value, optional, indicating whether the title of
#'   this section is shown in the hierarchy of the test structure. Default is
#'   `TRUE`.
#' @param shuffle A boolean value, optional, responsible for randomizing the
#'   order in which the assessment items and subsections are initially presented
#'   to the candidate. Default is `FALSE`.
#' @param max_attempts An integer value, optional, enabling the maximum number
#'   of attempts allowed for a candidate to pass this section.
#' @param allow_comment A boolean value, optional, enabling candidates to leave
#'   comments on each question of the section. Default is `TRUE`.
#' @return An object of class [AssessmentSection].
#' @examples
#' sc <- singleChoice(prompt = "Question", choices = c("A", "B", "C"))
#' es <- essay(prompt = "Question")
#' # Since ready-made S4 "AssessmentItem" objects are taken, in this example a
#' #permanent section consisting of two tasks is created.
#' s <- assessmentSection(list(sc, es), title = "Section with nonrandomized tasks")
#' @seealso [section()], [test()], [test4opal()]
#' @export
assessmentSection <- function(assessment_item,
                              identifier = generate_id(type = "section"),
                              title = identifier, selection = NA_integer_,
                              time_limit = NA_integer_, visible = TRUE,
                              shuffle = FALSE, max_attempts = NA_integer_,
                              allow_comment = TRUE) {
    params <- as.list(environment())
    params$Class <- "AssessmentSection"
    obj <- do.call("new", params)
    return(obj)
}

#' @rdname getAssessmentItems-methods
#' @aliases getAssessmentItems,AssessmentSection
setMethod("getAssessmentItems", signature(object = "AssessmentSection"),
          function(object) {
              Map(getAssessmentItems, object@assessment_item)
          })

#' @rdname buildAssessmentSection-methods
#' @aliases buildAssessmentSection,AssessmentSection
setMethod("buildAssessmentSection", signature(object = "AssessmentSection"),
          function(object, folder, verify) {
              create_section_test(object, folder, verify)
          })

#' @rdname getPoints-methods
#' @aliases getPoints,AssessmentSection
setMethod("getPoints", signature(object = "AssessmentSection"),
          function(object) {
              points <- sapply(object@assessment_item, getPoints)
              if (!is.na(object@selection)) {
                  is_same <- all(points == points[1])
                  if (!is_same) {
                      ids <- paste(names(points), "=", points, collapse = ", ")
                      msg <- paste0("In section id:", object@identifier,
                                    " there are items with different points. ",
                                    "In selection mode, this leads to ",
                                    "inconsistent overall score in different ",
                                    "test variants: ", ids)
                      warning(msg, call. = FALSE)
                  }
                  points <- points[seq(object@selection)]
              }
              points <- sum(points)
              names(points) <- object@identifier
              return(points)
          })

#' @rdname getIdentifier-methods
#' @aliases getIdentifier,AssessmentSection
setMethod("getIdentifier", signature(object = "AssessmentSection"),
          function(object) {
              ids <- sapply(object@assessment_item, getIdentifier)
              return(c(object@identifier, ids))
          })

#' @rdname getObject-methods
#' @aliases getObject,AssessmentSection
setMethod("getObject", signature(object = "AssessmentSection"),
          function(object) {
              return(object)
          })

#' @rdname getFiles-methods
#' @aliases getFiles,AssessmentSection
setMethod("getFiles", signature(object = "AssessmentSection"),
          function(object) {
              result <- unlist(sapply(object@assessment_item, getFiles))
              return(result)
          })

#' @rdname getCalculator-methods
#' @aliases getCalculator,AssessmentSection
setMethod("getCalculator", signature(object = "AssessmentSection"),
          function(object) {
              result <- unlist(sapply(object@assessment_item, getCalculator))
              return(result)
          })

#' @rdname prepareQTIJSFiles-methods
#' @aliases prepareQTIJSFiles,AssessmentSection
setMethod("prepareQTIJSFiles", signature(object = "AssessmentSection"),
          function(object, dir) {
              tst <- test(object)
              prepareQTIJSFiles(tst, dir)
              return(NULL)
          })

#' @rdname getContributors-methods
#' @aliases getContributors,AssessmentSection
setMethod("getContributors", signature(object = "AssessmentSection"),
          function(object) {
              result <- unlist(sapply(object@assessment_item, getContributors))
              return(result)
          })

