% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/TextGapOpal.R
\docType{class}
\name{TextGapOpal-class}
\alias{TextGapOpal-class}
\alias{TextGapOpal}
\title{Class "TextGapOpal"}
\description{
Class \code{TextGapOpal} is responsible for creating instances of input fields
with text type of answers in question \link{Entry} type assessment tasks according
to the QTI 2.1 standard for LMS Opal.
}
\section{Slots}{

\describe{
\item{\code{response_identifier}}{A character value representing an identifier for
the answer. By default, it is generated as 'id_gap_dddd', where dddd
represents random digits.}

\item{\code{points}}{A numeric value, optional, representing the number of points for
this gap. Default is \code{1}.}

\item{\code{placeholder}}{A character value, optional, responsible for placing
helpful text in the text input field in the content delivery engine.}

\item{\code{expected_length}}{A numeric value, optional, responsible for setting the
size of the text input field in the content delivery engine.}

\item{\code{solution}}{A character vector containing the values considered as correct
answers.}

\item{\code{case_sensitive}}{A boolean value, determining whether the evaluation of
the correct answer is case sensitive. Default is \code{FALSE}.}

\item{\code{tolerance}}{A numeric value defining how many characters will be taken
into account to tolerate spelling mistakes in the evaluation of candidate
answers. Default is \code{0}.}
}}

\examples{
tgo <- new("TextGapOpal",
          response_identifier = "id_gap_1234",
          points = 2,
          placeholder = "do not put special characters",
          expected_length = 20,
          solution = "answer",
          case_sensitive = FALSE,
          tolerance = 1)
}
\seealso{
\link{Entry}, \link{NumericGap}, \link{TextGap} and \link{InlineChoice}.
}
