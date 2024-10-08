% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/DirectedPair.R
\name{directedPair}
\alias{directedPair}
\title{Create object \link{DirectedPair}}
\usage{
directedPair(
  identifier = generate_id(),
  title = identifier,
  content = list(),
  prompt = "",
  points = 1,
  rows,
  rows_identifiers,
  cols,
  cols_identifiers,
  answers_identifiers,
  answers_scores = NA_real_,
  shuffle = TRUE,
  shuffle_rows = TRUE,
  shuffle_cols = TRUE,
  feedback = list(),
  orientation = "vertical",
  calculator = NA_character_,
  files = NA_character_
)
}
\arguments{
\item{identifier}{A character representing the unique identifier of the
assessment task. By default, it is generated as 'id_task_dddd', where dddd
represents random digits.}

\item{title}{A character representing the title of the XML file associated
with the task. By default, it takes the value of the identifier.}

\item{content}{A character string or a list of character strings to form the
text of the question, which may include HTML tags.}

\item{prompt}{An optional character representing a simple question text,
consisting of one paragraph. This can supplement or replace content in the
task. Default is "".}

\item{points}{A numeric value, optional, representing the number of points for
the entire task. If not provided, the default is calculated as 0.5 points
per pair.}

\item{rows}{A character vector specifying answer options as the first elements
in couples.}

\item{rows_identifiers}{A character vector, optional, specifies identifiers of
the first elements in couples.}

\item{cols}{A character vector specifying answer options as the second
elements in couples.}

\item{cols_identifiers}{A character vector, optional, specifies identifiers of
the second elements in couples.}

\item{answers_identifiers}{A character vector specifying couples of
identifiers that combine the correct answers.}

\item{answers_scores}{A numeric vector, optional, where each number determines
the number of points awarded to a candidate if they select the corresponding
answer. If not assigned, the individual values for correct answers are
calculated from the task points and the number of correct options.}

\item{shuffle}{A boolean value, optional, determining whether to randomize the
order in which the choices are initially presented to the candidate. Default
is \code{TRUE.}}

\item{shuffle_rows}{A boolean value, optional, determining whether to
randomize the order of the choices only for the first elements of the answer
tuples. Default is \code{TRUE.}}

\item{shuffle_cols}{A boolean value, optional, determining whether to
randomize the order of the choices only for the second elements of the
answer tuples. Default is \code{TRUE.}}

\item{feedback}{A list containing feedback message-object \link{ModalFeedback} for
candidates.}

\item{orientation}{A character, optional, determining whether to place answers
in vertical or horizontal mode. Possible values:
\itemize{
\item "vertical" - Default.
\item "horizontal".
}}

\item{calculator}{A character, optional, determining whether to show a
calculator to the candidate. Possible values:
\itemize{
\item "simple"
\item "scientific".
}}

\item{files}{A character vector, optional, containing paths to files that will
be accessible to the candidate during the test/exam.}
}
\value{
An object of class \link{DirectedPair}
}
\description{
Create object \link{DirectedPair}
}
\examples{
dp_min <- directedPair(content = "<p>\"Directed pairs\" task</p>",
                       rows = c("alfa", "beta", "gamma"),
                       rows_identifiers = c("a", "b", "g"),
                       cols = c("A", "B", "G;"),
                       cols_identifiers = c("as", "bs", "gs"),
                       answers_identifiers = c("a as", "b bs", 'g gs'))

dp <- directedPair(identifier = "id_task_1234",
                   title = "Directed Pair Task",
                   content = "<p>\"Directed pairs\" task</p>",
                   prompt = "Plain text, can be used instead of the content",
                   rows = c("alfa", "beta", "gamma"),
                   rows_identifiers = c("a", "b", "g"),
                   cols = c("A", "B", "G"),
                   cols_identifiers = c("as", "bs", "gs"),
                   answers_identifiers = c("a as", "b bs", "g gs"),
                   answers_scores = c(1, 0.5, 0.1),
                   shuffle_rows = FALSE,
                   shuffle_cols = TRUE,
                   orientation = "horizontal")
}
