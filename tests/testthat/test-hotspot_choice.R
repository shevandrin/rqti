hotspot_image <- function() {
    img <- tempfile(fileext = ".png")
    grDevices::png(img, width = 300, height = 200)
    graphics::par(mar = c(0, 0, 0, 0))
    graphics::plot.new()
    graphics::rect(0.05, 0.1, 0.45, 0.9)
    grDevices::dev.off()
    img
}

test_that("hotspotChoice writes a hotspot interaction with an embedded image", {
    img <- hotspot_image()
    item <- hotspotChoice(identifier = "hotspot_test", image = img,
                          image_width = 300, image_height = 200,
                          shapes = c("rect", "circle", "poly"),
                          coords = c("15,20,135,180", "225, 100, 60",
                                     "0,0,10,0,10,10"),
                          points = c(1, 0, 1),
                          content = "<p>Select the correct areas.</p>")
    body <- xml2::read_xml(toString(createItemBody(item)))
    interaction <- xml2::xml_find_first(body, "//hotspotInteraction")
    expect_identical(xml2::xml_attr(interaction, "maxChoices"), "0")
    object <- xml2::xml_find_first(interaction, "object")
    expect_identical(xml2::xml_attr(object, "type"), "image/png")
    expect_match(xml2::xml_attr(object, "data"), "^data:image/png;base64,")
    expect_identical(xml2::xml_attr(object, "width"), "300")
    choices <- xml2::xml_find_all(interaction, "hotspotChoice")
    expect_identical(xml2::xml_attr(choices, "shape"),
                     c("rect", "circle", "poly"))
    expect_identical(xml2::xml_attr(choices, "coords")[2], "225,100,60")
    declaration <- xml2::read_xml(toString(createResponseDeclaration(item)))
    expect_identical(xml2::xml_attr(declaration, "cardinality"), "multiple")
    expect_identical(xml2::xml_text(xml2::xml_find_all(declaration,
                                                       ".//value")),
                     c("Hotspot1", "Hotspot3"))
    expect_equal(getPoints(item), 2)
    expect_true(isTRUE(verify_qti(item, color = FALSE, print = FALSE)$valid))
})

test_that("hotspotChoice checks shapes, coordinates and the image", {
    img <- hotspot_image()
    expect_error(hotspotChoice(image = img, image_width = 300,
                               image_height = 200, shapes = "triangle",
                               coords = "1,2,3", points = 1), "shapes")
    expect_error(hotspotChoice(image = img, image_width = 300,
                               image_height = 200, shapes = "circle",
                               coords = "1,2", points = 1), "coords")
    expect_error(hotspotChoice(image = "missing.png", image_width = 300,
                               image_height = 200, shapes = "circle",
                               coords = "1,2,3", points = 1), "does not exist")
    single <- hotspotChoice(image = img, image_width = 300, image_height = 200,
                            shapes = c("circle", "circle"),
                            coords = c("50,50,20", "150,50,20"),
                            points = c(1, 0), max_choices = 1)
    body <- xml2::read_xml(toString(createItemBody(single)))
    expect_identical(xml2::xml_attr(xml2::xml_find_first(
        body, "//hotspotInteraction"), "maxChoices"), "1")
})
