test_that("Testing CreateItemBody Inline", {
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
    ))

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
       solution = c("Gloucester", "Lancaster", "York"),
       choices_identifiers = c("G","L","Y")),";<br/>
And all the clouds that lour'd upon our house
<br/>
In the deep bosom of the ocean buried.
</p>
</blockquote>"
    ))
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
        solution = c("Gloucester", "Lancaster", "York"),
        choices_identifiers = c("G","L","Y")),";<br/>
And all the clouds that lour'd upon our house
<br/>
In the deep bosom of the ocean buried.
</p>
</blockquote>"
    ))

    # ' The original example of QTI, do not have SCORE for that reason OPAL's example was taken with out MINSCORE

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

    responseDe <- as.character(htmltools::tag("additionalTag", list(createOutcomeDeclaration(sc))))
    xml1 <- xml2::read_xml(responseDe)
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
})
#options as numeric
test_that("Testing CreateItemBody Inline", {
    sc <- new("Entry", content = list("<p>One hour is",new("InlineChoice",
                                          response_identifier = "RESPONSE",
                                          answer_index = 3,
                                          score = 1,
                                          shuffle = FALSE,
                                          solution = c("160","90","60"),
                                          choices_identifiers = c("1","2","3")),
                                          "minutes</p>"))
    example <- '<itemBody>
	    <p>One hour is
  <inlineChoiceInteraction responseIdentifier="RESPONSE" shuffle="false">
				<inlineChoice identifier="1">160</inlineChoice>
				<inlineChoice identifier="2">90</inlineChoice>
				<inlineChoice identifier="3">60</inlineChoice>
			</inlineChoiceInteraction>
  minutes</p>
	</itemBody>'
    xml1 <- xml2::read_xml(toString(createItemBody(sc)))
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
})
# with out score
test_that("Testing CreateItemBody Inline", {
    sc <- new("Entry", content = list("<p>One hour is",new("InlineChoice",
                                                           response_identifier = "RESPONSE",
                                                           answer_index = 3,
                                                           shuffle = FALSE,
                                                           solution = c("160","90","60"),
                                                           choices_identifiers = c("1","2","3")),
                                      "minutes</p>"))
    example <- '<itemBody>
	    <p>One hour is
  <inlineChoiceInteraction responseIdentifier="RESPONSE" shuffle="false">
				<inlineChoice identifier="1">160</inlineChoice>
				<inlineChoice identifier="2">90</inlineChoice>
				<inlineChoice identifier="3">60</inlineChoice>
			</inlineChoiceInteraction>
  minutes</p>
	</itemBody>'
    xml1 <- xml2::read_xml(toString(createItemBody(sc)))
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
})
# with out options_identifier
test_that("Testing CreateItemBody Inline", {
    sc <- new("Entry", content = list("<p>One hour is",new("InlineChoice",
                                                           response_identifier = "RESPONSE",
                                                           answer_index = 3,
                                                           shuffle = FALSE,
                                                           solution = c("160","90","60")),
                                                               "minutes</p>"))
    example <- '<itemBody>
	    <p>One hour is
  <inlineChoiceInteraction responseIdentifier="RESPONSE" shuffle="false">
				<inlineChoice identifier="OptionA">160</inlineChoice>
				<inlineChoice identifier="OptionB">90</inlineChoice>
				<inlineChoice identifier="OptionC">60</inlineChoice>
			</inlineChoiceInteraction>
  minutes</p>
	</itemBody>'
    xml1 <- xml2::read_xml(toString(createItemBody(sc)))
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
})
test_that("Testing construction function for InlineChoice class", {
    sut <- new("Entry", identifier = "new",
                  points = 4,
                  title = "InlineChoice",
                  content = list('The speed of light is equal',
                                 new("InlineChoice",
                                     solution = c("400","300","500"),
                                     response_identifier = "RESPONSE_1",
                                     answer_index = 2,
                                     score = 0),
                                 'm/s'))

    example <- new("Entry",
                   identifier = "new",
                   points = 4,
                   title = "InlineChoice",
                   content = list('The speed of light is equal',
                                  new("InlineChoice",
                                      solution = c("400","300","500"),
                                      response_identifier = "RESPONSE_1",
                                      answer_index = 2,
                                      score = 0),
                                  'm/s'))

    expect_equal(sut, example)
})
