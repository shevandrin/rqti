test_that("Testing method createOutcomeDeclaration()
          for AssessmentTest class", {
    mc1 <- new("MultipleChoice",
               identifier = "q1", prompt = "What does 3/4 + 1/4 = ?",
               title = "MultipleChoice",
               choices = c("1", "4/8", "8/4", "4/4"),
               choice_identifiers = c("1", "2", "3", "4"),
               points = c(1, 0, 0, 1))
    sc2 <- new("SingleChoice",
               prompt = "What is the percentage of 3/20?",
               title = "SingleChoice",
               choices = c("15%", "20%", "30%"),
               choice_identifiers = "1",
               identifier = "q2")
    mc3 <- new("MultipleChoice",
               identifier = "q3",
               prompt = "3 + 4b = 15. What is the value of b in this equation?",
               title = "MultipleChoice",
               choices = c("3", "2", "5", "6/2"),
               choice_identifiers = c("1", "2", "3", "4"),
               points = c(1, 0, 0, 1)
    )
    order1 <- new("Ordering",
                  identifier = "q4",
                  title = "Order",
                  prompt = "Choose the correct order",
                  choices = c("Data collection", "Data cleansing",
                              "Data marking", "Verification and visualization"),
                  choices_identifiers = c("1", "2", "3", "4"),
                  points = 1
    )
    exam_section <- new("AssessmentSection",
                        identifier = "sec_id",
                        title = "section",
                        assessment_item = list(mc1, sc2, mc3, order1)
    )
    exam <- new("AssessmentTest",
                identifier = "id_test",
                academic_grading = NA_real_,
                # exclude "title"
                section = list(exam_section)
                )

    example <- "<additionalTag>
<outcomeDeclaration identifier=\"SCORE\" cardinality=\"single\" baseType=\"float\">
  <defaultValue>
    <value>0</value>
  </defaultValue>
</outcomeDeclaration>
<outcomeDeclaration identifier=\"MAXSCORE\" cardinality=\"single\" baseType=\"float\">
  <defaultValue>
    <value>6</value>
  </defaultValue>
</outcomeDeclaration>
<outcomeDeclaration identifier=\"MINSCORE\" cardinality=\"single\" baseType=\"float\">
	<defaultValue>
	<value>0</value>
  </defaultValue>
</outcomeDeclaration>
    </additionalTag>"

    expected <- paste('<additionalTag>', toString(createOutcomeDeclaration(exam)),'</additionalTag>')
    xml1 <- xml2::read_xml(expected)
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
})

