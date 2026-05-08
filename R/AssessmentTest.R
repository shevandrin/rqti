setClassUnion("NumericOrNull", c("numeric", "NULL"))
setClassUnion("CharacterOrNull", c("character", "NULL"))

#' Class "AssessmentTest"
#'
#' Class `AssessmentTest` is responsible for creating XML exam files according
#' to the QTI 2.1 standard.
#' @details Test consists of one or more sections. Each section can have one or
#' more questions/tasks and/or one or more sub sections.
#' @template ATSlotsTemplate
#' @seealso [AssessmentSection], [AssessmentTestOpal], [test()], [test4opal()],
#'   [section()].
#' @examples
#' # This example creates test 'exam' with one section 'exam_section' which
#' # consists of two questions/tasks: essay and single choice types
#' task1 <- new("Essay", prompt = "Test task", title = "Essay",
#'              identifier = "q1")
#' task2 <- new("SingleChoice", prompt = "Test task", title = "SingleChoice",
#'              choices = c("A", "B", "C"), identifier = "q2")
#' exam_section <- new("AssessmentSection", identifier = "sec_id",
#'                     title = "section", assessment_item = list(task1, task2))
#' exam <- new("AssessmentTest",
#'             identifier = "id_test_1234",
#'             title = "Example of Exam",
#'             navigation_mode = "linear",
#'             submission_mode = "individual",
#'             section = list(exam_section),
#'             time_limit = 90,
#'             max_attempts = 1,
#'             grade_label = "Preliminary grade")
#' @name AssessmentTest-class
#' @rdname AssessmentTest-class
#' @aliases AssessmentTest
#' @include AssessmentSection.R
setClass("AssessmentTest", slots = c(identifier = "character",
                                     title = "character",
                                     points = "numeric",
                                     test_part_identifier = "character",
                                     navigation_mode = "character",
                                     submission_mode = "character",
                                     section = "list",
                                     time_limit = "numeric",
                                     max_attempts = "numeric",
                                     allow_comment = "logical",
                                     rebuild_variables = "logical",
                                     fallback_titles = "character",
                                     academic_grading = "NumericOrNull",
                                     grade_label = "character",
                                     table_label = "character",
                                     stylesheet_path = "CharacterOrNull",
                                     metadata = "QtiMetadata"),
    prototype = prototype(navigation_mode = "nonlinear",
                          submission_mode = "individual",
                          test_part_identifier = "test_part",
                          time_limit = NA_integer_,
                          max_attempts = NA_integer_,
                          allow_comment = TRUE,
                          rebuild_variables = NA,
                          fallback_titles = "generic",
                          academic_grading = NULL,
                          grade_label = c(en="Grade", de="Note"),
                          table_label = c(en="Grade", de="Note"),
                          stylesheet_path = NULL)
)


setMethod("initialize", "AssessmentTest", function(.Object, ...) {
    .Object <- callNextMethod()

    .Object@fallback_titles <- match.arg(.Object@fallback_titles,
                                         c("filename", "generic"))

    if (length(.Object@identifier) == 0) {
        .Object@identifier <- generate_id(type = "test")
    }
    check_identifier(.Object@identifier)

    # us identifier as a title
    if (length(.Object@title) == 0) .Object@title <- .Object@identifier

    # assign points
    points <- sum(sapply(.Object@section, getPoints))
    .Object@points <- points

    # check identifiers
    ids <- unlist(lapply(.Object@section, getIdentifier))
    if (length(ids) != length(unique(ids))) {
        warning("Identifiers of test sections contain non-unique values: ",
                paste(unique(ids[duplicated(ids)]), collapse = ", "),
                call. = FALSE)
    }

    # check time limits
    if (!is.na(.Object@time_limit)) {
        if (.Object@time_limit > 180 | .Object@time_limit < 0.01) {
            warning("Value of time_limits does not seem plausible.",
                    call. = FALSE)
        }
    }

    .Object@section <- assign_fallback_titles(
        .Object@section,
        mode = .Object@fallback_titles
    )

    validObject(.Object)
    .Object
})

