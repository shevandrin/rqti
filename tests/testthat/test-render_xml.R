test_that("Testing Rmd file for SingleChoice that contains image in ItemBody", {
    path <- test_path("file/test_image_SC.Rmd")
    rmd2xml(path)

    xml_file_sut <- xml2::read_xml("test 2.xml")
    render_xml("test 2.xml")

    # Read example xml file
    xml_file_expected <- xml2::read_xml(test_path("file/test_example_contain_bin_image_SC.xml"))

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
    unlink("test 2.xml")
})
test_that("Testing Rmd file for SingleChoice that contain image in Feedback", {
    path <- test_path("file/test_image_SC.Rmd")
    rmd2xml(path)

    xml_file_sut <- xml2::read_xml("test 2.xml")
    render_xml("test 2.xml")

    # Read example xml file
    xml_file_expected <- xml2::read_xml(test_path("file/test_example_contain_bin_image_SC.xml"))

    # Strip namespaces from the XML files
    xml_file_sut <- xml_ns_strip(xml_file_sut)
    xml_file_expected <- xml_ns_strip(xml_file_expected)

    # Find the 'modalFeedback' tags
    modalFeedback_sut <- xml_find_first(xml_file_sut, ".//modalFeedback ")
    modalFeedback_expected <- xml_find_first(xml_file_expected, ".//modalFeedback")

    # Copy the contents to the 'sut' and 'expected' variables
    sut <- as.character(modalFeedback_sut)
    expected <- as.character(modalFeedback_expected)

    expect_equal(sut, expected)
    unlink("test 2.xml")
})
