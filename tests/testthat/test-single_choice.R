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
            shuffle = FALSE,
            identifier = "ID125",
            title = "Question 1",
            choices = c("Tea bags", "Loose tea"),
            solution = 2,
            choice_identifiers = c("ID_1", "ID_2")
            )
  example <- '<itemBody>
		<p>Do you mostly use tea bags or loose tea?</p>
		<p>Choose one option</p>
		<choiceInteraction responseIdentifier=\"RESPONSE\" shuffle=\"false\" maxChoices=\"1\" orientation=\"vertical\">
			<simpleChoice identifier=\"ID_1\">Tea bags</simpleChoice>
			<simpleChoice identifier=\"ID_2\">Loose tea</simpleChoice>
		</choiceInteraction>
	</itemBody>
            '
  xml1 <- xml2::read_xml(toString(createItemBody(sc)))
  xml2 <- xml2::read_xml(example)
  expect_equal(xml1, xml2)
})
# Testing createResponseProcessing() with modal Feedback
test_that("Testing createResponseProcessing() for SingleChoice class", {
    sc <- new("SingleChoice",
              content = list("<p>Do you mostly use tea bags or loose tea?</p>",
                             "<p>Choose one option</p>"),
              points = 2,
              identifier = "ID125",
              title = "Question 1",
              choices = c("Tea bags", "Loose tea"),
              # orientation = "horizontal",
              solution = 2,
              choice_identifiers = c("ID_1", "ID_2"),
              feedback = list(new("ModalFeedback", title = "common",
                                  content = list("general feedback"))))
    example <- '
    <responseProcessing>
  <responseCondition>
    <responseIf>
      <isNull>
        <variable identifier="RESPONSE"></variable>
      </isNull>
    </responseIf>
    <responseElseIf>
      <match>
        <variable identifier="RESPONSE"></variable>
        <correct identifier="RESPONSE"></correct>
      </match>
      <setOutcomeValue identifier="SCORE">
        <sum>
          <variable identifier="SCORE"></variable>
          <variable identifier="MAXSCORE"></variable>
        </sum>
      </setOutcomeValue>
    </responseElseIf>
  </responseCondition>
  <responseCondition>
    <responseIf>
      <gt>
        <variable identifier="SCORE"></variable>
        <variable identifier="MAXSCORE"></variable>
      </gt>
      <setOutcomeValue identifier="SCORE">
        <variable identifier="MAXSCORE"></variable>
      </setOutcomeValue>
    </responseIf>
  </responseCondition>
  <responseCondition>
    <responseIf>
      <lt>
        <variable identifier="SCORE"></variable>
        <variable identifier="MINSCORE"></variable>
      </lt>
      <setOutcomeValue identifier="SCORE">
        <variable identifier="MINSCORE"></variable>
      </setOutcomeValue>
    </responseIf>
  </responseCondition>
  <responseCondition>
    <responseIf>
      <isNull>
        <variable identifier="RESPONSE"></variable>
      </isNull>
      <setOutcomeValue identifier="FEEDBACKBASIC">
        <baseValue baseType="identifier">empty</baseValue>
      </setOutcomeValue>
    </responseIf>
    <responseElseIf>
      <lt>
        <variable identifier="SCORE"></variable>
        <variable identifier="MAXSCORE"></variable>
      </lt>
      <setOutcomeValue identifier="FEEDBACKBASIC">
        <baseValue baseType="identifier">incorrect</baseValue>
      </setOutcomeValue>
    </responseElseIf>
    <responseElse>
      <setOutcomeValue identifier="FEEDBACKBASIC">
        <baseValue baseType="identifier">correct</baseValue>
      </setOutcomeValue>
    </responseElse>
  </responseCondition>
  <responseCondition>
    <responseIf>
      <and>
        <gte>
          <variable identifier="SCORE"></variable>
          <baseValue baseType="float">0</baseValue>
        </gte>
      </and>
      <setOutcomeValue identifier="FEEDBACKMODAL">
        <multiple>
          <variable identifier="FEEDBACKMODAL"></variable>
          <baseValue baseType="identifier">modal_feedback</baseValue>
        </multiple>
      </setOutcomeValue>
    </responseIf>
  </responseCondition>
</responseProcessing>
            '
    xml1 <- xml2::read_xml(toString(createResponseProcessing(sc)))
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
})
