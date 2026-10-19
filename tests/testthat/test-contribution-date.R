test_that("contributor dates default at construction and allow explicit dates", {
    withr::local_envvar(c(RQTI_AUTHOR = "Ada"))
    expect_equal(qtiContributor()@contribution_date, Sys.Date())
    expect_equal(new("QtiContributor", name = "Ada")@contribution_date, Sys.Date())
    expect_length(qtiContributor("")@contribution_date, 0)
    expect_equal(qtiContributor("Ada", contribution_date = "2025-06-01")@contribution_date,
        as.Date("2025-06-01"))
})

test_that("YAML dates and current-date defaults survive test assembly", {
    withr::local_envvar(c(RQTI_AUTHOR = "Default Author"))
    path <- tempfile(fileext = ".Rmd")
    withr::defer(unlink(path))
    writeLines(c("---", "title: Date example", "type: essay",
        "metadata:", "  contributor:", "    - name: Explicit Author",
        "      contribution_date: '2025-06-01'", "    - name: Default Author",
        "---", "", "# question", "", "Write an answer."), path)
    item <- create_question_object(path)
    dates <- function(x) vapply(x@metadata@contributor,
        function(contributor) as.character(contributor@contribution_date), character(1))
    expect_equal(dates(item), c("2025-06-01", as.character(Sys.Date())))
    assessment <- test(section(item), identifier = "date_test")
    expect_equal(unname(dates(assessment)), dates(item))
    for (contributor in assessment@metadata@contributor) {
        xml <- xml2::read_xml(as.character(createMetadata(contributor)))
        expect_equal(xml2::xml_text(xml2::xml_find_first(xml, ".//dateTime")),
            as.character(contributor@contribution_date))
    }
})
