% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/AssessmentSection.R
\name{assessmentSection}
\alias{assessmentSection}
\title{Create an object \link{AssessmentSection}}
\usage{
assessmentSection(
  assessment_item,
  identifier = generate_id(type = "section"),
  title = identifier,
  selection = NA_integer_,
  time_limit = NA_integer_,
  visible = TRUE,
  shuffle = FALSE,
  max_attempts = NA_integer_,
  allow_comment = TRUE
)
}
\arguments{
\item{assessment_item}{A list containing \link{AssessmentSection} and/or
Assessment item objects, such as \link{SingleChoice}, \link{MultipleChoice}, \link{Essay},
\link{Entry}, \link{Ordering}, \link{OneInRowTable}, \link{OneInColTable},
\link{MultipleChoiceTable}, and \link{DirectedPair}.}

\item{identifier}{A character value indicating the identifier of the test
file. By default, it is generated as 'id_section_dddd', where dddd
represents random digits.}

\item{title}{A character value, optional, representing the file title. By
default, it takes the value of the \code{identifier}.}

\item{selection}{An integer value, optional, defining how many children of
the section are delivered in the test. Default is \code{NA_integer_}, meaning
"no selection".}

\item{time_limit}{An integer value, optional, controlling the amount of time
in munutes a candidate is allowed for this part of the test.}

\item{visible}{A boolean value, optional, indicating whether the title of
this section is shown in the hierarchy of the test structure. Default is
\code{TRUE}.}

\item{shuffle}{A boolean value, optional, responsible for randomizing the
order in which the assessment items and subsections are initially presented
to the candidate. Default is \code{FALSE}.}

\item{max_attempts}{An integer value, optional, enabling the maximum number
of attempts allowed for a candidate to pass this section.}

\item{allow_comment}{A boolean value, optional, enabling candidates to leave
comments on each question of the section. Default is \code{TRUE}.}
}
\value{
An object of class \link{AssessmentSection}.
}
\description{
Create an \link{AssessmentSection} \code{rqti}-object as part of a test content
}
\examples{
sc <- singleChoice(prompt = "Question", choices = c("A", "B", "C"))
es <- essay(prompt = "Question")
# Since ready-made S4 "AssessmentItem" objects are taken, in this example a
#permanent section consisting of two tasks is created.
s <- assessmentSection(list(sc, es), title = "Section with nonrandomized tasks")
}
\seealso{
\code{\link[=section]{section()}}, \code{\link[=test]{test()}}, \code{\link[=test4opal]{test4opal()}}
}
