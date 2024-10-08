% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/QtiMetadata.R
\docType{class}
\name{QtiContributor-class}
\alias{QtiContributor-class}
\alias{QtiContributor}
\title{Class QtiContributor}
\description{
This class stores metadata information about contributors.
}
\section{Slots}{

\describe{
\item{\code{name}}{A character string representing the name of the author.
By default it takes value from environment variable 'RQTI_AUTHOR'.}

\item{\code{role}}{A character string kind of contribution. Possible values: author,
publisher, unknown, initiator, terminator, validator, editor, graphical
designer, technical implementer, content provider, technical validator,
educational validator, script writer, instructional designer, subject
matter expert. Default is "author".}

\item{\code{contribution_date}}{A character string representing date of the
contribution. Default is the current system date.}
}}

