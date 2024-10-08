% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/LMS.R, R/Opal.R
\docType{methods}
\name{isUserLoggedIn}
\alias{isUserLoggedIn}
\alias{isUserLoggedIn,Opal-method}
\title{Check if User is Logged in LMS}
\usage{
isUserLoggedIn(object)

\S4method{isUserLoggedIn}{Opal}(object)
}
\arguments{
\item{object}{An S4 object of class \link{Opal} that represents a connection to the LMS.}
}
\value{
A logical value (\code{TRUE} if the user is logged in, \code{FALSE} otherwise).

A logical value (\code{TRUE} if the user is logged in, \code{FALSE} otherwise).
}
\description{
This method checks whether a user is logged into an LMS (Learning Management System) by
sending a request to the LMS server and evaluating the response.

This method checks whether a user is logged into an LMS Opal by
sending a request to the LMS server and evaluating the response.
}
