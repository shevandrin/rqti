#' Compose a root element AssessmentItem of xml task
#'
#' `create_assessment_item()` creates html structure with AssessmentItem root
#' element (shiny.tag) for xml qti task description according QTI 2.1
#'
#' @param object an instance of the S4 object
#' @importFrom htmltools tag p tagList tagAppendChildren
#' @returns A list() with a shiny.tag class
#'
create_assessment_item <- function(object) {
    assessment_attributes <- create_assessment_attributes(object)
    assesment_item <- tag("assessmentItem", assessment_attributes)
    assesment_item <- tagAppendChildren(assesment_item,
                                        createResponseDeclaration(object),
                                        createOutcomeDeclaration(object),
                                        createItemBody(object),
                                        createResponseProcessing(object),
                                        Map(createModalFeedback, object@feedback))
}

create_assessment_attributes <- function(object) {
    c("xmlns" = "http://www.imsglobal.org/xsd/imsqti_v2p1",
      "xmlns:xsi" = "http://www.w3.org/2001/XMLSchema-instance",
      "xsi:schemaLocation" = paste0("http://www.imsglobal.org/xsd/imsqti_v2p1 ",
                                    "http://www.imsglobal.org/xsd/qti/qtiv2p1/imsqti_v2p1.xsd"),
      "identifier" = object@identifier,
      "title" = paste(object@title),
      "adaptive" =  "false",
      "timeDependent" = "false")
}

create_correct_response <- function(values) {
    tags_value <- lapply(values, create_value)
    tag("correctResponse", tags_value)
}

create_value <- function(value) {
    tag("value", value)
}

create_item_body_entry <- function(object) {
    prompt <- NULL
    if (object@prompt != "") prompt <- tag("p", list(object@prompt))
    tag("itemBody", list(prompt, Map(createText, object@content)))
}

create_item_body_essay <- function(object) {
    prompt <- create_prompt(object)
    ext_text <- tag("extendedTextInteraction",
                    list("responseIdentifier" = "RESPONSE",
                         "expectedLength" = object@expected_length,
                         "expectedLines" = object@expected_lines,
                         "maxStrings" = object@words_max,
                         "minStrings" = object@words_min,
                         prompt))
    if (isFALSE(object@data_allow_paste)) {
        ext_text <- htmltools::tagAppendAttributes(ext_text,
                                                   "class" = "essay-nocopypaste",
                                                   "data-allowPaste" = "false")
    }
    tag("itemBody", list(Map(createText, object@content), ext_text))
}

create_item_body_choice <- function(object, max_choices) {
    tag("itemBody", list(Map(createText, object@content),
                         make_choice_interaction(object, max_choices)))
}

create_item_body_order <- function(object) {
    prompt <- create_prompt(object)
    choices <- Map(make_choice,
                   "simpleChoice",
                   object@choices_identifiers,
                   object@choices)
    order_interactioin <- tag("orderInteraction",
                              list("responseIdentifier" = "RESPONSE",
                                   "shuffle" = tolower(object@shuffle),
                                   prompt, choices))
    tag("itemBody", list(Map(createText, object@content),
                         order_interactioin))
}

create_item_body_match_table <- function(object,  row_associations,
                                         col_associations,
                                         max_associations = NULL,
                                         orientation = NULL) {
    if (is.null(max_associations)) {
        max_associations <- length(object@answers_identifiers)
    }
    prompt <- create_prompt(object)
    fixed <- ifelse(object@shuffle_rows, "false", "true")
    rows <- Map(make_associable_choice,
                object@rows_identifiers,
                object@rows,
                row_associations,
                fixed)
    rows_match <- tag("simpleMatchSet", list(rows))
    fixed <- ifelse(object@shuffle_cols, "false", "true")
    cols <- Map(make_associable_choice,
                object@cols_identifiers,
                object@cols,
                col_associations,
                fixed)
    cols_match <- tag("simpleMatchSet", list(cols))

    match_interactioin <- tag("matchInteraction",
                              list("responseIdentifier" = "RESPONSE",
                                   "shuffle" = tolower(object@shuffle),
                                   "maxAssociations" = max_associations,
                                   "orientation" = orientation,
                                   tagList(prompt, rows_match, cols_match)))
    tag("itemBody", list(Map(createText, object@content),
                         match_interactioin))
}

