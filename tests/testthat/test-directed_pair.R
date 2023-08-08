test_that("Testing CreateItemBody DirectedPair", {
    sc <- new("DirectedPair",
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

    # print("I think the name of the attributes confused a little")
    sut <- xml2::read_xml(toString(createItemBody(sc)))
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)
})

test_that("Testing ResponseDeclaration DirectedPair", {
    sc <- new("DirectedPair",
              rows = c("Lion", "Flower", "Mushrooms"),
              rows_identifiers = c("ID_1", "ID_2", "ID_3"),
              cols = c("Animal", "Plant", "Fungi"),
              cols_identifiers = c("IDT_1", "IDT_2", "IDT_3"),
              answers_identifiers = c("ID_3 IDT_3", "ID_1 IDT_1", "ID_2 IDT_2"),
              answers_scores = c(0.5, 0.5, 0.5),
              points = 3,
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

    # print("There is not option to give individual values to answer - fixed")
    sut <- xml2::read_xml(toString(createResponseDeclaration(sc)))
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)
})

test_that("Testing OutcomeDeclaration DirectedPair", {
    sc <- new("DirectedPair",
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
                                            list(createOutcomeDeclaration(sc))))
    sut <- xml2::read_xml(responseDe)
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)
})
