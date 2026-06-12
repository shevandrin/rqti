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
sc1d <- system.file("exercises", "sc1d.Rmd", package = "rqti")

if (!nzchar(sc1d)) {
    stop("Could not find exercises/sc1d.Rmd in the rqti package")
}

invisible(rqti:::prepareQTIJSFiles(sc1d, qtijs_path))
start_server(qtijs_path)

cat("RQTI_SERVER_STARTED\n")
flush.console()

repeat {
    httpuv::service()
    later::run_now(0.1)
    Sys.sleep(0.05)
}
