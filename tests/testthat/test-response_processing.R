test_that("german_grading() returns the expected grading scale", {
    expected <- c(
        "1.0" = 0.95, "1.3" = 0.9,  "1.7" = 0.85,
        "2.0" = 0.8,  "2.3" = 0.75, "2.7" = 0.7,
        "3.0" = 0.65, "3.3" = 0.6,  "3.7" = 0.55,
        "4.0" = 0.5,  "5.0" = 0
    )

    expect_equal(german_grading(), expected)
})

test_that("create_tag() and create_vartag() build htmltools tags", {
    custom_tag <- create_tag("custom")
    sut <- custom_tag(list(identifier = "id1"))

    expect_s3_class(sut, "shiny.tag")
    expect_equal(as.character(sut), "<custom identifier=\"id1\"></custom>")

    variable_tag <- create_vartag("variable")
    sut_variable <- variable_tag("SCORE")

    expect_s3_class(sut_variable, "shiny.tag")
    expect_equal(as.character(sut_variable), "<variable identifier=\"SCORE\"></variable>")
})

test_that("create_tag() wraps shiny.tag attributes as children", {
    custom_tag <- create_tag("custom")
    child <- htmltools::tag("child", list("value"))
    sut <- custom_tag(child)

    expect_equal(as.character(sut), "<custom>\n  <child>value</child>\n</custom>")
})