#'Create an object [AssessmentTest]
#'
#'Create an AssessmentTest `rqti`-object.
#'
#'@param section A list containing [AssessmentSection] objects.
#'@param identifier A character value indicating the identifier of the test
#'  file. By default, it is generated as 'id_test_dddd', where dddd represents
#'  random digits.
#'@param title A character value, optional, representing the file title. By
#'  default, it takes the value of the identifier.
#'@param time_limit An integer value, optional, controlling the time given to a
#'  candidate for the test in minutes. Default is \code{NULL}.
#'@param max_attempts An integer value, optional, indicating the maximum number
#'  of attempts allowed for the candidate. Default is 1.
#' @param fallback_titles A character value, optional, controlling how titles
#'   are assigned when no explicit title is provided. Possible values are
#'   "filename" (use filenames as titles) and "generic" (use generic labels
#'   such as "Section 1", "Section 1.2", or "Task 1.2.1"). Default is
#'   "generic".
#' @param academic_grading A named numeric vector that defines the grade table
#'   shown to the candidate as feedback at the end of the test.
#'
#'   Each grade corresponds to the minimum percentage score required to achieve it.
#'   A helper function \code{german_grading()} is available to generate a common
#'   German grading scheme.
#'
#'   The default is \code{NULL}, which means that no grading table is shown.
#'   To display a grading table, provide a named numeric vector or use
#'   \code{german_grading()}.
#'@param grade_label A character value, optional; a short message that shows
#'  with a grade in the final feedback; for multilingual use, it can be a named
#'  vector with two-letter ISO language codes as names (e.g., c(en="Grade",
#'  de="Note")); during test creation, it takes the value for the language of
#'  the operating system; c(en="Grade", de="Note")is default.
#'@param table_label A character value, optional; a concise message to display
#'  as the column title of the grading table in the final feedback; for
#'  multilingual use, it can be a named vector with two-letter ISO language
#'  codes as names (e.g., c(en="Grade", de="Note")); during test creation, it
#'  takes the value for the language of the operating system; c(en="Grade",
#'  de="Note")is default.
#'@param navigation_mode A character value, optional, determining the general
#'  paths that the candidate may have during the exam. Two mode options are
#'  possible:
#'     - 'linear': Candidate is not allowed to return to previous questions.
#'     - 'nonlinear': Candidate is free to navigate; used by default.
#'@param submission_mode A character value, optional, determining when the
#'  candidate's responses are submitted for response processing. One of two mode
#'  options is possible:
#'     - 'individual': Submit candidates' responses on an item-by-item basis; used by default.
#'     - 'simultaneous': Candidates' responses are submitted all together by the end of the test.
#'@param allow_comment A boolean, optional, enabling the candidate to leave
#'  comments in each question. Default is `TRUE.`
#'@param rebuild_variables A boolean, optional, enabling the recalculation of
#'  variables and reshuffling the order of choices for each item-attempt.
#'  Default is `TRUE.`
#'@param stylesheet_path A character value, optional, specifying the path to a
#'   custom CSS stylesheet. If provided, the stylesheet is included at the
#'   assessment test level and applied during rendering. When
#'   \code{academic_grading} is set, the default stylesheet
#'   \code{styles/rqti.css} is included automatically; a user-defined stylesheet
#'   is added in addition and may override default styles.
#'@param metadata An object of class [QtiMetadata] that holds metadata
#'  information about the test. By default it creates [QtiMetadata] object. See
#'  [qtiMetadata()].
#'@param points Do not use directly; the maximum number of points for the
#'  exam/test. It is calculated automatically as a sum of points of included
#'  tasks.
#'@return An [AssessmentTest] object.
#'@seealso [test()], [test4opal()], [section()], [AssessmentTest],
#'  [AssessmentSection]
#' @examples
#' sc <- sc <- singleChoice(prompt = "Question", choices = c("A", "B", "C"))
#' es <- new("Essay", prompt = "Question")
#' s <- section(c(sc, es), title = "Section with nonrandomized tasks")
#' t <- assessmentTest(list(s), title = "Example of the Exam")
#'
#'@export
assessmentTest <- function(section, identifier = generate_id(type = "test"),
                           title = identifier, time_limit = NULL,
                           max_attempts = 1L,
                           fallback_titles = "generic",
                           academic_grading = NULL,
                           grade_label = c(en="Grade", de="Note"),
                           table_label = c(en="Grade", de="Note"),
                           navigation_mode = "nonlinear",
                           submission_mode = "individual",
                           allow_comment = TRUE, rebuild_variables = TRUE,
                           metadata = qtiMetadata(),
                           stylesheet_path = NULL, points = NA_real_) {
    params <- as.list(environment())
    params$Class <- "AssessmentTest"
    params$time_limit <- ifelse(is.null(time_limit), NA_integer_, time_limit)
    obj <- do.call("new", params)
    return(obj)
}

#' Create an element assessmentTest of a qti-xml document for test
#'
#' Generic function for creating assessmentTest element for XML document of
#' specification the test following the QTI schema v2.1
#'
#' @param object an instance of the S4 object [AssessmentTest] or
#'   [AssessmentTestOpal]
#' @param folder string, optional; a folder to store xml file; working directory
#'   by default
#' @param verify boolean, optional; to check validity of xml file, default
#'   `FALSE`
#' @docType methods
#' @rdname createAssessmentTest-methods
#' @aliases createAssessmentTest
setGeneric("createAssessmentTest",
           function(object, folder,
                    verify = FALSE) standardGeneric("createAssessmentTest"))

#' Create an Zip archive of QTI test
#'
#' Generic function for creating zip archive with set of XML documents of
#' specification the test following the QTI schema v2.1
#'
#' @param object an instance of the S4 object [AssessmentTest] or
#'   [AssessmentTestOpal]
#' @param input string, optional; a source folder with xml files
#' @param output string, optional; a folder to store zip and xml files; working
#'   directory by default
#' @param file_name string, optional; file name of zip archive
#' @param zip_only boolean, optional; returns only zip file in case of TRUE or
#'   zip, xml and downloads files in case of FALSE value
#' @docType methods
#' @rdname createZip-methods
#' @aliases createZip
setGeneric("createZip", function(object, input, output, file_name, zip_only) {
    StandartGeneric("createZip")
})

