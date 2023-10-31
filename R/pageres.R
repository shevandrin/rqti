pageres <- function(filename, res) {
    system(paste0("pageres ", Sys.getenv("QTI_URL"),
                  " --delay=1.5",
                  " --overwrite --filename=", filename, " ", res),
           wait = F)
}

webshot_opal <- function(repo, path) {
    file <- paste0(path, repo$display_name, ".jpg")
    webshot2::webshot(url = repo$url,
                      file = file,
                      selector = ".content-container-inner",
                      expand = c(3, 9, 0, -6), vheight = 1200, vwidth = 1100)
    # requires imagemagick
    system(paste0("convert ", file, " -trim -border 3 ", file))
}
