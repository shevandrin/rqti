% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/LMS.R
\name{getLMSResourceURL}
\alias{getLMSResourceURL}
\title{Create a URL using the resource's display name in LMS}
\usage{
getLMSResourceURL(object, display_name)
}
\arguments{
\item{object}{An S4 object of class \link{LMS} that represents a connection to the LMS.}

\item{display_name}{A length one character vector to entitle file in LMS;
it takes file name without extension by default; optional.}
}
\value{
A string value of URL.
}
\description{
Create a URL using the resource's display name in LMS
}
