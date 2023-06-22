#' Create a section as a part of test content
#'
#' @param file string; vector of Rmd, md, or xml files
#' @param num_variants integer; number of variants to create from Rmd files
#' @param id string, optional; identifier of the assessment section
#' @param nested boolean; the type of the test structure; `TRUE` by default
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
section <- function(file, num_variants = 1, id = NULL, nested = TRUE,
                    title = character(0), time_limits = NA_integer_,
                    visible = TRUE, shuffle = FALSE, max_attempts = NA_integer_,
                    allow_comment = TRUE) {
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
                sec <- make_seed_subsection(file)
                names(sec) <- NULL
                sub_items <- c(sub_items, sec)
                if (is.null(id)) id <- paste0("variable_section_",
                                              sample.int(100, 1))
            }
        } else {
            selection <- 0
            for (f in file) {
                sec <- make_variant_subsection(f, num_variants)
                names(sec) <- NULL
                sub_items <- c(sub_items, sec)
                if (is.null(id)) id <- paste0("variable_section_",
                                              sample.int(100, 1))
            }
        }
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

make_seed_subsection <- function(file) {
    seed_number <- sample.int(100, 1)
    id <- paste0("seed_section_S", seed_number)
    asmt_items <- Map(make_variant, file, rep(seed_number, length(file)))
    names(asmt_items) <- NULL
    exam_subsection <- new("AssessmentSection", identifier = id,
                           assessment_item = asmt_items)
    return(exam_subsection)
}

make_variant_subsection <- function(file, num_variants) {
    seed_number <- sample.int(100, num_variants)
    id <- paste0("variant_section_S", sample.int(1000, 1))

    asmt_items <- Map(make_variant, file, seed_number)
    names(asmt_items) <- NULL

    exam_subsection <- new("AssessmentSection", identifier = id,
                           assessment_item = asmt_items, selection = 1)
    return(exam_subsection)
}

test <- function(content) {
    resutl <- new("AssessmentTest", section = content)
    return(resutl)
}
