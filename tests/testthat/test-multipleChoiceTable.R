# ' QTI example does not provide Outcome declaration then the following example was taken from OPAL
test_that("Testing CreateItemBody MultipleChoiceTable", {
    sc <- new("MultipleChoiceTable",
              rows = c("Capulet", "Demetrius", "Lysander", "Prospero"),
              rows_identifiers  = c("C", "D", "L", "P"),
              cols = c("A Midsummer-Night's Dream", "Romeo and Juliet", "The Tempest"),
              cols_identifiers = c("M", "R", "T"),
              answers_identifiers = c("C R", "C T", "D M", "L M", "P T", "P R"),
              points = 6,
              title = "MultipleChoiceTable",
              prompt = "Match the following characters to the Shakespeare play they appeared in:"
    )

    example <- '<itemBody>
<matchInteraction responseIdentifier="RESPONSE" shuffle="true" maxAssociations="4">
<prompt>Match the following characters to the Shakespeare play they appeared in:</prompt>
<simpleMatchSet>
<simpleAssociableChoice identifier="C" matchMax="1">Capulet</simpleAssociableChoice>
<simpleAssociableChoice identifier="D" matchMax="1">Demetrius</simpleAssociableChoice>
<simpleAssociableChoice identifier="L" matchMax="1">Lysander</simpleAssociableChoice>
<simpleAssociableChoice identifier="P" matchMax="1">Prospero</simpleAssociableChoice>
</simpleMatchSet>
<simpleMatchSet>
<simpleAssociableChoice identifier="M" matchMax="4">A Midsummer-Night\'s Dream</simpleAssociableChoice>
        <simpleAssociableChoice identifier="R" matchMax="4">Romeo and Juliet</simpleAssociableChoice>
        <simpleAssociableChoice identifier="T" matchMax="4">The Tempest</simpleAssociableChoice>
        </simpleMatchSet>
        </matchInteraction>
        </itemBody>'

    xml1 <- xml2::read_xml(toString(createItemBody(sc)))
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
})

test_that("Testing create_response_declaration_MultipleChoiceTable",{
    sc <- new("MultipleChoiceTable",
              rows = c("Capulet", "Demetrius", "Lysander", "Prospero"),
              rows_identifiers  = c("C", "D", "L", "P"),
              cols = c("A Midsummer-Night's Dream", "Romeo and Juliet", "The Tempest"),
              cols_identifiers = c("M", "R", "T"),
              answers_identifiers = c("C R", "C T", "D M", "L M", "P T", "P R"),
              points = 5,
              title = "MultipleChoiceTable",
              prompt = "Match the following characters to the Shakespeare play they appeared in:"
    )

    example <- '<responseDeclaration identifier="RESPONSE" cardinality="multiple" baseType="directedPair">
<correctResponse>
<value>C R</value>
<value>C T</value>
<value>D M</value>
<value>L M</value>
<value>P T</value>
<value>P R</value>
</correctResponse>
<mapping defaultValue="0">
<mapEntry mapKey="C R" mappedValue="1"/>
<mapEntry mapKey="C T" mappedValue="0.5"/>
<mapEntry mapKey="D M" mappedValue="0.5"/>
<mapEntry mapKey="L M" mappedValue="0.5"/>
<mapEntry mapKey="P T" mappedValue="1"/>
<mapEntry mapKey="P R" mappedValue="1"/>
</mapping>
</responseDeclaration>'

    qtiXML <- toString(createResponseDeclaration(sc))
    xml1 <- xml2::read_xml(qtiXML)
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)

})

test_that("Testing outcomeDeclaration MultipleChoiceTable",{
    sc <- new("MultipleChoiceTable",
              rows = c("Capulet", "Demetrius", "Lysander", "Prospero"),
              rows_identifiers  = c("C", "D", "L", "P"),
              cols = c("A Midsummer-Night's Dream", "Romeo and Juliet", "The Tempest"),
              cols_identifiers = c("M", "R", "T"),
              answers_identifiers = c("C R", "C T", "D M", "L M", "P T", "P R"),
              points = 5,
              title = "MultipleChoiceTable",
              prompt = "Match the following characters to the Shakespeare play they appeared in:"
    )

    # ' QTI example does not provide Outcome declaration then the following example was taken from OPAL
    example <- '<additionalTag><outcomeDeclaration identifier="SCORE" cardinality="single" baseType="float">
<defaultValue>
<value>5</value>
</defaultValue>
</outcomeDeclaration>
<outcomeDeclaration identifier="MAXSCORE" cardinality="single" baseType="float">
<defaultValue>
<value>5</value>
</defaultValue>
</outcomeDeclaration>
<outcomeDeclaration identifier="MINSCORE" cardinality="single" baseType="float" view="testConstructor">
<defaultValue>
<value>0</value>
</defaultValue>
</outcomeDeclaration>
    </additionalTag>'

    responseDe <- paste('<additionalTag>', toString(createOutcomeDeclaration(sc)[[1]]),'</additionalTag>')
    xml1 <- xml2::read_xml(responseDe)
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)

})