test_that("Testing method createOutcomeDeclaration() with
           academic_grading = TRUE for AssessmentTest class", {
               mc1 <- new("MultipleChoice",
                          identifier = "q1", prompt = "What does 3/4 + 1/4 = ?",
                          title = "MultipleChoice",
                          choices = c("1", "4/8", "8/4", "4/4"),
                          choice_identifiers = c("1", "2", "3", "4"),
                          points = c(1, 0, 0, 1))
               sc2 <- new("SingleChoice",
                          prompt = "What is the percentage of 3/20?",
                          title = "SingleChoice",
                          choices = c("15%", "20%", "30%"),
                          choice_identifiers = "1",
                          identifier = "q2")
               mc3 <- new("MultipleChoice",
                          identifier = "q3",
                          prompt = "3 + 4b = 15. What is the value of b in this equation?",
                          title = "MultipleChoice",
                          choices = c("3", "2", "5", "6/2"),
                          choice_identifiers = c("1", "2", "3", "4"),
                          points = c(1, 0, 0, 1)
               )
               order1 <- new("Ordering",
                             identifier = "q4",
                             title = "Order",
                             prompt = "Choose the correct order",
                             choices = c("Data collection", "Data cleansing",
                                         "Data marking", "Verification and visualization"),
                             choices_identifiers = c("1", "2", "3", "4"),
                             points = 1
               )
               exam_section <- new("AssessmentSection",
                                   identifier = "sec_id",
                                   title = "section",
                                   assessment_item = list(mc1, sc2, mc3, order1)
               )
               exam <- new("AssessmentTest",
                           identifier = "id_test",
                           section = list(exam_section)
               )

               example <- "<additionalTag>
<assessmentTest xmlns=\"http://www.imsglobal.org/xsd/imsqti_v2p1\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.imsglobal.org/xsd/imsqti_v2p1 http://www.imsglobal.org/xsd/qti/qtiv2p1/imsqti_v2p1.xsd\" identifier=\"id_test\" title=\"id_test\">
		<outcomeDeclaration identifier=\"SCORE\" cardinality=\"single\" baseType=\"float\">
			<defaultValue>
				<value>0</value>
			</defaultValue>
		</outcomeDeclaration>
        <outcomeDeclaration identifier=\"FEEDBACKMODAL\" cardinality=\"multiple\" baseType=\"identifier\" view=\"testConstructor\"/>
        <outcomeDeclaration identifier=\"FEEDBACKTABLE\" cardinality=\"multiple\" baseType=\"identifier\" view=\"testConstructor\"/>
        <outcomeDeclaration identifier=\"MAXSCORE\" cardinality=\"single\" baseType=\"float\">
    <defaultValue>
      <value>6</value>
    </defaultValue>
  </outcomeDeclaration>
		<outcomeDeclaration identifier=\"MINSCORE\" cardinality=\"single\" baseType=\"float\">
			<defaultValue>
				<value>0</value>
			</defaultValue>
		</outcomeDeclaration>
		<testPart identifier=\"test_part\" navigationMode=\"nonlinear\" submissionMode=\"individual\">
			<itemSessionControl allowComment=\"true\"/>
			<assessmentSection identifier=\"sec_id\" fixed=\"false\" title=\"section\" visible=\"true\">
				<itemSessionControl allowComment=\"true\"/>
				<assessmentItemRef identifier=\"q1\" href=\"q1.xml\"/>
				<assessmentItemRef identifier=\"q2\" href=\"q2.xml\"/>
				<assessmentItemRef identifier=\"q3\" href=\"q3.xml\"/>
				<assessmentItemRef identifier=\"q4\" href=\"q4.xml\"/>
			</assessmentSection>
		</testPart>
		<outcomeProcessing>
			<setOutcomeValue identifier=\"SCORE\">
				<sum>
					<testVariables variableIdentifier=\"SCORE\"/>
				</sum>
			</setOutcomeValue>
			<outcomeCondition>
				<outcomeIf>
					<and>
						<lt>
							<variable identifier=\"SCORE\"/>
							<baseValue baseType=\"float\">3.00</baseValue>
						</lt>
					</and>
					<setOutcomeValue identifier=\"FEEDBACKMODAL\">
						<multiple>
							<variable identifier=\"FEEDBACKMODAL\"/>
							<baseValue baseType=\"identifier\">feedback_grade_50</baseValue>
						</multiple>
					</setOutcomeValue>
				</outcomeIf>
			</outcomeCondition>
			<outcomeCondition>
				<outcomeIf>
					<and>
						<gte>
							<variable identifier=\"SCORE\"/>
							<baseValue baseType=\"float\">3.00</baseValue>
						</gte>
						<lt>
							<variable identifier=\"SCORE\"/>
							<baseValue baseType=\"float\">3.30</baseValue>
						</lt>
					</and>
					<setOutcomeValue identifier=\"FEEDBACKMODAL\">
						<multiple>
							<variable identifier=\"FEEDBACKMODAL\"/>
							<baseValue baseType=\"identifier\">feedback_grade_40</baseValue>
						</multiple>
					</setOutcomeValue>
				</outcomeIf>
			</outcomeCondition>
			<outcomeCondition>
				<outcomeIf>
					<and>
						<gte>
							<variable identifier=\"SCORE\"/>
							<baseValue baseType=\"float\">3.30</baseValue>
						</gte>
						<lt>
							<variable identifier=\"SCORE\"/>
							<baseValue baseType=\"float\">3.60</baseValue>
						</lt>
					</and>
					<setOutcomeValue identifier=\"FEEDBACKMODAL\">
						<multiple>
							<variable identifier=\"FEEDBACKMODAL\"/>
							<baseValue baseType=\"identifier\">feedback_grade_37</baseValue>
						</multiple>
					</setOutcomeValue>
				</outcomeIf>
			</outcomeCondition>
			<outcomeCondition>
				<outcomeIf>
					<and>
						<gte>
							<variable identifier=\"SCORE\"/>
							<baseValue baseType=\"float\">3.60</baseValue>
						</gte>
						<lt>
							<variable identifier=\"SCORE\"/>
							<baseValue baseType=\"float\">3.90</baseValue>
						</lt>
					</and>
					<setOutcomeValue identifier=\"FEEDBACKMODAL\">
						<multiple>
							<variable identifier=\"FEEDBACKMODAL\"/>
							<baseValue baseType=\"identifier\">feedback_grade_33</baseValue>
						</multiple>
					</setOutcomeValue>
				</outcomeIf>
			</outcomeCondition>
			<outcomeCondition>
				<outcomeIf>
					<and>
						<gte>
							<variable identifier=\"SCORE\"/>
							<baseValue baseType=\"float\">3.90</baseValue>
						</gte>
						<lt>
							<variable identifier=\"SCORE\"/>
							<baseValue baseType=\"float\">4.20</baseValue>
						</lt>
					</and>
					<setOutcomeValue identifier=\"FEEDBACKMODAL\">
						<multiple>
							<variable identifier=\"FEEDBACKMODAL\"/>
							<baseValue baseType=\"identifier\">feedback_grade_30</baseValue>
						</multiple>
					</setOutcomeValue>
				</outcomeIf>
			</outcomeCondition>
			<outcomeCondition>
				<outcomeIf>
					<and>
						<gte>
							<variable identifier=\"SCORE\"/>
							<baseValue baseType=\"float\">4.20</baseValue>
						</gte>
						<lt>
							<variable identifier=\"SCORE\"/>
							<baseValue baseType=\"float\">4.50</baseValue>
						</lt>
					</and>
					<setOutcomeValue identifier=\"FEEDBACKMODAL\">
						<multiple>
							<variable identifier=\"FEEDBACKMODAL\"/>
							<baseValue baseType=\"identifier\">feedback_grade_27</baseValue>
						</multiple>
					</setOutcomeValue>
				</outcomeIf>
			</outcomeCondition>
			<outcomeCondition>
				<outcomeIf>
					<and>
						<gte>
							<variable identifier=\"SCORE\"/>
							<baseValue baseType=\"float\">4.50</baseValue>
						</gte>
						<lt>
							<variable identifier=\"SCORE\"/>
							<baseValue baseType=\"float\">4.80</baseValue>
						</lt>
					</and>
					<setOutcomeValue identifier=\"FEEDBACKMODAL\">
						<multiple>
							<variable identifier=\"FEEDBACKMODAL\"/>
							<baseValue baseType=\"identifier\">feedback_grade_23</baseValue>
						</multiple>
					</setOutcomeValue>
				</outcomeIf>
			</outcomeCondition>
			<outcomeCondition>
				<outcomeIf>
					<and>
						<gte>
							<variable identifier=\"SCORE\"/>
							<baseValue baseType=\"float\">4.80</baseValue>
						</gte>
						<lt>
							<variable identifier=\"SCORE\"/>
							<baseValue baseType=\"float\">5.10</baseValue>
						</lt>
					</and>
					<setOutcomeValue identifier=\"FEEDBACKMODAL\">
						<multiple>
							<variable identifier=\"FEEDBACKMODAL\"/>
							<baseValue baseType=\"identifier\">feedback_grade_20</baseValue>
						</multiple>
					</setOutcomeValue>
				</outcomeIf>
			</outcomeCondition>
			<outcomeCondition>
				<outcomeIf>
					<and>
						<gte>
							<variable identifier=\"SCORE\"/>
							<baseValue baseType=\"float\">5.10</baseValue>
						</gte>
						<lt>
							<variable identifier=\"SCORE\"/>
							<baseValue baseType=\"float\">5.40</baseValue>
						</lt>
					</and>
					<setOutcomeValue identifier=\"FEEDBACKMODAL\">
						<multiple>
							<variable identifier=\"FEEDBACKMODAL\"/>
							<baseValue baseType=\"identifier\">feedback_grade_17</baseValue>
						</multiple>
					</setOutcomeValue>
				</outcomeIf>
			</outcomeCondition>
			<outcomeCondition>
				<outcomeIf>
					<and>
						<gte>
							<variable identifier=\"SCORE\"/>
							<baseValue baseType=\"float\">5.40</baseValue>
						</gte>
						<lt>
							<variable identifier=\"SCORE\"/>
							<baseValue baseType=\"float\">5.70</baseValue>
						</lt>
					</and>
					<setOutcomeValue identifier=\"FEEDBACKMODAL\">
						<multiple>
							<variable identifier=\"FEEDBACKMODAL\"/>
							<baseValue baseType=\"identifier\">feedback_grade_13</baseValue>
						</multiple>
					</setOutcomeValue>
				</outcomeIf>
			</outcomeCondition>
			<outcomeCondition>
				<outcomeIf>
					<and>
						<gte>
							<variable identifier=\"SCORE\"/>
							<baseValue baseType=\"float\">5.70</baseValue>
						</gte>
					</and>
					<setOutcomeValue identifier=\"FEEDBACKMODAL\">
						<multiple>
							<variable identifier=\"FEEDBACKMODAL\"/>
							<baseValue baseType=\"identifier\">feedback_grade_10</baseValue>
						</multiple>
					</setOutcomeValue>
				</outcomeIf>
			</outcomeCondition>
		<outcomeCondition>
            <outcomeIf>
            <and>
          <gte>
            <variable identifier=\"SCORE\"></variable>
            <baseValue baseType=\"float\">0</baseValue>
          </gte>
        </and>
        <setOutcomeValue identifier=\"FEEDBACKTABLE\">
          <multiple>
            <variable identifier=\"FEEDBACKTABLE\"></variable>
            <baseValue baseType=\"identifier\">feedback_grade_table</baseValue>
          </multiple>
        </setOutcomeValue>
      </outcomeIf>
    </outcomeCondition>
		</outcomeProcessing>
		<testFeedback identifier=\"feedback_grade_50\" outcomeIdentifier=\"FEEDBACKMODAL\" showHide=\"show\" access=\"atEnd\">
			<p>Grade 5.0</p>\n  </testFeedback>
		<testFeedback identifier=\"feedback_grade_40\" outcomeIdentifier=\"FEEDBACKMODAL\" showHide=\"show\" access=\"atEnd\">
			<p>Grade 4.0</p>\n  </testFeedback>\n  <testFeedback identifier=\"feedback_grade_37\" outcomeIdentifier=\"FEEDBACKMODAL\" showHide=\"show\" access=\"atEnd\">\n    <p>Grade 3.7</p>
		</testFeedback>
		<testFeedback identifier=\"feedback_grade_33\" outcomeIdentifier=\"FEEDBACKMODAL\" showHide=\"show\" access=\"atEnd\">
			<p>Grade 3.3</p>
		</testFeedback>
		<testFeedback identifier=\"feedback_grade_30\" outcomeIdentifier=\"FEEDBACKMODAL\" showHide=\"show\" access=\"atEnd\">
			<p>Grade 3.0</p>
		</testFeedback>
		<testFeedback identifier=\"feedback_grade_27\" outcomeIdentifier=\"FEEDBACKMODAL\" showHide=\"show\" access=\"atEnd\">
			<p>Grade 2.7</p>
		</testFeedback>
		<testFeedback identifier=\"feedback_grade_23\" outcomeIdentifier=\"FEEDBACKMODAL\" showHide=\"show\" access=\"atEnd\">
			<p>Grade 2.3</p>
		</testFeedback>
		<testFeedback identifier=\"feedback_grade_20\" outcomeIdentifier=\"FEEDBACKMODAL\" showHide=\"show\" access=\"atEnd\">
			<p>Grade 2.0</p>
		</testFeedback>
		<testFeedback identifier=\"feedback_grade_17\" outcomeIdentifier=\"FEEDBACKMODAL\" showHide=\"show\" access=\"atEnd\">
			<p>Grade 1.7</p>
		</testFeedback>
		<testFeedback identifier=\"feedback_grade_13\" outcomeIdentifier=\"FEEDBACKMODAL\" showHide=\"show\" access=\"atEnd\">
			<p>Grade 1.3</p>
		</testFeedback>
		<testFeedback identifier=\"feedback_grade_10\" outcomeIdentifier=\"FEEDBACKMODAL\" showHide=\"show\" access=\"atEnd\">
			<p>Grade 1.0</p>
		</testFeedback>
		<testFeedback identifier=\"feedback_grade_table\" outcomeIdentifier=\"FEEDBACKTABLE\" showHide=\"show\" access=\"atEnd\">
    <table class=\"table\" style=\"width: auto !important; \">
      <thead>
        <tr>
          <th style=\"text-align:left;\"> Grade </th>
          <th style=\"text-align:left;\"> Min </th>
          <th style=\"text-align:left;\"> Max </th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td  style=\"text-align:left;\"> 1.0 </td>
          <td  style=\"text-align:left;\"> 5.70 </td>
          <td  style=\"text-align:left;\"> 6.00 </td>
        </tr>
        <tr>
          <td  style=\"text-align:left;\"> 1.3 </td>
          <td  style=\"text-align:left;\"> 5.40 </td>
          <td  style=\"text-align:left;\"> 5.69 </td>
        </tr>
        <tr>
          <td  style=\"text-align:left;\"> 1.7 </td>
          <td  style=\"text-align:left;\"> 5.10 </td>
          <td  style=\"text-align:left;\"> 5.39 </td>
        </tr>
        <tr>
          <td  style=\"text-align:left;\"> 2.0 </td>
          <td  style=\"text-align:left;\"> 4.80 </td>
          <td  style=\"text-align:left;\"> 5.09 </td>
        </tr>
        <tr>
          <td  style=\"text-align:left;\"> 2.3 </td>
          <td  style=\"text-align:left;\"> 4.50 </td>
          <td  style=\"text-align:left;\"> 4.79 </td>
        </tr>
        <tr>
          <td  style=\"text-align:left;\"> 2.7 </td>
          <td  style=\"text-align:left;\"> 4.20 </td>
          <td  style=\"text-align:left;\"> 4.49 </td>
        </tr>
        <tr>
          <td  style=\"text-align:left;\"> 3.0 </td>
          <td  style=\"text-align:left;\"> 3.90 </td>
          <td  style=\"text-align:left;\"> 4.19 </td>
        </tr>
        <tr>
          <td  style=\"text-align:left;\"> 3.3 </td>
          <td  style=\"text-align:left;\"> 3.60 </td>
          <td  style=\"text-align:left;\"> 3.89 </td>
        </tr>
        <tr>
          <td  style=\"text-align:left;\"> 3.7 </td>
          <td  style=\"text-align:left;\"> 3.30 </td>
          <td  style=\"text-align:left;\"> 3.59 </td>
        </tr>
        <tr>
          <td  style=\"text-align:left;\"> 4.0 </td>
          <td  style=\"text-align:left;\"> 3.00 </td>
          <td  style=\"text-align:left;\"> 3.29 </td>
        </tr>
        <tr>
          <td  style=\"text-align:left;\"> 5.0 </td>
          <td  style=\"text-align:left;\"> 0.00 </td>
          <td  style=\"text-align:left;\"> 2.99 </td>
        </tr>
      </tbody>
    </table>
  </testFeedback>
</assessmentTest>
</additionalTag>"

    expected <- paste('<additionalTag>', toString(create_assessment_test(exam, "to_delete")),'</additionalTag>')
    xml1 <- xml2::read_xml(expected)
    xml2 <- xml2::read_xml(example)
    expect_equal(xml1, xml2)
    unlink("q1.xml", recursive = TRUE)
    unlink("q2.xml", recursive = TRUE)
    unlink("q3.xml", recursive = TRUE)
    unlink("q4.xml", recursive = TRUE)
    unlink("id_test.xml", recursive = TRUE)
    unlink("id_test.zip", recursive = TRUE)
    unlink("imsmanifest.xml", recursive = TRUE)
    unlink("to_delete", recursive = TRUE)
})