make_associable_choice <- function(id, text, match_max = 1, fixed) {
    tag("simpleAssociableChoice", list(identifier =  id,
                                       "fixed" = fixed,
                                       matchMax = match_max,
                                       text))
}

make_choice_interaction <- function(object, max_choices) {
    prompt <- create_prompt(object)
    simple_choices <- Map(make_choice, "simpleChoice",
                          object@choice_identifiers, object@choices)
    choice_interaction <- tag("choiceInteraction",
                              list(responseIdentifier = "RESPONSE",
                                   shuffle = tolower(object@shuffle),
                                   maxChoices = max_choices,
                                   orientation = object@orientation,
                                   tagList(prompt, simple_choices)))
    tagList(choice_interaction)
}

make_inline_choice_interaction <- function(object) {
    inline_choices <- Map(make_choice, "inlineChoice",
                          object@choices_identifiers,
                          object@choices)
    inline_choice_interaction <- tag("inlineChoiceInteraction",
                                     list(responseIdentifier = object@response_identifier,
                                          shuffle = tolower(object@shuffle),
                                          inline_choices))
    tagList(inline_choice_interaction)
}

make_choice <- function(type_choice, identifier, text) {
    tag(type_choice, list(identifier = identifier, text))
}

create_mapping <- function(object) {
    sum <- sum(object@points[object@points > 0])
    zero <- which(object@points == 0)
    if (all(object@points >= 0)) object@points[zero] <- - sum / length(zero)
    val <- object@points[object@points != 0]
    key <- object@choice_identifiers[object@points != 0]
    map_entries <- Map(create_map_entry, val, key)
    tag("mapping", list(lowerBound = 0,
                        upperBound = sum,
                        defaultValue = 0,
                        map_entries))
}

create_mapping_gap <- function(object) {
    map_enrties <- Map(create_map_entry, object@points, object@solution,
                       object@case_sensitive)
    tag("mapping", list(map_enrties))
}

create_map_entry <- function(value, key, case_sensitive = NULL) {
    tag("mapEntry", list(mapKey = key,
                         mappedValue = value,
                         caseSensitive = tolower(case_sensitive)))
}

make_outcome_declaration <- function(identifier,
                                     cardinality = "single",
                                     base_type = "float",
                                     value = 0, view = NULL) {
    tag("outcomeDeclaration", list(identifier = identifier,
                                   cardinality = cardinality,
                                   baseType = base_type,
                                   view = view,
                                   create_default_value(value)))
}

create_default_value <- function(value) {
    if (!is.null(value)) tag("defaultValue", list(tag("value", value)))
}

create_prompt <- function(object) {
    if (object@prompt != "") {
        tag("prompt", object@prompt)
    }
}

#' Create XML file for question specification
#'
#' @usage create_qti_task(object,
#'                 dir = NULL,
#'                 verification = FALSE)
#' @param object an instance of the S4 object ([SingleChoice], [MultipleChoice],
#'   [Essay], [Entry], [Ordering], [OneInRowTable], [OneInColTable],
#'   [MultipleChoiceTable], [DirectedPair]).
#' @param dir string, optional; a folder to store xml file; working directory by
#'   default
#' @param verification boolean, optional; to check validity of xml file, default
#'   `FALSE`
#' @return xml document.
#' @name create_qti_task
#' @rdname create_qti_task
#' @aliases create_qti_task
#' @importFrom textutils HTMLdecode
create_qti_task <- function(object, dir = NULL, verification = FALSE) {
    content <- as.character(create_assessment_item(object))
    # to handle reading of the xml with html entities
    # dtype <- "<!DOCTYPE assessmentItem PUBLIC \"-//W3C//DTD MathML 2.0//EN\" \"http://www.w3.org/Math/DTD/mathml3/mathml3.dtd\">"
    dtype <- "<!DOCTYPE assessmentItem>"
    doc <- try(suppressWarnings(xml2::read_xml(paste0(dtype, content))),
               silent = TRUE)
    if (inherits(doc, "try-error")) {
        content <- textutils::HTMLdecode(content)
        doc <- suppressWarnings(xml2::read_xml(paste0(dtype, content)))
    }
    if (verification) {
        ver <- verify_qti(doc)
        if (!ver) {
            stop("Xml file is not valid. \n", attributes(ver), call. = FALSE)
        }
    }
    if (is.null(dir)) dir <- getwd()
    ext <- tools::file_ext(dir)
    if (ext == "") {
        file_name <- object@identifier
    } else {
        file_name <- tools::file_path_sans_ext(basename(dir))
        dir <- dirname(dir)
    }
    if (!dir.exists(dir)) dir.create(dir, recursive = TRUE)

    path <- paste0(dir, "/", file_name, ".xml")
    xml2::write_xml(doc, path)
    message(paste("see assessment item:", path))
    return(stringr::str_remove(path, getwd()))
}

