# Local browser check

From the repository root, install the test's Node dependencies and Chromium:

```sh
npm ci --prefix tests/qtijs
PLAYWRIGHT_BROWSERS_PATH=0 tests/qtijs/node_modules/.bin/playwright install chromium --only-shell
```

Run the same browser check used by the local pre-push hook:

```sh
bash tests/qtijs/test-render_qtijs.sh
```

The check uses the current R installation and its normal `.Renviron` and
`.Rprofile` configuration, without loading or saving a workspace. Package-load
failures report the R version, R home, and library paths used by the test.
The check requires rqti's R dependencies and `pkgload` in those libraries.

Node dependencies and browser binaries stay under `tests/qtijs/node_modules/`
and are excluded from Git and R source packages. Set `PLAYWRIGHT_BROWSERS_PATH`
to use another browser cache.