test_that("Testing method createAssessmentTest for AssessmentTestOpal class", {
sc1 <- new("SingleChoice", prompt = "Test task", title = "SC",
           identifier = "q1", choices = c("a", "b", "c"))
sc2 <- new("SingleChoice", prompt = "Test task", title = "SC",
           identifier = "q2", choices = c("A", "B", "C"))
sc3 <- new("SingleChoice", prompt = "Test task", title = "SC",
           identifier = "q3", choices = c("aa", "bb", "cc"))
e1 <- new("Essay", prompt = "Essay task", identifier = "e1")
e2 <- new("Essay", prompt = "Essay task", identifier = "e2")
e3 <- new("Essay", prompt = "Essay task", identifier = "e3")
exam_subsection <- new("AssessmentSection", identifier = "subsec_id",
                       title = "Subsection", assessment_item = list(e1, e2, e3),
                       shuffle = TRUE, selection = 2)
exam_section <- new("AssessmentSection", identifier = "sec_id",
                    title = "section",
                    assessment_item = list(sc1, sc2, sc3, exam_subsection),
                    max_attempts = 3, time_limit = 30, allow_comment = TRUE)

exam <- new("AssessmentTestOpal", identifier = "id_test",
            title = "some title", section = list(exam_section),
            files = c(test_path("file/test_fig1.jpg"),
                      test_path("file/test_fig2.jpg")),
            max_attempts = 5, time_limit = 100, allow_comment = TRUE,
            rebuild_variables = TRUE,
            show_test_time = TRUE, calculator = "simple",
            keep_responses = TRUE
            )
suppressMessages(createQtiTest(exam, "test1a9b56cf96", "TRUE"))

sut <- sort(list.files("test1a9b56cf96"))
expected <- sort(c("downloads", "e1.xml", "e2.xml", "e3.xml", "q1.xml", "q2.xml", "q3.xml",
              "id_test.xml", "id_test.zip", "imsmanifest.xml"))
expect_equal(sut, expected)
unlink("test1a9b56cf96", recursive = TRUE)
})

