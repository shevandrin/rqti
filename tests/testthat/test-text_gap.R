test_that("Testing create_item_body_text ", {
    sc <- new("Entry", content = list('<p>Identify the missing words in this famous quote from Shakespeare\'s Richard III.</p>
        <p>', 'Now is the of our discontent',
                                                         new("TextGap",
                                                             response = "winter",
                                                             alternatives = c("WINTER", "Winter"),
                                                             response_identifier = "RESPONSE_1",
                                                             score = 0.5,
                                                             expected_length = 10),
                                                         "</p>","<p>",
                                                         new("NumericGap",
                                                             response_identifier = "RESPONSE_2",
                                                             response = 12,
                                                             score = 0.5,
                                                             value_precision = 1,
                                                             expected_length = 4),
                                                         "leaves by this sun of York;
  </p>
        <p>And all the clouds that lour'd upon our house</p>
        <p>
  In the deep bosom of the ocean buried.  At",
                                                         new("NumericGap",
                                                             response_identifier = "RESPONSE_4",
                                                             response = 12.5,
                                                             value_precision = 1,
                                                             expected_length = 5,
                                                             placeholder = "Floating point"),

                                                         "meters under the darkness is found.</p>"))
    # ' The XML example was taked from OPAL because qti example doesn't work in OPAL
    example <- '<itemBody>
        <p>Identify the missing words in this famous quote from Shakespeare\'s Richard III.</p>
        <p>
  Now is the of our discontent
  <textEntryInteraction responseIdentifier="RESPONSE_1" expectedLength="10"/>
  </p>
  <p>
  <textEntryInteraction responseIdentifier="RESPONSE_2" expectedLength="4"/>
  leaves by this sun of York;
  </p>
  <p>And all the clouds that lour\'d upon our house</p>
  <p>
  In the deep bosom of the ocean buried.  At
  <textEntryInteraction responseIdentifier="RESPONSE_4" expectedLength="5" placeholderText="Floating point"/>
  meters under the darkness is found.</p>
</itemBody>'

    xml1 <- xml2::read_xml(as.character(createItemBody(sc)))
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
})

test_that("Testing create Response Declaration Gap ", {
    sc <- new("Entry", content = list('<p>Identify the missing words in this famous quote from Shakespeare\'s Richard III.</p>
        <p>', 'Now is the of our discontent',
                                                         new("TextGap",
                                                             response = "winter",
                                                             alternatives = c("WINTER", "Winter"),
                                                             response_identifier = "RESPONSE_1",
                                                             score = 0.5,
                                                             expected_length = 10),
                                                         "</p>","<p>",
                                                         new("NumericGap",
                                                             response_identifier = "RESPONSE_2",
                                                             response = 12,
                                                             value_precision = 1,
                                                             expected_length = 4),
                                                         "leaves by this sun of York;
  </p>
        <p>And all the clouds that lour'd upon our house</p>
        <p>
  In the deep bosom of the ocean buried.  At",
                                                         new("NumericGap",
                                                             response_identifier = "RESPONSE_4",
                                                             response = 12.5,
                                                             value_precision = 1,
                                                             expected_length = 5,
                                                             score = 0.5,
                                                             placeholder = "Floating point"),

                                                         "meters under the darkness is found.</p>"))
    # ' The XML example was taken from OPAL because qti example doesn't work in OPAL

    # 'Response Declaration 1. In the example was not included <mapping defaultValue="0">
    # in mapEntry is included caseSensitive="true" according to qti inf model: caseSensitive [1]: boolean

    example <- '<responseDeclaration identifier="RESPONSE_1" cardinality="single" baseType="string">
<correctResponse>
<value>winter</value>
</correctResponse>
<mapping>
<mapEntry mapKey="winter" mappedValue="0.5" caseSensitive="true"/>
<mapEntry mapKey="WINTER" mappedValue="0.5" caseSensitive="true"/>
<mapEntry mapKey="Winter" mappedValue="0.5" caseSensitive="true"/>
</mapping>
</responseDeclaration>'

    responseDe <- createResponseDeclaration(sc)[[1]]
    xml1 <- xml2::read_xml(as.character(responseDe))
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)

    # 'Response Declaration 2

    example <- '<responseDeclaration identifier="RESPONSE_2" cardinality="single" baseType="float">
<correctResponse>
<value>12</value>
</correctResponse>
</responseDeclaration>'

    responseDe <- createResponseDeclaration(sc)[[2]]
    xml1 <- xml2::read_xml(as.character(responseDe))
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)

    # 'Response Declaration 3


    example <- '<responseDeclaration identifier="RESPONSE_4" cardinality="single" baseType="float">
