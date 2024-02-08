# The function to create RStudio project template.
#' @importFrom utils download.file
rqti_project <- function(path, ...) {

    # ensure path exists
    dir.create(path, recursive = TRUE, showWarnings = FALSE)
    # collect inputs
    dots <- list(...)
    sys_path <- system.file(package="qti")
    # copy supplement file
    file_url <- "https://raw.githubusercontent.com/johannes-titz/formelsammlung/main/main.pdf"
    download.file(file_url, file.path(path, "demo_file.pdf") , mode = "wb",
                  quiet = TRUE)
    # copy templates
    temps <- c("singlechoice", "multiplechoice", "dropdown", "order", "table",
               "directedpair", "essay")
    temps_r <- "gap"
    if (dots$templates == "YES")  {
        text_rmd <- c(
            paste0("exercises -> ", print_vector(temps, path, dots['render'])),
            paste0("exercises_random -> ", print_vector(temps_r, path, dots['render']))
        )
    } else {
        text_rmd <- c(
           "exercises = c(\"muster_ex1.Rmd\", \"muster_ex2.Rmd\")",
           "exercises_random = \"muster_ex_r.Rmd\""
        )

    }
    launch_qtijs <- NULL
    print(dots$start_server)
    if (dots$start_server) launch_qtijs <- "qti::start_server()"
    # create Rprofile
    text <- c(paste0("Sys.setenv(QTI_API_ENDPOINT=\"", dots$url_endpoint, "\")"),
              launch_qtijs)
    contents <- paste(
        paste(text, collapse = "\n"),
        sep = "\n"
    )
    # write to Rprofile
    writeLines(contents, con = file.path(path, ".Rprofile"))

    # create default main R file
    header <- c(
        "# The rqti package provides a powerful toolset for creating exercises",
        "# and exams according to the QTI standard directly from R.",
        "# This script serves as a basic introduction to the qti package,",
        "# demonstrating workflow.",
        "#",
        "# Step 1. Prepare set of Rmd files with individual exercises.",
        "# To create Rmd choose one of the Rstudio file templates starting with RQTI: .",
        "# or edit the templates that have been copied to your working directory.\n"
    )

    text_other <- c(
        "",
        "# Step 2. Create sections.\n",
        "section_fixed <- section(exercises)",
        "section_random <- section(exercises_random, n_variants = 4)",
        "sections <- list(section_random, section_fixed)\n",
        "# Step 3. Create test.",
        "test <- test(sections, \"test_demo\", time_limit = 90,",
        "             max_attempts = 2)\n",
        "# Create test for LMS OPAL",
        "test_opal <- test4opal(sections, \"test_demo_opal\", time_limit = 90,",
        "                       max_attempts = 1, files = \"demo_file.pdf\",",
        "                       calculator = \"scientific-calculator\",",
        "                       academic_grading = TRUE,",
        "                       grade_label = \"Note\")",
        "# Step 4. Render Test using QTIJS server.\n",
        "zip_file <- createQtiTest(test, \"upload\")",
        "render_zip(zip_file)\n",
        "# Step 5. Upload to LMS with a final grade.\n",
        "upload2opal(test_opal)"
    )

    contents <- paste(
        paste(header, collapse = "\n"),
        paste(text_rmd, collapse = "\n"),
        paste(text_other, collapse = "\n"),
        sep = "\n"
    )

    # write to default main R file
    writeLines(contents, con = file.path(path, "main.R"))
}

copy_template <- function(name, path, render) {
    temp <- paste0("rmarkdown/templates/", name,
                   "-simple/skeleton/skeleton.Rmd")
    sys_path <- system.file(package="qti")
    temp_path <- file.path(sys_path, temp)
    dir.create(file.path(path, name))
    target_file <- file.path(name, paste0(name, ".Rmd"))
    file_t <- file.path(path, target_file)
    file.copy(temp_path, file_t)
    if (render == "OPAL") replace_knit_method(file_t)
    return(target_file)
}

#' @importFrom stringr str_replace
replace_knit_method <- function(file_path) {
    content <- readLines(file_path, warn = FALSE)
    content <- stringr::str_replace(content, "knit: .*", "knit: qti::render_opal")
    writeLines(content, file_path)
}

print_vector <- function(vec, path, render) {
    temps_files <- Map(copy_template, vec, path, render)
    print_files <- sapply(temps_files, function(x) paste0('\"', x, '\"'))
    list_files <- paste(print_files, collapse = ", ")
    if (length(vec) > 1) list_files <- paste0("c(", list_files, ")")
    return(list_files)
}