test_that("Testing method createAssessmentTest for AssessmentTest class", {
    sc1 <- new("SingleChoice", prompt = "Test task", title = "SC",
               identifier = "q1", choices = c("a", "b", "c"))
    sc2 <- new("SingleChoice", prompt = "Test task", title = "SC",
               identifier = "q2", choices = c("A", "B", "C"))
    sc3 <- new("SingleChoice", prompt = "Test task", title = "SC",
               identifier = "q3", choices = c("aa", "bb", "cc"))
    e1 <- new("Essay", prompt = "Essay task", identifier = "e1")
    e2 <- new("Essay", prompt = "Essay task", identifier = "e2")
    e3 <- new("Essay", prompt = "Essay task", identifier = "e3")
    exam_subsection <- new("AssessmentSection", identifier = "subsec_id",
                           title = "Subsection",
                                            assessment_item = list(e1, e2, e3),
                           shuffle = TRUE, selection = 2)
    exam_section <- new("AssessmentSection", identifier = "sec_id",
                        title = "section",
                        assessment_item = list(sc1, sc2, sc3, exam_subsection),
                        max_attempts = 3, time_limit = 30,
                                                        allow_comment = TRUE)

    exam <- new("AssessmentTest", identifier = "id_test",
                title = "some title", section = list(exam_section),
                max_attempts = 5, time_limit = 100, allow_comment = TRUE,
                rebuild_variables = TRUE
    )

    # Testing AssessmentTest
    suppressMessages(createQtiTest(exam, "todelete", "TRUE"))

    sut <- xml2::read_xml(suppressMessages(toString(createAssessmentTest(
        object = exam, folder = getwd()))))
    expected <- xml2::read_xml("todelete/id_test.xml")
    expect_equal(sut, expected)
    file.remove("e1.xml")
    file.remove("e2.xml")
    file.remove("e3.xml")
    file.remove("q1.xml")
    file.remove("q2.xml")
    file.remove("q3.xml")
    unlink("todelete", recursive = TRUE)
})

