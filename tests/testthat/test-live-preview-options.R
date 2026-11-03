test_that("separate Knit sessions use changed console options without a server restart", {
    skip_on_cran()
    skip_if(!nzchar(Sys.which("maxima")), "Maxima not installed")
    root <- withr::local_tempdir()
    withr::local_envvar(c(RQTI_URL=NA, RQTI_MAXIMA=NA, RQTI_QTIJS_PATH=NA,
                         RQTI_SERVER_PID=NA, RSTUDIO="0"))
    initial <- file.path(root,"initial-maxima.bat")
    file.create(initial)
    withr::local_options(list(rqti.maxima=initial, rqti.task_names="title"))
    withr::defer(stop_server())
    start_server(root)
    url <- Sys.getenv("RQTI_URL")
    script <- file.path(root,"knit.R")
    result <- file.path(root,"result.rds")
    package_path <- getNamespaceInfo("rqti","path")
    load_package <- if(file.exists(file.path(package_path,"R","knit_functions.R"))) {
        sprintf("pkgload::load_all(%s,quiet=TRUE)",deparse(package_path))
    } else sprintf("library(rqti,lib.loc=%s)",deparse(dirname(package_path)))
    writeLines(c(load_package,
        'args <- commandArgs(TRUE)',
        'choice <- rqti:::maxima_default_executable()',
        'types <- rqti::maxima_check("string([\'answer=7]);",outputs=TRUE,libraries=character())',
        'saveRDS(list(executable=choice,names=rqti:::task_name_mode(),types=types),args[[1]])'),script)
    # Changing the console option leaves its startup environment value stale.
    expect_identical(Sys.getenv("RQTI_MAXIMA"), normalizePath(initial,winslash="/"))
    for (mode in c("both","hidden")) {
        options(rqti.task_names=mode, rqti.maxima=unname(Sys.which("maxima")))
        child <- processx::process$new(file.path(R.home("bin"),"Rscript"),
            c("--vanilla",script,result),stdout="|",stderr="|")
        withr::defer(if(child$is_alive()) child$kill_tree())
        started <- proc.time()[["elapsed"]]
        while(child$is_alive() && proc.time()[["elapsed"]]-started < 90) {
            httpuv::service(20)
            later::run_now(0.01)
        }
        expect_false(child$is_alive())
        expect_identical(child$get_exit_status(),0L,info=paste(child$read_error_lines(),collapse="\n"))
        actual <- readRDS(result)
        expect_identical(actual$executable,unname(Sys.which("maxima")))
        expect_identical(actual$names,mode)
        expect_identical(actual$types,c(answer="integer"))
        expect_identical(Sys.getenv("RQTI_URL"),url)
    }
})
