#' Compose a root element AssessmentItem of xml task
#'
#' `create_assessment_item()` creates html structure with AssessmentItem root
#' element (shiny.tag) for xml qti task description according QTI 2.1
#'
#' @param object an instance of the S4 object
#' @importFrom htmltools tag p tagList tagAppendChildren
#' @importFrom purrr imap
#' @returns A list() with a shiny.tag class
#'
#'
create_assessment_item <- function(object) {
    assessment_attributes <- create_assessment_attributes(object)
    assesment_item <- tag("assessmentItem", assessment_attributes)
    assesment_item <- tagAppendChildren(
        assesment_item,
        createResponseDeclaration(object),
        createOutcomeDeclaration(object),
        createItemBody(object),
        createResponseProcessing(object))
}

create_correct_response <- function(values) {
    tags_value <- lapply(values, create_value)
    tag("correctResponse", tags_value)
}

create_assessment_attributes <- function(object) {
    c("xmlns" = "http://www.imsglobal.org/xsd/imsqti_v2p1",
      "xmlns:xsi" = "http://www.w3.org/2001/XMLSchema-instance",
      "xsi:schemaLocation" = "http://www.imsglobal.org/xsd/imsqti_v2p1 http://www.imsglobal.org/xsd/qti/qtiv2p1/imsqti_v2p1.xsd",
      "identifier" = object@identifier,
      "title" = paste(object@title),
      "adaptive" =  "false",
      "timeDependent" = "false")
}

create_value <- function(value) {
    tag("value", value)
}

create_item_body_entry <- function(object) {
    tag("itemBody", list(Map(createText, object@text@content)))
}

create_item_body_essay <- function(object) {
    prompt <- create_prompt(object)
    ext_text <- tag("extendedTextInteraction",
                    list("responseIdentifier" = "RESPONSE",
                         "expectedLength" = object@expectedLength,
                         "expectedLines" = object@expectedLines,
                         "maxStrings" = object@maxStrings,
                         "minStrings" = object@minStrings,
                         "data-allowPaste" = tolower(object@dataAllowPaste),
                                                    prompt))
    tag("itemBody", list(Map(createText, object@text@content), ext_text))
}

create_item_body_choice <- function(object, max_choices) {
    tag("itemBody", list(Map(createText, object@text@content),
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
                                   "shuffle" = object@shuffle,
                                   prompt, choices))
    tag("itemBody", list(Map(createText, object@text@content),
                         order_interactioin))
}

create_item_body_match_table <- function(object,  row_associations,
                                         col_associations) {
    prompt <- create_prompt(object)
    rows <- Map(make_associable_choice,
                object@rows_identifiers,
                object@rows,
                row_associations)
    rows_match <- tag("simpleMatchSet", list(rows))
    cols <- Map(make_associable_choice,
                object@cols_identifiers,
                object@cols,
                col_associations)
    cols_match <- tag("simpleMatchSet", list(cols))
    match_interactioin <- tag("matchInteraction",
                              list("responseIdentifier" = "RESPONSE",
                                   "shuffle" = tolower(object@shuffle),
                                   "maxAssociations" = max(c(row_associations,
                                                             col_associations)),
                                   tagList(prompt, rows_match, cols_match)))
    tag("itemBody", list(Map(createText, object@text@content),
                         match_interactioin))
}


