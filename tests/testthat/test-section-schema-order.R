test_that("section selection, ordering and controls follow the QTI schema", {
    items <- list(singleChoice(identifier = "a", choices = c("A", "B")),
        singleChoice(identifier = "b", choices = c("A", "B")))
    s <- assessmentSection(items, identifier = "pool", selection = 1L,
        shuffle = TRUE, time_limit = 10, max_attempts = 2)
    folder <- withr::local_tempdir()
    node <- xml2::read_xml(as.character(create_section_test(s, folder, FALSE)))
    expect_identical(xml2::xml_name(xml2::xml_children(node))[1:4],
        c("itemSessionControl", "timeLimits", "selection", "ordering"))
    result <- verify_qti(assessmentTest(list(s), rebuild_variables = NA), print = FALSE)
    expect_true(all(vapply(result, function(x) isTRUE(x$valid), logical(1))))
})
