test_that("Testing CreateItemBody DirectedPair", {
    dp <- new("DirectedPair",
              rows = c("Lion", "Flower", "Mushrooms"),
              rows_identifiers = c("ID_1", "ID_2", "ID_3"),
              cols = c("Animal", "Plant", "Fungi"),
              cols_identifiers = c("IDT_1", "IDT_2", "IDT_3"),
              answers_identifiers = c("ID_3 IDT_3", "ID_1 IDT_1", "ID_2 IDT_2"),
              points = 5,
              title = "directed_pair",
              orientation = "horizontal",
              prompt = "Associated left elements with the right category"
    )

    # The example was based on OPAL question type "Match Interaction" because
    # qti does not provide it

    example <- '<itemBody>
<matchInteraction responseIdentifier="RESPONSE" shuffle="true"
                                maxAssociations="0" orientation="horizontal">
<prompt>Associated left elements with the right category</prompt>
<simpleMatchSet>
<simpleAssociableChoice identifier="ID_1" fixed="false"
                                matchMax="1">Lion</simpleAssociableChoice>
<simpleAssociableChoice identifier="ID_2" fixed="false"
                                matchMax="1">Flower</simpleAssociableChoice>
<simpleAssociableChoice identifier="ID_3" fixed="false"
                                matchMax="1">Mushrooms</simpleAssociableChoice>
</simpleMatchSet>
<simpleMatchSet>
<simpleAssociableChoice identifier="IDT_1" fixed="false"
                                matchMax="1">Animal</simpleAssociableChoice>
<simpleAssociableChoice identifier="IDT_2" fixed="false"
                                matchMax="1">Plant</simpleAssociableChoice>
<simpleAssociableChoice identifier="IDT_3" fixed="false"
                                matchMax="1">Fungi</simpleAssociableChoice>
</simpleMatchSet>
</matchInteraction>
    </itemBody>'

    sut <- xml2::read_xml(toString(createItemBody(dp)))
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)
})

test_that("Testing createResponseDeclaration() method in DirectedPair class
          where its slots answer_score and points are undefined", {
    dp <- new("DirectedPair",
              rows = c("Lion", "Flower", "Mushrooms"),
              rows_identifiers = c("ID_1", "ID_2", "ID_3"),
              cols = c("Animal", "Plant", "Fungi"),
              cols_identifiers = c("IDT_1", "IDT_2", "IDT_3"),
              answers_identifiers = c("ID_3 IDT_3", "ID_1 IDT_1", "ID_2 IDT_2"),
              title = "directed_pair",
              prompt = "Associated left elements with the right category"
    )

    # The example was based on OPAL question type "Match Interaction" because
    # qti does not provide it
    example <- '<responseDeclaration identifier="RESPONSE"
                            cardinality="multiple" baseType="directedPair">
<correctResponse>
<value>ID_3 IDT_3</value>
<value>ID_1 IDT_1</value>
<value>ID_2 IDT_2</value>
</correctResponse>
<mapping defaultValue="0">
<mapEntry mapKey="ID_3 IDT_3" mappedValue="0.5"/>
<mapEntry mapKey="ID_1 IDT_1" mappedValue="0.5"/>
<mapEntry mapKey="ID_2 IDT_2" mappedValue="0.5"/>
</mapping>
</responseDeclaration>'

    sut <- xml2::read_xml(toString(createResponseDeclaration(dp)))
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)
})

test_that("Testing OutcomeDeclaration DirectedPair", {
    dp <- new("DirectedPair",
              rows = c("Lion", "Flower", "Mushrooms"),
              rows_identifiers = c("ID_1", "ID_2", "ID_3"),
              cols = c("Animal", "Plant", "Fungi"),
              cols_identifiers = c("IDT_1", "IDT_2", "IDT_3"),
              answers_identifiers = c("ID_3 IDT_3", "ID_1 IDT_1", "ID_2 IDT_2"),
              points = 5,
              title = "directed_pair",
              prompt = "Associated left elements with the right category"
    )

    # The example was based on OPAL question type "Match Interaction" because
    # qti does not provide it
    example <- '<additionalTag>
<outcomeDeclaration identifier="SCORE" cardinality="single" baseType="float">
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

    responseDe <- as.character(htmltools::tag("additionalTag",
                                            list(createOutcomeDeclaration(dp))))
    sut <- xml2::read_xml(responseDe)
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)
})
test_that("Testing the constructor for DirectedPair class", {
    sut <- directedPair(content = list("<p>\"Directed pairs\" task</p>"),
                        rows = c("alfa", "beta", "gamma"),
                        rows_identifiers = c("a", "b", "g"),
                        cols = c("A", "B", "G;"),
                        cols_identifiers = c("as", "bs", "gs"),
                        answers_identifiers = c("a as", "b bs", 'g gs'))
    xml_sut <- create_assessment_item(sut)

    expect_no_error(xml2::read_xml(as.character(xml_sut)))
    expect_s4_class(sut, "DirectedPair")
})
