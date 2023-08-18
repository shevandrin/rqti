#' Create a section as a part of test content
#'
#' @param file string; vector of Rmd, md, or xml files
#' @param num_variants integer; number of variants to create from Rmd files
#' @param seed_number integer vector, optional; seed numbers to reproduce the
#'   result of calculations
#' @param id string, optional; identifier of the assessment section
#' @param nested boolean; the type of the test structure; `TRUE` by default
#' @param selection numeric, optional; defines how many children of the section are
#'   delivered in test
#' @param title string, optional; title of the section
#' @param time_limits integer, optional; controls the amount of time a candidate
#'   is allowed for this part of the test
#' @param visible boolean, optional; if TRUE it shows this section in hierarchy
#'   of test structure; default `TRUE`
#' @param shuffle boolean, optional; is responsible to randomize the order in
#'   which the assessment items and subsections are initially presented to the
#'   candidate; default `FALSE`
#' @param max_attempts numeric, optional; enables the maximum number of
#'   attempts, that candidate is allowed to pass in this section
#' @param allow_comment boolean, optional; enables to allow candidate to leave
#'   comments in each question of the section; `TRUE` by default
#' @return object of [AssessmentSection]-class
#' @export
section <- function(file, num_variants = 1, seed_number = NULL, id = NULL,
                    nested = TRUE, selection = 0, title = character(0),
                    time_limits = NA_integer_, visible = TRUE,
                    shuffle = FALSE, max_attempts = NA_integer_,
                    allow_comment = TRUE) {

    if (num_variants > length(seed_number) & !is.null(seed_number)) {
        stop("The items in seed_number must be equal to number of files",
             call. = FALSE)
    } else if (num_variants < length(seed_number)) {
        warning(paste("From seed_number only first", num_variants,
                      "items are taken"), call. = FALSE)
        seed_number <- seed_number[1:num_variants]
    }

    if (num_variants <= 1) {
        rmd_files <- file[grep("\\.Rmd$|\\.md$", file)]
        xml_files <- file[grep("\\.xml$", file)]
        rmd_items <- Map(create_question_object, rmd_files)
        names(rmd_items) <- NULL
        sub_items <- append(rmd_items, xml_files)
        if (is.null(id)) id <- paste0("permanent_section_", sample.int(100, 1))
        selection <- 0

    } else {
        sub_items <- list()

        if (nested) {
            selection <- 1
            for (n  in seq(num_variants)) {
                sec <- make_seed_subsection(file, seed_number[n])
                names(sec) <- NULL
                sub_items <- c(sub_items, sec)
            }
        } else {
            selection <- NA_integer_
            for (f in file) {

                sec <- make_variant_subsection(f, num_variants, seed_number)
                names(sec) <- NULL
                sub_items <- c(sub_items, sec)
            }
        }
    }

    if (is.null(id)) {
        id <- ifelse(length(file) == 1,
                  paste0(tools::file_path_sans_ext(basename(file)), "_section"),
                  paste0("variable_section_", sample.int(100, 1)))
    }
    section <- new("AssessmentSection", identifier = id, selection = selection,
                   assessment_item = sub_items, title = title,
                   time_limits = time_limits, visible = visible,
                   shuffle = shuffle, max_attempts = max_attempts,
                   allow_comment = allow_comment)
    return(section)
}

make_variant <- function(file, seed_number) {
    set.seed(seed_number)
    object <- create_question_object(file)
    id <- paste0(object@identifier, "_S", seed_number)
    object@identifier <- id
    object@title <- paste0(object@title, "_S", seed_number)
    return(object)
}

make_seed_subsection <- function(file, seed_number = NULL) {
    if (is.null(seed_number)) seed_number <- sample.int(10000, 1)
    file_name <-
    id <- ifelse(length(file) == 1,
                 paste0(tools::file_path_sans_ext(basename(file)), "_S",
                        seed_number),
                 paste0("seed_section_S", seed_number))
    asmt_items <- Map(make_variant, file, rep(seed_number, length(file)))
    names(asmt_items) <- NULL
    exam_subsection <- new("AssessmentSection", identifier = id,
                           assessment_item = asmt_items)
    return(exam_subsection)
}

