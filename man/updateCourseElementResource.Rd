% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/LMS.R
\name{updateCourseElementResource}
\alias{updateCourseElementResource}
\title{Update the referenced learning resource of a course element in the LMS}
\usage{
updateCourseElementResource(object, course_id, ...)
}
\arguments{
\item{object}{An S4 object of class \link{LMS} that represents a connection to the LMS.}

\item{course_id}{A character string with course id in the LMS.}

\item{...}{Additional arguments to be passed to the method, if applicable.}
}
\value{
Response of the HTTP request.
}
\description{
Update the referenced learning resource of a course element in the LMS
}
