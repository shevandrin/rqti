withr::local_options(list(rqti.maxima_cache_dir =
    file.path(tempdir(), "rqti-test-maxima-libraries")))

test_that("template names work consistently for objects and Rmd helpers", {
    expect_s4_class(template_value("a"), "TemplateVariableRef")
    expect_identical(template_value("a")@identifier, "a")
    expect_identical(numericGap(solution_variable = "a")@solution_variable, "a")
    expect_error(numericGap(1, solution_variable = "a"), "either")
    expect_error(gap_numeric(1, solution_variable = "a"), "either")
    expect_error(gap_numeric(), "Provide solution")
    expect_error(gap_numeric(solution_variable = NA_character_), "valid QTI identifier")
    expect_match(gap_numeric(12), "solution: 12", fixed = TRUE)
    dynamic <- gap_numeric(solution_variable = "answer")
    expect_match(dynamic, "solution_variable: 'answer'", fixed = TRUE)
    expect_false(grepl("solution:", dynamic, fixed = TRUE))
})

test_that("missing Maxima is an actionable source-specific error", {
    err <- tryCatch(maxima_check("1;", executable = "", file = "exercise.Rmd", chunk = "calculation"), error = identity)
    expect_s3_class(err, "rqti_maxima_error")
    expect_match(conditionMessage(err), "exercise.Rmd: Maxima chunk 'calculation'", fixed = TRUE)
    expect_match(err$diagnostic, "Install Maxima", fixed = TRUE)
    expect_error(maxima_check("1;", executable = tempfile("missing-maxima-")),
                 "Maxima executable not found.*Install Maxima")
})

test_that("real Maxima reports syntax and runtime errors and recovers", {
    skip_on_cran()
    skip_if(!nzchar(Sys.which("maxima")), "Maxima not installed")
    expect_true(maxima_check("block([a], a:random(100), string(['a = a]));"))
    for (code in c("1/0;", "1+);", "1;\n2+);", "block([a], a:1;", "1; /* unfinished")) {
        err <- tryCatch(maxima_check(code, file = "broken.Rmd", chunk = "broken"), error = identity)
        expect_s3_class(err, "rqti_maxima_error")
        expect_match(conditionMessage(err), "broken.Rmd", fixed = TRUE)
        expect_match(conditionMessage(err), "Source:", fixed = TRUE)
        expect_true(nzchar(err$diagnostic))
    }
    expect_true(maxima_check("3+4;"))
})

test_that("Maxima execution has a bounded timeout", {
    skip_on_cran()
    skip_if(!nzchar(Sys.which("maxima")), "Maxima not installed")
    started <- proc.time()[["elapsed"]]
    expect_error(maxima_check("while true do 1;", timeout = 2), "exceeded 2 seconds")
    expect_lt(proc.time()[["elapsed"]] - started, 10)
    expect_true(maxima_check("1+2;", libraries = character()))
})

test_that("Maxima checks also work without preloaded libraries", {
    skip_on_cran()
    skip_if(!nzchar(Sys.which("maxima")), "Maxima not installed")
    expect_true(maxima_check("1+2;", libraries = character()))
    expect_error(maxima_check("1+);", libraries = character()), "Illegal use of delimiter")
})

maxima_rmd_file <- function(code, variables = "c(a='integer')", question = NULL, label = "calculation") {
    if (is.null(question)) question <- c(
        "What is **`r template_value('a')`**?",
        "`r gap_numeric(solution_variable='a', tolerance_type='exact')`")
    path <- tempfile(fileext = ".Rmd")
    writeLines(c("---", "type: gap", "title: Example", "---", "",
        "```{r setup, include=FALSE}", "library(rqti)", "```", "",
        paste0("```{maxima ", label, ", variables=", variables, "}"),
        code, "```", "", "# question", "", question), path)
    path
}

test_that("missing Maxima stops template rendering but leaves ordinary Rmd usable", {
    old <- options(rqti.maxima = "")
    on.exit(options(old), add = TRUE)
    file <- maxima_rmd_file("string(['a = 3]);")
    expect_error(create_question_object(file), "Install Maxima")
    static <- create_question_object(test_path("file/rmd/Gap_primitive.Rmd"))
    expect_length(static@template, 0)
})

test_that("template chunks cannot bypass validation", {
    for (option in c("cache=TRUE", "eval=FALSE")) {
        disabled <- maxima_rmd_file("1+);", label = paste("calculation", option, sep = ", "))
        expect_error(create_question_object(disabled), "eval=TRUE and cache=FALSE")
    }
})