make_variant_subsection <- function(file, num_variants, seed_number = NULL) {
    if (is.null(seed_number)) seed_number <- sample.int(10000, num_variants)
    id <- paste0(tools::file_path_sans_ext(basename(file)),"_S",
                 sample.int(1000, 1))

    asmt_items <- Map(make_variant, file, seed_number)
    names(asmt_items) <- NULL

    exam_subsection <- new("AssessmentSection", identifier = id,
                           assessment_item = asmt_items, selection = 1)
    return(exam_subsection)
}
#' Create test
#'
#' @param content list contains [AssessmentSection] objects
#' @param identifier string; identifier if the test file
#' @param title string, optional; file title
#' @param navigation_mode string, optional; determines the general paths that the
#'   candidate may have during exam; two mode options are possible: `linear`
#'   "linear" - candidate is not allowed to return to the previous questions;
#'   `nonlinear`- candidate if free to navigate, used by default
#' @param submission_mode string, optional; determines when the candidate's responses
#'   are submitted for response processing; two mode options are possible:
#'   `individual` - submit candidates' responses on an item-by-idem basis, used
#'   by default; `simultaneous - candidates` - responses are submitted all
#'   together by the end of the test
#' @param time_limits numeric, optional; controls the amount of time a candidate
#'   is given for the test
#' @param max_attempts numeric, optional; enables the maximum number of
#'   attempts, that candidate is allowed to pass
#' @param allow_comment boolean, optional; enables to allow candidate to leave
#'   comments in each question, `TRUE` by default
#' @param rebuild_variables boolean, optional; enables to recalculate variables and
#'   reshuffle the order of choices for each item-attempt
test <- function(content, identifier = NULL, title = NULL,
                 navigation_mode = "nonlinear", submission_mode = "individual",
                 time_limits = NULL, max_attempts = NULL, allow_comment = TRUE,
                 rebuild_variables = TRUE) {

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

#' Create test for LMS Opal
#'
#' @param content list contains [AssessmentSection] objects
#' @param identifier string; identifier if the test file
#' @param title string, optional; file title
#' @param navigation_mode string, optional; determines the general paths that
#'   the candidate may have during exam; two mode options are possible: `linear`
#'   "linear" - candidate is not allowed to return to the previous questions;
#'   `nonlinear`- candidate if free to navigate, used by default
#' @param submission_mode string, optional; determines when the candidate's
#'   responses are submitted for response processing; two mode options are
#'   possible: `individual` - submit candidates' responses on an item-by-idem
#'   basis, used by default; `simultaneous - candidates` - responses are
#'   submitted all together by the end of the test
#' @param time_limits numeric, optional; controls the amount of time a candidate
#'   is given for the test
#' @param max_attempts numeric, optional; enables the maximum number of
#'   attempts, that candidate is allowed to pass
#' @param allow_comment boolean, optional; enables to allow candidate to leave
#'   comments in each question, `TRUE` by default
#' @param rebuild_variables boolean, optional; enables to recalculate variables
#'   and reshuffle the order of choices for each item-attempt
#' @param files string vector, optional; paths to files, which will be
#'   accessible to candidate during the test/exam
#' @param show_test_time boolean, optional; determines to show candidate elapsed
#'   processing time without time limit; default `FALSE`
#' @param calculator string, optional; determines to show to candidate
#'   calculator; possible values: `simple-calculator` or
#'   `scientific-calculator`, the lase one is assigned by default
#' @param mark_items boolean, optional; determines to allow candidate marking of
#'   questions, default `TRUE`
#' @param keep_responses boolean, optional; determines to save candidate's
#'   answers of the previous attempt, default `FALSE`
test4opal <- function(content, identifier = NULL, title = NULL,
                      navigation_mode = "nonlinear", submission_mode = "individual",
                      time_limits = NULL, max_attempts = NULL, allow_comment = TRUE,
                      rebuild_variables = TRUE, files = NULL, show_test_time = FALSE,
                      calculator = "scientific-calculator", mark_items  = FALSE,
                      keep_responses = FALSE) {

    params <- as.list(environment())
    params <- Filter(Negate(is.null), params)
    params["section"] <- ifelse (length(unlist(params["content"])) == 1,
                                list(params["content"]), as.list(params["content"]))
    params["content"] = NULL
    # define test class
    params["Class"] <- "AssessmentTestOpal"
    object <- do.call(new, params)
}
