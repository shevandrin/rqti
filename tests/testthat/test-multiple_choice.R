test_that("Testing create_item_body_multiplechoice", {
    sc <- new("MultipleChoice",
              text = new("Text",content = list("")),
              choices = c("Hydrogen","Helium","Carbon","Oxygen","Nitrogen","Chlorine"),
              choice_identifiers = c("H","He","C","O","N","Cl"),
              points = c(1,0,0,1,0,-1),
              title = "filename_sc",
              prompt = "Which of the following elements are used to form water?")

    example <- '<itemBody>
<choiceInteraction responseIdentifier="RESPONSE" shuffle="true" maxChoices="0">
<prompt>Which of the following elements are used to form water?</prompt>
<simpleChoice identifier="H">Hydrogen</simpleChoice>
<simpleChoice identifier="He">Helium</simpleChoice>
<simpleChoice identifier="C">Carbon</simpleChoice>
<simpleChoice identifier="O">Oxygen</simpleChoice>
<simpleChoice identifier="N">Nitrogen</simpleChoice>
<simpleChoice identifier="Cl">Chlorine</simpleChoice>
</choiceInteraction>
</itemBody>'

    xml1 <- xml2::read_xml(toString(create_item_body_multiplechoice(sc)))
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
})

test_that("Testing create_response_declaration_multiple_choice",{
    sc <- new("MultipleChoice",
              text = new("Text",content = list("")),
              choices = c("Hydrogen","Helium","Carbon","Oxygen","Nitrogen","Chlorine"),
              choice_identifiers = c("H","He","C","O","N","Cl"),
              points = c(1,0,0,1,0,-1),
              title = "filename_sc",
              prompt = "Which of the following elements are used to form water?")
# 'The default value was changed from -2 to 0 because the package not allow negative points for Total score

    example <- '<responseDeclaration identifier="RESPONSE" cardinality="multiple" baseType="identifier">
<correctResponse>
<value>H</value>
<value>O</value>
</correctResponse>
<mapping lowerBound="0" upperBound="2" defaultValue="0">
<mapEntry mapKey="H" mappedValue="1"/>
<mapEntry mapKey="O" mappedValue="1"/>
<mapEntry mapKey="Cl" mappedValue="-1"/>
</mapping>
</responseDeclaration>'

    xml1 <- xml2::read_xml(toString(create_response_declaration_multiple_choice(sc)))
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
})

test_that("Testing outcomeDeclaration for Multiple Choice",{
    sc <- new("MultipleChoice",
              text = new("Text",content = list("")),
              choices = c("Hydrogen","Helium","Carbon","Oxygen","Nitrogen","Chlorine"),
              points = c(1,0,0,1,0,-1),
              title = "filename_sc",
              prompt = "Which of the following elements are used to form water?")

    example <- '<outcomeDeclaration identifier="SCORE" cardinality="single" baseType="float"/>'

    print(create_outcome_declaration_multiple_choice(sc))
    xml1 <- xml2::read_xml(toString(create_outcome_declaration_multiple_choice(sc)))
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)


})

