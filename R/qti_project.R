# The function to create RStudio project template.
qti_project <- function(path, ...) {

    # ensure path exists
    dir.create(path, recursive = TRUE, showWarnings = FALSE)
    # collect inputs
    dots <- list(...)
    sys_path <- system.file(package="qti")
    # copy templates
    temps <- c("singlechoice", "multiplechoice", "gap",
               "dropdown", "order", "table",
               "directedpair", "essay")
    temps_dots <- dots[temps]
    Map(copy_template, temps_dots, names(temps_dots), path, dots['render'])

    # create Rprofile
    text <- c(paste0("Sys.setenv(QTI_API_ENDPOINT=\"", dots$url_endpoint, "\")"),
              paste0("Sys.setenv(QTI_AUTOSTART_SERVER=\"", dots$start_server, "\")"),
              "library(qti)")
    contents <- paste(
        paste(text, collapse = "\n"),
        sep = "\n"
    )
    # write to Rprofile
    writeLines(contents, con = file.path(path, ".Rprofile"))

}

copy_template <- function(need_copy, name, path, render) {
    if (need_copy) {
        temp <- paste0("rmarkdown/templates/", name,
                       "-simple/skeleton/skeleton.Rmd")
        sys_path <- system.file(package="qti")
        temp_path <- file.path(sys_path, temp)
        file_t <- file.path(path, paste0(name, ".Rmd"))
        file.copy(temp_path, file_t)
        if (render == "OPAL") replace_knit_method(file_t)
    }
}

#' @importFrom stringr str_replace
replace_knit_method <- function(file_path) {
    content <- readLines(file_path, warn = FALSE)
    content <- stringr::str_replace(content, "knit: .*", "knit: qti::render_opal")
    writeLines(content, file_path)
}
