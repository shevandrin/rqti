#' Create a section as part of a test content
#'
#' Create an AssessmentSection `rqti`-object as part of a test content
#' @param content A character vector of Rmd, md, xml files, task- or
#'   section-objects.
#' @param n_variants An integer value indicating the number of task variants to
#'   create from Rmd files. Default is `1`.
#' @param seed_number An integer vector, optional, specifying seed numbers to
#'   reproduce the result of calculations.
#' @param id A character value, optional, serving as the identifier of the
#'   assessment section.
#' @param by A character with two possible values: "variants" or "files",
#'   indicating the type of the test structure. Default is "variants".
#' @param selection An integer value, optional, defining how many children of
#'   the section are delivered in the test. Default is `NULL`, meaning "no
#'   selection".
#' @param title A character value, optional, representing the title of the
#'   section. If not provided, it defaults to `identifier`.
#' @param time_limits An integer value, optional, controlling the amount of time
#'   a candidate is allowed for this part of the test.
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
#' sc <- new("SingleChoice", prompt = "Question", choices = c("A", "B", "C"))
#' es <- new("Essay", prompt = "Question")
#' # Since ready-made S4 "AssessmentItem" objects are taken, in this example a
#' #permanent section consisting of two tasks is created.
#' s <- section(c(sc, es), title = "Section with nonrandomized tasks")
#'
#' # Since Rmd files with randomization of internal variables are taken,
#' #in this example 2 variants are created with a different seed number for each.
#' path <- system.file("rmarkdown/templates/", package='rqti')
#' file1 <- file.path(path, "singlechoice-simple/skeleton/skeleton.Rmd")
#' file2 <- file.path(path, "singlechoice-complex/skeleton/skeleton.Rmd")
#' s <- section(c(file1, file2), n_variants = 2,
#' title = "Section with two variants of tasks")
#' @seealso [test()], [test4opal()]
#' @export
section <- function(content, n_variants = 1L, seed_number = NULL, id = NULL,
                    by = "variants", selection = NULL, title = character(0),
                    time_limits = NA_integer_, visible = TRUE,
                    shuffle = FALSE, max_attempts = NA_integer_,
                    allow_comment = TRUE) {
    if (by %in% c("variants", "files")) {
        nested <- ifelse(by == "variants", TRUE, FALSE)
    } else {
        stop("Error: Invalid value for parameter \'by\'. The \'by\' parameter must be set to either \"variants\" or \"files\".")
    }
    # check conflicts between seed_number and n_variants
    if (n_variants > length(seed_number) & !is.null(seed_number)) {
        stop("The items in seed_number must be equal to number of variants")
    } else if (n_variants < length(seed_number)) {
        warning(paste("From seed_number only first", n_variants,
                      "items are taken"), call. = FALSE)
        seed_number <- seed_number[1:n_variants]
    }

    # check uniqueness of seed_number items
    if (any(duplicated(seed_number))) {
        stop("The items in seed_number are not unique", call. = FALSE)
    }

    if (is.null(seed_number)) seed_number <- sample.int(10000, n_variants)

    if (n_variants <= 1) {
        if (length(content) == 1) content <- list(content)
        sub_items <- Map(getObject, content)
        if (is.null(id)) id <- paste0("permanent_section_", sample.int(100, 1))
        if (is.null(selection)) selection <- 0

    } else {
        sub_items <- list()

        if (nested) {
            selection <- 1
            files_ <- replicate(n_variants, content, simplify = FALSE)
            if (length(content) > 1) {
                sub_items <- mapply(make_exam_subsection, files_, seed_number)
            } else {
                sub_items <- mapply(make_variant, files_, seed_number)
            }

        } else {
            selection <- NA_integer_
            sub_items <- lapply(content, FUN=make_variant_subsection,
                                n_variants, seed_number)
        }
    }

    if (is.null(id)) {
        if (length(content) == 1) {
            id <- ifelse (typeof(content) == "character",
                          paste0(tools::file_path_sans_ext(basename(content)), "_section"),
                          content@identifier)
        } else {
            id <- paste0("variable_section_", sample.int(100, 1))
        }
    }
    section <- new("AssessmentSection", identifier = id, selection = selection,
                   assessment_item = sub_items, title = title,
                   time_limit = time_limits, visible = visible,
                   shuffle = shuffle, max_attempts = max_attempts,
                   allow_comment = allow_comment)
    return(section)
}

make_variant <- function(object, seed_number) {
    set.seed(seed_number)
    if (typeof(object) == "character") object <- create_question_object(object)
    id <- paste0(object@identifier, "_S", seed_number)
    object@identifier <- id
    object@title <- paste0(object@title, "_S", seed_number)
    return(object)
}

