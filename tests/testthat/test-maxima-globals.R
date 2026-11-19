test_that("Maxima globals warnings identify variables and preserve typed outputs", {
    skip_on_cran()
    skip_if(!nzchar(Sys.which("maxima")), "Maxima not installed")
    diagnostic <- NULL
    result <- withCallingHandlers(maxima_check(
        "leaked:3; string(['answer=leaked]);", libraries = character(),
        outputs = TRUE, file = "exercise.Rmd", chunk = "calculation"),
        rqti_maxima_globals_warning = function(w) {
            diagnostic <<- w
            invokeRestart("muffleWarning")
        })
    expect_identical(result, c(answer = "integer"))
    expect_s3_class(diagnostic, "rqti_maxima_globals_warning")
    expect_identical(diagnostic$variables, "[leaked]")
    expect_identical(diagnostic$functions, "[]")
    expect_match(conditionMessage(diagnostic), "exercise.Rmd: Maxima chunk 'calculation'", fixed = TRUE)
    expect_match(conditionMessage(diagnostic), "block([a, b, ...]", fixed = TRUE)
    expect_match(conditionMessage(diagnostic), "restart", fixed = TRUE)
})

test_that("global functions are detected independently of the number of variables", {
    skip_on_cran()
    skip_if(!nzchar(Sys.which("maxima")), "Maxima not installed")
    expect_warning(result <- maxima_check(
        "helper(x):=x+1; string(['answer=helper(2)]);",
        libraries = character(), outputs = TRUE),
        "Global functions:.*helper", class = "rqti_maxima_globals_warning")
    expect_identical(result, c(answer = "integer"))
    expect_warning(result <- maxima_check(
        "a:1; first_fn(x):=x+1; second_fn(x):=2*x; string(['answer=second_fn(first_fn(a))]);",
        libraries = character(), outputs = TRUE),
        "Global functions:.*first_fn.*second_fn", class = "rqti_maxima_globals_warning")
    expect_identical(result, c(answer = "integer"))
    expect_warning(maxima_check("helper(x):=x+1;", libraries = character()),
        "Global functions:.*helper", class = "rqti_maxima_globals_warning")
})

test_that("local bindings and functions do not produce global warnings", {
    skip_on_cran()
    skip_if(!nzchar(Sys.which("maxima")), "Maxima not installed")
    code <- paste0("block([a,answer],local(helper),helper(x):=2*x,",
        "a:3,answer:helper(a),string(['answer=answer]));")
    expect_no_warning(result <- maxima_check(code, libraries = character(), outputs = TRUE))
    expect_identical(result, c(answer = "integer"))
    expect_no_warning(maxima_check("1+2;", libraries = character()))
    expect_no_warning(maxima_check("temporary:3; kill(temporary);", libraries = character()))
    expect_no_warning(maxima_check("string(['answer=7]);", outputs = TRUE))
})

test_that("library globals form the baseline and replacing them does not hide new globals", {
    skip_on_cran()
    skip_if(!nzchar(Sys.which("maxima")), "Maxima not installed")
    library <- tempfile(fileext = ".mac")
    withr::defer(unlink(library))
    writeLines(c("library_value:1$", "library_fn(x):=x+1$"), library)
    expect_no_warning(maxima_check("string(['answer=library_fn(library_value)]);",
        libraries = library, outputs = TRUE))
    diagnostic <- NULL
    withCallingHandlers(maxima_check(paste0(
        "kill(library_value,library_fn); replacement:2; replacement_fn(x):=2*x;",
        "string(['answer=replacement_fn(replacement)]);"),
        libraries = library, outputs = TRUE),
        rqti_maxima_globals_warning = function(w) {
            diagnostic <<- w
            invokeRestart("muffleWarning")
        })
    expect_s3_class(diagnostic, "rqti_maxima_globals_warning")
    expect_identical(diagnostic$variables, "[replacement]")
    expect_identical(diagnostic$functions, "[replacement_fn(x)]")
})

test_that("Rmd authoring warns about globals without rewriting the exported program", {
    skip_on_cran()
    skip_if(!nzchar(Sys.which("maxima")), "Maxima not installed")
    file <- tempfile(fileext = ".Rmd")
    withr::defer(unlink(file))
    code <- "leaked:3; string(['answer=leaked]);"
    writeLines(c("---", "type: gap", "title: Example", "---", "",
        "```{r setup, include=FALSE}", "library(rqti)", "```", "",
        "```{maxima calculation}", code, "```", "", "# question", "",
        "`r gap_numeric(solution_variable='answer')`"), file)
    expect_warning(item <- create_question_object(file),
        "Maxima chunk 'calculation'.*left global definitions",
        class = "rqti_maxima_globals_warning")
    expect_identical(item@template[[1L]]@code, code)
    expect_identical(item@template[[1L]]@variables, c(answer = "integer"))
})
