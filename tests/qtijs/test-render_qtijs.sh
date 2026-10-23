#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
cd "$REPO_ROOT"
LOG=$(mktemp)

# Respect the same startup files and package libraries as the hook's R tests.
# --vanilla ignores .Renviron and .Rprofile, which may configure user libraries.
RQTI_REPO_ROOT="$REPO_ROOT" Rscript --no-save --no-restore "$SCRIPT_DIR/serve-render_qtijs.R" > "$LOG" 2>&1 &
R_PID=$!

cleanup() {
  kill "$R_PID" 2>/dev/null || true
  rm -f "$LOG"
}
trap cleanup EXIT

for _ in $(seq 1 100); do
  if grep -qE 'http://127\.0\.0\.1:[0-9]+' "$LOG"; then
    break
  fi

  if ! kill -0 "$R_PID" 2>/dev/null; then
    echo "R died. Log:"
    cat "$LOG"
    exit 1
  fi

  sleep 0.2
done

if ! grep -qE 'http://127\.0\.0\.1:[0-9]+' "$LOG"; then
  echo "Timed out waiting for qtijs server URL. Log:"
  cat "$LOG"
  exit 1
fi

URL=$(grep -oE 'http://127\.0\.0\.1:[0-9]+' "$LOG" | tail -n1)
URL="${URL}/?mfb=0"

echo "Using URL: $URL"

READY_DEADLINE=$((SECONDS + 20))
until curl --noproxy 127.0.0.1,localhost -fsS --max-time 2 "$URL" >/dev/null 2>&1; do
  if ! kill -0 "$R_PID" 2>/dev/null || (( SECONDS >= READY_DEADLINE )); then
    echo "The qtijs server did not become reachable. Log:"
    cat "$LOG"
    exit 1
  fi
  sleep 0.2
done

node "$SCRIPT_DIR/check-render_qtijs.js" "$URL"
