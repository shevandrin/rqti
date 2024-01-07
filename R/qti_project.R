# The function to create RStudio project template.
qti_project <- function(path, ...) {

    # ensure path exists
    dir.create(path, recursive = TRUE, showWarnings = FALSE)
    # collect inputs
    dots <- list(...)
    sys_path <- system.file(package="qti")
    # copy templates
    if (dots$check_sc) {
        temp <- file.path(sys_path, "rmarkdown/templates/singlechoice-simple/skeleton/skeleton.Rmd")
        file.copy(temp, file.path(path, "sc.Rmd"))
    }
    if (dots$check_mc) {
        temp <- file.path(sys_path, "rmarkdown/templates/multiplechoice-simple/skeleton/skeleton.Rmd")
        file.copy(temp, file.path(path, "mc.Rmd"))
    }
    if (dots$check_gp) {
        temp <- file.path(sys_path, "rmarkdown/templates/gap-simple/skeleton/skeleton.Rmd")
        file.copy(temp, file.path(path, "gap.Rmd"))
    }
    if (dots$check_dd) {
        temp <- file.path(sys_path, "rmarkdown/templates/dropdown-simple/skeleton/skeleton.Rmd")
        file.copy(temp, file.path(path, "dropdown.Rmd"))
    }
    if (dots$check_or) {
        temp <- file.path(sys_path, "rmarkdown/templates/order-simple/skeleton/skeleton.Rmd")
        file.copy(temp, file.path(path, "order.Rmd"))
    }
    if (dots$check_tb) {
        temp <- file.path(sys_path, "rmarkdown/templates/table-simple/skeleton/skeleton.Rmd")
        file.copy(temp, file.path(path, "table.Rmd"))
    }
    if (dots$check_dp) {
        temp <- file.path(sys_path, "rmarkdown/templates/directedpair-simple/skeleton/skeleton.Rmd")
        file.copy(temp, file.path(path, "directedpair.Rmd"))
    }
    if (dots$check_es) {
        temp <- file.path(sys_path, "rmarkdown/templates/essay-simple/skeleton/skeleton.Rmd")
        file.copy(temp, file.path(path, "essay.Rmd"))
    }
    # create Rprofile
    text <- c(paste0("Sys.setenv(QTI_API_ENDPOINT=\"", dots$url_endpoint, "\")"),
              "library(qti)")
    contents <- paste(
        # paste(header, collapse = "\n"),
        paste(text, collapse = "\n"),
        sep = "\n"
    )
    # write to Rprofile
    writeLines(contents, con = file.path(path, ".Rprofile"))

}
