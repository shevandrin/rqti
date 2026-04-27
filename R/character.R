#' @rdname buildAssessmentSection-methods
#' @aliases buildAssessementSection,character
setMethod("buildAssessmentSection", signature(object = "character"),
          function(object, folder, verify) {

              f_path <- file.path(object)

              if (file.exists(f_path)) {
                  doc <- xml2::read_xml(f_path)
                  if (verify) {
                      valid <- verify_qti(doc)
                      if (!valid$valid) warning("xml file \'", object, "\' is not valid")
                  }

                  id <- xml2::xml_attr(doc, "identifier")

                  file.copy(f_path, folder)
                  message(paste("see assessment item:", file.path(folder, basename(f_path))))
                  tag("assessmentItemRef", list(identifier = id,
                                                href = basename(object)))
              }
              else {
                  warning("File or path \'", object, "\' is not correct. This ",
                          "file will be omitted in test", call. = FALSE,
                          immediate. = TRUE)
                  return(NULL)
              }
          })

#' @rdname getAssessmentItems-methods
#' @aliases getAssessmentItems,character
setMethod("getAssessmentItems", signature(object = "character"),
          function(object) {
              if (file.exists(object)) {
                  href <- basename(object)
                  doc <- xml2::read_xml(object)
                  names(href) <- xml2::xml_attr(doc, "identifier")
                  return(href)
              }
          })

# form text content of the question with html
#' @rdname createText-methods
#' @aliases createText,character
#' @importFrom htmltools HTML
setMethod("createText", "character", function(object) {
    HTML(object)
})

# deliver nothing as outcome for character objects
#' @rdname getResponse-methods
#' @aliases getResponse,character
setMethod("getResponse", "character", function(object) {
})