make_exam_subsection <- function(object, seed_number) {
    if (length(object) == 1) {
        id <- ifelse(typeof(object) == "character",
                     tools::file_path_sans_ext(basename(object)),
                     object@identifier)
        id <- paste0(id, "_S", seed_number)
        object <- list(object)
    } else {
        id <- paste0("exam_S", seed_number)
    }

    asmt_items <- mapply(make_variant, object, rep(seed_number, length(object)),
                         USE.NAMES = FALSE)
    exam_subsection <- new("AssessmentSection", identifier = id,
                           assessment_item = asmt_items)
    return(exam_subsection)
}

make_variant_subsection <- function(file, n_variants, seed_number) {
    id <- tools::file_path_sans_ext(basename(file))

    asmt_items <- mapply(FUN=make_variant, rep(file, n_variants), seed_number,
                         USE.NAMES = FALSE)

    exam_subsection <- new("AssessmentSection", identifier = id,
                           assessment_item = asmt_items, selection = 1)
    return(exam_subsection)
}

#' Create a test
#'
#' Create an AssessmentTest `rqti`-object.
#'
#' @param content A list containing [AssessmentSection] objects.
#' @param identifier A character value indicating the identifier of the test
#'   file. Default is 'test_identifier'.
#' @param title A character value, optional, representing the file title.
#'   Default is 'Test Title'.
#' @param time_limit An integer value, optional, controlling the time given to a
#'   candidate for the test in minutes. Default is 90 minutes.
#' @param max_attempts An integer value, optional, indicating the maximum number
#'   of attempts allowed for the candidate. Default is 1.
#' @param academic_grading A boolean, optional; enables showing a grade to the
#'   candidate at the end of the testing according to the 5-point academic grade
#'   system as feedback. Default is `FALSE.`
#' @param grade_label A character value, optional; a short message that shows
#'   with a grade in the final feedback; for multilingual use, it can be a named
#'   vector with two-letter ISO language codes as names (e.g., c(en="Grade",
#'   de="Note")); during test creation, it takes the value for the language of
#'   the operating system; c(en="Grade", de="Note")is default.
#' @param table_label A character value, optional; a concise message to display
#'   as the column title of the grading table in the final feedback; for
#'   multilingual use, it can be a named vector with two-letter ISO language
#'   codes as names (e.g., c(en="Grade", de="Note")); during test creation, it
#'   takes the value for the language of the operating system; c(en="Grade",
#'   de="Note")is default.
#' @param navigation_mode A character value, optional, determining the general
#'   paths that the candidate may have during the exam. Two mode options are
#'   possible:
#'     - 'linear': Candidate is not allowed to return to previous questions.
#'     - 'nonlinear': Candidate is free to navigate; used by default.
#' @param submission_mode A character value, optional, determining when the
#'   candidate's responses are submitted for response processing. One of two
#'   mode options is possible:
#'     - 'individual': Submit candidates' responses on an item-by-item basis; used by default.
#'     - 'simultaneous': Candidates' responses are submitted all together by the end of the test.
#' @param allow_comment A boolean, optional, enabling the candidate to leave
#'   comments in each question. Default is `TRUE.`
#' @param rebuild_variables A boolean, optional, enabling the recalculation of
#'   variables and reshuffling the order of choices for each item-attempt.
#'   Default is `TRUE.`
#' @return An [AssessmentTest] object.
#' @seealso [test4opal()], [section()], [AssessmentTest], [AssessmentSection]
#' @examples
#' sc <- new("SingleChoice", prompt = "Question", choices = c("A", "B", "C"))
#' es <- new("Essay", prompt = "Question")
#' s <- section(c(sc, es), title = "Section with nonrandomized tasks")
#' t <- test(s, title = "Example of the Exam", academic_grading = TRUE)
#'
#'@export
test <- function(content, identifier = "test_identifier", title = "Test Title",
                 time_limit = 90L, max_attempts = 1L, academic_grading = FALSE,
                 grade_label = c(en="Grade", de="Note"),
                 table_label = c(en="Grade", de="Note"),
                 navigation_mode = "nonlinear", submission_mode = "individual",
                 allow_comment = TRUE, rebuild_variables = TRUE) {

    params <- as.list(environment())
    params <- Filter(Negate(is.null), params)
    params["section"] <- ifelse (length(unlist(params["content"])) == 1,
                                 list(params["content"]), as.list(params["content"]))
    params["content"] = NULL
    # define test class
    params["Class"] <- "AssessmentTest"
    object <- do.call(new, params)
    return(object)
}