test_that("Testing of AssessmentSection class that contains
          non-unique identifiers of AssessmentItem class", {
    mc1 <- new("MultipleChoice",
               identifier = "theSame", prompt = "What does 3/4 + 1/4 = ?",
               title = "MultipleChoice",
               choices = c("1", "4/8", "8/4", "4/4"),
               choice_identifiers = c("1", "2", "3", "4"),
               points = c(1, 0, 0, 1))

    sc2 <- new("SingleChoice",
               prompt = "What is the percentage of 3/20?",
               title = "SingleChoice",
               choices = c("15%", "20%", "30%"),
               choice_identifiers = "1",
               identifier = "theSame")

    expect_error({
        new("AssessmentSection",
            identifier = "sec_id",
            title = "section",
            assessment_item = list(mc1, sc2)
        )
    }, "Items of section id:sec_id contain non-unique values: theSame, theSame")
})

test_that("Testing of AssessmentTest class that contains non-unique identifiers
          of AssessmentSection", {
    mc1 <- new("MultipleChoice",
                identifier = "theSame", prompt = "What does 3/4 + 1/4 = ?",
                title = "MultipleChoice",
                choices = c("1", "4/8", "8/4", "4/4"),
                choice_identifiers = c("1", "2", "3", "4"),
                points = c(1, 0, 0, 1))
    sc2 <- new("SingleChoice",
               prompt = "What is the percentage of 3/20?",
               title = "SingleChoice",
               choices = c("15%", "20%", "30%"),
               choice_identifiers = "1",
               identifier = "theSame")
    section1 <- new("AssessmentSection",
                    identifier = "sec_id",
                    title = "section",
                    assessment_item = list(mc1))
    section2 <- new("AssessmentSection",
                     identifier = "sec_id",
                     title = "section",
                     assessment_item = list(sc2))

    expect_warning({ exam <- new("AssessmentTest",
                                  identifier = "id_test",
                                  title = "some title",
                                  section = list(section1, section2))
    }, "Identifiers of test sections contain non-unique values: sec_id, theSame, sec_id, theSame")
})
test_that("Testing of time_limits in AssessmentTest class", {
              mc1 <- new("MultipleChoice",
                         identifier = "theSame", prompt = "What does 3/4 + 1/4 = ?",
                         title = "MultipleChoice",
                         choices = c("1", "4/8", "8/4", "4/4"),
                         choice_identifiers = c("1", "2", "3", "4"),
                         points = c(1, 0, 0, 1))
              section <- new("AssessmentSection",
                              identifier = "sec_id",
                              title = "section",
                              assessment_item = list(mc1))
              expect_warning({
                  exam <- new("AssessmentTest",
                               identifier = "id_test",
                               title = "some title",
                               time_limit = 190,
                               section = list(section))
              }, "Value of time_limits does not seem plausible.")
          })
