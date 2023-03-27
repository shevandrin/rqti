#' Create XML file for exam test specification
#'
#' @usage create_qti_test(object,
#'                 dir = NULL,
#'                 verification = FALSE)
#' @param object an instance of the [AssessmentTest] S4 object
#' @param dir string, optional; a folder to store xml file; working directory by
#'   default
#' @param verification boolean, optional; to check validity of xml file, default
#'   `FALSE`
#' @return xml document.
#' @examples
#' \dontrun{
#' essay <- new("Essay", prompt = "Test task", title = "Essay",
#'              identifier = "q1")
#' sc <- new("SingleChoice", prompt = "Test task", title = "SingleChoice",
#'           choices = c("A", "B", "C"), identifier = "q2")
#' exam_section <- new("AssessmentSection", identifier = "sec_id",
#'                    title = "section", assessment_item = list(essay, sc))
#' exam <- new("AssessmentTestOpal", identifier = "id_test",
#'            title = "some title", section = list(exam_section))
#' create_qti_test(exam, "exam_folder", "TRUE")
#' }
#' @export
create_qti_test <- function(object,dir = NULL, verification = FALSE) {
    if (!dir.exists(dir)) dir.create(dir)
    wd <- getwd()
    setwd(dir)

    content <- create_assessment_test(object, dir)
    doc_test <- xml2::read_xml(as.character(content))
    setwd(wd)

    path_test <- paste0(dir, "/", object@identifier, ".xml")
    xml2::write_xml(doc_test, path_test)
    print(paste("see assessment test:", path_test))

    manifest <- create_manifest(object)
    doc_manifest <- xml2::read_xml(as.character(manifest))
    path_manifest <- paste0(dir, "/imsmanifest.xml")
    xml2::write_xml(doc_manifest, path_manifest)
    print(paste("see manifest file:", path_manifest))

    zip_wrapper(object@identifier, object@files, dir)
}

# creates xml root and children of test file
create_assessment_test <-function(object, folder) {
    data_downloads <- NULL
    if (length(object@files) > 0) {
        file_names <- basename(object@files)
        files <- unlist(lapply("file://downloads/", paste0, file_names, ";"))
        for (f in files) {
            data_downloads <- paste0(f, data_downloads)
        }
    }
    data_features <- NULL
    if (object@show_test_time) {
        data_features <- paste("show-test-time", data_features, sep = ";")
    }
    if (!is.na(object@calculator)) {
        data_features <- paste(object@calculator, data_features, sep = ";")
    }
    if (object@mark_items) {
        data_features <- paste("mark-items", data_features, sep = ";")
    }
    if (object@keep_responses) {
        data_features <- paste("keep-responses", data_features, sep = ";")
    }
    assessment_attributes <- c("xmlns" = "http://www.imsglobal.org/xsd/imsqti_v2p1",
                               "xmlns:xsi" = "http://www.w3.org/2001/XMLSchema-instance",
                               "xsi:schemaLocation" = "http://www.imsglobal.org/xsd/imsqti_v2p1 http://www.imsglobal.org/xsd/qti/qtiv2p1/imsqti_v2p1.xsd",
                               "identifier" = object@identifier,
                               "title" = paste(object@title),
                               "data-downloads" = data_downloads,
                               "data-features" = data_features)
    assesment_test <- tag("assessmentTest", assessment_attributes)
    if (!is.na(object@time_limits)) {
        time_limits <- tag("timeLimits", list(maxTime = object@time_limits))
    } else {time_limits = c()}

    session_control <- create_item_session_control(object@max_attempts,
                                                   object@allow_comment,
                                                   object@rebuild_variables)
    sections <- Map(create_section_test, object@section)
    testPart <- tag("testPart", list(identifier = object@test_part_identifier,
                                     navigationMode = object@navigation_mode,
                                     submissionMode = object@submission_mode,
                                     tagList(session_control,
                                             sections)))
    tagAppendChildren(assesment_test,
                      createOutcomeDeclaration(object),
                      time_limits,
                      testPart)
}

# creates tag "assessmentSection" in test file
create_section_test <- function(object) {
    assessment_items <- Map(buildAssessmentSection, object@assessment_item)
    if (!is.na(object@time_limits)) {
        time_limits <- tag("timeLimits", list(maxTime = object@time_limits))
    } else {time_limits = c()}
    if (object@shuffle) {
        shuffle <- tag("ordering", list(shuffle = "true"))
    } else {shuffle <- c()}
    if (!is.na(object@selection)) {
        selection <- tag("selection", list(select = object@selection))
    } else {selection <- c()}

    session_control <- create_item_session_control(object@max_attempts,
                                                   object@allow_comment,
                                                   NA)

    tag("assessmentSection", list(identifier = object@identifier,
                                  fixed = "false",
                                  title = object@title,
                                  visible = tolower(object@visible),
                                  tagList(time_limits,
                                          shuffle,
                                          selection,
                                          session_control,
                                          assessment_items)))
}

