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
    sut <- xml2::read_xml(toString(createText(sut)))
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)
})

test_that("Testing of method createText() (with out slot alt) for Img class", {
    sut <- new("Img", src = "https://example.com/images/example.png",
               width = 320,
               height = 200
    )
    example <-"
<p>
    <img src=\"https://example.com/images/example.png\" alt=\"picture\"
    width=\"320\" height=\"200\" />
</p>"
    sut <- xml2::read_xml(toString(createText(sut)))
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)
})

skip("This test is skipped")
skip_on_cran()
skip_on_covr()
skip_on_ci()
test_that("Testing Rmd file for SingleChoice that contains image in ItemBody", {

    path <- test_path("file/test_image_SC.Rmd")
    suppressMessages(rmd2xml(path, path = test_path()))

    xml_file_sut <- xml2::read_xml(test_path("test 2.xml"))

    # Read example xml file
    xml_file_expected <- xml2::read_xml(
        test_path("file/test_example_contain_bin_image_SC.xml"))

    # Strip namespaces from the XML files
    xml_file_sut <- xml_ns_strip(xml_file_sut)
    xml_file_expected <- xml_ns_strip(xml_file_expected)

    # Find the 'ItemBody' tags
    item_body_sut <- xml_find_first(xml_file_sut, ".//itemBody")
    item_body_expected <- xml_find_first(xml_file_expected, ".//itemBody")

    # Copy the contents to the 'sut' and 'expected' variables
    sut <- as.character(item_body_sut)
    expected <- as.character(item_body_expected)

    expect_equal(sut, expected)
    unlink(test_path("test 2.xml"))
    unlink(test_path("file/ND.png"))
})

skip("This test is skipped")
skip_on_cran()
skip_on_covr()
skip_on_ci()
test_that("Testing Rmd file for SingleChoice that contain image in Feedback", {
    path <- test_path("file/test_image_SC.Rmd")
    suppressMessages(rmd2xml(path, path = test_path()))

    xml_file_sut <- xml2::read_xml(test_path("test 2.xml"))

    # Read example xml file
    xml_file_expected <- xml2::read_xml(
        test_path("file/test_example_contain_bin_image_SC.xml"))

    # Strip namespaces from the XML files
    xml_file_sut <- xml_ns_strip(xml_file_sut)
    xml_file_expected <- xml_ns_strip(xml_file_expected)

    # Find the 'modalFeedback' tags
    modalFeedback_sut <- xml_find_first(xml_file_sut, ".//modalFeedback ")
    modalFeedback_expected <- xml_find_first(xml_file_expected,
                                             ".//modalFeedback")

    # Copy the contents to the 'sut' and 'expected' variables
    sut <- as.character(modalFeedback_sut)
    expected <- as.character(modalFeedback_expected)

    expect_equal(sut, expected)
    unlink(test_path("test 2.xml"))
    unlink(test_path("file/ND.png"))
})

skip("This test is skipped")
skip_on_cran()
skip_on_covr()
skip_on_ci()
test_that("Testing Rmd file for MultipleChoice that contains two images", {

    path <- test_path("file/rmd/test_image_MC.Rmd")
    q <- create_question_object(path)
    suppressMessages(rmd2xml(path, path = test_path()))

    xml_file_sut <- xml2::read_xml(test_path("test 2.xml"))

    # Read example xml file
    xml_file_expected <- xml2::read_xml(
        test_path("file/test_example_contain_bin_image_MC.xml"))

    # Strip namespaces from the XML files
    xml_file_sut <- xml_ns_strip(xml_file_sut)
    xml_file_expected <- xml_ns_strip(xml_file_expected)

    # Find the 'ItemBody' tags
    item_body_sut <- xml_find_first(xml_file_sut, ".//itemBody")
    item_body_expected <- xml_find_first(xml_file_expected, ".//itemBody")

    # Copy the contents to the 'sut' and 'expected' variables
    sut <- as.character(item_body_sut)
    expected <- as.character(item_body_expected)

    expect_equal(sut, expected)
    unlink(test_path("test 2.xml"))
    unlink(test_path("file/pic_1.png"))
    unlink(test_path("file/pic_2.png"))
})

skip("This test is skipped")
skip_on_cran()
skip_on_covr()
skip_on_ci()
test_that("Testing Rmd file for MultipleChoice that contain image in Feedback",
          {
    path <- test_path("file/rmd/test_image_MC.Rmd")
    suppressMessages(rmd2xml(path, path = test_path()))

    xml_file_sut <- xml2::read_xml(test_path("test 2.xml"))

    # Read example xml file
    xml_file_expected <- xml2::read_xml(
        test_path("file/test_example_contain_bin_image_MC.xml"))

    # Strip namespaces from the XML files
    xml_file_sut <- xml_ns_strip(xml_file_sut)
    xml_file_expected <- xml_ns_strip(xml_file_expected)

    # Find the 'modalFeedback' tags
    modalFeedback_sut <- xml_find_first(xml_file_sut, ".//modalFeedback ")
    modalFeedback_expected <- xml_find_first(xml_file_expected,
                                             ".//modalFeedback")

    # Copy the contents to the 'sut' and 'expected' variables
    sut <- as.character(modalFeedback_sut)
    expected <- as.character(modalFeedback_expected)

    expect_equal(sut, expected)
    unlink(test_path("test 2.xml"))
    unlink(test_path("file/pic_1.png"))
    unlink(test_path("file/pic_2.png"))
})

test_that("Testing Rmd file for MultipleChoice that contain formula by Latex", {
    path <- test_path("file/rmd/test_mc_no_point.Rmd")
    suppressMessages(rmd2xml(path, path = test_path()))

    xml_file_sut <- xml2::read_xml(test_path("test 2.xml"))

    # Read example xml file
    xml_file_expected <- xml2::read_xml(
        test_path("file/test_example_MS_contain_Latex.xml"))

    # Strip namespaces from the XML files
    xml_file_sut <- xml_ns_strip(xml_file_sut)
    xml_file_expected <- xml_ns_strip(xml_file_expected)

    # Find the 'itemBody' tags
    itemBody_sut <- xml_find_first(xml_file_sut, ".//itemBody ")
    itemBody_expected <- xml_find_first(xml_file_expected, ".//itemBody")

    # Copy the contents to the 'sut' and 'expected' variables
    sut <- as.character(itemBody_sut)
    expected <- as.character(itemBody_expected)

    expect_equal(sut, expected)
    unlink(test_path("test 2.xml"))
})

