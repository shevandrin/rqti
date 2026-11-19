test_that("Maxima descriptions preserve code and output types", {
    code <- "block([a],\n a: 1, string(['a = a]));"
    block <- new("MaximaVariables", code = code,
                 variables = c(a = "integer", b = "float", c = "string"))
    expect_identical(block@code, code)
    expect_identical(block@identifier, "all")
    expect_identical(block@variables,
                     c(a = "integer", b = "float", c = "string"))
    expect_true(validObject(block))
})

test_that("Maxima descriptions reject invalid programs and outputs", {
    make <- function(code = "string(['a = 1]);",
                     variables = c(a = "integer"), identifier = "all") {
        new("MaximaVariables", code = code, variables = variables,
            identifier = identifier)
    }
    for (code in list(character(), NA_character_, " \n\t", c("a", "b"))) {
        expect_error(make(code = code), "code must")
    }
    for (outputs in list(character(), "integer", setNames("integer", ""))) {
        expect_error(make(variables = outputs), "output names")
    }
    for (name in c(NA_character_, "1a", "a-b", "a.b", "a b", "ä")) {
        expect_error(make(variables = setNames("integer", name)), "output names")
    }
    expect_error(make(variables = c(a = "integer", a = "float")), "unique")
    expect_error(make(variables = c(a = "boolean")), "Output types")
    expect_error(make(variables = c(a = NA_character_)), "Output types")
    for (id in list(character(), NA_character_, "", "1all", c("x", "y"))) {
        expect_error(make(identifier = id), "valid QTI identifier")
    }
    expect_error(make(identifier = "a"), "differ from output names")
    expect_true(validObject(make(identifier = "result-1")))
})

test_that("Assessment items store validated template descriptions", {
    block <- new("MaximaVariables", code = "string(['a = 1]);",
                 variables = c(a = "integer"))
    expect_identical(new("Essay")@template, list())
    expect_identical(new("SingleChoice", choices = c("A", "B"))@template,
                     list())
    expect_identical(new("Entry", content = list(numericGap(1)))@template,
                     list())
    item <- new("Essay", template = list(block))
    expect_identical(item@template, list(block))
    expect_error(new("Essay", template = list("code")), "MaximaVariables")
    block@code <- ""
    expect_error(new("Essay", template = list(block)), "code must")
})
