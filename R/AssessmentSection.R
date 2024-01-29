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
                                     time_limit = "numeric",
                                     visible = "logical",
                                     assessment_item = "list",
                                     shuffle = "logical",
                                     selection = "numeric",
                                     max_attempts = "numeric",
                                     allow_comment = "logical"),
         prototype = prototype(identifier = ids::adjective_animal(),
                               visible = TRUE,
                               time_limit = NA_integer_,
                               shuffle = FALSE,
                               selection = NA_integer_,
                               max_attempts = NA_integer_,
                               allow_comment = TRUE
         ))

setMethod("initialize", "AssessmentSection", function(.Object, ...) {
    .Object <- callNextMethod()

    if (length(.Object@title) == 0) .Object@title <- .Object@identifier

    # check identifiers
    ids <- sapply(.Object@assessment_item, getIdentifier)
    if (length(ids) != length(unique(ids))) {
        ids <- paste(ids, collapse = ", ")
        stop("Items of section id:", .Object@identifier,
                " contain non-unique values: ", ids, call. = FALSE)
    }

    # check selection value
    if (!is.na(.Object@selection)) {
        if (.Object@selection > length(.Object@assessment_item)) {
            warning(paste0("value of selection (", .Object@selection,
            ") must be less than number of items in assessment_item slot (",
            length(.Object@assessment_item), "). Selection is assigned to ",
            length(.Object@assessment_item) - 1))
            .Object@selection <- length(.Object@assessment_item) - 1
        }
    }

    select  <- .Object@selection
    if (!is.na(select)) if (select == 0) .Object@selection <- NA_integer_

    validObject(.Object)
    .Object
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
              return(object@identifier)
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
