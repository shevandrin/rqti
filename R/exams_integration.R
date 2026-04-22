# prepare replication of one exercise from exams package
import_exams_item <- function(path, id = NULL, title = NULL) {
    converter <- "pandoc"

    htmltransform <- exams:::make_exercise_transform_html(
        converter = converter,
        base64 = TRUE
    )

    exm <- exams::xexams(
        file = path,
        n = 1,
        driver = list(
            sweave = list(
                quiet = TRUE,
                pdf = FALSE,
                png = TRUE,
                svg = FALSE,
                resolution = 100,
                width = 4,
                height = 4,
                encoding = "UTF-8",
                envir = NULL,
                engine = NULL
            ),
            read = NULL,
            transform = htmltransform,
            write = NULL
        ),
        dir = tempdir()
    )

    set.seed(0)
    x <- exm[[1]][[1]]

    if (is.null(id)) {
        id <- generate_id(type = "exams_task", digits = 5)
    }
    if (is.null(title)) {
        title <- if (!is.null(x$metainfo$title)) x$metainfo$title else id
    }

    x$metainfo$id <- id
    x$metainfo$name <- title
    x$converter <- converter
    x$flavor <- "plain"

    item_fun <- exams:::make_itembody_qti21()
    xml <- item_fun(x)

    list(
        xml = xml,
        supplements = x$supplements,
        metainfo = x$metainfo
    )
}

# write xml file for the exams exercise and return the path to it
write_exams_item_xml <- function(item, dir = tempdir()) {
    if (!dir.exists(dir)) dir.create(dir, recursive = TRUE)
    file <- file.path(dir, paste0(item$metainfo$id, ".xml"))

    writeLines(
        c('<?xml version="1.0" encoding="UTF-8"?>', item$xml),
        file,
        useBytes = TRUE
    )

    return(normalizePath(file))
}

# helper function to handle path to the Rmd in exams format
exams_task <- function(path) {
    item <- import_exams_item(path)
    xml_path <- write_exams_item_xml(item)
    return(xml_path)
}

# detector which Rmd format is used in the file (rqti or exams)
detect_rmd_format <- function(file) {
    if (!file.exists(file)) {
        stop("File does not exist: ", file, call. = FALSE)
    }

    yaml <- rmarkdown::yaml_front_matter(file)
    has_yaml <- length(yaml) > 0

    x <- readLines(file, warn = FALSE, encoding = "UTF-8")
    has_meta_information <- any(
        grepl("^Meta-information\\s*$", x, ignore.case = TRUE)
    )

    if (has_yaml && !has_meta_information) {
        return("rqti_rmd")
    }

    if (has_meta_information && !has_yaml) {
        return("exams_rmd")
    }

    return("unknown")
}