test_that("Testing getPoints() method in case the point of Task
          in XML file is not defined", {
    path <- test_path("file/xml/Essay_without_Maxscore_Minscore.xml")
    sut_points <- getPoints(path)
    expect_equal(sut_points, 1)
})

test_that("Testing getPoints() method in case of XML file does not exist", {
    path <- test_path("file/test.xml")
    expect_warning({
        sut_points <- suppressMessages(getPoints(path))
    }, "file file/test.xml does not exist")
})

test_that("Testing getIdentifier() method in case of XML file does not exist", {
    path <- test_path("file/test.xml")
    expect_warning({
        sut_points <- getIdentifier(path)
    }, "file file/test.xml does not exist")
})

test_that("Testing a specific attribute 'files' in yaml section of Rmd file",
          {
    tpath <- "file/test_rmd_files"
    path <- test_path("file/test_rmd_files/test_DirectedPair_from_table.Rmd")
    exam_section <- suppressMessages(section(path))
    fls <- exam_section@assessment_item[[1]]@files
    fls <- sapply(fls, function(x) test_path(tpath, x))
    exam_section@assessment_item[[1]]@files <- fls
    exam <- new("AssessmentTestOpal",
            identifier = "id_test",
            section = list(exam_section))
    expected <- c(test_path(tpath, "test_fig2.jpg"),
                  test_path(tpath, "test_fig1.jpg"),
                  test_path(tpath, "statistics.csv"))
    expect_equal(exam@files, expected)
})