# creates tag "itemSessionControl" with attrs in test file
create_item_session_control <- function(attempts, comments, rebuild) {
    if ((att <- !is.na(attempts)) |
        (com <- !is.na(comments)) |
        (reb <- !is.na(rebuild))) {
        if (att) { att <- list(maxAttempts = attempts)} else {att <- list()}
        if (com) { com <- list(allowComment = tolower(comments))}
        else {com <- list()}
        if (reb) { reb <- list(rebuildVariables = tolower(rebuild))}
        else {reb <- list()}
        session_control <- tag("itemSessionControl", c(att, com, reb))
    } else {session_control = c()}
}

# creates manifest file wiht root tag "manifest"
create_manifest <- function(object) {
    manifest_attributes <- c("xmlns" = "http://www.imsglobal.org/xsd/imscp_v1p1",
                             "xmlns:xsi" = "http://www.w3.org/2001/XMLSchema-instance",
                             "xsi:schemaLocation" = "http://www.imsglobal.org/xsd/imscp_v1p1 http://www.imsglobal.org/xsd/qti/qtiv2p1/qtiv2p1_imscpv1p2_v1p0.xsd http://www.imsglobal.org/xsd/imsqti_v2p1 http://www.imsglobal.org/xsd/qti/qtiv2p1/imsqti_v2p1p1.xsd http://www.imsglobal.org/xsd/imsqti_metadata_v2p1 http://www.imsglobal.org/xsd/qti/qtiv2p1/imsqti_metadata_v2p1p1.xsd http://ltsc.ieee.org/xsd/LOM http://www.imsglobal.org/xsd/imsmd_loose_v1p3p2.xsd http://www.w3.org/1998/Math/MathML http://www.w3.org/Math/XMLSchema/mathml2/mathml2.xsd",
                             "identifier" = paste0(object@title, "_manifest"))
    manifest <- tag("manifest", manifest_attributes)
    metadata <- tag("metadata", c())
    organisations <- tag("organisations", c())

    file_name <- paste0(object@identifier, ".xml")
    file <-  tag("file", list(href = file_name))
    items <- unlist(Map(getAssessmentItems, object@section))
    dependencies <- Map(create_dependency, names(items))
    test_resource <- tag("resource", list(identifier = object@identifier,
                                          type = "imsqti_test_xmlv2p1",
                                          href = paste0(object@identifier,
                                                        ".xml"),
                                          file,
                                          dependencies))
    item_resources <- Map(create_resource_item, names(items), items)
    resources <- tag("resources", list(test_resource, item_resources))

    tagAppendChildren(manifest, metadata, organisations,resources)
}

# create tag 'dependency' for minifest file
create_dependency <- function(id) {
    tag("dependency", list(identifierref = id))
}

# create tag 'resource' for manifest file
create_resource_item <- function(id, href) {
    file <- tag("file", list(href = href))
    tag("resource", list(identifier = id,
                         type = "imsqti_item_xmlv2p1",
                         href = href,
                         file))
}

zip_wrapper <- function(id, files, dir_xml) {
    # create temp directory
    tdir <- tempfile()
    dir.create(tdir)
    test_dir <- file.path(tools::file_path_as_absolute(tdir), "qti_test")
    dir.create(test_dir)
    if (length(files) > 0) {
        download_dir <- file.path(tools::file_path_as_absolute(test_dir),
                                  "downloads")
        dir.create(download_dir)
        file.copy(files, download_dir)
    }

    #  copy files from working directory to temporary
    files <- list.files(dir_xml)
    dir_xml <- paste0(dir_xml, "/")
    items_files <-unlist(lapply(dir_xml, paste0, files))
    file.copy(items_files, test_dir)

    # make and copy final zip in folder exams
    files_temp <- list.files(test_dir)
    wd <- getwd()
    setwd(test_dir)
    zip_name <- paste0(id, ".zip")
    utils::zip(zip_name, list.files(test_dir), extras = "-qdgds 10m")
    setwd(wd)
    file.copy(file.path(test_dir, zip_name), dir_xml, recursive = TRUE)
}
