test_that("Testing create_item_body_text ", {
    entry <- suppressMessages(new("Entry",
    content = list('<p>Identify the missing words in this famous quote from Shakespeare\'s Richard III.</p>
        <p>', 'Now is the of our discontent',
                   new("TextGap",
                       solution = c("winter", "WINTER", "Winter"),
                       response_identifier = "RESPONSE_1",
                       points = 0.5,
                       expected_length = 10),
                   "</p>","<p>",
                   new("NumericGap",
                       response_identifier = "RESPONSE_2",
                       solution = 12,
                       points = 0.5,
                       tolerance = 1,
                       expected_length = 4),
                   "leaves by this sun of York;
  </p>
        <p>And all the clouds that lour'd upon our house</p>
        <p>
  In the deep bosom of the ocean buried.  At",

                   new("NumericGap",
                       response_identifier = "RESPONSE_4",
                       solution = 12.5,
                       tolerance = 1,
                       expected_length = 5,
                       placeholder = "Floating point"),

                   "meters under the darkness is found.</p>")))

    # The XML example was taked from OPAL because qti
    # example doesn't work in OPAL

    example <- '<itemBody>
    <div>
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
  </div>
</itemBody>'

    sut <- xml2::read_xml(as.character(createItemBody(entry)))
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)
})

test_that("Testing create Response Declaration Gap ", {
    entry <- suppressMessages(new("Entry",
    content = list('<p>Identify the missing words in this famous quote from Shakespeare\'s Richard III.</p>
        <p>', 'Now is the of our discontent',
                   new("TextGap",
                       solution = c("winter","WINTER", "Winter"),
                       response_identifier = "RESPONSE_1",
                       points = 0.5,
                       expected_length = 10),
                   "</p>","<p>",
                   new("NumericGap",
                       response_identifier = "RESPONSE_2",
                       solution = 1234567890,
                       tolerance = 1,
                       expected_length = 4),
                   "leaves by this sun of York;
  </p>
        <p>And all the clouds that lour'd upon our house</p>
        <p>
  In the deep bosom of the ocean buried.  At",
                   new("NumericGap",
                       response_identifier = "RESPONSE_4",
                       solution = 12.5,
                       tolerance = 1,
                       points = 0.5,
                       placeholder = "Floating point"),

                   "meters under the darkness is found.</p>")))

# The XML example was taken from OPAL because qti example doesn't work in OPAL
# Response Declaration 1. In the example was not included
# <mapping defaultValue="0">
# in mapEntry is included caseSensitive="true" according to
# qti inf model: caseSensitive [1]: boolean

    example <- '<responseDeclaration identifier="RESPONSE_1" cardinality="single" baseType="string">
<correctResponse>
<value>winter</value>
</correctResponse>
<mapping>
<mapEntry mapKey="winter" mappedValue="0.5" caseSensitive="false"/>
<mapEntry mapKey="WINTER" mappedValue="0.5" caseSensitive="false"/>
<mapEntry mapKey="Winter" mappedValue="0.5" caseSensitive="false"/>
</mapping>
</responseDeclaration>'

    responseDe <- createResponseDeclaration(entry)[[1]]
    sut <- xml2::read_xml(as.character(responseDe))
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)

    # 'Response Declaration 2

    example <- '<responseDeclaration identifier="RESPONSE_2" cardinality="single" baseType="float">
<correctResponse>
<value>1234567890</value>
</correctResponse>
</responseDeclaration>'

    responseDe <- createResponseDeclaration(entry)[[2]]
    sut <- xml2::read_xml(as.character(responseDe))
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)

    # 'Response Declaration 3


    example <- '<responseDeclaration identifier="RESPONSE_4" cardinality="single" baseType="float">
<correctResponse>
<value>12.5</value>
</correctResponse>
</responseDeclaration>'

    responseDe <- createResponseDeclaration(entry)[[3]]
    sut <- xml2::read_xml(as.character(responseDe))
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)
})

test_that("Testing create Outcome Declaration Gap ", {
    entry <- suppressMessages(new("Entry",
    content = list('<p>Identify the missing words in this famous quote from Shakespeare\'s Richard III.</p>
        <p>', 'Now is the of our discontent',
                   new("TextGap",
                       solution = c("winter", "WINTER", "Winter"),
                       response_identifier = "RESPONSE_1",
                       points = 0.5,
                       expected_length = 10),
                   "</p>","<p>",
                   new("NumericGap",
                       response_identifier = "RESPONSE_2",
                       solution = 12,
                       tolerance = 1,
                       expected_length = 4),
                   "leaves by this sun of York;
  </p>
        <p>And all the clouds that lour'd upon our house</p>
        <p>
  In the deep bosom of the ocean buried.  At",
                   new("NumericGap",
                       response_identifier = "RESPONSE_4",
                       solution = 12.5,
                       tolerance = 1,
                       expected_length = 5,
                       points = 0.5,
                       placeholder = "Floating point"),

                   "meters under the darkness is found.</p>")))
# The XML example was taken from OPAL because qti example doesn't work in OPAL

# Outcome Declaration 1.Omitted the tag view="testConstructor" from OPAL
# example. There is not outcome Delete it from the example

    example <- '<additionalTag>
  <outcomeDeclaration identifier="SCORE" cardinality="single" baseType="float">
    <defaultValue>
      <value>0</value>
    </defaultValue>
  </outcomeDeclaration>
  <outcomeDeclaration identifier="MAXSCORE" cardinality="single" baseType="float">
    <defaultValue>
      <value>2</value>
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

    responseDe <- as.character(htmltools::tag(
        "additionalTag", list(createOutcomeDeclaration(entry))))
    sut <- xml2::read_xml(responseDe)
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)

})

