preview_request <- function(code = "string(['answer=7]);", type = "integer") {
    list(blocks = list(list(code = code, identifier = "calculation",
        outputs = list(list(name = "answer", type = type)))), libraries = character())
}

preview_api_request <- function(app, request) {
    config <- jsonlite::fromJSON(app$call(list(PATH_INFO="/.rqti-maxima/config", REQUEST_METHOD="GET"))$body)
    bytes <- charToRaw(as.character(jsonlite::toJSON(request, auto_unbox=TRUE)))
    app$call(list(PATH_INFO="/.rqti-maxima/run", REQUEST_METHOD="POST",
        CONTENT_TYPE="application/json", CONTENT_LENGTH=as.character(length(bytes)),
        HTTP_X_RQTI_MAXIMA=config$token, rook.input=list(read=function(n) bytes)))
}

await_preview_response <- function(promise, timeout = 10) {
    result <- NULL
    promises::then(promise, onFulfilled=function(value) result <<- value,
                   onRejected=function(error) result <<- error)
    started <- proc.time()[["elapsed"]]
    while (is.null(result) && proc.time()[["elapsed"]]-started < timeout) later::run_now(0.05)
    if (is.null(result)) stop("Preview response did not complete.")
    result
}
