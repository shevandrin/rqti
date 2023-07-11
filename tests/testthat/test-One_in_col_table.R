#' The example for this time of question was adapted from the original provided by QTI to validated

test_that("Testing CreateItemBody OneInColTable", {
    sc <- new("OneInColTable",
              rows = c("Capulet", "Demetrius", "Prospero"),
              rows_identifiers = c("C", "D", "P"),
              cols = c("A Midsummer-Night's Dream", "Romeo and Juliet", "The Tempest"),
              cols_identifiers  = c("M", "R", "T"),

              answers_identifiers = c("C R", "D M", "P T"),
              points = 5,
              title = "one_in_col_table",
              prompt = "Match the following characters to the Shakespeare play they appeared in:"
    )

    example <- '<itemBody>
<matchInteraction responseIdentifier="RESPONSE" shuffle="true" maxAssociations="3">
<prompt>Match the following characters to the Shakespeare play they appeared in:</prompt>
<simpleMatchSet>
<simpleAssociableChoice identifier="C" fixed="false" matchMax="3">Capulet</simpleAssociableChoice>
<simpleAssociableChoice identifier="D" fixed="false" matchMax="3">Demetrius</simpleAssociableChoice>
<simpleAssociableChoice identifier="P" fixed="false" matchMax="3">Prospero</simpleAssociableChoice>
</simpleMatchSet>
<simpleMatchSet>
<simpleAssociableChoice identifier="M" fixed="false" matchMax="1">A Midsummer-Night\'s Dream</simpleAssociableChoice>
        <simpleAssociableChoice identifier="R" fixed="false" matchMax="1">Romeo and Juliet</simpleAssociableChoice>
        <simpleAssociableChoice identifier="T" fixed="false" matchMax="1">The Tempest</simpleAssociableChoice>
        </simpleMatchSet>
        </matchInteraction>
        </itemBody>'

    xml1 <- xml2::read_xml(toString(createItemBody(sc)))
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
})

test_that("Testing create_response_declaration_OneInColTable", {
    sc <- new("OneInColTable",
              cols = c("Capulet", "Demetrius", "Prospero"),
              cols_identifiers = c("C", "D", "P"),
              rows = c("A Midsummer-Night's Dream", "Romeo and Juliet", "The Tempest"),
              rows_identifiers = c("M", "R", "T"),
              answers_identifiers = c("C R", "D M", "P T"),
              answers_scores = c(1, 0.5, 1),
              points = 5,
              title = "one_in_col_table",
              prompt = "Match the following characters to the Shakespeare play they appeared in:"
    )

    example <- '<responseDeclaration identifier="RESPONSE" cardinality="multiple" baseType="directedPair">
<correctResponse>
<value>C R</value>
<value>D M</value>
<value>P T</value>
</correctResponse>
<mapping defaultValue="0">
<mapEntry mapKey="C R" mappedValue="1"/>
<mapEntry mapKey="D M" mappedValue="0.5"/>
<mapEntry mapKey="P T" mappedValue="1"/>
</mapping>
</responseDeclaration>'

    xml1 <- xml2::read_xml(toString(createResponseDeclaration(sc)))
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
})

test_that("Testing outcomeDeclaration OneInColTable", {
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

    responseDe <- as.character(htmltools::tag("additionalTag", list(createOutcomeDeclaration(sc))))
    xml1 <- xml2::read_xml(responseDe)
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
})
