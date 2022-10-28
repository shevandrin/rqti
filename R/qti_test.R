#' @param choices
#'
#'


setClass("assessmentTest", slots = list(file_name = "character",
                                        doc = "xml_document"))

setMethod("show", "assessmentTest", function(object) {
    cat("this is S4 object of 'assessmentTest' according to QTI 2.1 ")
    print(object@doc)
})

setGeneric("create", function(object) standardGeneric("create"))

setMethod("create", signature(object = "assessmentTest"), function(object) {
    ns <- c("title" = "qti_pack_test",
            "identifier" = "_some_test_id_")
    doc <- xml2::xml_new_document()
    doc <- xml2::xml_new_root("assessmentTest")
    xml2::xml_attrs(doc) <- ns
    object@doc <- doc
    return(doc)
})

setGeneric("write", function(object) {
    standardGeneric("write")
})

setMethod("write", signature("assessmentTest"),
          function(object){
              cat("the xml file will be created")
              path <- paste("exams/", object@file_name, sep = "")
              doc <- xml2::read_xml(object@doc)
              xml2::write_xml(doc, path)
              print(paste("see the file ", file_name, " in your work directory"))
          })

create_test <- function(file_name =  "test.xml") {
    ns <- c("title" = "qti_pack_test",
            "identifier" = "_some_test_id_")
    doc <- xml2::xml_new_document()
    doc <- xml2::xml_new_root("assessmentTest")
    xml2::xml_attrs(doc) <- ns
    files <- list.files(path = "results", pattern = ".xml$")
    data <- lapply(files, function(x) {
        doc <- xml2::read_xml(paste("results/", x, sep = ""))
        item <- xml2::xml_find_first(doc, "/d1:assessmentItem")
        id <- xml2::xml_attr(item, "identifier")
        print(id)
    })



    # to save the result in text.xml in the "exams" folder
    path <- paste("exams/", file_name, sep = "")
    xml2::write_xml(doc, path)
    print(paste("see the file ", file_name, " in your work directory"))
}