make_associable_choice <- function(id, text, match_max = 1) {
    tag("simpleAssociableChoice", list(identifier =  id,
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
                          object@options_identifiers,
                          object@options)
    inline_choice_interaction <- tag("inlineChoiceInteraction",
                              list(shuffle = object@shuffle,
                                responseIdentifier = object@response_identifier,
                                   inline_choices))
    tagList(inline_choice_interaction)
}

make_choice <- function(type_choice, identifier, text) {
    tag(type_choice, list(identifier = identifier, text))
}


create_mapping <- function(object) {
    map_entries <- imap(object@mapping[object@mapping != 0], create_map_entry)
    tag("mapping", list(lowerBound = object@lower_bound,
                        upperBound = object@upper_bound,
                        defaultValue = object@default_value,
                        map_entries)
    )
}

create_mapping_gap <- function(object) {
    map_keys <- c(object@response, object@alternatives)
    map_enrties <- Map(create_map_entry, object@score, map_keys,
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
                                       value = 0) {
    tag("outcomeDeclaration", list(identifier = identifier,
                                   cardinality = cardinality,
                                   baseType = base_type,
                                   create_default_value(value)))
}

create_default_value <- function(value) {
    tag("defaultValue", list(tag("value", value)))
}

create_prompt <- function(object) {
    if (object@prompt != "") {
        tag("prompt", object@prompt)
    }
}

#' Create XML file for question specification
#'
#' @param object an instance of the S4 object (SingleChoice, MultipleChoice,
#'   Entry, Order, OneInRowTable, OneInColTable, MultipleChoiceTable,
#'   DirectedPair).
#'
#' @return xml document.
#' @export
create_qti_task <- function(object) {
    content <- create_assessment_item(object)
    print(content)
    doc <- xml2::read_xml(as.character(content))
    path <- paste0("results/", object@title, ".xml")
    xml2::write_xml(doc, path)
    print(paste("see:", path))
}


create_assessment_test <-function(object) {
    assessment_attributes <- c("xmlns" = "http://www.imsglobal.org/xsd/imsqti_v2p1",
                               "xmlns:xsi" = "http://www.w3.org/2001/XMLSchema-instance",
                               "xsi:schemaLocation" = "http://www.imsglobal.org/xsd/imsqti_v2p1 http://www.imsglobal.org/xsd/qti/qtiv2p1/imsqti_v2p1.xsd",
                               "identifier" = object@identifier,
                               "title" = paste(object@title))
    assesment_test <- tag("assessmentTest", assessment_attributes)
    sections <- Map(create_section_test, object@section)
    testPart <- tag("testPart", list(identifier = object@test_part_identifier,
                                     navigationMode = object@navigation_mode,
                                     submissionMode = object@submission_mode,
                                     sections))
    tagAppendChildren(assesment_test,
                      createOutcomeDeclaration(object),
                      testPart,
                      createTestPart(object))
}

create_qti_test <- function(object) {
    content <- create_assessment_test(object)
    # print(content)
    doc_test <- xml2::read_xml(as.character(content))
    path_test <- paste0("results/", object@title, ".xml")
    # items_list =
    xml2::write_xml(doc_test, path_test)
    manifest <- create_manifest(object)
    doc_manifest <- xml2::read_xml(as.character(manifest))
    path_manifest <- paste0("results/", "imsmanifest.xml")
    xml2::write_xml(doc_manifest, path_manifest)
    print(manifest)
}

create_section_test <- function(object) {
    assessment_items <- Map(buildAssessmentSection, object@assessment_item)
    print(object@identifier)
    print(object@title)
    tag("assessmentSection", list(identifier = object@identifier,
                                  fixed = "false",
                                  title = object@title,
                                  visible = TRUE,
                                  assessment_items))
}

create_assessment_refs <- function(object) {
    tag("assessmentItemRef", list(identifier = object@identifier,
                                  href = object@href))
}

create_manifest <- function(object) {
    manifest_attributes <- c("xmlns" = "http://www.imsglobal.org/xsd/imscp_v1p1",
                             "xmlns:xsi" = "http://www.w3.org/2001/XMLSchema-instance",
                             "xsi:schemaLocation" = "http://www.imsglobal.org/xsd/imscp_v1p1 http://www.imsglobal.org/xsd/qti/qtiv2p1/qtiv2p1_imscpv1p2_v1p0.xsd http://www.imsglobal.org/xsd/imsqti_v2p1 http://www.imsglobal.org/xsd/qti/qtiv2p1/imsqti_v2p1p1.xsd http://www.imsglobal.org/xsd/imsqti_metadata_v2p1 http://www.imsglobal.org/xsd/qti/qtiv2p1/imsqti_metadata_v2p1p1.xsd http://ltsc.ieee.org/xsd/LOM http://www.imsglobal.org/xsd/imsmd_loose_v1p3p2.xsd http://www.w3.org/1998/Math/MathML http://www.w3.org/Math/XMLSchema/mathml2/mathml2.xsd",
                             "identifier" = paste0(object@title, "_manifest"))
    manifest <- tag("manifest", manifest_attributes)
    metadata <- tag("metadata", c())
    organisations <- tag("organisations", c())

    file_name <- paste0(object@title, ".xml")
    file <-  tag("file", list(href = file_name))
    items <- unlist(Map(getAssessmentItems, object@section))
    print(names(items))
    dependencies <- Map(create_dependency, names(items))
    test_resource <- tag("resource", list(identifier = object@identifier,
                                          type = "imsqti_test_xmlv2p1",
                                          href = paste0(object@title, ".xml"),
                                          file,
                                          dependencies))
    item_resources <- Map(create_resource_item, names(items), items)
    resources <- tag("resources", list(test_resource, item_resources))

    tagAppendChildren(manifest, metadata, organisations,resources)
}

create_dependency <- function(id) {
    tag("dependency", list(identifierref = id))
}

create_resource_item <- function(id, href) {
    file <- tag("file", list(href = href))
    tag("resource", list(identifier = id,
                         type = "imsqti_item_xmlv2p1",
                         href = href,
                         file))
}
