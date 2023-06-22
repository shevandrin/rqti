#' Create a section as a part of test content
#'
#' @param file vector of Rmd, md, or xml files
#' @param num_variants number of variants from Rmd files
#' @param id identifier of section
#' @param nested the type of the test structure
#' @export
section <- function(file, num_variants = 1, id = NULL, nested = TRUE) {
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
                print(n)
                sec <- make_subsection(file)
                names(sec) <- NULL
                print(sec@identifier)
                sub_items <- c(sub_items, sec)
                if (is.null(id)) id <- paste0("variable_section_",
                                              sample.int(100, 1))
            }
        } else {
            selection <- 0
            for (f in seq(length(file))) {
                sec <- make_subsection(f)
            }
        }
    }




    section <- new("AssessmentSection", identifier = id, selection = selection,
                               assessment_item = sub_items)
    return(section)
}

make_variant <- function(file, seed_number) {
    set.seed(seed_number)
    object <- create_question_object(file)
    object@identifier <- paste0(object@identifier, "_S", seed_number)
    return(object)
}

make_subsection <- function(file) {
    seed_number <- sample.int(100, 1)
    id <- paste0("seed_section_S", seed_number)
    asmt_items <- Map(make_variant, file, rep(seed_number, length(file)))
    names(asmt_items) <- NULL
    exam_subsection <- new("AssessmentSection", identifier = id,
                           assessment_item = asmt_items)
    return(exam_subsection)
}

test <- function(content) {
    resutl <- new("AssessmentTest", section = content)
    return(resutl)
}
