generate_id <- function(prefix = "id_", type = "task", digits = 4L) {
    random_digits <- sample(0:9, digits, replace = TRUE)
    id <- paste0(prefix, type, "_", paste0(random_digits, collapse = ""))
    return(id)
}

check_identifier <- function(id, quiet = FALSE) {
    checker = grepl("^[A-Za-z]", id)
    checker <- checker & !grepl("[\u00C4\u00E4\u00DF\u00D6\u00F6\u00DC\u00FC]", id)
    checker <- checker & !grepl("\\s", id)

    if (!checker && !quiet) {
        stop("The identifier must start with a letter and not contain spaces",
        " or umlauts. Error value: ", id, call. = FALSE)
    }
    return(checker)
}

tags_dict <- c("itemBody", "responseIdentifier", "extendedTextInteraction",
               "expectedLength", "expectedLines", "maxStrings", "minStrings",
               "data-allowPaste", "orderInteraction", "simpleChoice",
               "simpleMatchSet", "matchInteraction", "maxAssociations",
               "simpleAssociableChoice", "choiceInteraction", "maxChoices",
               "inlineChoice", "inlineChoiceInteraction", "matchMax",
               "textEntryInteraction", "placeholderText")
# helps to keep camel case style of tag names after reading html content
rename_nodes <- function(node) {
    # rename nodes
    curr_name <- xml2::xml_name(node)
    name_index <- base::match(curr_name, tolower(tags_dict))
    if (!is.na(name_index)) {
        xml2::xml_name(node) <- tags_dict[name_index]
    }
    # rename attrs
    attrs <- xml2::xml_attrs(node)
    if (length(attrs) > 0) {
        ns <- names(attrs)
        ns_new <- unlist(lapply(ns, function(x) {
            name_index <- base::match(x, tolower(tags_dict))
            ifelse(!is.na(name_index), tags_dict[name_index], x)
        }))
        names(attrs) <- ns_new
        xml2::xml_set_attrs(node, attrs)
    }
    # process childs elements
    chlds <- xml2::xml_children(node)
    if (length(chlds) > 0) {
        # for (chld in chlds) {rename_nodes(chld)}
        sapply(chlds, rename_nodes)
    }
    invisible(NULL)
}

replace_html_entities <- function(node) {
    doc <- read_html(as.character(node))
    result <- xml2::xml_find_first(doc, ".//itembody")
    rename_nodes(result)
    result <- as.character(result)
    result <- gsub("<br>", "<br/>", result)
    pattern <- "<img(\\s[^>]*)?>"
    result <- gsub(pattern, "<img\\1/>", result)
    return(htmltools::HTML(result))
}
