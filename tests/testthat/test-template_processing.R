maxima_test_block <- function(id = "all", outputs = c(a = "integer")) {
    new("MaximaVariables", identifier = id, variables = outputs,
        code = "block([a],\n a: 1, string(['a = a]));")
}

test_that("Maxima outputs have declarations and ordered extraction rules", {
    block <- maxima_test_block(outputs = c(a = "integer", b = "float", c = "string"))
    item <- new("Essay", css = "p { color: black; }", template = list(block))
    doc <- xml2::read_xml(as.character(create_assessment_item(item)))
    xml2::xml_ns_strip(doc)
    declarations <- xml2::xml_find_all(doc, "./templateDeclaration")
    expect_equal(xml2::xml_attr(declarations, "identifier"), c("all", "a", "b", "c"))
    expect_equal(xml2::xml_attr(declarations, "baseType"), c("string", "integer", "float", "string"))
    expect_true(all(xml2::xml_attr(declarations, "cardinality") == "single"))
    rules <- xml2::xml_find_all(doc, "./templateProcessing/setTemplateValue")
    expect_equal(xml2::xml_attr(rules, "identifier"), c("all", "a", "b", "c"))
    operators <- xml2::xml_find_all(rules, "./customOperator")
    expect_true(all(xml2::xml_attr(operators, "definition") == "MAXIMA"))
    expect_equal(xml2::xml_attr(operators[-1], "value"),
                 c("assoc(a,$(1));", "assoc(b,$(1));", "assoc(c,$(1));"))
    expect_equal(xml2::xml_attr(xml2::xml_find_all(operators, "./variable"), "identifier"),
                 rep("all", 3))
    names <- xml2::xml_name(xml2::xml_children(doc))
    expect_lt(max(which(names == "templateDeclaration")), which(names == "templateProcessing"))
    expect_lt(which(names == "templateProcessing"), which(names == "stylesheet"))
    expect_lt(which(names == "stylesheet"), which(names == "itemBody"))
})

test_that("OPAL inner encoding preserves special characters and normalizes newlines", {
    block <- maxima_test_block()
    block@code <- "'a\r\n'b\r'c\n\"<& ä\""
    item <- new("Essay", template = list(block))
    xml <- as.character(createTemplateProcessing(item))
    doc <- xml2::read_xml(xml)
    value <- xml2::xml_attr(xml2::xml_find_first(doc, ".//customOperator"), "value")
    expect_identical(value, "&#x27;a&#xA;&#xD;&#x27;b&#xA;&#xD;&#x27;c&#xA;&#xD;\"<& ä\"")
    expect_match(xml, "&amp;#x27;", fixed = TRUE)
    expect_identical(block@code, "'a\r\n'b\r'c\n\"<& ä\"")
})

test_that("Multiple blocks share one processing element in list order", {
    item <- new("Essay", template = list(maxima_test_block(),
        maxima_test_block("second", c(b = "integer"))))
    doc <- xml2::read_xml(as.character(create_assessment_item(item)))
    xml2::xml_ns_strip(doc)
    expect_length(xml2::xml_find_all(doc, "./templateProcessing"), 1)
    expect_equal(xml2::xml_attr(xml2::xml_find_all(doc,
        "./templateProcessing/setTemplateValue"), "identifier"), c("all", "a", "second", "b"))
})

test_that("Template conflicts include generated response and outcome identifiers", {
    for (name in c("SCORE", "MAXSCORE", "MINSCORE", "RESPONSE")) {
        item <- new("Essay", template = list(maxima_test_block(outputs = setNames("integer", name))))
        expect_error(create_assessment_item(item), paste0("Conflicting template identifiers: ", name))
    }
    item <- new("Entry", content = list(numericGap(1, response_identifier = "answer")),
                template = list(maxima_test_block(outputs = c(answer = "integer"))))
    expect_error(create_assessment_item(item), "Conflicting template identifiers: answer")
    for (second in list(maxima_test_block(), maxima_test_block("other"),
                        maxima_test_block("a", c(b = "integer")))) {
        item <- new("Essay", template = list(maxima_test_block(), second))
        expect_error(createTemplateDeclaration(item), "Conflicting template identifiers")
        expect_error(createTemplateProcessing(item), "Conflicting template identifiers")
    }
})

test_that("Empty templates leave the previous XML assembly unchanged", {
    item <- new("Essay", identifier = "example")
    expect_null(createTemplateDeclaration(item))
    expect_null(createTemplateProcessing(item))
    old <- tag("assessmentItem", create_assessment_attributes(item))
    old <- tagAppendChildren(old, createResponseDeclaration(item),
        createOutcomeDeclaration(item), createItemBody(item),
        createResponseProcessing(item), Map(createModalFeedback, item@feedback))
    expect_identical(as.character(create_assessment_item(item)), as.character(old))
})

test_that("Maxima assessment XML validates against the extended QTI schema", {
    item <- new("Essay", template = list(maxima_test_block()))
    doc <- xml2::read_xml(as.character(create_assessment_item(item)))
    schema <- xml2::read_xml(system.file("qti_v2p1p2_extension.xsd", package = "rqti"))
    expect_true(xml2::xml_validate(doc, schema))
})
