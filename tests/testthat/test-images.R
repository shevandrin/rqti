test_that("Markdown image is embedded as Base64", {
    object <- create_question_object(
        test_path("file", "rmd", "resolution_image.Rmd")
    )

    item_body <- createItemBody(object)
    item_body <- xml2::read_xml(as.character(item_body))

    img <- xml2::xml_find_first(item_body, ".//img")

    expect_false(inherits(img, "xml_missing"))

    src <- xml2::xml_attr(img, "src")

    expect_true(startsWith(src, "data:image/jpeg;base64,"))
    expect_false(grepl("test_fig1\\.jpg", src))
})
