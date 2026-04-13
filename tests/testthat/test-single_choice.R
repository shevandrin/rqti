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

testthat::skip_if_not_installed("XML")
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

testthat::skip_if_not_installed("XML")
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

testthat::skip_if_not_installed("XML")
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

testthat::skip_if_not_installed("XML")
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
    <responseElse>
      <setOutcomeValue identifier="SCORE">
        <variable identifier="MINSCORE"></variable>
      </setOutcomeValue>
    </responseElse>
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
test_that("Testing the constructor for SingleChoice class", {
    sut <- singleChoice(content = list("Some content"),
                        choices = c("Answer_1","Answer_2","Answer_3"))
    xml_sut <- create_assessment_item(sut)

    expect_no_error(xml2::read_xml(as.character(xml_sut)))
    expect_s4_class(sut, "SingleChoice")
})


test_that("SingleChoice accepts valid scoring_scheme values", {
    sc_standard <- singleChoice(
        prompt = "Question?",
        choices = c("A", "B", "C"),
        scoring_scheme = "standard"
    )

    sc_penalty <- singleChoice(
        prompt = "Question?",
        choices = c("A", "B", "C"),
        scoring_scheme = "penalty"
    )

    expect_equal(sc_standard@scoring_scheme, "standard")
    expect_equal(sc_penalty@scoring_scheme, "penalty")
})


test_that("SingleChoice rejects invalid scoring_scheme values", {
    expect_error(
        singleChoice(
            prompt = "Question?",
            choices = c("A", "B", "C"),
            scoring_scheme = "wrong"
        ),
        "scoring_scheme"
    )
})


test_that("standard scoring_scheme creates zero minscore and no penalty branch", {
    sc <- singleChoice(
        identifier = "sc_standard",
        prompt = "Question?",
        choices = c("A", "B", "C"),
        solution = 1,
        points = 2,
        scoring_scheme = "standard"
    )

    xml <- as.character(createOutcomeDeclaration(sc))

    expect_match(
        xml,
        '<outcomeDeclaration identifier="MAXSCORE"[^>]*>.*<value>2</value>.*</outcomeDeclaration>'
    )

    expect_match(
        xml,
        '<outcomeDeclaration identifier="MINSCORE"[^>]*>.*<value>0</value>.*</outcomeDeclaration>'
    )

    expect_no_match(
        xml,
        '<responseElse>.*<variable identifier="MINSCORE"/>.*</responseElse>'
    )
})


test_that("penalty scoring_scheme creates negative minscore and penalty responseElse", {
    sc <- singleChoice(
        identifier = "sc_penalty",
        prompt = "Question?",
        choices = c("A", "B", "C"),
        solution = 1,
        points = 2,
        scoring_scheme = "penalty"
    )

    xml_outcome <- as.character(createOutcomeDeclaration(sc))
    xml_processing <- as.character(createResponseProcessing(sc))

    expect_match(
        xml_outcome,
        '<outcomeDeclaration identifier="MAXSCORE"[^>]*>.*<value>2</value>.*</outcomeDeclaration>'
    )

    expect_match(
        xml_outcome,
        '<outcomeDeclaration identifier="MINSCORE"[^>]*>.*<value>-1</value>.*</outcomeDeclaration>'
    )

    expect_match(
        xml_processing,
        '<responseElse>.*<setOutcomeValue identifier="SCORE">.*<variable identifier="MINSCORE"(?:\\s*/>|>\\s*</variable>).*</setOutcomeValue>.*</responseElse>'
    )
})
