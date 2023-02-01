test_that("Testing CreateItemBody Inline", {
    sc <- new("Entry", text = new("Text", content = list("<p>Identify the missing word in this famous quote from Shakespeare's Richard III.</p>
<blockquote>
<p>
Now is the winter of our discontent
<br/>
Made glorious summer by this sun of",
        new("InlineChoice",
            response_identifier = "RESPONSE",
            solution = 3,
            score = 2,
            shuffle = FALSE,
            options = c("Gloucester", "Lancaster", "York"),
            options_identifiers = c("G","L","Y")),";<br/>
And all the clouds that lour'd upon our house
<br/>
In the deep bosom of the ocean buried.
</p>
</blockquote>"
    )))

    example <- '<itemBody>
<p>Identify the missing word in this famous quote from Shakespeare\'s Richard III.</p>
<blockquote>
<p>
Now is the winter of our discontent
<br/>
Made glorious summer by this sun of
  <inlineChoiceInteraction responseIdentifier="RESPONSE" shuffle="false">
<inlineChoice identifier="G">Gloucester</inlineChoice>
<inlineChoice identifier="L">Lancaster</inlineChoice>
<inlineChoice identifier="Y">York</inlineChoice>
</inlineChoiceInteraction>
  ;<br/>
And all the clouds that lour\'d upon our house
<br/>
In the deep bosom of the ocean buried.
</p>
</blockquote>
</itemBody>'

    xml1 <- xml2::read_xml(toString(createItemBody(sc)))
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
})

test_that("Testing ResponseDeclaration Inline", {
    sc <- new("Entry", text = new("Text", content = list("<p>Identify the missing word in this famous quote from Shakespeare's Richard III.</p>
<blockquote>
<p>
Now is the winter of our discontent
<br/>
Made glorious summer by this sun of",
       new("InlineChoice",
       response_identifier = "RESPONSE",
       solution = 3,
       score = 2,
       options = c("Gloucester", "Lancaster", "York"),
       options_identifiers = c("G","L","Y")),";<br/>
And all the clouds that lour'd upon our house
<br/>
In the deep bosom of the ocean buried.
</p>
</blockquote>"
    )))
    # ' The original example of QTI, do not have SCORE for that reason OPAL's example was taken with out the attribute defaultValue="0"
    example <- '<responseDeclaration identifier="RESPONSE" cardinality="single" baseType="identifier">
<correctResponse>
<value>Y</value>
</correctResponse>
<mapping>
<mapEntry mapKey="Y" mappedValue="2"/>
</mapping>
</responseDeclaration>'

    xml1 <- xml2::read_xml(toString(createResponseDeclaration(sc)[[1]]))
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
})

test_that("Testing OutcomeDeclaration Inline", {
    sc <- new("Entry", text = new("Text", content = list("<p>Identify the missing word in this famous quote from Shakespeare's Richard III.</p>
<blockquote>
<p>
Now is the winter of our discontent
<br/>
Made glorious summer by this sun of",
        new("InlineChoice",
        response_identifier = "RESPONSE",
        solution = 3,
        score = 2,
        options = c("Gloucester", "Lancaster", "York"),
        options_identifiers = c("G","L","Y")),";<br/>
And all the clouds that lour'd upon our house
<br/>
In the deep bosom of the ocean buried.
</p>
</blockquote>"
    )))

    # ' The original example of QTI, do not have SCORE for that reason OPAL's example was taken with out MINSCORE

    example <- '<additionalTag>
<outcomeDeclaration identifier="SCORE_RESPONSE" cardinality="single" baseType="float">
<defaultValue>
<value>2</value>
</defaultValue>
</outcomeDeclaration>
<outcomeDeclaration identifier="MAXSCORE_RESPONSE" cardinality="single" baseType="float">
<defaultValue>
<value>2</value>
</defaultValue>
</outcomeDeclaration>
</additionalTag>'

    responseDe <- paste('<additionalTag>', toString(createOutcomeDeclaration(sc)[[1]]),'</additionalTag>')
    xml1 <- xml2::read_xml(responseDe)
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
})

test_that("XML validation with schema file", {
    sc <- new("Entry", text = new("Text", content = list("<p>Identify the missing word in this famous quote from Shakespeare's Richard III.</p>
<blockquote>
<p>
Now is the winter of our discontent
<br/>
Made glorious summer by this sun of",
                                                         new("InlineChoice",
                                                             response_identifier = "RESPONSE",
                                                             solution = 3,
                                                             score = 2,
                                                             shuffle = FALSE,
                                                             options = c("Gloucester", "Lancaster", "York"),
                                                             options_identifiers = c("G","L","Y")),";<br/>
And all the clouds that lour'd upon our house
<br/>
In the deep bosom of the ocean buried.
</p>
</blockquote>"
    )), title = "inline_choice")
    doc <- xml2::read_xml(toString(create_assessment_item(sc)))
    file <- file.path(getwd(), "imsqti_v2p1.xsd")
    schema <- xml2::read_xml(file)
    validation <- xml2::xml_validate(doc, schema)
    expect_equal(validation[1], TRUE)
})
