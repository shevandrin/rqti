# Define the test-only function
equal_xml <- function(sut, expected) {
  parse_sut <- XML::xmlParse(sut, asText = TRUE)
  parse_expected <- XML::xmlParse(expected, asText = TRUE)

  result <- XML::compareXMLDocs(parse_sut, parse_expected)

  v_xml_sut <- unlist(strsplit(as.character(sut), split = ""))
  v_xml_expected <- unlist(strsplit(as.character(expected), split = ""))

  sort_v_xml_sut <- sort(v_xml_sut)
  sort_v_xml_expected <- sort(v_xml_expected)

  if (identical(sort_v_xml_sut, sort_v_xml_expected) &&
        length(result$countDiffs) == 0) {
    return(expect_equal(0, 0))
  } else {
    message("XML structures are differs")
    return(expect_equal(sut, expected))
  }
}