#' Create a test for LMS OPAL
#'
#' Create an AssessmentTestOpal `rqti`-object.
#'
#' @param content A list containing [AssessmentSection] objects.
#' @param identifier A character value indicating the identifier of the test
#'   file. Default is 'test_identifier'.
#' @param title A character value, optional, representing the file title.
#'   Default is 'Test Title'.
#' @param time_limit An integer value, optional, controlling the time given to a
#'   candidate for the test in minutes. Default is 90 minutes.
#' @param max_attempts An integer value, optional, indicating the maximum number
#'   of attempts allowed for the candidate. Default is 1.
#' @param files A character vector, optional; paths to files that will be
#'   accessible to the candidate during the test/exam.
#' @param calculator A character, optional; determines whether to show a
#'   calculator to the candidate. Possible values:
#'   - 'simple-calculator'
#'   - 'scientific-calculator' (assigned by default).
#' @param academic_grading A boolean, optional; enables to show to candidate at
#'   the end of the testing a grade according to 5-point academic grade system
#'   as a feedback; Default is `FALSE`.
#' @param grade_label A character value, optional; a short message that shows
#'   with a grade in the final feedback; for multilingual use, it can be a named
#'   vector with two-letter ISO language codes as names (e.g., c(en="Grade",
#'   de="Note")); during test creation, it takes the value for the language of
#'   the operating system; c(en="Grade", de="Note")is default.
#' @param table_label A character value, optional; a concise message to display
#'   as the column title of the grading table in the final feedback; for
#'   multilingual use, it can be a named vector with two-letter ISO language
#'   codes as names (e.g., c(en="Grade", de="Note")); during test creation, it
#'   takes the value for the language of the operating system; c(en="Grade",
#'   de="Note")is default.
#' @param navigation_mode A character value, optional, determining the general
#'   paths that the candidate may have during the exam. Two mode options are
#'   possible:
#'     - 'linear': Candidate is not allowed to return to previous questions.
#'     - 'nonlinear': Candidate is free to navigate; used by default.
#' @param submission_mode A character value, optional, determining when the
#'   candidate's responses are submitted for response processing. One of two
#'   mode options is possible:
#'     - 'individual': Submit candidates' responses on an item-by-item basis; used by default.
#'     - 'simultaneous': Candidates' responses are submitted all together by the end of the test.
#' @param allow_comment A boolean, optional, enabling the candidate to leave
#'   comments in each question. Default is `TRUE.`
#' @param rebuild_variables A boolean, optional, enabling the recalculation of
#'   variables and reshuffling the order of choices for each item-attempt.
#'   Default is `TRUE`.
#' @param show_test_time A boolean, optional, determining whether to show
#'   candidate elapsed processing time without a time limit. Default is `TRUE`.
#' @param mark_items A boolean, optional, determining whether to allow candidate
#'   marking of questions. Default is `TRUE`.
#' @param keep_responses A boolean, optional, determining whether to save the
#'   candidate's answers from the previous attempt. Default is `FALSE`.
#' @return An [AssessmentTestOpal] object
#' @seealso [test()], [section()],
#'   [AssessmentTestOpal], [AssessmentSection]
#' @examples
#' sc <- new("SingleChoice", prompt = "Question", choices = c("A", "B", "C"))
#' es <- new("Essay", prompt = "Question")
#' s <- section(c(sc, es), title = "Section with nonrandomized tasks")
#' t <- test4opal(s, title = "Example of the Exam", academic_grading = TRUE,
#' show_test_time = FALSE)
#' @export
test4opal <- function(content, identifier = "test_identifier",
                      title = "Test Title", time_limit = 90L, max_attempts = 1L,
                      files = NULL, calculator = "scientific-calculator",
                      academic_grading = FALSE,
                      grade_label = c(en="Grade", de="Note"),
                      table_label = c(en="Grade", de="Note"),
                      navigation_mode = "nonlinear",
                      submission_mode = "individual", allow_comment = TRUE,
                      rebuild_variables = TRUE, show_test_time = TRUE,
                      mark_items  = TRUE, keep_responses = FALSE) {

    params <- as.list(environment())
    params <- Filter(Negate(is.null), params)
    params["section"] <- ifelse (length(unlist(params["content"])) == 1,
                                 list(params["content"]), as.list(params["content"]))
    params["content"] = NULL
    # define test class
    params["Class"] <- "AssessmentTestOpal"
    object <- do.call(new, params)
}