test_that("Testing create_item_body_text ", {
    entry <- suppressMessages(new("Entry",
            content = list('The speed of light is', new("TextGapOpal",
                                    response_identifier = "RESPONSE_1",
                                    points = 1,
                                    solution = c("more", "MORE", "More"),
                                    tolerance = 4),
                                   'than the speed of sound')))
    expected <- '<additionalTag>
    <responseProcessing>
    <responseCondition>
      <responseIf>
        <not>
          <isNull>
            <variable identifier="RESPONSE_1"/>
          </isNull>
        </not>
        <setOutcomeValue identifier="SCORE_RESPONSE_1">
          <mapTolResponse xmlns="http://bps-system.de/xsd/imsqti_ext_maptolresponse" identifier="RESPONSE_1" tolerance="4" toleranceMode="absolute"/>
        </setOutcomeValue>
      </responseIf>
    </responseCondition>
            <setOutcomeValue identifier="SCORE">
        <sum>
            <variable identifier="SCORE_RESPONSE_1"/>
        </sum>
    </setOutcomeValue>
    </responseProcessing>
    </additionalTag>'
    response <- as.character(htmltools::tag(
        "additionalTag", list(createResponseProcessing(entry))))
    sut <- xml2::read_xml(response)
    expected <- xml2::read_xml(expected)
    expect_equal(sut, expected)
})

test_that("Testing function of create_outcome_declaration_entry
          for Entry class", {
    sut <- suppressMessages(new("Entry", identifier = "new",
                  points = 3,
                  title = "NumericGap",
                  content = list('The speed of light is equal',
                                 new("NumericGap",
                                     response_identifier = "RESPONSE_1",
                                     points = 3,
                                     solution = 300,
                                     tolerance = 2,
                                     include_lower_bound = TRUE,
                                     include_upper_bound = TRUE),'m/s'),
                feedback = list(new("ModalFeedback", title = "common",
                                        content = list("general feedback"))))                                )

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
    <value>3</value>
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
<outcomeDeclaration identifier="FEEDBACKMODAL" cardinality="multiple" baseType="identifier"/>
</additionalTag>'

    sut1 <- toString(htmltools::tag(
        "additionalTag", list(create_outcome_declaration_entry(sut))))

    sut <- xml2::read_xml(sut1)
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)
})

test_that("Testing of the warning message in case response_identifier
          in NumericGap class is empty", {
    sut <- evaluate_promise(
        new("Entry", identifier = "new",
            points = 3,
            title = "NumericGap",
            content = list('The speed of light is equal',
                           new("NumericGap",
                               # "response_identifier" is empty
                               points = 3,
                               solution = 300,
                               tolerance = 2,
                               include_lower_bound = TRUE,
                               include_upper_bound = TRUE),
                           'm/s')
            )
        )

    response_identifier <- sut$result@content[[2]]@response_identifier
    sut_warning <- paste0("There is no response_identifier ",
                          "in Gap-object. A random  value is assigned: ",
                          response_identifier, "\n")
    warning_message <- sut$messages
    expect_equal(sut_warning, warning_message)
})

test_that("Testing warning message in the case Identifiers of objects
          in content-slot are non-unique for Entry class", {
    warning_message <- NULL
    suppressWarnings(withCallingHandlers(
        {
            sut <-suppressMessages(new("Entry", identifier = "new",
                       points = 3,
                       title = "test",
                       content = list(
                           'The speed of light is equal',
                           new("NumericGap",
                               response_identifier ="RESPONSE_1",
                               points = 3,
                               solution = 300,
                               tolerance = 2),
                           'm/s','The speed of sound is equal',
                           new("NumericGap",
                                response_identifier ="RESPONSE_1",
                                points = 3,
                                solution = 343,
                                tolerance = 2),
                            'm/s', 'The speed of light is',
                           new("TextGapOpal",
                               response_identifier = "RESPONSE_1",
                               points = 1,
                               solution = c("more", "MORE", "More"),
                               tolerance = 4),
                           'than the speed of sound')))
        entry <- initialize(sut)
    sut_warning <- (
        "Identifiers of objects in content-slot are non-unique : RESPONSE_1, RESPONSE_1, RESPONSE_1")
    },
    warning = function(w) {
        warning_message <<- w$message
    }
    ))
    expect_equal(warning_message, sut_warning)
})

test_that("Testing the constructor for Entry class", {
    sut <- entry(content = list(textGap("answer"),
                                textGapOpal("answer"),
                                numericGap(5.1),
                                inlineChoice(c("answer1", "answer2", "answer3"))))

    xml_sut <- create_assessment_item(sut)

    expect_no_error(xml2::read_xml(as.character(xml_sut)))
    expect_s4_class(sut, "Entry")
})
