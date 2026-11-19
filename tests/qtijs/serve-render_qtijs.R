options(error = function() quit(status = 1))

repo_root <- Sys.getenv("RQTI_REPO_ROOT")
if (nzchar(repo_root) && requireNamespace("pkgload", quietly = TRUE)) {
    pkgload::load_all(repo_root, quiet = TRUE, export_all = FALSE)
} else {
    library(rqti)
}

copy_qtijs_dir <- function() {
    src <- system.file("QTIJS", package = "rqti")
    dst <- file.path(tempdir(), paste0("QTIJS-", Sys.getpid()))
    dir.create(dst)
    file.copy(
        from = list.files(src, full.names = TRUE),
        to = dst,
        recursive = TRUE,
        overwrite = TRUE
    )
    dst
}

qtijs_path <- copy_qtijs_dir()
source_rmd <- system.file("extdata", "sc1d.Rmd", package = "rqti")

if (!nzchar(source_rmd)) {
    stop("Could not find extdata/sc1d.Rmd in the rqti package")
}

# Rendering an Rmd writes its XML next to the source, so render a copy to keep
# the shipped extdata/sc1d.xml example unchanged.
sc1d <- file.path(tempfile("sc1d-"), "sc1d.Rmd")
dir.create(dirname(sc1d))
file.copy(source_rmd, sc1d)

invisible(rqti:::prepareQTIJSFiles(sc1d, qtijs_path))
start_server(qtijs_path)

cat("RQTI_SERVER_STARTED\n")
flush.console()

repeat {
    httpuv::service()
    later::run_now(0.1)
    Sys.sleep(0.05)
}
