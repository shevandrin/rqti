test_that("Testing create_item_body_single_choice", {
    sc <- new("SingleChoice",
              content = list("<p>Look at the text in the picture.</p><p><img src=\"images/sign.png\" alt=\"NEVER LEAVE LUGGAGE UNATTENDED\"/></p>"),
              choices = c("You must stay with your luggage at all times.", "Do not let someone else look after your luggage.", "Remember your luggage when you leave."),
              title = "filename_sc",
              prompt = "What does it say?",
              shuffle = FALSE)
    example <- "<itemBody>
    <p>Look at the text in the picture.</p>
    <p><img src=\"images/sign.png\" alt=\"NEVER LEAVE LUGGAGE UNATTENDED\"/></p>
    <choiceInteraction responseIdentifier=\"RESPONSE\" shuffle=\"false\" maxChoices=\"1\" orientation=\"vertical\">
    <prompt>What does it say?</prompt>
    <simpleChoice identifier=\"ChoiceA\">You must stay with your luggage at all times.</simpleChoice>
    <simpleChoice identifier=\"ChoiceB\">Do not let someone else look after your luggage.</simpleChoice>
    <simpleChoice identifier=\"ChoiceC\">Remember your luggage when you leave.</simpleChoice></choiceInteraction></itemBody>"

    xml1 <- xml2::read_xml(toString(create_item_body_single_choice(sc)))
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
})

test_that("Testing create_response_declaration_single_choice",{
    sc <- new("SingleChoice",
              content = list("<p>Look at the text in the picture.</p><p><img src=\"images/sign.png\" alt=\"NEVER LEAVE LUGGAGE UNATTENDED\"/></p>"),
              choices = c("You must stay with your luggage at all times.", "Do not let someone else look after your luggage.", "Remember your luggage when you leave."),
              title = "filename_sc",
              prompt = "What does it say?")

    example <- '<responseDeclaration identifier="RESPONSE" cardinality="single" baseType="identifier">
<correctResponse>
<value>ChoiceA</value>
</correctResponse>
</responseDeclaration>'

    xml1 <- xml2::read_xml(toString(create_response_declaration_single_choice(sc)))
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
})

test_that("Testing outcomeDeclaration for Single Choice",{
    sc <- new("SingleChoice",
              content = list("<p>Look at the text in the picture.</p><p><img src=\"images/sign.png\" alt=\"NEVER LEAVE LUGGAGE UNATTENDED\"/></p>"),
              choices = c("You must stay with your luggage at all times.", "Do not let someone else look after your luggage.", "Remember your luggage when you leave."),
              title = "filename_sc",
              prompt = "What does it say?",points = 0,
              feedback = list(new("ModalFeedback", title = "common",
                                  content = list("general feedback"))))

    example <- '<outcomeDeclaration identifier="SCORE" cardinality="single" baseType="float">
<defaultValue>
<value>0</value>
</defaultValue>
</outcomeDeclaration>'
    nodes <- createOutcomeDeclaration(sc)
    xml1 <- xml2::read_xml(toString(nodes[[1]]))
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
})

test_that("Testing additional attribute for item body single choice", {
  sc <- new("SingleChoice",
            content = list("<p>Do you mostly use tea bags or loose tea?</p>",
                           "<p>Choose one option</p>"),
            points = 2,
            identifier = "ID125",
            title = "Question 1",
            choices = c("Tea bags", "Loose tea"),
            orientation = "horizontal",
            solution = 2,
            choice_identifiers = c("ID_1", "ID_2")
            )
  example <- '<itemBody>
		<p>Do you mostly use tea bags or loose tea?</p>
		<p>Choose one option</p>
		<choiceInteraction responseIdentifier=\"RESPONSE\" shuffle=\"true\" maxChoices=\"1\" orientation=\"horizontal\">
			<simpleChoice identifier=\"ID_1\">Tea bags</simpleChoice>
			<simpleChoice identifier=\"ID_2\">Loose tea</simpleChoice>
		</choiceInteraction>
	</itemBody>
            '
  xml1 <- xml2::read_xml(toString(createItemBody(sc)))
  xml2 <- xml2::read_xml(example)
  expect_equal(xml1, xml2)
})
