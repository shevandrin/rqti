check_contributor <- function(object) {
    errors <- list()
    roles <- c("author", "publisher", "unknown", "initiator", "terminator",
               "validator", "editor", "graphial designer",
               "technical implementer", "content provider",
               "technical validator", "educational validator", "script writer",
               "instructional designer", "subject matter expert")
    if (!object@role %in% roles ) {
        errors <- c(errors, paste0("The Role of the contributer has to have one
                                   of these values: ",
                     paste(roles, collapse = ", "), "."))
    }
    if (length(errors) == 0) TRUE else unlist(errors)
}

#' Class QtiContributor
#'
#' This class stores metadata information about contributors.
#' @slot name A character string representing the name of the author.
#' By default it takes value from environment variable 'RQTI_AUTHOR'.
#' @slot role A character string kind of contribution. Possible values: author,
#'   publisher, unknown, initiator, terminator, validator, editor, graphical
#'   designer, technical implementer, content provider, technical validator,
#'   educational validator, script writer, instructional designer, subject
#'   matter expert. Default is "author".
#' @slot contribution_date A character string representing date of the
#'   contribution. Default is the current system date.
#' @name QtiContributor-class
#' @rdname QtiContributor-class
#' @aliases QtiContributor
#' @include rqti.R
setClass("QtiContributor", slots = c(name = "character",
                                     role = "character",
                                     contribution_date = "Date"),
         prototype = prototype(name = Sys.getenv("RQTI_AUTHOR"),
                               role = "author",
                               contribution_date = Date(0)),
         validity = check_contributor)

setMethod("initialize", "QtiContributor", function(.Object, ...) {
    .Object <- callNextMethod()
    if (.Object@name != "" && length(.Object@contribution_date) == 0) {
        .Object@contribution_date <- Sys.Date()
    }
    validObject(.Object)
    .Object
})


#' Constructor function for class QtiContributor
#'
#' Creates object of [QtiContributor]-class
#' @param name A character string representing the name of the author.
#' @param role A character string kind of contribution. Possible values: author,
#'   publisher, unknown, initiator, terminator, validator, editor, graphical
#'   designer, technical implementer, content provider, technical validator,
#'   educational validator, script writer, instructional designer, subject
#'   matter expert. Default is "author".
#' @param contribution_date A character string representing date of the
#'   contribution. Default is the current system date, when contributor is
#'   assigned.
#' @examples
#' creator= qti_contributor("Max Mustermann", "technical validator")
#' @export
qti_contributor <- function(name = Sys.getenv("RQTI_AUTHOR"),
                            role = "author",
                            contribution_date = ifelse(name != "", Sys.Date(), NA_Date_)) {
    lifecycle::deprecate_warn("0.3.1", "qti_contributor()", "qtiContributor()")
    qtiContributor(name, role, contribution_date)
}

#' Constructor function for class QtiContributor
#'
#' Creates object of [QtiContributor]-class
#' @param name A character string representing the name of the author.
#' @param role A character string kind of contribution. Possible values: author,
#'   publisher, unknown, initiator, terminator, validator, editor, graphical
#'   designer, technical implementer, content provider, technical validator,
#'   educational validator, script writer, instructional designer, subject
#'   matter expert. Default is "author".
#' @param contribution_date A character string representing date of the
#'   contribution. Default is the current system date, when contributor is
#'   assigned.
#' @examples
#' creator= qtiContributor("Max Mustermann", "technical validator")
#' @export
qtiContributor <- function(name = Sys.getenv("RQTI_AUTHOR"),
                            role = "author",
                            contribution_date = ifelse(name != "", Sys.Date(), NA_Date_)) {
    params <- as.list(environment())
    params$Class <- "QtiContributor"
    if (is.na(params$contribution_date)) params$contribution_date <- Date(0)
    params$contribution_date <- as.Date(params$contribution_date)
    obj <- do.call("new", params)
    return(obj)
}

check_metadata <- function(object) {
    errors <- list()
    errors <- lapply(object@contributor, function(x) if(!is(x, "QtiContributor")){
        msg <- paste0("Item \'", x, "\' is not an object of QtiContributor class")
        errors <- c(errors, msg)})
    if (length(errors) == 0) TRUE else unlist(errors)
}

#' Class QtiMetadata
#'
#' This class stores metadata information such as contributors, description,
#' rights and version for QTI-compliant tasks or tests.
#' @slot contributor A list of objects [QtiContributor]-type that holds metadata
#'   information about the authors.
#' @slot description A character string providing a textual description of the
#'   content of this learning object.
#' @slot rights A character string describing the intellectual property rights
#'   and conditions of use for this learning object. By default it takes value
#'   from environment variable 'RQTI_RIGHTS'.
#' @slot version A character string representing the edition/version of this
#'   learning object.
#' @name QtiMetadata-class
#' @rdname QtiMetadata-class
#' @aliases QtiMetadata
#' @include rqti.R
setClass("QtiMetadata", slots = c(contributor = "list",
                                  description = "character",
                                  rights = "character",
                                  version = "character"),
         prototype = prototype(contributor = list(qtiContributor()),
                               rights = Sys.getenv("RQTI_RIGHTS"),
                               description = ""),
         validity = check_metadata)

