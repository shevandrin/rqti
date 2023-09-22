source("test_helpers.R")
sc <- new("SingleChoice",
          content = list(paste0("<p>Look at the text in the picture.</p><p>",
                                "<img src=\"images/sign.png\" alt=\"NEVER ",
                                "LEAVE LUGGAGE UNATTENDED\"/></p>")),
          choices = c("You must stay with your luggage at all times.",
                      "Do not let someone else look after your luggage.",
                      "Remember your luggage when you leave."),
          title = "filename_sc",
          prompt = "What does it say?",
          shuffle = FALSE,
          choice_identifiers = c("ID_1", "ID_2", "ID_3"),
          feedback = list(new("ModalFeedback", title = "common",
                              content = list("general feedback"))))

test_that("Test createItemBody() for SingleChoice class", {
  example <- paste0("<itemBody>",
                    "<p>Look at the text in the picture.</p>",
                    "<p><img src=\"images/sign.png\" alt=\"NEVER LEAVE ",
                    "LUGGAGE UNATTENDED\"/></p>",
                    "<choiceInteraction responseIdentifier=\"RESPONSE\" ",
                    "shuffle=\"false\" maxChoices=\"1\" ",
                    "orientation=\"vertical\">",
                    "<prompt>What does it say?</prompt>",
                    "<simpleChoice identifier=\"ID_1\">",
                    "You must stay with your luggage at all times.",
                    "</simpleChoice>",
                    "<simpleChoice identifier=\"ID_2\">",
                    "Do not let someone else look after your luggage.",
                    "</simpleChoice>",
                    "<simpleChoice identifier=\"ID_3\">",
                    "Remember your luggage when you leave.",
                    "</simpleChoice>",
                    "</choiceInteraction>",
                    "</itemBody>")
  sut <- xml2::read_xml(toString(createItemBody(sc)))
  expected <- xml2::read_xml(example)
  equal_xml(sut, expected)
})

test_that("Test createResponseDeclaration()
          for SingleChoice class:solution = 2", {
  sc@solution <- 2
  example <- paste0("<responseDeclaration identifier=\"RESPONSE\" ",
                    "cardinality=\"single\" baseType=\"identifier\">",
                    "<correctResponse>",
                    "<value>ID_2</value>",
                    "</correctResponse>",
                    "</responseDeclaration>")
  sut <- xml2::read_xml(toString(createResponseDeclaration(sc)))
  expected <- xml2::read_xml(example)
  equal_xml(sut, expected)
})

test_that("Test outcomeDeclaration() for SingleChoice class", {
  example <- paste0("<outcomeDeclaration identifier=\"SCORE\" ",
                    "cardinality=\"single\" baseType=\"float\"> ",
                    "<defaultValue>",
                    "<value>0</value>",
                    "</defaultValue>",
                    "</outcomeDeclaration>")

  nodes <- createOutcomeDeclaration(sc)
  sut <- xml2::read_xml(toString(nodes[[1]]))
  expected <- xml2::read_xml(example)
  expect_equal(sut, expected)
})

test_that("Test createItemBody() for SingleChoice class:
          orientation = horizontal", {
  sc@orientation <- "horizontal"
  example <- paste0("<itemBody>",
                    "<p>Look at the text in the picture.</p>",
                    "<p><img src=\"images/sign.png\" ",
                    "alt=\"NEVER LEAVE LUGGAGE UNATTENDED\"/></p>",
                    "<choiceInteraction ",
                    "responseIdentifier=\"RESPONSE\" ",
                    "shuffle=\"false\" maxChoices=\"1\" ",
                    "orientation=\"horizontal\">",
                    "<prompt>What does it say?</prompt>",
                    "<simpleChoice identifier=\"ID_1\">",
                    "You must stay with your luggage at all times.",
                    "</simpleChoice>",
                    "<simpleChoice identifier=\"ID_2\">",
                    "Do not let someone else look after ",
                    "your luggage.",
                    "</simpleChoice>",
                    "<simpleChoice identifier=\"ID_3\">",
                    "Remember your luggage when you leave.",
                    "</simpleChoice>",
                    "</choiceInteraction>",
                    "</itemBody>")

  sut <- xml2::read_xml(toString(createItemBody(sc)))
  expected <- xml2::read_xml(example)
  equal_xml(sut, expected)
          })

test_that("Test createResponseProcessing() for SingleChoice class", {
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
          <variable identifier="MAXSCORE"></variable>
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
</responseProcessing>'

  sut <- xml2::read_xml(toString(createResponseProcessing(sc)))
  expected <- xml2::read_xml(example)
  equal_xml(sut, expected)
})
test_that("Test function for SingleChoice class", {
  sut <- SingleChoice(content = list("<p>Pick up the right option</p>"),
                        choices = c("option 1", "option 2", "option 3",
                                    "option 4"),
                        orientation = "vertical",
                        title = "single_choice_task",
                        prompt = "test",
                        shuffle = FALSE,
                        points = 2,
                        identifier = "sc_example" )
  expected <- new("SingleChoice",
                    content = list("<p>Pick up the right option</p>"),
                    choices = c("option 1", "option 2", "option 3",
                                "option 4"),
                    orientation = "vertical",
                    title = "single_choice_task",
                    prompt = "test",
                    shuffle = FALSE,
                    points = 2,
                    identifier = "sc_example")
  expect_equal(sut, expected)
  expect_true(inherits(sut, "SingleChoice"))
})

test_that("Testing message on invalid xml in SingleChoice class", {
    xml_content <- '<invalid_xml></invalid_xml>'
    doc <- xml2::read_xml(as.character(xml_content))
    verify <- verify_qti(doc)
    expect_false(verify)
})

