source("test_helpers.R")

mc <- new("MultipleChoice",
          content = list(),
          choices = c("Hydrogen","Helium","Carbon","Oxygen","Nitrogen",
                      "Chlorine"),
          choice_identifiers = c("H","He","C","O","N","Cl"),
          points = c(1,0,0,1,0,-1),
          title = "title_mc",
          prompt = paste0("Which of the following elements ",
                          "are used to form water?"))

testthat::skip_if_not_installed("XML")
test_that("Test createItemBody for MultipleChoice class", {

    example <- '<itemBody>
<choiceInteraction responseIdentifier="RESPONSE" shuffle="true" maxChoices="0"
orientation="vertical">
<prompt>Which of the following elements are used to form water?</prompt>
<simpleChoice identifier="H">Hydrogen</simpleChoice>
<simpleChoice identifier="He">Helium</simpleChoice>
<simpleChoice identifier="C">Carbon</simpleChoice>
<simpleChoice identifier="O">Oxygen</simpleChoice>
<simpleChoice identifier="N">Nitrogen</simpleChoice>
<simpleChoice identifier="Cl">Chlorine</simpleChoice>
</choiceInteraction>
</itemBody>'

    sut <- xml2::read_xml(toString(createItemBody(mc)))
    expected <- xml2::read_xml(example)
    equal_xml(sut, expected)
})

testthat::skip_if_not_installed("XML")
test_that("Test createResponseDeclaration for MultipleChoice class",{
    mc <- new("MultipleChoice",
              content = list(""),
              choices = c("Hydrogen","Helium","Carbon","Oxygen","Nitrogen",
                          "Chlorine"),
              choice_identifiers = c("H","He","C","O","N","Cl"),
              points = c(1,0,0,1,0,-1),
              title = "filename_sc",
              prompt = paste0("Which of the following elements ",
                                       "are used to form water?"))

    example <- '
    <responseDeclaration identifier="RESPONSE"
                            cardinality="multiple" baseType="identifier">
    <correctResponse>
        <value>H</value>
        <value>O</value>
    </correctResponse>
    <mapping lowerBound="0" upperBound="2" defaultValue="0">
        <mapEntry mapKey="Cl" mappedValue="-1"/>
        <mapEntry mappedValue="1" mapKey="H"/>
        <mapEntry mapKey="O" mappedValue="1"/>
    </mapping>
    </responseDeclaration>'

    qtiXML <- toString(createResponseDeclaration(mc))
    sut <- xml2::read_xml(qtiXML)
    expected <- xml2::read_xml(example)

    equal_xml(sut, expected)
})

test_that("Test getPoints for MultipleChoice class", {

    sut <- getPoints(mc)
    expect_equal(sut, 2)
})

testthat::skip_if_not_installed("XML")
test_that("Test createOutcomeDeclaration() for Multiple Choice",{

    example <- '
<additionalTag>
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
</additionalTag>'

    responseDe <- as.character(htmltools::tag(
        "additionalTag", list(createOutcomeDeclaration(mc))))
    sut <- xml2::read_xml(responseDe)

    expected <- xml2::read_xml(example)
    equal_xml(sut, expected)
})
test_that("Testing the constructor for MultipleChoice class", {
    sut <- multipleChoice(choices = c("option1", "option2", "option3"),
                          points = c(0, 0.5, 0.5))
    xml_sut <- create_assessment_item(sut)

    expect_no_error(xml2::read_xml(as.character(xml_sut)))
    expect_s4_class(sut, "MultipleChoice")
})
