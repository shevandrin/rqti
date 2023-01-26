test_that("Testing CreateItemBody DirectedPair", {
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

    # The example was based on OPAL question type "Match Interaction" because qti does not provide it
    example <- '<itemBody>
<matchInteraction responseIdentifier="RESPONSE_1" shuffle="true" maxAssociations="0">
<prompt>Associated left elements with the right category</prompt>
<simpleMatchSet>
<simpleAssociableChoice identifier="ID_1" fixed="false" matchMax="1">
<p>Lion</p>
</simpleAssociableChoice>
<simpleAssociableChoice identifier="ID_2" fixed="false" matchMax="1">
<p>Flower</p>
</simpleAssociableChoice>
<simpleAssociableChoice identifier="ID_3" fixed="false" matchMax="1">
<p>Mushrooms</p>
</simpleAssociableChoice>
</simpleMatchSet>
<simpleMatchSet>
<simpleAssociableChoice identifier="IDT_1" fixed="false" matchMax="1">
<p>Animal</p>
</simpleAssociableChoice>
<simpleAssociableChoice identifier="IDT_2" fixed="false" matchMax="1">
<p>Plant</p>
</simpleAssociableChoice>
<simpleAssociableChoice identifier="IDT_3" fixed="false" matchMax="1">
<p>Fungi</p>
</simpleAssociableChoice>
</simpleMatchSet>
</matchInteraction>
    </itemBody>'

    print("I think the name of the attributes confused a little")
    xml1 <- xml2::read_xml(toString(createItemBody(sc)))
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
})

test_that("Testing ResponseDeclaration DirectedPair", {
    sc <- new("DirectedPair",
              rows = c("Lion", "Flower", "Mushrooms"),
              rows_identifiers = c("ID_1", "ID_2", "ID_3"),
              cols = c("Animal", "Plant", "Fungi"),
              cols_identifiers = c("IDT_1", "IDT_2", "IDT_3"),
              answers_identifiers = c("ID_3 IDT_3", "ID_1 IDT_1", "ID_2 IDT_2"),
              points = 3,
              title = "directed_pair",
              prompt = "Associated left elements with the right category"
    )

    # The example was based on OPAL question type "Match Interaction" because qti does not provide it
    example <- '<responseDeclaration identifier="RESPONSE_1" cardinality="multiple" baseType="directedPair">
<correctResponse>
<value>ID_3 IDT_3</value>
<value>ID_1 IDT_1</value>
<value>ID_2 IDT_2</value>
</correctResponse>
<mapping defaultValue="0" lowerBound="0.0">
<mapEntry mapKey="ID_1 IDT_1" mappedValue="0.5"/>
<mapEntry mapKey="ID_2 IDT_2" mappedValue="0.5"/>
<mapEntry mapKey="ID_3 IDT_3" mappedValue="0.5"/>
</mapping>
</responseDeclaration>'

    print("There is not option to give individual values to answer")
    print(toString(createResponseDeclaration(sc)))
    xml1 <- xml2::read_xml(toString(createResponseDeclaration(sc)))
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
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

    # The example was based on OPAL question type "Match Interaction" because qti does not provide it
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
<outcomeDeclaration identifier="MINSCORE" cardinality="single" baseType="float" view="testConstructor">
<defaultValue>
<value>0</value>
</defaultValue>
</outcomeDeclaration>
    </additionalTag>'

    responseDe <- as.character(htmltools::tag("additionalTag", list(createOutcomeDeclaration(sc))))
    print(responseDe)
    xml1 <- xml2::read_xml(responseDe)
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
})

