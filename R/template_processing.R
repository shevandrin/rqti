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
    validate_dynamic_solutions(object)
    if (!length(object@template)) return(NULL)
    validate_template_identifiers(object)
    tag("templateProcessing", list(
        lapply(object@template, create_template_rules),
        create_dynamic_correct_responses(object)))
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

# Answer bindings belong to gaps, independently of the calculation block.
dynamic_numeric_gaps <- function(object) {
    Filter(function(x) is(x, "NumericGap") && length(x@solution_variable) > 0L,
           object@content)
}

validate_dynamic_solutions <- function(object) {
    gaps <- dynamic_numeric_gaps(object)
    if (!length(gaps)) return(invisible(TRUE))
    validObject(object)
    # Drop names on the list itself so named template lists cannot prefix IDs.
    types <- do.call(c, unname(lapply(object@template, function(block) {
        c(setNames("string", block@identifier), block@variables)
    })))
    for (gap in gaps) {
        validObject(gap)
        id <- gap@solution_variable
        if (!id %in% names(types)) {
            stop("Undeclared solution variable: ", id, call. = FALSE)
        }
        if (!types[[id]] %in% c("integer", "float")) {
            stop("Solution variable must have type integer or float: ", id,
                 call. = FALSE)
        }
    }
    invisible(TRUE)
}

create_dynamic_correct_responses <- function(object) {
    lapply(dynamic_numeric_gaps(object), function(gap) {
        tag("setCorrectResponse", list(identifier = gap@response_identifier,
            tag("variable", list(identifier = gap@solution_variable))))
    })
}
