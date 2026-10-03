#' Create QTI template declarations
#'
#' @param object A [MaximaVariables] or [AssessmentItem] object.
#' @return An `htmltools` tag list, or `NULL` for an item without templates.
#' @export
#' @include AssessmentItem.R
setGeneric("createTemplateDeclaration", function(object) {
    standardGeneric("createTemplateDeclaration")
})

#' @rdname createTemplateDeclaration
setMethod("createTemplateDeclaration", "MaximaVariables", function(object) {
    validObject(object)
    types <- c("string", unname(object@variables))
    ids <- c(object@identifier, names(object@variables))
    tagList(Map(function(id, type) {
        tag("templateDeclaration", list(identifier = id,
                                         cardinality = "single",
                                         baseType = type))
    }, ids, types))
})

#' @rdname createTemplateDeclaration
setMethod("createTemplateDeclaration", "AssessmentItem", function(object) {
    if (!length(object@template)) return(NULL)
    validate_template_identifiers(object)
    tagList(lapply(object@template, createTemplateDeclaration))
})

#' Create QTI template processing
#'
#' Programs run in the target Maxima-capable player, not in R. Blocks execute
#' in list order. Each program stores a string result before its outputs are
#' extracted. The OPAL/ONYX `value` attribute requires rqti's extended schema
#' for XML validation (`schema = "extended"` in [verify_qti]). Live execution requires a player supporting the MAXIMA operator.
#' @param object An [AssessmentItem] object.
#' @return A `templateProcessing` tag, or `NULL` for an item without templates.
#' @export
setGeneric("createTemplateProcessing", function(object) {
    standardGeneric("createTemplateProcessing")
})

#' @rdname createTemplateProcessing
setMethod("createTemplateProcessing", "AssessmentItem", function(object) {
    if (!length(object@template)) return(NULL)
    validate_template_identifiers(object)
    tag("templateProcessing", lapply(object@template, create_template_rules))
})

# Preserve OPAL's inner character references; htmltools adds XML escaping.
encode_maxima_code <- function(code) {
    code <- gsub("\r\n|\r|\n", "&#xA;&#xD;", code)
    gsub("'", "&#x27;", code, fixed = TRUE)
}

create_template_rules <- function(object) {
    validObject(object)
    program <- tag("setTemplateValue", list(identifier = object@identifier,
        tag("customOperator", list(definition = "MAXIMA",
                                    value = encode_maxima_code(object@code)))))
    outputs <- lapply(names(object@variables), function(id) {
        tag("setTemplateValue", list(identifier = id,
            tag("customOperator", list(definition = "MAXIMA",
                value = paste0("assoc(", id, ",$(1));"),
                tag("variable", list(identifier = object@identifier))))))
    })
    tagList(program, outputs)
}

# Run at serialization time, after subclass initialization has populated IDs.
validate_template_identifiers <- function(object) {
    validObject(object)
    ids <- unlist(lapply(object@template, function(block) {
        c(block@identifier, names(block@variables))
    }), use.names = FALSE)
    declarations <- tagList(createResponseDeclaration(object),
                            createOutcomeDeclaration(object))
    doc <- xml2::read_xml(paste0("<declarations>",
                                as.character(declarations), "</declarations>"))
    existing <- xml2::xml_attr(xml2::xml_children(doc), "identifier")
    conflicts <- unique(c(ids[duplicated(ids)], ids[ids %in% existing]))
    if (length(conflicts)) {
        stop("Conflicting template identifiers: ", paste(conflicts, collapse = ", "),
             call. = FALSE)
    }
    invisible(TRUE)
}
