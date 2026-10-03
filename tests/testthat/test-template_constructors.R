test_that("Template constructors preserve and validate their inputs", {
    code <- "block([a],\n a: 1, string(['a = a]));"
    block <- maxima_variables(code, c(a = "integer"), "result")
    expect_s4_class(block, "MaximaVariables")
    expect_identical(block@code, code)
    expect_identical(block@identifier, "result")
    expect_identical(block@variables, c(a = "integer"))
    expect_s4_class(template_value("a"), "TemplateVariableRef")
    expect_identical(template_value("a")@identifier, "a")
    expect_error(maxima_variables("", c(a = "integer")), "code must")
    expect_error(maxima_variables(code, c(a = "boolean")), "Output types")
    expect_error(template_value("a b"), "valid QTI identifier")
})

test_that("Every item constructor accepts templates without changing existing defaults", {
    block <- maxima_variables("string(['a = 1]);", c(a = "integer"))
    pairs <- list(rows = c("A", "B"), rows_identifiers = c("r1", "r2"),
                  cols = c("C", "D"), cols_identifiers = c("c1", "c2"),
                  answers_identifiers = c("r1 c1", "r2 c2"), answers_scores = c(1, 1))
    cases <- list(
        entry = list(content = list(numericGap(1))), essay = list(),
        singleChoice = list(choices = c("A", "B")),
        multipleChoice = list(choices = c("A", "B"), points = c(1, 0)),
        ordering = list(choices = c("A", "B")),
        directedPair = pairs, oneInRowTable = pairs,
        oneInColTable = pairs, multipleChoiceTable = pairs
    )
    for (name in names(cases)) {
        args <- c(list(identifier = "example", title = "Example"), cases[[name]])
        fun <- get(name)
        original <- do.call(fun, args)
        explicit <- do.call(fun, c(args, list(template = list())))
        expect_identical(original@template, list(), info = name)
        expect_identical(as.character(create_assessment_item(original)),
                         as.character(create_assessment_item(explicit)), info = name)
        dynamic <- do.call(fun, c(args, list(template = list(block))))
        expect_identical(dynamic@template, list(block), info = name)
        doc <- xml2::read_xml(as.character(create_assessment_item(dynamic)))
        xml2::xml_ns_strip(doc)
        expect_length(xml2::xml_find_all(doc, "./templateDeclaration"), 2)
    }
})

test_that("Numeric gap helpers support both answer modes and positional calls", {
    for (fun in list(numericGap, gapNumeric)) {
        dynamic <- fun(solution_variable = "c")
        expect_identical(dynamic@solution, numeric())
        expect_identical(dynamic@solution_variable, "c")
        expect_identical(dynamic@expected_length, 10)
        expect_identical(fun(solution_variable = "c", expected_length = 6)@expected_length, 6)
        expect_error(fun(3, solution_variable = "c"), "either solution or solution_variable")
        expect_error(fun(), "Provide solution or solution_variable")
        expect_error(fun(solution_variable = ""), "valid QTI identifier")
        fixed <- fun(42, "answer", 2, "Number", 5, 1, "relative", FALSE, TRUE)
        expected <- new("NumericGap", solution = 42, response_identifier = "answer",
            points = 2, placeholder = "Number", expected_length = 5, tolerance = 1,
            tolerance_type = "relative", include_lower_bound = FALSE,
            include_upper_bound = TRUE)
        expect_identical(fixed, expected)
    }
    item <- singleChoice("example", "Example", c("A", "B"), c("a", "b"),
        1, list(), "", 1, list(), "vertical", TRUE, NA_character_, NA_character_, "standard")
    expect_identical(item@template, list())
})

test_that("Public constructors build a complete dynamic addition item", {
    calculation <- maxima_variables(
        "block([a,b,c], a: random(100), b: random(100), c: a+b,
         string(['a=a, 'b=b, 'c=c]));",
        c(a = "integer", b = "integer", c = "integer"))
    item <- entry(identifier = "addition", template = list(calculation),
        content = list("<p>", template_value("a"), " + ", template_value("b"),
            " = ", numericGap(solution_variable = "c", response_identifier = "answer"), "</p>"))
    expect_s4_class(item@content[[2]], "TemplateVariableRef")
    # Export via the public API, keeping all generated files in a temporary folder.
    directory <- tempfile()
    dir.create(directory)
    on.exit(unlink(directory, recursive = TRUE))
    path <- suppressMessages(createQtiTask(item, dir = directory))
    doc <- xml2::read_xml(path)
    schema <- xml2::read_xml(system.file("qti_v2p1p2_extension.xsd", package = "rqti"))
    expect_true(xml2::xml_validate(doc, schema))
    xml2::xml_ns_strip(doc)
    expect_identical(xml2::xml_attr(xml2::xml_find_all(doc, ".//printedVariable"), "identifier"),
                     c("a", "b"))
    expect_identical(xml2::xml_attr(xml2::xml_find_all(doc, ".//setCorrectResponse/variable"),
                                   "identifier"), c("c", "c"))
})
