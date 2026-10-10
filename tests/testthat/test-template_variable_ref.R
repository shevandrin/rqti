test_that("Template references require one valid identifier and render as XML", {
    for (id in list(character(), NA_character_, "", c("a", "b"), "1a", "a b")) {
        expect_error(new("TemplateVariableRef", identifier = id), "valid QTI identifier")
    }
    reference <- new("TemplateVariableRef", identifier = "result-1")
    doc <- xml2::read_xml(as.character(createText(reference)))
    expect_identical(xml2::xml_name(doc), "printedVariable")
    expect_identical(xml2::xml_attr(doc, "identifier"), "result-1")
    expect_length(xml2::xml_children(doc), 0)
    expect_null(getResponse(reference))
    reference@identifier <- ""
    expect_error(createText(reference), "valid QTI identifier")
})

test_that("Entry mixes template references and gaps without changing scoring", {
    block <- new("MaximaVariables", code = "string(['a = 1]);",
                 variables = c(a = "integer"))
    ref <- new("TemplateVariableRef", identifier = "a")
    gap <- numericGap(1, response_identifier = "answer", points = 2)
    item <- new("Entry", template = list(block),
                content = list("<p>Value <strong>", ref, "</strong> = ",
                               gap, "; again ", ref, "</p>"))
    expect_identical(item@points, 2)
    doc <- xml2::read_xml(as.character(create_assessment_item(item)))
    xml2::xml_ns_strip(doc)
    expect_identical(xml2::xml_attr(xml2::xml_find_all(doc, "./responseDeclaration"),
                                   "identifier"), "answer")
    expect_length(xml2::xml_find_all(doc, ".//textEntryInteraction"), 1)
    expect_identical(xml2::xml_attr(xml2::xml_find_all(doc, ".//printedVariable"),
                                   "identifier"), c("a", "a"))
    expect_length(xml2::xml_find_all(doc, ".//strong/printedVariable"), 1)
    baseline <- new("Entry", content = list("<p>", gap, "</p>"))
    expect_identical(as.character(createResponseProcessing(item)),
                     as.character(createResponseProcessing(baseline)))
    expect_identical(as.character(createOutcomeDeclaration(item)),
                     as.character(createOutcomeDeclaration(baseline)))
    expect_error(new("Entry", content = list(ref)), "at least one gap")
    xml <- xml2::read_xml(as.character(create_assessment_item(item)))
    schema <- xml2::read_xml(system.file("qti_v2p1p2_extension.xsd", package = "rqti"))
    expect_true(xml2::xml_validate(xml, schema))
})

test_that("Complete item exports reject undeclared references even without templates", {
    ref <- new("TemplateVariableRef", identifier = "missing")
    block <- new("MaximaVariables", code = "string(['a = 1]);",
                 variables = c(a = "integer"))
    for (template in list(list(), list(block))) {
        item <- new("Essay", content = list(ref), template = template)
        expect_error(create_assessment_item(item),
                     "Undeclared template variables in content: missing")
    }
    # An outcome variable is not a template variable.
    item <- new("Essay", content = list(new("TemplateVariableRef", identifier = "SCORE")))
    expect_error(create_assessment_item(item), "Undeclared template variables in content: SCORE")
    item@content <- list(ref)
    item@content[[1]]@identifier <- NA_character_
    expect_error(create_assessment_item(item), "valid QTI identifier")
})

test_that("Other item types can display outputs and intermediate results", {
    block <- new("MaximaVariables", code = "string(['a = 1]);",
                 variables = c(a = "integer"))
    content <- list("<p>", new("TemplateVariableRef", identifier = "all"),
                    new("TemplateVariableRef", identifier = "a"), "</p>")
    for (item in list(new("Essay", content = content, template = list(block)),
                     new("SingleChoice", choices = c("A", "B"),
                         content = content, template = list(block)))) {
        doc <- xml2::read_xml(as.character(create_assessment_item(item)))
        xml2::xml_ns_strip(doc)
        expect_identical(xml2::xml_attr(xml2::xml_find_all(doc, ".//printedVariable"),
                                       "identifier"), c("all", "a"))
    }
})
