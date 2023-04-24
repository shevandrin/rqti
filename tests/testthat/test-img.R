test_that("Testing method createText for Img class", {
    sut <- new("Img", src = "https://example.com/images/example.png",
                 alt = "image_1",
                 width = 320,
                 height = 200
    )
    example <-"
<p>
    <img src=\"https://example.com/images/example.png\" alt=\"image_1\"
    width=\"320\" height=\"200\" />
</p>"
    xml1 <- xml2::read_xml(toString(createText(sut)))
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
})
