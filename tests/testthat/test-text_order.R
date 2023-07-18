test_that("Testing createItemBody for Order questions", {
    question <- new("Order",
                 content = list(""),
                 title = "Grand Prix of Bahrain",
                 prompt = "The following F1 drivers finished on the podium in the first ever Grand Prix of Bahrain. Can you rearrange them into the correct finishing order?",
                 choices = c("Rubens Barrichello", "Jenson Button",
                             "Michael Schumacher"),
                 points = 0.5,
                 choices_identifiers = c("DriverA","DriverB","DriverC"),
                 shuffle = TRUE)
    example <- '<itemBody>
<orderInteraction responseIdentifier="RESPONSE" shuffle="true">
<prompt>The following F1 drivers finished on the podium in the first ever Grand Prix of Bahrain. Can you rearrange them into the correct finishing order?</prompt>
<simpleChoice identifier="DriverA">Rubens Barrichello</simpleChoice>
<simpleChoice identifier="DriverB">Jenson Button</simpleChoice>
<simpleChoice identifier="DriverC">Michael Schumacher</simpleChoice>
</orderInteraction>
</itemBody>'

    sut <- xml2::read_xml(toString(createItemBody(question)))
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)
})

test_that("Testing ResponseDeclaration for Order questions", {
    question <- new("Order",
                 content = list(""),
                 title = "Grand Prix of Bahrain",
                 prompt = "The following F1 drivers finished on the podium in the first ever Grand Prix of Bahrain. Can you rearrange them into the correct finishing order?",
                 choices = c("Michael Schumacher","Jenson Button","Rubens Barrichello"),
                 points = 0.5,
                 choices_identifiers = c("DriverA","DriverB","DriverC"),
                 shuffle = TRUE)
    example <- '<responseDeclaration identifier="RESPONSE" cardinality="ordered" baseType="identifier">
<correctResponse>
<value>DriverA</value>
<value>DriverB</value>
<value>DriverC</value>
</correctResponse>
</responseDeclaration>'

    sut <- xml2::read_xml(toString(createResponseDeclaration(question)))
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)
})

test_that("Testing OutcomeDeclaration for Order questions", {
    question <- new("Order",
                    content = list(""),
                    title = "Grand Prix of Bahrain",
                    prompt = "The following F1 drivers finished on the podium in the first ever Grand Prix of Bahrain. Can you rearrange them into the correct finishing order?",
                    choices = c("Michael Schumacher","Jenson Button","Rubens Barrichello"),
                    points = 2.5,
                    choices_identifiers = c("DriverA","DriverB","DriverC"),
                    shuffle = TRUE)

# The example was taken from OPAL, the original qti example does not have score.

    example <- '<additionalTag>
<outcomeDeclaration identifier="SCORE" cardinality="single" baseType="float">
<defaultValue>
<value>0</value>
</defaultValue>
</outcomeDeclaration>
<outcomeDeclaration identifier="MAXSCORE" cardinality="single" baseType="float">
<defaultValue>
<value>2.5</value>
</defaultValue>
</outcomeDeclaration>
<outcomeDeclaration identifier="MINSCORE" cardinality="single" baseType="float">
<defaultValue>
<value>0</value>
</defaultValue>
</outcomeDeclaration>
    </additionalTag>'

    responseDe <- paste('<additionalTag>',
                        toString(createOutcomeDeclaration(question)),
                        '</additionalTag>')
    sut <- xml2::read_xml(responseDe)
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)
})

# Testing Order class without choices_identifiers for Order class
test_that("Testing Order class", {
    question <- new("Order",
                    content = list(""),
                    title = "Grand Prix of Bahrain",
                    prompt = "The following F1 drivers finished on the podium in the first ever Grand Prix of Bahrain. Can you rearrange them into the correct finishing order?",
                    choices = c("Michael Schumacher","Jenson Button","Rubens Barrichello"),
                    points = 0.5,
                    shuffle = TRUE)
    example <- '<responseDeclaration identifier="RESPONSE" cardinality="ordered" baseType="identifier">
<correctResponse>
<value>ChoiceA</value>
<value>ChoiceB</value>
<value>ChoiceC</value>
</correctResponse>
</responseDeclaration>'

    sut <- xml2::read_xml(toString(createResponseDeclaration(question)))
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)
})

# Testing with modal Feedback
test_that("Testing createResponseProcessing() for Order class", {
    question <- new("Order",
                    content = list(""),
                    title = "Grand Prix of Bahrain",
                    prompt = "The following F1 drivers finished on the podium in the first ever Grand Prix of Bahrain. Can you rearrange them into the correct finishing order?",
                    choices = c("Michael Schumacher","Jenson Button",
                                "Rubens Barrichello"),
                    points = 2.5,
                    choices_identifiers = c("DriverA","DriverB","DriverC"),
                    shuffle = TRUE,
                    feedback = list(new("ModalFeedback", title = "common",
                                        content = list("general feedback"))),
                    points_per_answer = FALSE)
    example <- '<additionalTag>
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
    </additionalTag>'

    responseDe <- paste(
        '<additionalTag>',
        toString(createResponseProcessing(question)),'</additionalTag>')
    sut <- xml2::read_xml(responseDe)
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)
})
