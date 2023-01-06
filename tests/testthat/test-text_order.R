test_that("Testing createItemBody for Order questions", {
    question <- new("Order",
                 text = new("Text", content = list("")),
                 title = "Grand Prix of Bahrain",
                 prompt = "The following F1 drivers finished on the podium in the first ever Grand Prix of Bahrain. Can you rearrange them into the correct finishing order?",
                 choices = c("Michael Schumacher","Jenson Button","Rubens Barrichello"),
                 points = c(0.5,0.5,0.5),
                 choices_identifiers = c("DriverA","DriverB","DriverC"),
                 shuffle = TRUE)
    example <- '<itemBody>
<orderInteraction responseIdentifier="RESPONSE" shuffle="true">
<prompt>The following F1 drivers finished on the podium in the first ever Grand Prix of Bahrain. Can you rearrange them into the correct finishing order?</prompt>
<simpleChoice identifier="DriverA">Rubens Barrichello</simpleChoice>
<simpleChoice identifier="DriverB">Jenson Button</simpleChoice>
<simpleChoice identifier="DriverC" fixed="true">Michael Schumacher</simpleChoice>
</orderInteraction>
</itemBody>'

    print("Pendent to check how define the order")
    xml1 <- xml2::read_xml(toString(createItemBody(question)))
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
})

test_that("Testing ResponseDeclaration for Order questions", {
    question <- new("Order",
                 text = new("Text", content = list("")),
                 title = "Grand Prix of Bahrain",
                 prompt = "The following F1 drivers finished on the podium in the first ever Grand Prix of Bahrain. Can you rearrange them into the correct finishing order?",
                 choices = c("Michael Schumacher","Jenson Button","Rubens Barrichello"),
                 points = c(0.5,0.5,0.5),
                 choices_identifiers = c("DriverA","DriverB","DriverC"),
                 shuffle = TRUE)
    example <- '<responseDeclaration identifier="RESPONSE" cardinality="ordered" baseType="identifier">
<correctResponse>
<value>DriverC</value>
<value>DriverA</value>
<value>DriverB</value>
</correctResponse>
</responseDeclaration>'

    xml1 <- xml2::read_xml(toString(createResponseDeclaration(question)))
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
})

test_that("Testing OutcomeDeclaration for Order questions", {
    question <- new("Order",
                    text = new("Text", content = list("")),
                    title = "Grand Prix of Bahrain",
                    prompt = "The following F1 drivers finished on the podium in the first ever Grand Prix of Bahrain. Can you rearrange them into the correct finishing order?",
                    choices = c("Michael Schumacher","Jenson Button","Rubens Barrichello"),
                    points = c(0.5,0.5,0.5),
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
<value>1.5</value>
</defaultValue>
</outcomeDeclaration>
    </additionalTag>'

    print(createOutcomeDeclaration(question))
    responseDe <- paste('<additionalTag>', toString(createOutcomeDeclaration(question)),'</additionalTag>')
    xml1 <- xml2::read_xml(responseDe)
    xml2 <- xml2::read_xml(example)
    print("tag <MINSCORE> is not included")
    expect_equal(xml1, xml2)
})
