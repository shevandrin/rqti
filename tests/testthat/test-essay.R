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
                expectedLength=\"200\"
                data-allowPaste=\"false\">
                <prompt>Write Sam a postcard. Answer the questions. Write 25-35 words.</prompt>
                </extendedTextInteraction>
                </itemBody>
                "

    xml1 <- xml2::read_xml(toString(createItemBody(essay)))
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
})
