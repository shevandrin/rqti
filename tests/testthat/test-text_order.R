test_that("Testing createItemBody for Order questions", {
    question <- new("Order",
                 content = list(""),
                 title = "Grand Prix of Bahrain",
                 prompt = "The following F1 drivers finished on the podium in the first ever Grand Prix of Bahrain. Can you rearrange them into the correct finishing order?",
                 choices = c("Rubens Barrichello", "Jenson Button", "Michael Schumacher"),
                 points = 0.5,
                 choices_identifiers = c("DriverA","DriverB","DriverC"),
                 shuffle = TRUE)
    example <- '<itemBody>
<orderInteraction responseIdentifier="RESPONSE" shuffle="true">
<prompt>The following F1 drivers finished on the podium in the first ever Grand Prix of Bahrain. Can you rearrange them into the correct finishing order?</prompt>
<simpleChoice identifier="DriverA">Rubens Barrichello</simpleChoice>
<simpleChoice identifier="DriverB">Jenson Button</simpleChoice>
<simpleChoice identifier="DriverC">Michael Schumacher</simpleChoice>
</orderInteraction>
</itemBody>'

    xml1 <- xml2::read_xml(toString(createItemBody(question)))
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
})

test_that("Testing ResponseDeclaration for Order questions", {
    question <- new("Order",
                 content = list(""),
                 title = "Grand Prix of Bahrain",
                 prompt = "The following F1 drivers finished on the podium in the first ever Grand Prix of Bahrain. Can you rearrange them into the correct finishing order?",
                 choices = c("Michael Schumacher","Jenson Button","Rubens Barrichello"),
                 points = 0.5,
                 choices_identifiers = c("DriverA","DriverB","DriverC"),
                 shuffle = TRUE)
    example <- '<responseDeclaration identifier="RESPONSE" cardinality="ordered" baseType="identifier">
<correctResponse>
<value>DriverA</value>
<value>DriverB</value>
<value>DriverC</value>
</correctResponse>
</responseDeclaration>'

    xml1 <- xml2::read_xml(toString(createResponseDeclaration(question)))
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
})

test_that("Testing OutcomeDeclaration for Order questions", {
    question <- new("Order",
                    content = list(""),
                    title = "Grand Prix of Bahrain",
                    prompt = "The following F1 drivers finished on the podium in the first ever Grand Prix of Bahrain. Can you rearrange them into the correct finishing order?",
                    choices = c("Michael Schumacher","Jenson Button","Rubens Barrichello"),
                    points = 2.5,
                    choices_identifiers = c("DriverA","DriverB","DriverC"),
                    shuffle = TRUE)

    #' The example was taken from OPAL, the original qti example does not have score.

    example <- '<additionalTag>
<outcomeDeclaration identifier="SCORE" cardinality="single" baseType="float">
<defaultValue>
<value>0</value>
</defaultValue>
</outcomeDeclaration>
<outcomeDeclaration identifier="MAXSCORE" cardinality="single" baseType="float">
<defaultValue>
<value>2.5</value>
</defaultValue>
</outcomeDeclaration>
<outcomeDeclaration identifier="MINSCORE" cardinality="single" baseType="float">
<defaultValue>
<value>0</value>
</defaultValue>
</outcomeDeclaration>
    </additionalTag>'

    responseDe <- paste('<additionalTag>', toString(createOutcomeDeclaration(question)),'</additionalTag>')
    xml1 <- xml2::read_xml(responseDe)
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
})

test_that("XML validation with schema file", {
    question <- new("Order",
                    content = list("<p>a</p>"),
                    title = "Grand Prix of Bahrain",
                    prompt = "The following F1 drivers finished on the podium in the first ever Grand Prix of Bahrain. Can you rearrange them into the correct finishing order?",
                    choices = c("Michael Schumacher","Jenson Button","Rubens Barrichello"),
                    points = 0.5,
                    choices_identifiers = c("DriverA","DriverB","DriverC"),
                    shuffle = TRUE)
    doc <- xml2::read_xml(toString(create_assessment_item(question)))
    file <- file.path(getwd(), "imsqti_v2p1.xsd")
    schema <- xml2::read_xml(file)
    validation <- xml2::xml_validate(doc, schema)
    expect_equal(validation[1], TRUE)
})
