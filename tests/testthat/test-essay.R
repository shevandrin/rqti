test_that("Testing createItemBody for the Essay object", {
    essay <- new("Essay",
             content = list("<p>Read this postcard from your English pen-friend, Sam.</p>
                                                <div>
                                                <object type=\"image/png\" data=\"images/postcard.png\">
                                                <blockquote class=\"postcard\">
                                                <p>Here is a postcard of my town. Please send me<br/>a postcard from your town. What size is your<br/>town? What is the nicest part of your town?<br/>Where do you go in the evenings?<br/>Sam.</p>
                                                </blockquote>
                                                </object>
                                                </div>
                                                "),
              title = "extended_text",
              expected_length = 200,
              prompt = "Write Sam a postcard. Answer the questions. Write 25-35 words.")
    example <- "
                <itemBody>
                <p>Read this postcard from your English pen-friend, Sam.</p>
                <div>
                <object type=\"image/png\" data=\"images/postcard.png\">
                <blockquote class=\"postcard\">
                <p>Here is a postcard of my town. Please send me<br/>a postcard from your town. What size is your<br/>town? What is the nicest part of your town?<br/>Where do you go in the evenings?<br/>Sam.</p>
                </blockquote>
                </object>
                </div>
                <extendedTextInteraction responseIdentifier=\"RESPONSE\"
                expectedLength=\"200\">
                <prompt>Write Sam a postcard. Answer the questions. Write 25-35 words.</prompt>
                </extendedTextInteraction>
                </itemBody>
                "

    xml1 <- xml2::read_xml(toString(createItemBody(essay)))
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
})

test_that("Testing attributes values in extendedTextInteraction for Essay
object", {
    essay <- new("Essay",
                 content = list("some question text"),
                 title = "extendedText",
                 expected_length = 100,
                 expected_lines = 10,
                 max_strings = 50,
                 min_strings = 1,
                 data_allow_paste = FALSE)
    example <- "
<itemBody>
  some question text
  <extendedTextInteraction responseIdentifier=\"RESPONSE\"
  expectedLength=\"100\"
  expectedLines=\"10\"
  maxStrings=\"50\"
  minStrings=\"1\"
  data-allowPaste=\"false\"/>
</itemBody>
                "
    xml1 <- xml2::read_xml(toString(createItemBody(essay)))
    xml2 <- xml2::read_xml(toString(example))
    expect_equal(xml1, xml2)
})
test_that("Testing construction function for Essay class", {
    sut <- Essay (content = list("<p>\"Essay\"</p>",
                                 "<i>Essay description</i>"),
                  prompt = "Test task",
                  title = "Essay",
                  identifier = "new")

    example <- new("Essay", content = list("<p>\"Essay\"</p>",
                                           "<i>Essay description</i>"),
                   prompt = "Test task",
                   title = "Essay",
                   identifier = "new")

    expect_s4_class(sut, "Essay")
    expect_equal(sut, example)
})