<correctResponse>
<value>12.5</value>
</correctResponse>
</responseDeclaration>'

    responseDe <- createResponseDeclaration(sc)[[3]]
    xml1 <- xml2::read_xml(as.character(responseDe))
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
})

test_that("Testing create Outcome Declaration Gap ", {
    sc <- new("Entry", content = list('<p>Identify the missing words in this famous quote from Shakespeare\'s Richard III.</p>
        <p>', 'Now is the of our discontent',
                                                         new("TextGap",
                                                             response = "winter",
                                                             alternatives = c("WINTER", "Winter"),
                                                             response_identifier = "RESPONSE_1",
                                                             score = 0.5,
                                                             expected_length = 10),
                                                         "</p>","<p>",
                                                         new("NumericGap",
                                                             response_identifier = "RESPONSE_2",
                                                             response = 12,
                                                             value_precision = 1,
                                                             expected_length = 4),
                                                         "leaves by this sun of York;
  </p>
        <p>And all the clouds that lour'd upon our house</p>
        <p>
  In the deep bosom of the ocean buried.  At",
                                                         new("NumericGap",
                                                             response_identifier = "RESPONSE_4",
                                                             response = 12.5,
                                                             value_precision = 1,
                                                             expected_length = 5,
                                                             score = 0.5,
                                                             placeholder = "Floating point"),

                                                         "meters under the darkness is found.</p>"))
    # ' The XML example was taken from OPAL because qti example doesn't work in OPAL

    # 'Outcome Declaration 1.Omitted the tag view="testConstructor" from OPAL example. There is not outcome Delete it from the example

    example <- '<additionalTag>
    <outcomeDeclaration identifier="SCORE_RESPONSE_1" cardinality="single" baseType="float">\n
<defaultValue>
<value>0</value>
</defaultValue>
</outcomeDeclaration>
<outcomeDeclaration identifier="MAXSCORE_RESPONSE_1" cardinality="single" baseType="float">
<defaultValue>
<value>0.5</value>
</defaultValue>
</outcomeDeclaration>
<outcomeDeclaration identifier="MINSCORE_RESPONSE_1" cardinality="single" baseType="float">
<defaultValue>
<value>0</value>
</defaultValue>
</outcomeDeclaration>
<outcomeDeclaration identifier="SCORE_RESPONSE_2" cardinality="single" baseType="float">\n
<defaultValue>
<value>0</value>
</defaultValue>
</outcomeDeclaration>
<outcomeDeclaration identifier="MAXSCORE_RESPONSE_2" cardinality="single" baseType="float">
<defaultValue>
<value>1</value>
</defaultValue>
</outcomeDeclaration>
<outcomeDeclaration identifier="MINSCORE_RESPONSE_2" cardinality="single" baseType="float">
<defaultValue>
<value>0</value>
</defaultValue>
</outcomeDeclaration>
<outcomeDeclaration identifier="SCORE_RESPONSE_4" cardinality="single" baseType="float">
<defaultValue>
<value>0</value>
</defaultValue>
</outcomeDeclaration>
<outcomeDeclaration identifier="MAXSCORE_RESPONSE_4" cardinality="single" baseType="float">
<defaultValue>
<value>0.5</value>
</defaultValue>
</outcomeDeclaration>
<outcomeDeclaration identifier="MINSCORE_RESPONSE_4" cardinality="single" baseType="float">
<defaultValue>
<value>0</value>
</defaultValue>
</outcomeDeclaration>
    </additionalTag>'

    responseDe <- as.character(htmltools::tag("additionalTag", list(createOutcomeDeclaration(sc))))
    xml1 <- xml2::read_xml(responseDe)
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)

})