test_that("Maxima infers names and QTI types from its returned associations", {
    skip_on_cran()
    skip_if(!nzchar(Sys.which("maxima")), "Maxima not installed")
    code <- paste0("string(['whole=3, 'decimal=1.5, 'fraction=1/2, ",
                   "'real=sqrt(2), 'label=\"hello\", 'items=[1,2]]);")
    types <- maxima_check(code, libraries=character(), outputs=TRUE)
    expect_identical(types, c(whole="integer", decimal="float", fraction="float",
                             real="float", label="string", items="unsupported"))
    expect_error(resolve_maxima_types(types), "Cannot infer QTI types.*items")
    expect_identical(resolve_maxima_types(types, c(whole="float", items="string")),
                     c(whole="float", items="string"))
    expect_error(resolve_maxima_types(types, c(decimal="integer")), "disagree")
    expect_error(resolve_maxima_types(types, c(missing="integer")), "missing from")
    expect_identical(resolve_maxima_types(c(all="integer"), c(all="float")), c(all="float"))
    for (bad in c("3;", "\"not a list\";", "string([1,2]);", "string(['a=1,'a=2]);")) {
        expect_error(maxima_check(bad, libraries=character(), outputs=TRUE))
    }
    # Outputs must retain their names even when global variables are assigned.
    expect_identical(maxima_check("a:3; b:1/2; string(['a=a,'b=b]);",
                                libraries=character(), outputs=TRUE), c(a="integer", b="float"))
})

test_that("automatic Rmd declarations match explicit types and execute once", {
    skip_on_cran()
    skip_if(!nzchar(Sys.which("maxima")), "Maxima not installed")
    code <- "string(['a = 3]);"
    auto <- create_question_object(maxima_rmd_file(code, variables="NULL"))
    explicit <- create_question_object(maxima_rmd_file(code))
    expect_identical(auto@template, explicit@template)
    expect_identical(maxima_variables(code)@variables, c(a="integer"))
    # A second execution would try to create an existing file and fail.
    sentinel <- tempfile()
    code <- paste0("if file_search(\"", sentinel, "\")#false then error(\"Executed twice\");\n",
                   "with_stdout(\"", sentinel, "\",print(\"run\"));\n",
                   "string(['a = 3]);")
    file <- maxima_rmd_file(code, variables="NULL")
    expect_length(create_question_object(file)@template, 1)
    expect_true(file.exists(sentinel))
})

test_that("Rmd preserves live Maxima templates, displayed references and dynamic answers", {
    skip_on_cran()
    skip_if(!nzchar(Sys.which("maxima")), "Maxima not installed")
    file <- system.file("extdata", "maxima-addition.Rmd", package = "rqti")
    item <- create_question_object(file)
    expect_length(item@template, 1)
    expect_identical(item@template[[1]]@variables, c(a="integer", b="integer", answer="integer"))
    xml <- xml2::read_xml(as.character(create_assessment_item(item)))
    xml2::xml_ns_strip(xml)
    expect_length(xml2::xml_find_all(xml, ".//strong/span/printedVariable"), 2)
    expect_length(xml2::xml_find_all(xml, ".//customOperator[@definition='MAXIMA']"), 4)
    expect_length(xml2::xml_find_all(xml, "./responseDeclaration/correctResponse"), 0)
    expect_identical(xml2::xml_attr(xml2::xml_find_all(xml, ".//setCorrectResponse/variable"), "identifier"), c("answer", "answer"))
    schema <- xml2::read_xml(system.file("qti_v2p1p2_extension.xsd", package="rqti"))
    expect_true(xml2::xml_validate(xml2::read_xml(as.character(create_assessment_item(item))), schema))
    expect_equal(item@points, 1)
    path <- tempfile()
    dir.create(path)
    archive <- rmd2zip(file, path)
    expect_true(file.exists(archive))
    expect_true(any(grepl("maxima_rmd_addition.xml", zip::zip_list(archive)$filename, fixed=TRUE)))
})

test_that("failed Rmd checks restore knitting state and cannot leak templates", {
    skip_on_cran()
    skip_if(!nzchar(Sys.which("maxima")), "Maxima not installed")
    engines <- knitr::knit_engines$get()
    hooks <- knitr::knit_hooks$get()
    option_hooks <- knitr::opts_hooks$get()
    chunk_options <- knitr::opts_chunk$get()
    knit_options <- knitr::opts_knit$get()
    broken <- maxima_rmd_file("1+);")
    expect_error(create_question_object(broken), "Illegal use of delimiter")
    expect_identical(knitr::knit_engines$get(), engines)
    expect_identical(knitr::knit_hooks$get(), hooks)
    expect_identical(knitr::opts_hooks$get(), option_hooks)
    expect_identical(knitr::opts_chunk$get(), chunk_options)
    expect_identical(knitr::opts_knit$get(), knit_options)
    good <- maxima_rmd_file("string(['a = 3]);")
    first <- create_question_object(good)
    second <- create_question_object(good)
    expect_length(first@template, 1)
    expect_length(second@template, 1)
    expect_identical(first@template, second@template)
    static <- create_question_object(test_path("file/rmd/Gap_primitive.Rmd"))
    expect_length(static@template, 0)
})

test_that("Rmd fails early for missing references and nonnumeric answers", {
    skip_on_cran()
    skip_if(!nzchar(Sys.which("maxima")), "Maxima not installed")
    missing <- maxima_rmd_file("string(['a = 1]);", question = c(
        "`r template_value('missing')`", "`r gap_numeric(solution_variable='a')`"))
    expect_error(create_question_object(missing), "Undeclared template variables")
    string_answer <- maxima_rmd_file("string(['a = \"text\"]);", variables = "c(a='string')")
    expect_error(create_question_object(string_answer), "integer or float")
})
