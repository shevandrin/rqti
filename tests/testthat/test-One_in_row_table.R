test_that("Testing CreateItemBody OneInRowTable", {
    sut <- new("OneInRowTable",
              rows = c("Capulet", "Demetrius", "Lysander", "Prospero"),
              rows_identifiers = c("C", "D", "L", "P"),
              cols = c("A Midsummer-Night's Dream", "Romeo and Juliet",
                       "The Tempest"),
              cols_identifiers = c("M", "R", "T"),
              answers_identifiers = c("C R", "D M", "L M", "P T"),
              points = 5,
              title = "one_in_row_table",
              prompt = "Match the following characters to the Shakespeare play they appeared in:"
    )

    example <- '<itemBody>
<matchInteraction responseIdentifier="RESPONSE" shuffle="true" maxAssociations="4">
<prompt>Match the following characters to the Shakespeare play they appeared in:</prompt>
<simpleMatchSet>
<simpleAssociableChoice identifier="C" fixed="false" matchMax="1">Capulet</simpleAssociableChoice>
<simpleAssociableChoice identifier="D" fixed="false" matchMax="1">Demetrius</simpleAssociableChoice>
<simpleAssociableChoice identifier="L" fixed="false" matchMax="1">Lysander</simpleAssociableChoice>
<simpleAssociableChoice identifier="P" fixed="false" matchMax="1">Prospero</simpleAssociableChoice>
</simpleMatchSet>
<simpleMatchSet>
<simpleAssociableChoice identifier="M" fixed="false" matchMax="4">A Midsummer-Night\'s Dream</simpleAssociableChoice>
        <simpleAssociableChoice identifier="R" fixed="false" matchMax="4">Romeo and Juliet</simpleAssociableChoice>
        <simpleAssociableChoice identifier="T" fixed="false" matchMax="4">The Tempest</simpleAssociableChoice>
        </simpleMatchSet>
        </matchInteraction>
        </itemBody>'

    sut <- xml2::read_xml(toString(createItemBody(sut)))
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)
})

test_that("Testing create_response_declaration_OneInRowTable",{
    sut <- new("OneInRowTable",
              rows = c("Capulet", "Demetrius", "Lysander", "Prospero"),
              rows_identifiers = c("C", "D", "L", "P"),
              cols = c("A Midsummer-Night's Dream", "Romeo and Juliet",
                       "The Tempest"),
              cols_identifiers = c("M", "R", "T"),
              answers_identifiers = c("C R", "D M", "L M", "P T"),
              answers_scores = c(1, 0.5, 0.5, 1),
              points = 5,
              title = "one_in_row_table",
              prompt = "Match the following characters to the Shakespeare play they appeared in:"
    )

    example <- '<responseDeclaration identifier="RESPONSE" cardinality="multiple" baseType="directedPair">
<correctResponse>
<value>C R</value>
<value>D M</value>
<value>L M</value>
<value>P T</value>
</correctResponse>
<mapping defaultValue="0">
<mapEntry mapKey="C R" mappedValue="1"/>
<mapEntry mapKey="D M" mappedValue="0.5"/>
<mapEntry mapKey="L M" mappedValue="0.5"/>
<mapEntry mapKey="P T" mappedValue="1"/>
</mapping>
</responseDeclaration>'

    qtiXML <- toString(createResponseDeclaration(sut))
    sut <- xml2::read_xml(qtiXML)
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)
})

test_that("Testing outcomeDeclaration OneInRowTable",{
    sut <- new("OneInRowTable",
              rows = c("Capulet", "Demetrius", "Lysander", "Prospero"),
              rows_identifiers = c("C", "D", "L", "P"),
              cols = c("A Midsummer-Night's Dream", "Romeo and Juliet",
                       "The Tempest"),
              cols_identifiers = c("M", "R", "T"),
              answers_identifiers = c("C R", "D M", "L M", "P T"),
              points = 5,
              title = "one_in_row_table",
              prompt = "Match the following characters to the Shakespeare play they appeared in:"
    )

    # ' QTI example does not provide Outcome declaration then the following example was taken from OPAL
    example <- '<additionalTag><outcomeDeclaration identifier="SCORE" cardinality="single" baseType="float">
<defaultValue>
<value>0</value>
</defaultValue>
</outcomeDeclaration>
<outcomeDeclaration identifier="MAXSCORE" cardinality="single" baseType="float">
<defaultValue>
<value>5</value>
</defaultValue>
</outcomeDeclaration>
<outcomeDeclaration identifier="MINSCORE" cardinality="single" baseType="float">
<defaultValue>
<value>0</value>
</defaultValue>
</outcomeDeclaration>
    </additionalTag>'

    responseDe <- as.character(htmltools::tag(
        "additionalTag", list(createOutcomeDeclaration(sut))))
    sut <- xml2::read_xml(responseDe)
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)
})
