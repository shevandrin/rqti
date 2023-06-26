test_that("XML validation with schema file for Order", {
    question <- new("Order",
                    content = list("<p>a</p>"),
                    title = "Grand Prix of Bahrain",
                    prompt = "The following F1 drivers finished on the podium in the first ever Grand Prix of Bahrain. Can you rearrange them into the correct finishing order?",
                    choices = c("Michael Schumacher","Jenson Button","Rubens Barrichello"),
                    points = 0.5,
                    choices_identifiers = c("DriverA","DriverB","DriverC"),
                    shuffle = TRUE,
                    points_per_answer = FALSE)
    doc <- xml2::read_xml(toString(create_assessment_item(question)))
    file <- system.file("imsqti_v2p1.xsd", package = "qti")
    schema <- xml2::read_xml(file)
    validation <- xml2::xml_validate(doc, schema)
    expect_equal(validation[1], TRUE)
})
test_that("XML validation with schema file for Entry", {
    sc <- new("Entry", content = list("<p>Identify the missing word in this famous quote from Shakespeare's Richard III.</p>
<blockquote>
<p>
Now is the winter of our discontent
<br/>
Made glorious summer by this sun of",
                                      new("InlineChoice",
                                          response_identifier = "RESPONSE",
                                          answer_index = 3,
                                          score = 2,
                                          shuffle = FALSE,
                                          solution = c("Gloucester", "Lancaster", "York"),
                                          choices_identifiers = c("G","L","Y")),";<br/>
And all the clouds that lour'd upon our house
<br/>
In the deep bosom of the ocean buried.
</p>
</blockquote>"
    ), title = "inline_choice")
    doc <- xml2::read_xml(toString(create_assessment_item(sc)))
    file <- system.file("imsqti_v2p1.xsd", package = "qti")
    schema <- xml2::read_xml(file)
    validation <- xml2::xml_validate(doc, schema)
    expect_equal(validation[1], TRUE)
})

