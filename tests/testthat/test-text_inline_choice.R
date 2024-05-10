test_that("Testing CreateItemBody Inline", {
    entry <- suppressMessages(new("Entry",
    content = list("<p>Identify the missing word in this famous quote from Shakespeare's Richard III.</p>
<blockquote>
<p>
Now is the winter of our discontent
<br/>
Made glorious summer by this sun of",
        new("InlineChoice",
            response_identifier = "RESPONSE",
            solution_index = 3,
            points = 2,
            shuffle = FALSE,
            choices = c("Gloucester", "Lancaster", "York"),
            choices_identifiers = c("G","L","Y")),";<br/>
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

    sut <- xml2::read_xml(toString(createItemBody(entry)))
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)
})

test_that("Testing ResponseDeclaration Inline", {
    entry <- suppressMessages(new("Entry",
    content = list(
    "<p>Identify the missing word in this famous quote from Shakespeare's Richard III.</p>
<blockquote>
<p>
Now is the winter of our discontent
<br/>
Made glorious summer by this sun of",
       new("InlineChoice",
       response_identifier = "RESPONSE",
       solution_index = 3,
       points = 2,
       choices = c("Gloucester", "Lancaster", "York"),
       choices_identifiers = c("G","L","Y")),";<br/>
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

    sut <- xml2::read_xml(toString(createResponseDeclaration(entry)[[1]]))
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)
})

test_that("Testing OutcomeDeclaration Inline", {
    entry <- suppressMessages(
    new("Entry",
    content = list("<p>Identify the missing word in this famous quote from Shakespeare's Richard III.</p>
<blockquote>
<p>
Now is the winter of our discontent
<br/>
Made glorious summer by this sun of",
        new("InlineChoice",
        response_identifier = "RESPONSE",
        solution_index = 3,
        points = 2,
        choices = c("Gloucester", "Lancaster", "York"),
        choices_identifiers = c("G","L","Y")),";<br/>
And all the clouds that lour'd upon our house
<br/>
In the deep bosom of the ocean buried.
</p>
</blockquote>"
    )))

    # The original example of QTI, do not have SCORE for that
    # reason OPAL's example was taken with out MINSCORE

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
<outcomeDeclaration identifier="SCORE_RESPONSE" cardinality="single" baseType="float">
<defaultValue>
<value>0</value>
</defaultValue>
</outcomeDeclaration>
<outcomeDeclaration identifier="MAXSCORE_RESPONSE" cardinality="single" baseType="float">
<defaultValue>
<value>2</value>
</defaultValue>
</outcomeDeclaration>
<outcomeDeclaration identifier="MINSCORE_RESPONSE" cardinality="single" baseType="float">
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

#options as numeric
test_that("Testing CreateItemBody Inline", {
    entry <- suppressMessages(new("Entry",
                    content = list("<p>One hour is",new("InlineChoice",
                              response_identifier = "RESPONSE",
                              solution_index = 3,
                              points = 1,
                              shuffle = FALSE,
                              choices = c("160","90","60"),
                              choices_identifiers = c("1","2","3")),
                              "minutes</p>")))
    example <- '<itemBody>
	    <p>One hour is
  <inlineChoiceInteraction responseIdentifier="RESPONSE" shuffle="false">
				<inlineChoice identifier="1">160</inlineChoice>
				<inlineChoice identifier="2">90</inlineChoice>
				<inlineChoice identifier="3">60</inlineChoice>
			</inlineChoiceInteraction>
  minutes</p>
	</itemBody>'
    sut <- xml2::read_xml(toString(createItemBody(entry)))
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)
})

# with out score
test_that("Testing CreateItemBody Inline", {
    entry <- suppressMessages(new("Entry",
                               content = list(
                                   "<p>One hour is",new("InlineChoice",
                                          response_identifier = "RESPONSE",
                                          solution_index = 3,
                                          shuffle = FALSE,
                                          choices = c("160","90","60"),
                                          choices_identifiers = c("1","2","3")),
                                      "minutes</p>")))
    example <- '<itemBody>
	    <p>One hour is
  <inlineChoiceInteraction responseIdentifier="RESPONSE" shuffle="false">
				<inlineChoice identifier="1">160</inlineChoice>
				<inlineChoice identifier="2">90</inlineChoice>
				<inlineChoice identifier="3">60</inlineChoice>
			</inlineChoiceInteraction>
  minutes</p>
	</itemBody>'
    sut <- xml2::read_xml(toString(createItemBody(entry)))
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)
})

# with out options_identifier
test_that("Testing CreateItemBody Inline", {
    entry <- suppressMessages(new("Entry",
                        content = list("<p>One hour is",new("InlineChoice",
                                           response_identifier = "RESPONSE",
                                           solution_index = 3,
                                           shuffle = FALSE,
                                           choices = c("160","90","60")),
                                           "minutes</p>")))
    example <- '<itemBody>
	    <p>One hour is
  <inlineChoiceInteraction responseIdentifier="RESPONSE" shuffle="false">
				<inlineChoice identifier="OptionA">160</inlineChoice>
				<inlineChoice identifier="OptionB">90</inlineChoice>
				<inlineChoice identifier="OptionC">60</inlineChoice>
			</inlineChoiceInteraction>
  minutes</p>
	</itemBody>'
    sut <- xml2::read_xml(toString(createItemBody(entry)))
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)
})

test_that("Testing InlineChoice class in case its score is undefined", {
    sut_1 <- suppressMessages(new("Entry", identifier = "new",
                           points = 4,
                           title = "InlineChoice",
                           content = list('The speed of light is equal',
                                            new("InlineChoice",
                                            choices = c("400","300","500"),
                                            response_identifier = "RESPONSE_1",
                                            solution_index = 2),
                                            'm/s')))
    sut_2 <- suppressMessages(new("Entry", identifier = "new",
                           points = 4,
                           title = "InlineChoice",
                           content = list('The speed of light is equal',
                                           new("InlineChoice",
                                           choices = c("400","300","500"),
                                           response_identifier = "RESPONSE_1",
                                           solution_index = 2,
                                           points = as.integer(NA)),
                                           'm/s')))
    inline_choice_1 <- sut_1@content[[2]]
    inline_choice_2 <- sut_2@content[[2]]
    expect_equal(inline_choice_1@points, 1)
    expect_equal(inline_choice_2@points, 1)
})

test_that("Testing InlineChoice class in case points are zero", {
sut <- suppressMessages(new("Entry",
                              content = list(
                                  "<p>One hour is",new("InlineChoice",
                                                       response_identifier = "RESPONSE",
                                                       solution_index = 3,
                                                       points = numeric(0L),
                                                       shuffle = FALSE,
                                                       choices = c("160","90","60"),
                                                       choices_identifiers = c("1","2","3")),
                                  "minutes</p>")))
expect_equal(sut@points, 1)
})
