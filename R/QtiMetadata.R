#' Class QtiMetadata
#'
#' This class stores metadata information such as author name, description,
#' rights, version, format, creation date, and modified date for QTI-compliant
#' tasks or tests.
#' @slot author A character string representing the name of the author.
#' @slot description A character string providing a textual description of the
#'   content of this learning object.
#' @slot rights A character string describing the intellectual property rights
#'   and conditions of use for this learning object.
#' @slot version A character string representing the edition/version of this
#'   learning object.
#' @slot format A character string representing the QTI (Question and Test
#'   Interoperability) information model version. Default is 'IMS QTI 2.1'.
#' @slot created_date A character string representing the creation date of the
#'   learning object. Default is the current system date.
#' @slot modified_date A character string representing the date of the last
#'   modification of the learning object. Default is the current system date.
#' @name QtiMetadata-class
#' @rdname QtiMetadata-class
#' @aliases QtiMetadata
#' @include rqti.R
setClass("QtiMetadata", slots = c(author = "character",
                                  description = "character",
                                  rights = "character",
                                  version = "character",
                                  format = "character",
                                  created_date = "Date",
                                  modified_date = "Date"),
         prototype = prototype(version = "0.0.9",
                               created_date = Sys.Date(),
                               modified_date = Sys.Date(),
                               format = "IMS QTI 2.1"))
