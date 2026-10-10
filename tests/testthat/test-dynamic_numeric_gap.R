dynamic_test_item <- function(type = "integer", ...) {
    gap <- new("NumericGap", response_identifier = "answer",
               solution_variable = "c", ...)
    block <- new("MaximaVariables", code = "string(['c = 3]);",
                 variables = c(c = type))
    new("Entry", content = list("<p>", gap, "</p>"),
        template = list(calculation = block))
}

test_that("Dynamic numeric gaps validate their source and choose a usable width", {
    gap <- new("NumericGap", response_identifier = "answer", solution_variable = "c")
    expect_identical(gap@solution, numeric())
    expect_identical(gap@expected_length, 10)
    expect_identical(new("NumericGap", response_identifier = "answer",
        solution_variable = "c", expected_length = 7)@expected_length, 7)
    expect_error(new("NumericGap", solution = 3, solution_variable = "c"),
                 "either solution or solution_variable")
    for (id in list("", NA_character_, c("a", "b"), "a b")) {
        expect_error(new("NumericGap", solution_variable = id), "valid QTI identifier")
    }
    expect_identical(numericGap(123)@solution_variable, character())
})

test_that("Dynamic numeric answers are assigned after calculation and before scoring", {
    for (type in c("integer", "float")) {
        item <- dynamic_test_item(type, points = 2)
        doc <- xml2::read_xml(as.character(create_assessment_item(item)))
        schema <- xml2::read_xml(system.file("qti_v2p1p2_extension.xsd", package = "rqti"))
        expect_true(xml2::xml_validate(doc, schema))
        xml2::xml_ns_strip(doc)
        expect_length(xml2::xml_find_all(doc, "./responseDeclaration/correctResponse"), 0)
        expect_identical(xml2::xml_attr(xml2::xml_find_first(doc, "./responseDeclaration"),
                                       "baseType"), "float")
        for (path in c("./templateProcessing", "./responseProcessing")) {
            assignments <- xml2::xml_find_all(doc, paste0(path, "/setCorrectResponse"))
            expect_length(assignments, 1)
            expect_identical(xml2::xml_attr(assignments, "identifier"), "answer")
            expect_identical(xml2::xml_attr(xml2::xml_children(assignments), "identifier"), "c")
        }
        expect_identical(xml2::xml_name(xml2::xml_find_first(doc,
            "./templateProcessing/*[last()]")), "setCorrectResponse")
        expect_identical(xml2::xml_name(xml2::xml_find_first(doc,
            "./responseProcessing/*[1]")), "setCorrectResponse")
        expect_length(xml2::xml_find_all(doc, "./responseProcessing//customOperator"), 0)
        expect_identical(item@points, 2)
    }
})

test_that("Unknown and nonnumeric solution variables are rejected", {
    item <- dynamic_test_item()
    item@template <- list()
    expect_error(createTemplateProcessing(item), "Undeclared solution variable: c")
    expect_error(createResponseProcessing(item), "Undeclared solution variable: c")
    expect_error(create_assessment_item(item), "Undeclared solution variable: c")
    item <- dynamic_test_item("string")
    expect_error(create_assessment_item(item), "type integer or float: c")
    item <- dynamic_test_item()
    item@content[[2]]@solution_variable <- "all"
    expect_error(create_assessment_item(item), "type integer or float: all")
    item@content[[2]]@solution_variable <- "missing"
    expect_error(create_assessment_item(item), "Undeclared solution variable: missing")
})

test_that("Dynamic scoring uses the existing exact and tolerance comparisons", {
    for (mode in c("exact", "absolute", "relative")) {
        item <- dynamic_test_item(tolerance_type = mode, tolerance = 5,
                                   include_lower_bound = FALSE,
                                   include_upper_bound = TRUE, points = 3)
        dynamic <- item@content[[2]]
        fixed <- numericGap(3, response_identifier = "answer", points = 3,
                            tolerance = 5, tolerance_type = mode,
                            include_lower_bound = FALSE, include_upper_bound = TRUE)
        expect_identical(as.character(createResponseProcessing(dynamic)),
                         as.character(createResponseProcessing(fixed)))
        expect_identical(as.character(createOutcomeDeclaration(dynamic)),
                         as.character(createOutcomeDeclaration(fixed)))
        doc <- xml2::read_xml(as.character(createResponseProcessing(item)))
        comparison <- xml2::xml_find_first(doc, ".//equal")
        expect_identical(xml2::xml_attr(comparison, "toleranceMode"), mode)
        expect_identical(xml2::xml_attr(comparison, "tolerance"), "5 5")
        expect_identical(xml2::xml_attr(comparison, "includeLowerBound"), "false")
        expect_identical(xml2::xml_attr(comparison, "includeUpperBound"), "true")
        expect_identical(xml2::xml_attr(xml2::xml_find_first(comparison, "./correct"),
                                       "identifier"), "answer")
    }
})

test_that("Mixed fixed and dynamic gaps keep all assignments ahead of scoring", {
    item <- dynamic_test_item()
    item@content <- list("<p>", numericGap(9, response_identifier = "fixed"),
        new("NumericGap", response_identifier = "first", solution_variable = "c"),
        new("NumericGap", response_identifier = "second", solution_variable = "c"), "</p>")
    doc <- xml2::read_xml(as.character(create_assessment_item(item)))
    xml2::xml_ns_strip(doc)
    expect_identical(xml2::xml_text(xml2::xml_find_first(doc,
        "./responseDeclaration[@identifier='fixed']/correctResponse/value")), "9")
    for (path in c("./templateProcessing", "./responseProcessing")) {
        expect_identical(xml2::xml_attr(xml2::xml_find_all(doc,
            paste0(path, "/setCorrectResponse")), "identifier"), c("first", "second"))
    }
    expect_identical(xml2::xml_name(xml2::xml_find_all(doc,
        "./responseProcessing/*[position() <= 2]")), rep("setCorrectResponse", 2))
    fixed <- new("Entry", content = list(numericGap(9, response_identifier = "fixed")))
    expect_null(createTemplateProcessing(fixed))
    expect_length(xml2::xml_find_all(xml2::read_xml(as.character(createResponseProcessing(fixed))),
                                   ".//setCorrectResponse"), 0)
})
