# The function to create RStudio project template.
#' @importFrom utils download.file
rqti_project <- function(path, ...) {

    # ensure path exists
    dir.create(path, recursive = TRUE, showWarnings = FALSE)
    # collect inputs
    dots <- list(...)
    sys_path <- system.file(package="rqti")
    # copy mock attachment
    file_path <- system.file("attachment.pdf", package='rqti')
    file.copy(file_path, path)
    # copy templates
    temps <- c("singlechoice", "multiplechoice", "dropdown", "order", "table",
               "directedpair", "essay")
    temps_r <- "gap"
    if (dots$templates == "YES")  {
        text_rmd <- c(
            paste0("exercises <- ", print_vector(temps, path, dots['render'])),
            paste0("exercises_random <- ", print_vector(temps_r, path, dots['render']))
        )
    } else {
        text_rmd <- c("exercises = c(\"muster_ex1.Rmd\", \"muster_ex2.Rmd\")",
                      "exercises_random = \"muster_ex_r.Rmd\"")

    }
    launch_qtijs <- NULL
    if (dots$start_server) launch_qtijs <- "rqti::start_server()"
    # create Rprofile
    text <- c("library(rqti)",
              paste0("Sys.setenv(RQTI_API_ENDPOINT=\"", dots$url_endpoint, "\")"),
              launch_qtijs)
    contents <- paste(
        paste(text, collapse = "\n"),
        sep = "\n"
    )
    # write to Rprofile
    writeLines(contents, con = file.path(path, ".Rprofile"))

    # create default main R file
    header <- c(
        "# The rqti package provides a robust toolset for crafting exercises",
        "# and exams aligned with the QTI standard directly from R.",
        "# This script serves as a fundamental introduction to rqti,",
        "# illustrating a basic workflow.",
        "",
        "# Step 1: Prepare Rmd files with individual exercises.",
        "# To create an Rmd file, select RStudio templates starting with rqti ",
        "# File -> New File -> R Markdown -> From Template -> rqti: ...",
        "# Alternatively, modify the templates copied to your working directory",
        "# when the project was created. They can be found in the Files tab",
        "# in the bottom right region in RStudio, such as gap or dropdown."
    )

    text_other <- c(
        "",
        "# Step 2. Create sections.",
        "section_fixed <- section(exercises)",
        "section_random <- section(exercises_random, n_variants = 4)",
        "sections <- list(section_random, section_fixed)\n",
        "# Step 3. Create test.",
        "test <- test(sections, \"test_demo\", time_limit = 90,",
        "             max_attempts = 2)\n",
        "# Create test for LMS OPAL",
        "test_opal <- test4opal(sections, \"test_demo_opal\", time_limit = 90,",
        "                       max_attempts = 1, files = \"attachment.pdf\",",
        "                       calculator = \"scientific-calculator\",",
        "                       academic_grading = TRUE,",
        "                       grade_label = \"Note\")\n",
        "# Step 4. Render Test using QTIJS server.",
        "# Render test_opal using QTIJS server",
        "render_qtijs(test_opal)",
        "# Create zip archive with test",
        "zip_file <- createQtiTest(test, dir = \"upload\")",
        "# Render zip archive using QTIJS server",
        "render_zip(zip_file)\n",
        "# Step 5. Upload to Opal via API or, alternatively, upload zip manually.",
        "upload2opal(test_opal)",
        "\n# For more information, read the documentation:",
        "# https://shevandrin.github.io/rqti/"
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
    sys_path <- system.file(package="rqti")
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
    content <- stringr::str_replace(content, "knit: .*", "knit: rqti::render_opal")
    writeLines(content, file_path)
}

print_vector <- function(vec, path, render) {
    temps_files <- Map(copy_template, vec, path, render)
    print_files <- sapply(temps_files, function(x) paste0('\"', x, '\"'))
    list_files <- paste(print_files, collapse = ",\n  ")
    if (length(vec) > 1) list_files <- paste0("c(\n  ", list_files, "\n)")
    return(list_files)
}
