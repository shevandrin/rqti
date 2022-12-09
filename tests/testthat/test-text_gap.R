test_that("Testing create_item_body_text ", {
    sc <- new("Entry", text =  new("Text",content = list(
        "first line ",
        "sec",
        new("TextGap", response_identifier = "RESPONSE",
            score = 1, response = "answer",
            alternatives = c("answer", "Answer")),
        "text after the gap",

        "third line"))

    )

    example <- '<itemBody>
<gapMatchInteraction responseIdentifier="RESPONSE" shuffle="false">
<prompt>Identify the missing words in this famous quote from Shakespeare\'s Richard III.</prompt>
        <gapText identifier="W" matchMax="1">winter</gapText>
        <gapText identifier="Sp" matchMax="1">spring</gapText>
        <gapText identifier="Su" matchMax="1">summer</gapText>
        <gapText identifier="A" matchMax="1">autumn</gapText>
        <blockquote>
        <p>
        Now is the
    <gap identifier="G1"/>
        of our discontent
    <br/>
        Made glorious
    <gap identifier="G2"/>
        by this sun of York;
    <br/>
        And all the clouds that lour\'d upon our house
<br/>
In the deep bosom of the ocean buried.
</p>
</blockquote>
</gapMatchInteraction>
</itemBody>'

    print (createItemBody(sc))
    xml1 <- xml2::read_xml(as.character(createItemBody(sc)))
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
})
