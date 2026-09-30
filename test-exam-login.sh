#!/usr/bin/env bash

# Test password-based authentication against the TUCexam OpenOlat REST API.
# The password is read silently and is never passed in curl's command line.

set -u
set -o pipefail

readonly login_url="${EXAM_API_LOGIN_URL:-https://exam.tu-chemnitz.de/opal/restapi/auth/login}"

usage() {
    printf 'Usage: %s [username]\n' "${0##*/}" >&2
}

if (( $# > 1 )); then
    usage
    exit 2
fi

if [[ ! -t 0 ]]; then
    printf 'Error: an interactive terminal is required to read credentials securely.\n' >&2
    exit 2
fi

username="${1:-}"
if [[ -z "$username" ]]; then
    read -r -p 'API username: ' username
fi

if [[ -z "$username" ]]; then
    printf 'Error: username must not be empty.\n' >&2
    exit 2
fi

password=''
IFS= read -r -s -p 'API password: ' password
printf '\n'

if [[ -z "$password" ]]; then
    printf 'Error: password must not be empty.\n' >&2
    exit 2
fi

# HTTP header values cannot contain line breaks; rejecting them also prevents
# an accidentally pasted value from creating extra request headers.
if [[ "$username" == *$'\r'* || "$username" == *$'\n'* ||
      "$password" == *$'\r'* || "$password" == *$'\n'* ]]; then
    printf 'Error: credentials must not contain line breaks.\n' >&2
    unset password
    exit 2
fi

umask 077
auth_tmp_dir=$(mktemp -d "${TMPDIR:-/tmp}/tuc-exam-auth.XXXXXX") || {
    printf 'Error: could not create temporary storage.\n' >&2
    unset password
    exit 1
}

cleanup() {
    unset password
    if [[ -n "${auth_tmp_dir:-}" && -d "$auth_tmp_dir" ]]; then
        rm -rf -- "$auth_tmp_dir"
    fi
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM HUP

headers_file="$auth_tmp_dir/request-headers"
response_headers_file="$auth_tmp_dir/response-headers"

# Supplying headers from a protected file keeps the password out of ps output.
printf 'Content-Type: application/xml\nAccept: text/plain\nusername: %s\npassword: %s\n' \
    "$username" "$password" >"$headers_file"
unset password

printf 'Testing %s\n' "$login_url"
http_code=$(curl \
    --silent \
    --show-error \
    --connect-timeout 10 \
    --max-time 30 \
    --request POST \
    --header "@$headers_file" \
    --dump-header "$response_headers_file" \
    --output /dev/null \
    --write-out '%{http_code}' \
    "$login_url")
curl_exit=$?

if (( curl_exit != 0 )); then
    printf 'Authentication test failed before an HTTP response was received (curl exit %d).\n' \
        "$curl_exit" >&2
    exit "$curl_exit"
fi

case "$http_code" in
    200)
        printf 'Authentication successful (HTTP 200).\n'
        exit 0
        ;;
    401)
        printf 'Authentication rejected (HTTP 401): check the username, password, and API permission.\n' >&2
        ;;
    403)
        printf 'Access forbidden (HTTP 403): the request may still be blocked by the server or IP allowlist.\n' >&2
        ;;
    000)
        printf 'No HTTP response received.\n' >&2
        ;;
    *)
        printf 'Authentication failed with HTTP %s.\n' "$http_code" >&2
        ;;
esac

exit 1
