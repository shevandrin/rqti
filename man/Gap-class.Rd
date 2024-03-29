% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Gap.R
\docType{class}
\name{Gap-class}
\alias{Gap-class}
\alias{Gap}
\title{Class "Gap"}
\description{
Abstract class \code{Gap} is not meant to be instantiated directly; instead, it
serves as a base for derived classes such as \link{NumericGap}, \link{TextGap},
\link{TextGapOpal} and \link{InlineChoice}.
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
}}

\seealso{
\link{NumericGap}, \link{TextGap}, \link{TextGapOpal} and \link{InlineChoice}.
}