test_that("XML validation with schema file for Entry", {
    sc <- new("Entry", content = list('<p>Identify the missing words in this famous quote from Shakespeare\'s Richard III.</p>
        <p>', 'Now is the of our discontent',
                                      new("TextGap",
                                          solution = c("winter", "WINTER", "Winter"),
                                          response_identifier = "RESPONSE_1",
                                          score = 0.5,
                                          expected_length = 10),
                                      "</p>","<p>",
                                      new("NumericGap",
                                          response_identifier = "RESPONSE_2",
                                          solution = 12,
                                          score = 0.5,
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

                                      "meters under the darkness is found.</p>"),
              title = "fill the gaps")
    doc <- xml2::read_xml(toString(create_assessment_item(sc)))
    file <- system.file("imsqti_v2p1.xsd", package = "qti")
    schema <- xml2::read_xml(file)
    validation <- xml2::xml_validate(doc, schema)
    expect_equal(validation[1], TRUE)
})

test_that("XML validation with schema file for SingleChoice", {
    sc <- new("SingleChoice",
              content = list("<p>Look at the text in the picture.</p><p><img src=\"images/sign.png\" alt=\"NEVER LEAVE LUGGAGE UNATTENDED\"/></p>"),
              choices = c("You must stay with your luggage at all times.", "Do not let someone else look after your luggage.", "Remember your luggage when you leave."),
              title = "filename_sc",
              prompt = "What does it say?",
              shuffle = FALSE)
    doc <- xml2::read_xml(toString(create_assessment_item(sc)))
    file <- system.file("imsqti_v2p1.xsd", package = "qti")
    schema <- xml2::read_xml(file)
    validation <- xml2::xml_validate(doc, schema)
    expect_equal(validation[1], TRUE)
})

test_that("XML validation with schema file for MultipleChoiceTable", {
    sc <- new("MultipleChoiceTable",
              rows = c("Capulet", "Demetrius", "Lysander", "Prospero"),
              rows_identifiers  = c("C", "D", "L", "P"),
              cols = c("A Midsummer-Night's Dream", "Romeo and Juliet", "The Tempest"),
              cols_identifiers = c("M", "R", "T"),
              answers_identifiers = c("C R", "C T", "D M", "L M", "P T", "P R"),
              answers_scores = c(1, 0.5, 0.5, 0.5, 1, 1),
              points = 4,
              title = "MultipleChoiceTable",
              prompt = "Match the following characters to the Shakespeare play they appeared in:"
    )
    doc <- xml2::read_xml(toString(create_assessment_item(sc)))
    file <- system.file("imsqti_v2p1.xsd", package = "qti")
    schema <- xml2::read_xml(file)
    validation <- xml2::xml_validate(doc, schema)
    expect_equal(validation[1], TRUE)
})

test_that("XML validation with schema file for MultipleChoice", {
    sc <- new("MultipleChoice",
              content = list(""),
              choices = c("Hydrogen","Helium","Carbon","Oxygen","Nitrogen","Chlorine"),
              points = c(1,0,0,1,0,-1),
              title = "filename_sc",
              prompt = "Which of the following elements are used to form water?")
    doc <- xml2::read_xml(toString(create_assessment_item(sc)))
    file <- system.file("imsqti_v2p1.xsd", package = "qti")
    schema <- xml2::read_xml(file)
    validation <- xml2::xml_validate(doc, schema)
    expect_equal(validation[1], TRUE)
})

test_that("XML validation with schema file Essay", {
    essay <- new("Essay",
                 content = list("<p>some question text</p>"),
                 title = "extendedText",
                 expected_length = 100,
                 expected_lines = 10,
                 max_strings = 50,
                 min_strings = 1)
    doc <- xml2::read_xml(toString(create_assessment_item(essay)))
    file <- system.file("imsqti_v2p1.xsd", package = "qti")
    schema <- xml2::read_xml(file)
    validation <- xml2::xml_validate(doc, schema)
    expect_equal(validation[1], TRUE)
})

test_that("XML validation with schema file for DirectedPair", {
    sc <- new("DirectedPair",
              rows = c("Lion", "Flower", "Mushrooms"),
              rows_identifiers = c("ID_1", "ID_2", "ID_3"),
              cols = c("Animal", "Plant", "Fungi"),
              cols_identifiers = c("IDT_1", "IDT_2", "IDT_3"),
              answers_identifiers = c("ID_3 IDT_3", "ID_1 IDT_1", "ID_2 IDT_2"),
              points = 5,
              title = "directed_pair",
              prompt = "Associated left elements with the right category"
    )
    doc <- xml2::read_xml(toString(create_assessment_item(sc)))
    file <- system.file("imsqti_v2p1.xsd", package = "qti")
    schema <- xml2::read_xml(file)
    validation <- xml2::xml_validate(doc, schema)
    expect_equal(validation[1], TRUE)
})

test_that("XML validation with schema file for OneInRowTable", {
    sc <- new("OneInRowTable",
              rows = c("Capulet", "Demetrius", "Lysander", "Prospero"),
              rows_identifiers = c("C", "D", "L", "P"),
              cols = c("A Midsummer-Night's Dream", "Romeo and Juliet", "The Tempest"),
              cols_identifiers = c("M", "R", "T"),
              answers_identifiers = c("C R", "D M", "L M", "P T"),
              points = 5,
              title = "one_in_row_table",
              prompt = "Match the following characters to the Shakespeare play they appeared in:"
    )
    doc <- xml2::read_xml(toString(create_assessment_item(sc)))
    file <- system.file("imsqti_v2p1.xsd", package = "qti")
    schema <- xml2::read_xml(file)
    validation <- xml2::xml_validate(doc, schema)
    expect_equal(validation[1], TRUE)
})

test_that("XML validation with schema file for OneInColTable", {
    sc <- new("OneInColTable",
              cols = c("Capulet", "Demetrius", "Prospero"),
              cols_identifiers = c("C", "D", "P"),
              rows = c("A Midsummer-Night's Dream", "Romeo and Juliet", "The Tempest"),
              rows_identifiers = c("M", "R", "T"),
              answers_identifiers = c("C R", "D M", "P T"),
              points = 5,
              title = "one_in_col_table",
              prompt = "Match the following characters to the Shakespeare play they appeared in:"
    )
    doc <- xml2::read_xml(toString(create_assessment_item(sc)))
    file <- system.file("imsqti_v2p1.xsd", package = "qti")
    schema <- xml2::read_xml(file)
    validation <- xml2::xml_validate(doc, schema)
    expect_equal(validation[1], TRUE)
})
