# XML interpreter adapted from the GPL-3 exams2rqti test suite.
scoring_item_xml <- function(item) {
    path <- tempfile(fileext = ".xml")
    on.exit(unlink(path))
    rqti::createQtiTask(item, path)
    xml2::xml_ns_strip(xml2::read_xml(path))
}

# A deliberately small interpreter for the QTI scoring operators emitted by
# rqti's choice classes. It reads declarations AND executes responseProcessing;
# it does not score from the adapter's R objects or repeat its weight formula.
# Unknown operators fail, so a changed upstream processing tree requires review.
# Feedback and LMS/session behaviour are outside this test interpreter's scope.
score_choice_qti <- function(doc, response = NULL, responses = NULL, manual_scores = list(), outcomes = FALSE) {
    env <- new.env(parent = emptyenv())
    declarations <- xml2::xml_find_all(doc, "/assessmentItem/outcomeDeclaration")
    for (node in declarations) {
        value <- xml2::xml_text(xml2::xml_find_first(node, "defaultValue/value"))
        env[[xml2::xml_attr(node, "identifier")]] <- if (is.na(value)) NULL else {
            type <- xml2::xml_attr(node, "baseType")
            if (is.na(type) || type %in% c("float", "integer")) as.numeric(value) else value
        }
    }
    env$RESPONSE <- response
    for (id in names(responses)) env[[id]] <- responses[[id]]
    for (id in names(manual_scores)) env[[id]] <- manual_scores[[id]]
    eval_node <- function(node) {
        children <- xml2::xml_children(node)
        identifier <- xml2::xml_attr(node, "identifier")
        args <- function() lapply(children, eval_node)
        switch(xml2::xml_name(node),
            variable = env[[identifier]],
            correct = xml2::xml_text(xml2::xml_find_all(doc, paste0(
                "/assessmentItem/responseDeclaration[@identifier='", identifier,
                "']/correctResponse/value"))),
            null = NULL,
            baseValue = {
                value <- xml2::xml_text(node)
                if (xml2::xml_attr(node, "baseType") %in% c("float", "integer")) {
                    as.numeric(value)
                } else value
            },
            isNull = length(eval_node(children[[1L]])) == 0L,
            not = !eval_node(children[[1L]]),
            and = all(unlist(args())),
            equal = {
                values <- args()
                if (any(lengths(values) == 0L)) FALSE else {
                    a <- as.numeric(values[[1]]); b <- as.numeric(values[[2]])
                    tolerance <- xml2::xml_attr(node, "tolerance")
                    if (is.na(tolerance)) tolerance <- "0 0"
                    tolerance <- as.numeric(strsplit(tolerance, " ", fixed = TRUE)[[1]])
                    a >= b - tolerance[1] && a <= b + tail(tolerance, 1)
                }
            },
            match = { values <- args(); setequal(values[[1L]], values[[2L]]) },
            gt = { values <- args(); values[[1L]] > values[[2L]] },
            gte = { values <- args(); values[[1L]] >= values[[2L]] },
            lt = { values <- args(); values[[1L]] < values[[2L]] },
            lte = { values <- args(); values[[1L]] <= values[[2L]] },
            sum = sum(unlist(args())),
            multiple = unlist(args()),
            or = any(unlist(args())),
            containerSize = length(eval_node(children[[1L]])),
            member = { values <- args(); values[[1L]] %in% values[[2L]] },
            mapResponse = {
                mapping <- xml2::xml_find_first(doc, paste0(
                    "/assessmentItem/responseDeclaration[@identifier='", identifier,
                    "']/mapping"))
                entries <- xml2::xml_find_all(mapping, "mapEntry")
                keys <- xml2::xml_attr(entries, "mapKey")
                weights <- as.numeric(xml2::xml_attr(entries, "mappedValue"))
                selected <- base::match(unique(env[[identifier]]), keys)
                scores <- weights[selected]
                default <- as.numeric(xml2::xml_attr(mapping, "defaultValue"))
                if (is.na(default)) default <- 0
                scores[is.na(selected)] <- default
                total <- sum(scores)
                lower <- as.numeric(xml2::xml_attr(mapping, "lowerBound"))
                upper <- as.numeric(xml2::xml_attr(mapping, "upperBound"))
                if (!is.na(lower)) total <- max(lower, total)
                if (!is.na(upper)) total <- min(upper, total)
                total
            },
            setOutcomeValue = { env[[identifier]] <- eval_node(children[[1L]]); NULL },
            responseProcessing = { lapply(children, eval_node); NULL },
            responseCondition = {
                for (branch in children) {
                    statements <- xml2::xml_children(branch)
                    if (xml2::xml_name(branch) == "responseElse") {
                        lapply(statements, eval_node)
                        break
                    }
                    if (isTRUE(eval_node(statements[[1L]]))) {
                        lapply(statements[-1L], eval_node)
                        break
                    }
                }
                NULL
            },
            stop("Unimplemented QTI test operator: ", xml2::xml_name(node))
        )
    }
    eval_node(xml2::xml_find_first(doc, "/assessmentItem/responseProcessing"))
    if (outcomes) as.list(env) else env$SCORE
}