# verifies xml according to xsd scheme
verify_qti <- function(doc) {
    file <- file.path(system.file(package = "rqti"), "imsqti_v2p1p2.xsd")
    schema <- xml2::read_xml(file)
    validation <- xml2::xml_validate(doc, schema)
    ifelse(validation[1], return(validation[1]), return(validation))
}

# returns manifest for task
create_manifest_task <- function(object) {
    manifest <- tag("manifest", create_manifest_attributes(object))
    metadata <- tag("metadata", c())
    organisations <- tag("organisations", c())

    file_name <- paste0(object@identifier, ".xml")
    file <-  tag("file", list(href = file_name))

    resource <- tag("resource", list(identifier = object@identifier,
                                     type = "imsqti_item_xmlv2p1",
                                     href = paste0(object@identifier, ".xml"),
                                     file))
    resources <- tag("resources", list(resource))
    tagAppendChildren(manifest, metadata, organisations, resources)
}

create_manifest_attributes <- function(object) {
    c("xmlns" = "http://www.imsglobal.org/xsd/imscp_v1p1",
      "xmlns:xsi" = "http://www.w3.org/2001/XMLSchema-instance",
      "xsi:schemaLocation" = paste0("http://www.imsglobal.org/xsd/imscp_v1p1 ",
                                    "http://www.imsglobal.org/xsd/qti/qtiv2p1/qtiv2p1_imscpv1p2_v1p0.xsd ",
                                    "http://www.imsglobal.org/xsd/imsqti_v2p1 ",
                                    "http://www.imsglobal.org/xsd/qti/qtiv2p1/imsqti_v2p1p1.xsd ",
                                    "http://www.imsglobal.org/xsd/imsqti_metadata_v2p1 ",
                                    "http://www.imsglobal.org/xsd/qti/qtiv2p1/imsqti_metadata_v2p1p1.xsd ",
                                    "http://ltsc.ieee.org/xsd/LOM ",
                                    "http://www.imsglobal.org/xsd/imsmd_loose_v1p3p2.xsd ",
                                    "http://www.w3.org/1998/Math/MathML ",
                                    "http://www.w3.org/Math/XMLSchema/mathml2/mathml2.xsd"),
      "identifier" = paste0(object@title, "_manifest"))
}

create_task_zip <- function(object, path = ".", verification = FALSE,
                            zip_only = TRUE) {
    ext <- tools::file_ext(path)

    if (ext == "") {
        dir <- path
        file_name <- object@identifier
    } else {
        dir <- dirname(path)
        file_name <- tools::file_path_sans_ext(basename(path))
    }

    if (!dir.exists(path)) dir.create(path, recursive = TRUE)

    tdir <- tempfile()
    dir.create(tdir)

    task_path <- create_qti_task(object, tdir)

    manifest <- create_manifest_task(object)
    doc_manifest <- xml2::read_xml(as.character(manifest))
    manifest_path <- paste0(tdir, "/imsmanifest.xml")
    xml2::write_xml(doc_manifest, manifest_path)

    path <- zip_wrapper(file_name, tdir, path, NULL, zip_only)
    return(path)
}
