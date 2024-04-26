test_that("Testing CreateItemBody MultipleChoiceTable", {
    mct <- new("MultipleChoiceTable",
              rows = c("Capulet", "Demetrius", "Lysander", "Prospero"),
              rows_identifiers  = c("C", "D", "L", "P"),
              cols = c("A Midsummer-Night's Dream", "Romeo and Juliet",
                       "The Tempest"),
              cols_identifiers = c("M", "R", "T"),
              answers_identifiers = c("C R", "C T", "D M", "L M", "P T", "P R"),
              answers_scores = c(1, 0.5, 0.5, 0.5, 1, 1),
              title = "MultipleChoiceTable",
              prompt = "Match the following characters to the Shakespeare play they appeared in:"
    )

    example <- '<itemBody>
<matchInteraction responseIdentifier="RESPONSE" shuffle="true" maxAssociations="6">
<prompt>Match the following characters to the Shakespeare play they appeared in:</prompt>
<simpleMatchSet>
<simpleAssociableChoice identifier="C" fixed="false" matchMax="3">Capulet</simpleAssociableChoice>
<simpleAssociableChoice identifier="D" fixed="false" matchMax="3">Demetrius</simpleAssociableChoice>
<simpleAssociableChoice identifier="L" fixed="false" matchMax="3">Lysander</simpleAssociableChoice>
<simpleAssociableChoice identifier="P" fixed="false" matchMax="3">Prospero</simpleAssociableChoice>
</simpleMatchSet>
<simpleMatchSet>
<simpleAssociableChoice identifier="M" fixed="false" matchMax="4">A Midsummer-Night\'s Dream</simpleAssociableChoice>
        <simpleAssociableChoice identifier="R" fixed="false" matchMax="4">Romeo and Juliet</simpleAssociableChoice>
        <simpleAssociableChoice identifier="T" fixed="false" matchMax="4">The Tempest</simpleAssociableChoice>
        </simpleMatchSet>
        </matchInteraction>
        </itemBody>'

    sut <- xml2::read_xml(toString(createItemBody(mct)))
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)
})

test_that("Testing create_response_declaration_MultipleChoiceTable",{
    mct <- new("MultipleChoiceTable",
              rows = c("Capulet", "Demetrius", "Lysander", "Prospero"),
              rows_identifiers  = c("C", "D", "L", "P"),
              cols = c("A Midsummer-Night's Dream", "Romeo and Juliet", "The Tempest"),
              cols_identifiers = c("M", "R", "T"),
              answers_identifiers = c("C R", "C T", "D M", "L M", "P T", "P R"),
              answers_scores = c(1, 0.5, 0.5, 0.5, 1, 1),
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
<mapEntry mapKey=\"C M\" mappedValue=\"-0.75\"/>
<mapEntry mapKey=\"D R\" mappedValue=\"-0.75\"/>
<mapEntry mapKey=\"D T\" mappedValue=\"-0.75\"/>
<mapEntry mapKey=\"L R\" mappedValue=\"-0.75\"/>
<mapEntry mapKey=\"L T\" mappedValue=\"-0.75\"/>
<mapEntry mapKey=\"P M\" mappedValue=\"-0.75\"/>
</mapping>
</responseDeclaration>'

    qtiXML <- toString(createResponseDeclaration(mct))
    sut <- xml2::read_xml(qtiXML)
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)

})

test_that("Testing outcomeDeclaration MultipleChoiceTable",{
    mct <- suppressMessages(new("MultipleChoiceTable",
              rows = c("Capulet", "Demetrius", "Lysander", "Prospero"),
              rows_identifiers  = c("C", "D", "L", "P"),
              cols = c("A Midsummer-Night's Dream", "Romeo and Juliet",
                       "The Tempest"),
              cols_identifiers = c("M", "R", "T"),
              answers_identifiers = c("C R", "C T", "D M", "L M", "P T", "P R"),
              answers_scores = c(1, 0.5, 0.5, 0.5, 1, 1),
              points = 4,
              title = "MultipleChoiceTable",
              prompt = "Match the following characters to the Shakespeare play they appeared in:"
    ))

    example <- '<additionalTag><outcomeDeclaration identifier="SCORE" cardinality="single" baseType="float">
<defaultValue>
<value>0</value>
</defaultValue>
</outcomeDeclaration>
<outcomeDeclaration identifier="MAXSCORE" cardinality="single" baseType="float">
<defaultValue>
<value>4.5</value>
</defaultValue>
</outcomeDeclaration>
<outcomeDeclaration identifier="MINSCORE" cardinality="single" baseType="float">
<defaultValue>
<value>0</value>
</defaultValue>
</outcomeDeclaration>
    </additionalTag>'

    responseDe <- as.character(htmltools::tag(
        "additionalTag", list(createOutcomeDeclaration(mct))))
    sut <- xml2::read_xml(responseDe)
    example <- xml2::read_xml(example)
    expect_equal(sut, example)

})