setMethod("initialize", "QtiMetadata", function(.Object, ...) {
    .Object <- callNextMethod()

    .Object@version <- replace_na(.Object@version)

    validObject(.Object)
    .Object
})

#' Constructor function for class QtiMetadata
#'
#' Creates object of [QtiMetadata]-class
#' @param contributor A list of objects [QtiContributor]-type that holds
#'   metadata information about the authors.
#' @param description A character string providing a textual description of the
#'   content of this learning object.
#' @param rights A character string describing the intellectual property rights
#'   and conditions of use for this learning object. By default it takes value
#'   from environment variable 'RQTI_RIGHTS'.
#' @param version A character string representing the edition/version of this
#'   learning object.
#' @examples
#' creator= qti_metadata(qtiContributor("Max Mustermann"),
#'                       description = "Task description",
#'                       rights = "This file is Copyright (C) 2024 Max
#'                       Mustermann, all rights reserved.",
#'                       version = "1.0")
#' @export
qti_metadata<- function(contributor = list(), description = "",
                        rights = Sys.getenv("RQTI_RIGHTS"),
                        version = NA_character_) {
    lifecycle::deprecate_warn("0.3.1", "qti_metadata()", "qtiMetadata()")
    obj <- qtiMetadata(contributor, description, rights, version)
    return(obj)
}

#' Constructor function for class QtiMetadata
#'
#' Creates object of [QtiMetadata]-class
#' @param contributor A list of objects [QtiContributor]-type that holds
#'   metadata information about the authors.
#' @param description A character string providing a textual description of the
#'   content of this learning object.
#' @param rights A character string describing the intellectual property rights
#'   and conditions of use for this learning object. By default it takes value
#'   from environment variable 'RQTI_RIGHTS'.
#' @param version A character string representing the edition/version of this
#'   learning object.
#' @examples
#' creator= qtiMetadata(qtiContributor("Max Mustermann"),
#'                       description = "Task description",
#'                       rights = "This file is Copyright (C) 2024 Max
#'                       Mustermann, all rights reserved.",
#'                       version = "1.0")
#' @export
qtiMetadata<- function(contributor = list(), description = "",
                        rights = Sys.getenv("RQTI_RIGHTS"),
                        version = NA_character_) {
    if (!is(contributor, "list")) contributor <- list(contributor)
    params <- as.list(environment())
    params$Class <- "QtiMetadata"
    obj <- do.call("new", params)
    return(obj)
}


#' Create an element of metadata
#'
#' @param object an instance of the S4 object ([QtiContributor], [QtiMetadata]
#' @docType methods
#' @rdname createMetadata-methods
setGeneric("createMetadata",
           function(object) standardGeneric("createMetadata"))

#' @rdname createMetadata-methods
#' @aliases createMetadata,QtiContributor
setMethod("createMetadata", signature(object = "QtiContributor"),
          function(object) {
              role_src <- tag("source", list("LOMv1.0"))
              role_value <- tag("value", list(object@role))
              role <- tag("role", list(role_src, role_value))
              vcard <- paste0("BEGIN:VCARD\r\nFN:", object@name,
                              "\r\nEND:VCARD\r\n")
              ent <- tag("entity", list(vcard))
              dt <- tag("date",
                        list(tag("dateTime",
                                 as.character(object@contribution_date))))
              return(tag("contribute", list(role, ent, dt)))
          })

create_metadata <- function(object) {
    mt_obj <- object@metadata
    # section General
    idf <- tag("identifier", list(tag("entry", list(object@identifier))))
    descr_txt = paste0(mt_obj@description, "\n", mt_obj@rights)
    descr <- tag("description", list(tag("string", list(descr_txt))))
    ttl <- tag("title", list(tag("string", list(object@title))))
    general <- tag("general", list(idf, ttl, descr))
    # section Life Cycle
    ver <- tag("version", list(tag("string", mt_obj@version)))
    contrib <- lapply(mt_obj@contributor, createMetadata)
    lifeccl <- tag("lifeCycle", list(ver, contrib))
    # section Technical
    techn <- tag("technical", list(tag("format", list("IMS QTI 2.1"))))
    # section Rights
    rights <- tag("rights", list(tag("description", list(mt_obj@rights))))

    lom <- tag("lom", list(xmlns = "http://ltsc.ieee.org/xsd/LOM",
                           lifeccl, general, techn, rights))
    metadata <- tag("metadata", list(lom))
    return(metadata)
}