test_that("Test assessmentSection function that return an object
          of class AssessmentSection", {

              sc <- singleChoice(prompt = "Question",
                                       choices = c("A", "B", "C"))
              es <- new("Essay", prompt = "Question")
              s <- section(c(sc, es), title = "Section with nonrandomized tasks")

              sut <- assessmentSection(list(s), title = "Example of the Exam")

              expected <- new("AssessmentSection",
                              title = "Example of the Exam",
                              assessment_item = list(s))

              expected@identifier <- sut@identifier

              # Check if the object is of class AssessmentSection
              expect_true(inherits(sut, "AssessmentSection"))

              # Check if the object is of class AssessmentSection
              expect_equal(expected, sut)
})

test_that("Test assessmentTest function that return an object
          of class AssessmentTest", {

              sc <- singleChoice(prompt = "Question", choices = c("A", "B", "C"))
              es <- new("Essay", prompt = "Question")
              s <- section(c(sc, es), title = "Section with nonrandomized tasks")

              sut <- assessmentTest(list(s), title = "Example of the Exam")

              expected <- new("AssessmentTest",
                              title = "Example of the Exam",
                              section = list(s),
                              time_limit = 90,
                              max_attempts = 1)

              expected@identifier <- sut@identifier
              expected@rebuild_variables <- sut@rebuild_variables
              expected@metadata <- sut@metadata


              # Check if the object is of class AssessmentTest
              expect_true(inherits(sut, "AssessmentTest"))

              # Check if the object is of class AssessmentTest
              expect_equal(expected, sut)
})

test_that("Test assessmentTestOpal function that return an object
          of class AssessmentTest", {

              sc <- singleChoice(prompt = "Question", choices = c("A", "B", "C"))
              es <- new("Essay", prompt = "Question")
              s <- section(c(sc, es), title = "Section with nonrandomized tasks")

              sut <- assessmentTestOpal(list(s), title = "Example of the Exam" )

              expected <- new("AssessmentTestOpal",
                              title = "Example of the Exam",
                              section = list(s),
                              time_limit = 90,
                              max_attempts = 1)

              expected@identifier <- sut@identifier
              expected@metadata <- sut@metadata
              expected@rebuild_variables <- sut@rebuild_variables


              # Check if the object is of class AssessmentTestOpal
              expect_true(inherits(sut, "AssessmentTest"))

              # Check if the object is of class AssessmentTestOpal
              expect_equal(expected, sut)
})
