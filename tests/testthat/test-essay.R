test_that("Testing createItemBody for the Essay object", {
    essay <- new("Essay",
              text = new("Text", content = list("<p>Read this postcard from your English pen-friend, Sam.</p>
                                                <div>
                                                <object type=\"image/png\" data=\"images/postcard.png\">
                                                <blockquote class=\"postcard\">
                                                <p>Here is a postcard of my town. Please send me<br/>a postcard from your town. What size is your<br/>town? What is the nicest part of your town?<br/>Where do you go in the evenings?<br/>Sam.</p>
                                                </blockquote>
                                                </object>
                                                </div>
                                                ")),
              title = "extendedText",
              expectedLength = 200,
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
                 text = new("Text", content = list("some question text")),
                 title = "extendedText",
                 expectedLength = 100,
                 expectedLines = 10,
                 maxStrings = 50,
                 minStrings = 1,
                 dataAllowPaste = FALSE)
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

test_that("XML validation with schema file", {
    essay <- new("Essay",
                 text = new("Text", content = list("<p>some question text</p>")),
                 title = "extendedText",
                 expectedLength = 100,
                 expectedLines = 10,
                 maxStrings = 50,
                 minStrings = 1)
    doc <- xml2::read_xml(toString(create_assessment_item(essay)))
    file <- file.path(getwd(), "imsqti_v2p1.xsd")
    schema <- xml2::read_xml(file)
    validation <- xml2::xml_validate(doc, schema)
    expect_equal(validation[1], TRUE)
})
