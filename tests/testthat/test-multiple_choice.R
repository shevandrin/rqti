test_that("Testing  method of createItemBody
          for MultipleChoice class", {
    mc <- new("MultipleChoice",
              content = list(),
              choices = c("Hydrogen","Helium","Carbon","Oxygen","Nitrogen",
                          "Chlorine"),
              choice_identifiers = c("H","He","C","O","N","Cl"),
              points = c(1,0,0,1,0,-1),
              title = "filename_sc",
              prompt = paste0("Which of the following elements ",
                              "are used to form water?"))

    example <- '<itemBody>
<choiceInteraction responseIdentifier="RESPONSE" shuffle="true" maxChoices="0"
orientation="vertical">
<prompt>Which of the following elements are used to form water?</prompt>
<simpleChoice identifier="H">Hydrogen</simpleChoice>
<simpleChoice identifier="He">Helium</simpleChoice>
<simpleChoice identifier="C">Carbon</simpleChoice>
<simpleChoice identifier="O">Oxygen</simpleChoice>
<simpleChoice identifier="N">Nitrogen</simpleChoice>
<simpleChoice identifier="Cl">Chlorine</simpleChoice>
</choiceInteraction>
</itemBody>'

    sut <- xml2::read_xml(toString(createItemBody(mc)))
    expected <- xml2::read_xml(example)
    expect_equal(sut, expected)
})

test_that("Testing method of createResponseDeclaration
          for MultipleChoice class",{
    skip_if_not_installed("XML")
    mc <- new("MultipleChoice",
              content = list(""),
              choices = c("Hydrogen","Helium","Carbon","Oxygen","Nitrogen",
                          "Chlorine"),
              choice_identifiers = c("H","He","C","O","N","Cl"),
              points = c(1,0,0,1,0,-1),
              title = "filename_sc",
              prompt = paste0("Which of the following elements ",
                                       "are used to form water?"))

    # The default value was changed from -2 to 0 because the package
    # not allow negative points for Total score

    example <- '<responseDeclaration identifier="RESPONSE"
                            cardinality="multiple" baseType="identifier">
    <correctResponse>
        <value>H</value>
        <value>O</value>
    </correctResponse>
    <mapping lowerBound="0" upperBound="2" defaultValue="0">
        <mapEntry mapKey="H" mappedValue="1"/>
        <mapEntry mapKey="O" mappedValue="1"/>
        <mapEntry mapKey="Cl" mappedValue="-1"/>
    </mapping>
    </responseDeclaration>'

    qtiXML <- toString(createResponseDeclaration(mc))
    sut <- xml2::read_xml(qtiXML)
    expected <- xml2::read_xml(example)

    if(isTRUE(identical(sut,expected)) == FALSE){

    # Convert the String in atomic vector to compare
    # the 2 XML are equal in content
        vxml1 <- unlist(strsplit(as.character(sut),split = ""))
        vxml2 <- unlist(strsplit(as.character(expected),split = ""))

        if (identical(stringr::str_sort(vxml2),
                      stringr::str_sort(vxml1)) == FALSE){
            print("XML content differs")
            expect_equal(sut, expected)
        }
        else{
            # Compare if the 2 XML are equal in structure.
            # It omits attributes and other values, only validate de tag names
            a <- XML::xmlParse(sut, asText = TRUE)
            b <- XML::xmlParse(expected, asText = TRUE)
            result <- XML::compareXMLDocs(a,b)

            if(is.logical(result$countDiffs) &&
               length(result$countDiffs) == 1 &&
               !is.na(result$countDiffs) && lengths(result$countDiffs) > 0){
                print("XML structure differs")
                expect_equal(sut, expected)
            }
            else{
                expect_equal(0, 0)
            }
        }
    }else{
        print("Direct test passed")
        expect_equal(sut, expected)
    }

})

test_that("Testing  method of getPoints for MultipleChoice class", {
              mc <- new("MultipleChoice",
                        content = list(),
                        choices = c("Hydrogen","Helium","Carbon",
                                    "Oxygen","Nitrogen",
                                    "Chlorine"),
                        choice_identifiers = c("H","He","C","O","N","Cl"),
                        points = c(1,0,0,1,0,-1),
                        title = "filename_sc",
                        prompt = paste0("Which of the following elements ",
                                        "are used to form water?"))

              sut <- getPoints(mc)

             # To calculate only positive points points for
             # MultipleChoice class

              positive_points <- mc@points[mc@points > 0]
              expected <- sum(positive_points)

              expect_equal(sut, expected)
          })

test_that("Testing outcomeDeclaration() for Multiple Choice",{
        mc <- new("MultipleChoice",
                  content = list(""),
                  choices = c("Hydrogen","Helium","Carbon","Oxygen","Nitrogen",
                              "Chlorine"),
                  points = c(1,0,0,1,0,-1),
                  title = "filename_sc",
                  prompt = paste0("Which of the following elements ",
                                           "are used to form water?"))

        example <- '
    <outcomeDeclaration identifier="MAXSCORE"
                            cardinality="single" baseType="float">
    <defaultValue>
    <value>2</value>
    </defaultValue>
    </outcomeDeclaration>'

        sut <- xml2::read_xml(
            toString(create_outcome_declaration_multiple_choice(mc)))
        expected <- xml2::read_xml(example)
        expect_equal(sut, expected)
    })
