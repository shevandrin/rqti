test_that("sc1d.Rmd renders via render_qti", {
    render_rmd(fs::path_package("exercises", "sc1d.Rmd", package = "qti"))
    system(paste0("pageres ", Sys.getenv("QTI_URL"),
                  " --delay=1.5",
                  " --overwrite --filename=sc1d 600x600"),
           wait = T)
    skip_if(Sys.getenv("HOME") != "/home/jt")
    expect_equal(as.character(tools::md5sum("sc1d.png")), "e134e49b2ed933248e04540566fce5f9")
})

test_that("sc1d.xml renders via render_qti", {
    render_xml(fs::path_package("exercises", "sc1d.xml", package = "qti"))
    system(paste0("pageres ", Sys.getenv("QTI_URL"),
                  " --delay=1.5",
                  " --overwrite --filename=sc1dxml 600x600"),
           wait = T)
    skip_if(Sys.getenv("HOME") != "/home/jt")
    expect_equal(as.character(tools::md5sum("sc1dxml.png")), "e134e49b2ed933248e04540566fce5f9")
})

test_that("sc1d.zip renders via render_qti", {
    file_zip <- fs::path_package("exercises", "sc1d.zip", package = "qti")
    render_zip(file_zip)
    system(paste0("pageres ", Sys.getenv("QTI_URL"),
                  " --delay=3",
                  " --overwrite --filename=sc1dzip 600x600"),
           wait = T)
    skip_if(Sys.getenv("HOME") != "/home/jt")
    expect_equal(as.character(tools::md5sum("sc1dzip.png")), "337bc386d37876801aa4867e43d172b1")
})

test_that("server functions work", {
    skip()
    start_server()
    expect_false(Sys.getenv("QTI_URL") == "")
    stop_server()
    expect_true(Sys.getenv("QTI_URL") == "")
    Sys.setenv("QTI_URL" = "")
    prepare_renderer()
    expect_false(Sys.getenv("QTI_URL") == "")
})
