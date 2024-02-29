source(test_path("test_helpers.R"))
essay <- new("Essay",

             content = list(paste0("<p>Earlier technological developments ",
                                   "brought more benefits and changed ",
                                   "the lives of ordinary people more",
                                   " than recent developments ever will.</p>",
                                   "<p>To what extent do you agree ",
                                   "or disagree?</p>")),
             title = "Example essay IELTS",
             prompt = "Write at least 250 words.",
             expected_length = 250)

test_that("Test createItemBody for the Essay class", {

  example <- '
  <itemBody>
  <p>Earlier technological developments brought more benefits and changed the lives of ordinary people more than recent developments ever will.</p><p>To what extent do you agree or disagree?</p>
  <extendedTextInteraction responseIdentifier="RESPONSE" expectedLength="250">
    <prompt>Write at least 250 words.</prompt>
  </extendedTextInteraction>
  </itemBody>'

  sut <- xml2::read_xml(toString(createItemBody(essay)))
  expected <- xml2::read_xml(example)
  equal_xml(sut, expected)
})

test_that("Test values of attributes in extendedTextInteraction for Essay class", {

  essay@expected_length <- 100
  essay@expected_lines <- 10
  essay@words_max <- 50
  essay@words_min <- 1
  essay@data_allow_paste <- FALSE

  example <-'
  <itemBody>
  <p>Earlier technological developments brought more benefits and changed the lives of ordinary people more than recent developments ever will.</p>
  <p>To what extent do you agree or disagree?</p>
  <extendedTextInteraction responseIdentifier="RESPONSE" expectedLength="100" expectedLines="10" maxStrings="50" minStrings="1" class=\"essay-nocopypaste\" data-allowPaste="false">
    <prompt>Write at least 250 words.</prompt>
  </extendedTextInteraction>
  </itemBody>'

  sut <- xml2::read_xml(toString(createItemBody(essay)))
  expected <- xml2::read_xml(toString(example))
  equal_xml(sut, expected)
})

test_that("Test the warning message of the feedback in Essay class", {
  essay@feedback <- list(new("CorrectFeedback", title = "correct",
                               content = list("positeve feedback")))
  expect_error({initialize(essay)},
               "Only general feedback is possible for this type of task")
})

test_that("Testing of set default max count of words and
          default size as expected length parameter of the feedback",{
  essay@feedback <- list(new("ModalFeedback", title = "correct",
                           content = list("General feedback for Essay")))
  essay@expected_length <- numeric(0)

  sut<- initialize(essay)

  expect_equal(sut@words_max, 8)
  expect_equal(sut@expected_length, 24)
  expect_equal(sut@expected_lines, 1)
})
