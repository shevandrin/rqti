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
    if (is.null(object@contributor) || object@contributor == "") {
        errors <- c(errors, "Please assign a value to 'contributor'.")
    }
    if (length(errors) == 0) TRUE else unlist(errors)
}

#' Class QtiContributor
#'
#' This class stores metadata information about contributors.
#' @slot contributor A character string representing the name of the author.
#' By default it takes value from environment variable 'QTI_AUTHOR'.
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
setClass("QtiContributor", slots = c(contributor = "character",
                                     role = "character",
                                     contribution_date = "Date"),
         prototype = prototype(contributor = Sys.getenv("QTI_AUTHOR"),
                               role = "author",
                               contribution_date = Sys.Date()),
         validity = check_contributor)

setMethod("initialize", "QtiContributor", function(.Object, ...) {
    .Object <- callNextMethod()



    validObject(.Object)
    .Object
})


#' Constructor function for class QtiContributor
#'
#' Creates object of [QtiContributor]-class
#' @param contributor A character string representing the name of the author.
#' @param role A character string kind of contribution. Possible values: author,
#'   publisher, unknown, initiator, terminator, validator, editor, graphical
#'   designer, technical implementer, content provider, technical validator,
#'   educational validator, script writer, instructional designer, subject
#'   matter expert. Default is "author".
#' @param contribution_date A character string representing date of the
#'   contribution. Default is the current system date.
#' @examples
#' creator= qti_contributor("Max Mustermann", "technical validator")
#' @export
qti_contributor <- function(contributor = Sys.getenv("QTI_AUTHOR"),
                            role = "author",
                            contribution_date = Sys.Date()) {
    params <- as.list(environment())
    params$Class <- "QtiContributor"
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
#' rights, version and format for QTI-compliant tasks or tests.
#' @slot contributor A list of objects [QtiContributor]-type that holds metadata
#'   information about the authors.
#' @slot description A character string providing a textual description of the
#'   content of this learning object.
#' @slot rights A character string describing the intellectual property rights
#'   and conditions of use for this learning object. By default it takes value
#'   from environment variable 'QTI_RIGHTS'.
#' @slot version A character string representing the edition/version of this
#'   learning object.
#' @slot format A character string representing the QTI (Question and Test
#'   Interoperability) information model version. Default is 'IMS QTI 2.1'.
#' @name QtiMetadata-class
#' @rdname QtiMetadata-class
#' @aliases QtiMetadata
#' @include rqti.R
setClass("QtiMetadata", slots = c(contributor = "list",
                                  description = "character",
                                  rights = "character",
                                  version = "character",
                                  format = "character"),
         prototype = prototype(rights = Sys.getenv("QTI_RIGHTS"),
                               version = "0.0.9",
                               format = "IMS QTI 2.1",
                               description = NA_character_),
         validity = check_metadata)

#' Constructor function for class QtiMetadata
#'
#' Creates object of [QtiMetadata]-class
#' @param contributor A list of objects [QtiContributor]-type that holds
#'   metadata information about the authors.
#' @param description A character string providing a textual description of the
#'   content of this learning object.
#' @param rights A character string describing the intellectual property rights
#'   and conditions of use for this learning object. By default it takes value
#'   from environment variable 'QTI_RIGHTS'.
#' @param version A character string representing the edition/version of this
#'   learning object.
#' @param format A character string representing the QTI (Question and Test
#'   Interoperability) information model version. Default is 'IMS QTI 2.1'.
#' @examples
#' creator= qti_metadata(qti_contributor("Max Mustermann"),
#'                       description = "Task description",
#'                       rights = "This file is Copyright (C) 2024 Max
#'                       Mustermann, all rights reserved.",
#'                       version = "1.0")
#' @export
qti_metadata<- function(contributor, description = NA_character_,
                        rights = Sys.getenv("QTI_RIGHTS"), version = "0.0.9",
                        format = "IMS QTI 2.1") {
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
              role <- tag("role", list(object@role))
              ent <- tag("entity", list(object@contributor))
              dt <- tag("date",
                        list(tag("dateTime",
                                 as.character(object@contribution_date))))
              return(tag("contribute", list(role, ent, dt)))
          })

create_metadata <- function(object) {
    mt_obj <- object@metadata
    # section General
    idf <- tag("identifier", list(tag("entry", list(object@identifier))))
    descr <- tag("description", list(tag("string", list(mt_obj@description))))
    ttl <- tag("title", list(tag("string", list(object@title))))
    general <- tag("general", list(idf, ttl, descr))
    # section Life Cycle
    ver <- tag("version", list(tag("string", mt_obj@version)))
    contrib <- lapply(mt_obj@contributor, createMetadata)
    lifeccl <- tag("lifeCycle", list(ver, contrib))
    # section Technical
    techn <- tag("technical", list(tag("format", list(mt_obj@format))))
    # section Rights
    rights <- tag("rights", list(tag("description", list(mt_obj@rights))))

    lom <- tag("lom", list(xmlns = "http://ltsc.ieee.org/xsd/LOM",
                           lifeccl, general, techn, rights))
    metadata <- tag("metadata", list(lom))
    return(metadata)
}