#' Create a configuration file for QTI test
#'
#' Generic function for creating additional configuration file for the archive with test
#'
#' @param object an instance of the S4 object [AssessmentTest]
#' @param output string, a folder to store an xml configuration files
#' @docType methods
#' @rdname createConfigurationFile-methods
#' @aliases createConfigurationFile
setGeneric("createConfigurationFile", function(object, output) {
    StandartGeneric("createConfigurationFile")
})

#' @rdname createAssessmentTest-methods
#' @aliases createAssessmentTest,AssessmentTest
setMethod("createAssessmentTest", signature(object = "AssessmentTest"),
          function(object, folder, verify) {
              create_assessment_test(object, folder, verify)
          })

#' @rdname createQtiTest-methods
#' @aliases createQtiTest,AssessmentTest
setMethod("createQtiTest", signature(object = "AssessmentTest"),
          function(object, dir = getwd(), verification = FALSE,
                   zip_only = FALSE) {
              create_qti_test(object, dir, verification, zip_only)
          })

#' @rdname createOutcomeDeclaration-methods
#' @aliases createOutcomeDeclaration,AssessmentTest
setMethod("createOutcomeDeclaration", signature(object = "AssessmentTest"),
          function(object) {
              feedback_grade <- NULL
              feedback_grade_table <- NULL
              if (!all(is.na(object@academic_grading))) {
                  feedback_grade <- make_outcome_declaration("FEEDBACKMODAL",
                                                             "multiple",
                                                             "identifier",
                                                             value = NULL,
                                                             view = "testConstructor")
                  feedback_grade_table <- make_outcome_declaration("FEEDBACKTABLE",
                                                                   "multiple",
                                                                   "identifier",
                                                                   value = NULL,
                                                                   view = "testConstructor")
              }
              tagList(make_outcome_declaration("SCORE", value = 0),
                      feedback_grade, feedback_grade_table,
                      make_outcome_declaration("MAXSCORE",
                                               value = object@points),
                      make_outcome_declaration("MINSCORE", value = 0))
          })

#' @rdname createZip-methods
#' @aliases createZip,AssessmentTest
setMethod("createZip", signature(object = "AssessmentTest"),
          function(object, input, output, file_name, zip_only) {
              if (is.null(file_name)) file_name <- object@identifier
              zip_wrapper(file_name, input, output, NULL, zip_only)
          })

#' @rdname prepareQTIJSFiles-methods
#' @aliases prepareQTIJSFiles,AssessmentTest
setMethod("prepareQTIJSFiles", signature(object = "AssessmentTest"),
          function(object, dir) {
              zip_file <- createQtiTest(object = object,
                                        dir = dir,
                                        verification = FALSE)
              zip::unzip(zip_file, exdir = dir)
              unlink(zip_file)
              return(NULL)
          })

#' @include AssessmentTest.R
#' @rdname createMetadata-methods
#' @aliases createMetadata,AssessmentTest
setMethod("createMetadata", signature(object = "AssessmentTest"),
          function(object) {
              create_metadata(object)
          })

#' @rdname createConfigurationFile-methods
#' @aliases createConfigurationFile,AssessmentTest
setMethod("createConfigurationFile", signature(object = "AssessmentTest"),
          function(object, output) {
          })

assign_fallback_titles <- function(section,
                                   mode = c("filename", "generic")) {
    mode <- match.arg(mode)

    if (mode == "filename") {
        return(section)
    }

    warned_paths <- FALSE

    for (i in seq_along(section)) {
        res <- assign_titles_section(
            sec = section[[i]],
            path = as.character(i),
            warned_paths = warned_paths
        )
        section[[i]] <- res$section
        warned_paths <- res$warned_paths
    }

    return(section)
}

assign_titles_section <- function(sec, path, warned_paths = FALSE) {
    sec@title <- paste("Section", path)

    if (length(sec@assessment_item) > 0) {
        task_counter <- 0
        subsection_counter <- 0

        for (j in seq_along(sec@assessment_item)) {
            obj <- sec@assessment_item[[j]]

            if (is(obj, "AssessmentSection")) {
                subsection_counter <- subsection_counter + 1
                sub_path <- paste0(path, ".", subsection_counter)

                res <- assign_titles_section(
                    sec = obj,
                    path = sub_path,
                    warned_paths = warned_paths
                )
                obj <- res$section
                warned_paths <- res$warned_paths

            } else if (is.character(obj) && length(obj) == 1) {
                if (!warned_paths) {
                    message(
                        "Generic fallback titles cannot be assigned to assessment items ",
                        "provided as XML file paths. These entries keep their original titles."
                    )
                    warned_paths <- TRUE
                }

            } else {
                task_counter <- task_counter + 1
                task_path <- paste0(path, ".", task_counter)
                obj@title <- paste("Task", task_path)
            }

            sec@assessment_item[[j]] <- obj
        }
    }

    return(list(section = sec, warned_paths = warned_paths))
}

