#' Compose a root element AssessmentItem of xml task
#'
#' `create_assessment_item()` creates html structure with AssessmentItem root
#' element (shiny.tag) for xml qti task description according QTI 2.1
#'
#' @param object an instance of the S4 object
#' @importFrom htmltools tag p tagList tagAppendChildren
#' @importFrom purrr imap
#' @importFrom utils zip
#' @returns A list() with a shiny.tag class
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
    tag("itemBody", list(Map(createText, object@content)))
}

create_item_body_essay <- function(object) {
    prompt <- create_prompt(object)
    ext_text <- tag("extendedTextInteraction",
                    list("responseIdentifier" = "RESPONSE",
                         "expectedLength" = object@expected_length,
                         "expectedLines" = object@expected_lines,
                         "maxStrings" = object@max_strings,
                         "minStrings" = object@min_strings,
                         "data-allowPaste" = tolower(object@data_allow_paste),
                                                    prompt))
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
    tag("itemBody", list(Map(createText, object@content),
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
                              list(responseIdentifier = object@response_identifier,
                                   shuffle = tolower(object@shuffle),
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
#' @usage create_qti_task(object,
#'                 dir = NULL,
#'                 verification = FALSE)
#' @param object an instance of the S4 object ([SingleChoice], [MultipleChoice],
#'   [Essay], [Entry], [Order], [OneInRowTable], [OneInColTable], [MultipleChoiceTable],
#'   [DirectedPair]).
#' @param dir string, optional; a folder to store xml file; working directory by
#'   default
#' @param verification boolean, optional; to check validity of xml file, default
#'   `FALSE`
#' @return xml document.
#' @examples
#' \dontrun{
#' essay <- new("Essay", prompt = "Test task", title = "Essay")
#' create_qti_task(essay, "result", "TRUE")
#' }
#' @name create_qti_task
#' @rdname create_qti_task
#' @export
create_qti_task <- function(object, dir = NULL, verification = FALSE) {
    if (is.null(dir)) dir <- getwd()
    if (!dir.exists(dir)) dir.create(dir)
    content <- create_assessment_item(object)
    doc <- xml2::read_xml(as.character(content))
    if (verification) {
        ver <- verify_qti(doc)
        if (!ver) {
            msg <- cat("xml file is not valid. See details:\n",
                       attributes(ver))
            return(msg)
        }
    }
    path <- paste0(dir, "/",object@identifier, ".xml")
    xml2::write_xml(doc, path)
    print(paste("see assessment item:", path))
}

# function to verify xml with xsd scheme
verify_qti <- function(doc) {
    file <- file.path(getwd(), "tests/testthat/imsqti_v2p1.xsd")
    schema <- xml2::read_xml(file)
    validation <- xml2::xml_validate(doc, schema)
    ifelse ((validation[1]), return(validation[1]), return(validation))
}