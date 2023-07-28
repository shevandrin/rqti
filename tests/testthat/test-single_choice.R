sc <- new("SingleChoice",
          content = list("<p>Look at the text in the picture.</p><p><img src=\"images/sign.png\" alt=\"NEVER LEAVE LUGGAGE UNATTENDED\"/></p>"),
          choices = c("You must stay with your luggage at all times.", "Do not let someone else look after your luggage.", "Remember your luggage when you leave."),
          title = "filename_sc",
          prompt = "What does it say?",
          shuffle = FALSE,
          feedback = list(new("ModalFeedback", title = "common",
                              content = list("general feedback"))))

test_that("Test createItemBody() for SingleChoice-object with valid options", {
    example <- "<itemBody>
    <p>Look at the text in the picture.</p>
    <p><img src=\"images/sign.png\" alt=\"NEVER LEAVE LUGGAGE UNATTENDED\"/></p>
    <choiceInteraction responseIdentifier=\"RESPONSE\" shuffle=\"false\" maxChoices=\"1\" orientation=\"vertical\">
    <prompt>What does it say?</prompt>
    <simpleChoice identifier=\"ChoiceA\">You must stay with your luggage at all times.</simpleChoice>
    <simpleChoice identifier=\"ChoiceB\">Do not let someone else look after your luggage.</simpleChoice>
    <simpleChoice identifier=\"ChoiceC\">Remember your luggage when you leave.</simpleChoice></choiceInteraction></itemBody>"

    sut <- xml2::read_xml(toString(create_item_body_single_choice(sc)))
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)
})

test_that("Testing create_response_declaration_single_choice",{
    example <- '<responseDeclaration identifier="RESPONSE" cardinality="single" baseType="identifier">
<correctResponse>
<value>ChoiceA</value>
</correctResponse>
</responseDeclaration>'

    sut <- xml2::read_xml(toString(create_response_declaration_single_choice(sc)))
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)
})

test_that("Testing outcomeDeclaration for Single Choice",{
    example <- '<outcomeDeclaration identifier="SCORE" cardinality="single" baseType="float">
<defaultValue>
<value>0</value>
</defaultValue>
</outcomeDeclaration>'
    nodes <- createOutcomeDeclaration(sc)

    sut <- xml2::read_xml(toString(nodes[[1]]))
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)
})

test_that("Testing additional attribute for item body single choice", {
  sc@choices <- c("Tea bags", "Loose tea")
  sc@solution <- 2
  sc@choice_identifiers <-  c("ID_1", "ID_2")
  sc@content <- list("<p>Do you mostly use tea bags or loose tea?</p>",
                                             "<p>Choose one option</p>")
  sc@prompt <- ""

  example <- '<itemBody>
		<p>Do you mostly use tea bags or loose tea?</p>
		<p>Choose one option</p>
		<choiceInteraction responseIdentifier=\"RESPONSE\" shuffle=\"false\" maxChoices=\"1\" orientation=\"vertical\">
			<simpleChoice identifier=\"ID_1\">Tea bags</simpleChoice>
			<simpleChoice identifier=\"ID_2\">Loose tea</simpleChoice>
		</choiceInteraction>
	</itemBody>
            '
  sut <- xml2::read_xml(toString(createItemBody(sc)))
  expected <- xml2::read_xml(example)
  expect_equal(sut, expected)
})

# Testing createResponseProcessing() with modal Feedback
test_that("Testing createResponseProcessing() for SingleChoice class", {
    sc@choices <- c("Tea bags", "Loose tea")
    sc@solution <- 2
    sc@choice_identifiers <-  c("ID_1", "ID_2")
    sc@content <- list("<p>Do you mostly use tea bags or loose tea?</p>",
                       "<p>Choose one option</p>")
    sc@prompt <- ""

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
    sut <- xml2::read_xml(toString(createResponseProcessing(sc)))
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)
})

test_that("SingleChoice creates a valid SingleChoice object", {
    # Create a SingleChoice object using the function
    sc@choices <- c("Tea bags", "Loose tea")
    sc@solution <- 2
    sc@choice_identifiers <-  c("ID_1", "ID_2")
    sc@content <- list("<p>Do you mostly use tea bags or loose tea?</p>",
                       "<p>Choose one option</p>")
    sc@prompt <- ""

    # Check that the object is of class "SingleChoice"
    expect_true(inherits(sc, "SingleChoice"))
})

# Define a test for the error case when the points slot has an invalid value
test_that("SingleChoice throws an error for invalid points value", {
    expect_error(SingleChoice(content = list("<p>Pick up the right option</p>"),
        choices = c("option 1", "option 2", "option 3", "option 4"),
        orientation = "vertical",
        title = "single_choice_task",
        shuffle = FALSE,
        points = "f",  # Invalid points value (character instead of numeric)
        identifier = "sc_example"
    ), "invalid object for slot \"points\"")
})
