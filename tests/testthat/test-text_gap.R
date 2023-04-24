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
  <outcomeDeclaration identifier="SCORE" cardinality="single" baseType="float">
    <defaultValue>
      <value>0</value>
    </defaultValue>
  </outcomeDeclaration>
  <outcomeDeclaration identifier="MAXSCORE" cardinality="single" baseType="float">
    <defaultValue>
      <value>1</value>
    </defaultValue>
  </outcomeDeclaration>
  <outcomeDeclaration identifier="MINSCORE" cardinality="single" baseType="float">
    <defaultValue>
      <value>0</value>
    </defaultValue>
  </outcomeDeclaration>
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

test_that("Testing create_item_body_text ", {
    sc <- new("Entry", content = list('The speed of light is', new("TextGapOpal",
                                                                   response_identifier = "RESPONSE_1",
                                                                   score = 1,
                                                                   response = "more",
                                                                   alternatives = c("MORE", "More"),
                                                                   value_precision = 4),
                                      'than the speed of sound'))
    expected <- '<additionalTag>
    <responseProcessing>
        <setOutcomeValue identifier="SCORE">
        <sum>
            <variable identifier="SCORE_RESPONSE_1"/>
        </sum>
    </setOutcomeValue>
		<responseCondition>
	<responseIf>
		<equal toleranceMode="absolute" tolerance="4">
			<variable identifier="RESPONSE_1"/>
			<correct identifier="RESPONSE_1"/>
			</equal>
	<setOutcomeValue identifier="SCORE_RESPONSE_1">
		<variable identifier="MAXSCORE_RESPONSE_1"/>
		</setOutcomeValue>
	</responseIf>
        </responseCondition>
    </responseProcessing>
    </additionalTag>'
    response <- as.character(htmltools::tag("additionalTag", list(createResponseProcessing(sc))))
    xml1 <- xml2::read_xml(response)
    xml2 <- xml2::read_xml(expected)
    expect_equal(xml1, xml2)
})
test_that("Testing function of create_outcome_declaration_entry for Entry class", {
    sut <- new("Entry", identifier = "new",
                  points = 3,
                  title = "NumericGap",
                  content = list('The speed of light is equal',
                                 new("NumericGap",
                                     response_identifier = "RESPONSE_1",
                                     score = NA_integer_,
                                     response = 300,
                                     value_precision = 2,
                                     include_lower_bound = TRUE,
                                     include_upper_bound = TRUE),'m/s'),
                feedback = list(new("ModalFeedback", title = "common",
                                        content = list("general feedback")))                                )

    example <- '<additionalTag>
    <outcomeDeclaration identifier="SCORE" cardinality="single" baseType="float">
  <defaultValue>
    <value>0</value>
  </defaultValue>
</outcomeDeclaration>
<outcomeDeclaration identifier="MAXSCORE" cardinality="single" baseType="float">
  <defaultValue>
    <value>3</value>
  </defaultValue>
</outcomeDeclaration>
<outcomeDeclaration identifier="MINSCORE" cardinality="single" baseType="float">
  <defaultValue>
    <value>0</value>
  </defaultValue>
</outcomeDeclaration>
<outcomeDeclaration identifier="SCORE_RESPONSE_1" cardinality="single" baseType="float">
  <defaultValue>
    <value>0</value>
  </defaultValue>
</outcomeDeclaration>
<outcomeDeclaration identifier="MAXSCORE_RESPONSE_1" cardinality="single" baseType="float">
  <defaultValue>
    <value>NA</value>
  </defaultValue>
</outcomeDeclaration>
<outcomeDeclaration identifier="MINSCORE_RESPONSE_1" cardinality="single" baseType="float">
  <defaultValue>
    <value>0</value>
  </defaultValue>
</outcomeDeclaration>
<outcomeDeclaration identifier="FEEDBACKBASIC" cardinality="single" baseType="identifier">
  <defaultValue>
    <value>empty</value>
  </defaultValue>
</outcomeDeclaration>
<outcomeDeclaration identifier="FEEDBACKMODAL" cardinality="multiple" baseType="identifier">
  <defaultValue>
    <value></value>
  </defaultValue>
</outcomeDeclaration>
</additionalTag>'

    expected <- toString(htmltools::tag(
        "additionalTag", list(create_outcome_declaration_entry(sut))))

    xml1 <- xml2::read_xml(expected)
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
})
