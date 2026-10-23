dynamic_text_item <- function(type = "string", gap = textGap(
    solution_variable = "word", response_identifier = "answer", points = 2)) {
    block <- new("MaximaVariables", code = 'string([\'word = "Blue"]);',
                 variables = setNames(type, "word"))
    entry(content = list("<p>", gap, "</p>"), template = list(block))
}

test_that("dynamic text bindings validate identifiers, sources and options", {
    gap <- textGap(solution_variable = "word")
    expect_identical(gap@solution, character())
    expect_identical(gap@expected_length, 10)
    expect_identical(textGap("answer")@solution_variable, character())
    expect_identical(textGap(solution_variable = "word", expected_length = 20)@expected_length, 20)
    expect_identical(gapText(solution_variable = "word")@solution_variable, "word")
    expect_error(textGap(), "Provide solution")
    expect_error(gap_text(), "Provide solution")
    expect_error(textGap("fixed", solution_variable = "word"), "either solution")
    expect_error(gap_text("fixed", solution_variable = "word"), "either solution")
    for (id in list("", NA_character_, c("a", "b"), "a b")) {
        expect_error(textGap(solution_variable = id), "valid QTI identifier")
        expect_error(gap_text(solution_variable = id), "valid QTI identifier")
    }
    expect_error(textGap(solution_variable = "word", case_sensitive = NA), "case_sensitive")
    expect_error(textGapOpal(solution_variable = "word", tolerance = 1), "spelling tolerance")
    expect_error(gap_text(solution_variable = "word", tolerance = 1), "spelling tolerance")
    expect_s4_class(textGapOpal(solution_variable = "word", tolerance = 0), "TextGapOpal")
    item <- dynamic_text_item()
    item@template <- list()
    expect_error(create_assessment_item(item), "Undeclared solution variable: word")
    for (type in c("integer", "float")) {
        expect_error(create_assessment_item(dynamic_text_item(type)), "type string: word")
    }
})

test_that("text answers are set before scoring and use a string comparison", {
    for (sensitive in c(TRUE, FALSE)) {
        for (make_gap in list(textGap, textGapOpal)) {
            item <- dynamic_text_item(gap = make_gap(solution_variable = "word",
                response_identifier = "answer", points = 2, case_sensitive = sensitive))
            doc <- xml2::read_xml(as.character(create_assessment_item(item)))
            schema <- xml2::read_xml(system.file("qti_v2p1p2_extension.xsd", package = "rqti"))
            expect_true(xml2::xml_validate(doc, schema))
            xml2::xml_ns_strip(doc)
            expect_length(xml2::xml_find_all(doc, "./responseDeclaration/correctResponse | ./responseDeclaration/mapping"), 0)
            expect_identical(xml2::xml_attr(xml2::xml_find_first(doc, "./responseDeclaration"), "baseType"), "string")
            expect_identical(xml2::xml_attr(xml2::xml_find_first(doc,
                "./templateProcessing/*[last()]/variable"), "identifier"), "word")
            expect_identical(xml2::xml_name(xml2::xml_find_first(doc,
                "./responseProcessing/*[1]")), "setCorrectResponse")
            comparison <- xml2::xml_find_first(doc, ".//stringMatch")
            expect_identical(xml2::xml_attr(comparison, "caseSensitive"), tolower(sensitive))
            expect_identical(xml2::xml_attr(xml2::xml_find_first(comparison, "./correct"), "identifier"), "answer")
            expect_identical(xml2::xml_text(xml2::xml_find_first(doc,
                "./responseProcessing/responseCondition/responseElse/setOutcomeValue/baseValue")), "0")
            expect_length(xml2::xml_find_all(doc, "./responseProcessing//mapResponse | ./responseProcessing//mapTolResponse"), 0)
        }
    }
})

test_that("mixed numeric, static text and dynamic text gaps retain their answer sources", {
    item <- dynamic_text_item()
    item@content <- list(textGap("Fixed", response_identifier = "fixed"),
        textGap(solution_variable = "word", response_identifier = "text"),
        numericGap(solution_variable = "number", response_identifier = "numeric"))
    item@template[[1]]@variables <- c(word = "string", number = "integer")
    doc <- xml2::read_xml(as.character(create_assessment_item(item)))
    xml2::xml_ns_strip(doc)
    expect_identical(xml2::xml_attr(xml2::xml_find_all(doc,
        "./responseProcessing/setCorrectResponse"), "identifier"), c("text", "numeric"))
    expect_identical(xml2::xml_text(xml2::xml_find_first(doc,
        "./responseDeclaration[@identifier='fixed']/correctResponse/value")), "Fixed")
    expect_length(xml2::xml_find_all(doc, ".//mapResponse[@identifier='fixed']"), 1)
    expect_length(xml2::xml_find_all(doc, ".//equal/correct[@identifier='numeric']"), 1)
})

test_that("Rmd text helpers bind a real Maxima string without freezing its sample value", {
    skip_on_cran()
    skip_if(!nzchar(Sys.which("maxima")), "Maxima not installed")
    withr::local_options(list(rqti.maxima_cache_dir =
        file.path(tempdir(), "rqti-test-maxima-libraries")))
    item <- create_question_object(system.file("extdata", "maxima-text-answer.Rmd", package = "rqti"))
    gaps <- Filter(function(x) is(x, "TextGap"), item@content)
    expect_length(gaps, 2)
    expect_identical(vapply(gaps, slot, character(1), "solution_variable"), rep("answer", 2))
    expect_identical(vapply(gaps, slot, logical(1), "case_sensitive"), c(FALSE, TRUE))
    expect_identical(unname(item@template[[1]]@variables), "string")
    expect_true(all(vapply(gaps, function(x) !length(x@solution), logical(1))))
    for (tolerance in c("", ", tolerance=0")) {
        yaml <- gap_text(solution_variable = "word", tolerance = if (nzchar(tolerance)) 0 else NULL)
        node <- xml2::xml_find_first(xml2::read_xml(paste0("<root>", yaml, "</root>")), "./gap")
        parsed <- create_gap_object(node, "text")
        expect_s4_class(parsed, if (nzchar(tolerance)) "TextGapOpal" else "TextGap")
        expect_identical(parsed@solution_variable, "word")
    }
})
