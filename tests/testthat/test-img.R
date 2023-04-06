test_that("Testing Img class", {
    sut1 <- new("Img", src = "https://example.com/images/example.png",
                alt = "image_1",
                width = 320,
                height = 140
    )
    sut2 <- new("Img", src = "https://example.com/images/example.png" )
    example1 <- new("Img",
                   src = "https://example.com/images/example.png",
                   alt = "image_1",
                   width = 320,
                   height = 140
    )
    example2 <- new("Img",
                   src = "https://example.com/images/example.png"  )

    expect_equal(sut1, example1)
    expect_equal(sut2, example2)
})
test_that("Testing construction function for Img class", {
    sut1 <- Img (src = "https://example.com/images/example.png",
                alt = "image_1",
                width = 320,
                height = 140
                )
    sut2 <- Img (src = "https://example.com/images/example.png")
    example1 <- new("Img",
                   src = "https://example.com/images/example.png",
                   alt = "image_1",
                   width = 320,
                   height = 140
                )
    example2 <- new("Img", src = "https://example.com/images/example.png")

    expect_equal(sut1, example1)
    expect_equal(sut2, example2)
})
test_that("Testing method createText for Img class", {
    sut <- Img (src = "https://example.com/images/example.png",
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
