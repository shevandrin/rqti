% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/QtiMetadata.R
\name{qti_contributor}
\alias{qti_contributor}
\title{Constructor function for class QtiContributor}
\usage{
qti_contributor(
  name = Sys.getenv("RQTI_AUTHOR"),
  role = "author",
  contribution_date = ifelse(name != "", Sys.Date(), NA_Date_)
)
}
\arguments{
\item{name}{A character string representing the name of the author.}

\item{role}{A character string kind of contribution. Possible values: author,
publisher, unknown, initiator, terminator, validator, editor, graphical
designer, technical implementer, content provider, technical validator,
educational validator, script writer, instructional designer, subject
matter expert. Default is "author".}

\item{contribution_date}{A character string representing date of the
contribution. Default is the current system date, when contributor is
assigned.}
}
\description{
Creates object of \link{QtiContributor}-class
}
\examples{
creator= qti_contributor("Max Mustermann", "technical validator")
}