#' @rdname getPoints-methods
#' @aliases getPoints,character
setMethod("getPoints", signature(object = "character"),
          function(object) {
              if (!file.exists(object)) {
                  warning(paste("file", object, "does not exist"),
                          call. = FALSE)
                  return(1)
              }
              doc <- xml2::read_xml(object)
              od_tag  <- xml2::xml_find_first(doc, ".//d1:outcomeDeclaration
                                            [@identifier='MAXSCORE']")
              points <- xml2::xml_text(od_tag)
              points <- suppressWarnings(as.numeric(points))
              points <- if (length(points) == 0 || is.na(points)) 1 else points
              return(points)
          })

#' @rdname getIdentifier-methods
#' @aliases getIdentifier,character
setMethod("getIdentifier", signature(object = "character"),
          function(object) {
              if (!file.exists(object)) {
                  warning(paste("file", object, "does not exist"),
                          call. = FALSE)
                  return(1)
              }
              doc <- xml2::read_xml(object)
              ai_tag  <- xml2::xml_find_all(doc, "//d1:assessmentItem")
              id <- xml2::xml_attr(ai_tag, "identifier")
              return(id)
          })

#' @rdname createQtiTest-methods
#' @aliases createQtiTest,character
setMethod("createQtiTest", signature(object = "character"),
          function(object, dir = getwd()) {

              file <- object
              if (length(file) > 1) {
                  stop("Only one file can be provided as input.", call. = FALSE)
              }

              if (!all(file.exists(file))) {
                  stop("The file does not exist", call. = FALSE)
              }

              ext <- file_ext(file)
              if (ext != "zip") {
                  if (ext %in% c("Rmd", "md")) file <- rmd2zip(file, path = dir)
                  if (ext == "xml") {
                      section_obj <- section(file, title = "Preview")
                      test_obj <- test(content = section_obj,
                                       identifier = "Preview")
                      file <- create_qti_test(test_obj, path = dir,
                                              zip_only = TRUE)
                  }
              }
              return(file)
          })

#' @rdname createQtiTask-methods
#' @aliases createQtiTask,character
setMethod("createQtiTask", signature(object = "character"),
          function(object, dir = getwd(),
                   verification = FALSE, zip = FALSE) {

              file <- object
              if (length(file) > 1) {
                  stop("Only one file can be provided as input.", call. = FALSE)
              }

              if (!all(file.exists(file))) {
                  stop("The file does not exist", call. = FALSE)
              }

              ext <- file_ext(file)
              if (ext != "zip") {
                  if (ext %in% c("Rmd", "md")) {
                      obj <- create_question_object(file)
                      file <- createQtiTask(obj, dir = dir, zip = zip)
                  }
              }
              return(file)
          })

#' @rdname getObject-methods
#' @aliases getObject,character
setMethod("getObject", signature(object = "character"),
          function(object) {
              ext <- file_ext(object)
              if (file.exists(object) & (ext %in% c("xml", "Rmd", "md"))) {
                  if (ext %in% c("Rmd", "md")) {

                      fmt <- detect_rmd_format(object)

                      if (identical(fmt, "rqti_rmd")) {
                          object <- create_question_object(object)
                      } else if (identical(fmt, "exams_rmd")) {
                          object <- exams_task(object)
                          object <- xml_preparation(object)
                      } else {
                          stop(
                              "Cannot determine Rmd format (rqti or exams are allowed): ",
                              object,
                              call. = FALSE
                          )
                      }
                  }
                  if (ext %in% "xml") {
                      object <- xml_preparation(object)
                  }

                  return(object)
              }
              return(NULL)
          })

#' @rdname getFiles-methods
#' @aliases getFiles,character
setMethod("getFiles", signature(object = "character"),
          function(object) {
              return(character(0))
          })

#' @rdname getCalculator-methods
#' @aliases getCalculator,character
setMethod("getCalculator", signature(object = "character"),
          function(object) {
              return(character(0))
          })

#' @rdname prepareQTIJSFiles-methods
#' @aliases prepareQTIJSFiles,AssessmentItem
setMethod("prepareQTIJSFiles", signature(object = "character"),
          function(object, dir) {
              if (!file.exists(object)) {
                  stop("The file does not exist", call. = FALSE)
              }
              out_path <- file.path(dir, "index.xml")
              ext <- file_ext(object)
              if (ext %in% c("Rmd", "md")) {
                  task <- create_question_object(object)
                  create_qti_task(task, out_path, verification = FALSE)
                  current_rmd_fullpath <- normalizePath(object)
                  xml_target <- sub("\\.Rmd$", ".xml", current_rmd_fullpath)
                  file.copy(out_path, xml_target)
              }
              if (ext == "xml") {
                  object <- xml_preparation(object)
                  file.copy(object, out_path)
              }
              if (ext == "zip") zip::unzip(object, exdir = dir)
              params <- knit_params(readLines(object))
              if (!is.null(params$preview_feedback$value)) {
                  return(params$preview_feedback$value)
              }
              return(NULL)
          })

#' @rdname getContributors-methods
#' @aliases getContributors,character
setMethod("getContributors", signature(object = "character"),
          function(object) {
              return(NULL)
          })

# check images in xml and embedds them
xml_preparation <- function(obj) {
    content <- xml2::read_xml(obj)
    images <- xml2::xml_find_all(content, ".//*[local-name()='img']")

    if (length(images) == 0) return (obj)
    for (img in images) {
        src <- xml2::xml_attr(img, "src")

        # skip already embedded images
        if (grepl("^data:image/", src)) {
            next
        }
        image_path <- file.path(dirname(obj), src)

        if (!file.exists(image_path)) {
            warning("Image file does not exist: ", src)
            next
        }

        ext <- tools::file_ext(image_path)
        mime <- switch(
            tolower(ext),
            "png"  = "image/png",
            "jpg"  = "image/jpeg",
            "jpeg" = "image/jpeg",
            "gif"  = "image/gif",
            "svg"  = "image/svg+xml",
            "webp" = "image/webp",
            "application/octet-stream"
        )

        encoded <- base64enc::base64encode(image_path)
        embedded_src <- paste0("data:", mime, ";base64,", encoded)

        xml2::xml_set_attr(img, "src", embedded_src)
    }

    tmp <- tempfile(fileext = ".xml")
    xml2::write_xml(content, tmp)
    return(tmp)
}
