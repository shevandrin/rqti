#!/usr/bin/env Rscript

# Store the TUCexam API password and test one rqti login.
# Usage: Rscript test-exam-login.R [username]

endpoint <- "https://exam.tu-chemnitz.de/opal/"

args <- commandArgs(trailingOnly = TRUE)
if (length(args) > 1) {
    stop("Usage: Rscript test-exam-login.R [username]", call. = FALSE)
}

username <- if (length(args) == 1) args[[1]] else Sys.getenv("RQTI_API_USER")
if (!nzchar(username)) {
    username <- readline("API username: ")
}
if (!nzchar(username)) {
    stop("API username must not be empty.", call. = FALSE)
}

if (!requireNamespace("devtools", quietly = TRUE)) {
    stop("The devtools package is required to load the current rqti source tree.",
         call. = FALSE)
}

devtools::load_all(".", quiet = TRUE)

# Select credentials automatically by endpoint. Remove an old manual override
# from this process so it cannot redirect lookup to rqtiopal-<credential_id>.
Sys.setenv(
    RQTI_API_ENDPOINT = endpoint,
    RQTI_API_USER = username
)
Sys.unsetenv("RQTI_API_CREDENTIAL_ID")

message("Store the same password that succeeded with test-exam-login.sh.")
rqti::set_opal_credentials(endpoint, username)

message("Submitting one authentication request to TUCexam...")
exam <- rqti::opal(api_user = username, endpoint = endpoint)

# This is an authenticated GET using the token already returned by opal(); it
# does not submit the username and password a second time.
if (!rqti::isUserLoggedIn(exam)) {
    stop("Login returned a token, but the authenticated session check failed.",
         call. = FALSE)
}

message("Authentication successful; the rqti session is active.")
