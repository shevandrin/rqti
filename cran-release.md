# rqti 1.4.0: CRAN release preparation

Prepared on 2026-11-17 for Andrey Shevandrin, the unchanged CRAN maintainer.
The workflow follows [R Packages: Releasing to CRAN](https://r-pkgs.org/release.html).
This is a minor release because it adds scoring options and public APIs.
No package has been submitted, no builder upload or email has been sent, and no
release tag, GitHub release or push has been made during preparation.

## Scope and baseline

Candidate: the release-preparation commit based on local `main` at
`f32abea0a24b23b5c7e4c4715e3640046a48e8da`. The package was built from a
temporary copy of Git-tracked files with those edits applied. Untracked local
files were not included or changed.

Baseline: CRAN rqti 1.3.1, published 2026-10-01, downloaded from
<https://cran.r-project.org/src/contrib/rqti_1.3.1.tar.gz> on 2026-11-17.
Its SHA-256 is
`86a42e3613b712f025be2ad7c54f369d534b5116ac60edda47747ab6f162f6b1`.
Its R sources, NAMESPACE, NEWS and bundled QTI.JS were compared with the checkout;
the release tag `v1.3.1` points to `fd40e5e6b7673a40f40df1857a01cf66ceffbf53`.
All baseline R sources, NAMESPACE, NEWS.md and qti.js matched that tag.
CRAN's built 1.3.1 archive already requires R >= 4.1.0, matching this candidate;
the older R requirement in the Git tag's unbuilt DESCRIPTION is not a new
user-visible minimum-version change.

The audit covers all 23 commits reachable since that tag (21 non-merge commits),
including changes brought in by merges, and the resulting source/documentation
diff. Maxima work on other branches is outside this candidate.

## NEWS audit

`NEWS.md` now groups user-visible changes into features, improvements and fixes.
The 1.3.1-and-earlier section is restored verbatim from CRAN's source archive:
endpoint-derived credentials, connection-specific tokens, `set_opal_credentials()`
and `render_opal()` forwarding had incorrectly been attributed to 1.3.1 in the
development NEWS, although they are absent from the shipped package.
The optional explicit `credential_id` itself did ship in 1.3.1 and is not presented
as new again.

| Commit(s) | Effect since CRAN 1.3.1 | NEWS treatment |
| --- | --- | --- |
| `40a4d5f6`, `53636690` | Configurable single/multiple-choice scoring in S4 constructors and Rmd YAML; new helper documentation and worked examples | Two feature entries, preserving existing defaults and stating LMS compatibility limits |
| `1719d7eb` | Non-positive incorrect-answer scores for numeric/text gaps; omissions remain zero; entry score bounds include penalties | Gap-penalty feature entry |
| `72e10e60` | Configurable response identifiers and public score-bound inspection | Score-bound inspection retained; response identifiers omitted as an integration detail |
| `f32abea0` | Update/delete OPAL course learning groups | Feature entry with server-version, supported-property and rename limitations |
| `a18df4c6` | Endpoint-specific stored credentials with legacy fallback, credential helper/environment override, isolated authentication tokens, endpoint/login fixes and knitting argument forwarding | Credential feature entry and two fix entries; moved out of historical 1.3.1 |
| `90e98d55` | Smaller installed QTI 2.2 schema bundle with offline dependency resolution | User benefit in improvements; bundle-building/CI details omitted |
| `ebd15d33` | Opt-in extended validation accepts attachment download hints | Improvement entry; standard-QTI and LMS/browser limits retained |
| `3413cdac` | Full-credit fractional scores receive correct feedback despite serialization roundoff | Fix entry; previously missing from NEWS |
| `3fa9dc2c` | Preview result icons use the correct item/interaction and reset matching-table feedback | Fix entry; previously missing from NEWS |
| `6e07fd7b` | Academic-grading export works with C.UTF-8 and unknown locales | Fix entry |
| `6040c0de` | Section controls, time limits, selection and ordering follow schema order | Fix entry |
| `84da4290` | Correct current-date defaults and preservation of explicit contributor dates | Fix entry |
| `0d4c1f36` | OpenOlat configuration no longer treated as a QTI assessment document | Fix entry |
| `d470cc39` | Real OPAL integration tests require explicit opt-in | Test infrastructure; omitted from user NEWS, retained in this audit |
| `62db5985` | Declare withr for tests | Dependency bookkeeping; omitted from user NEWS |
| `42f6af15` | Regenerate help files and record roxygen version | Documentation tooling; omitted from user NEWS |
| `0f8aed39` | Replace identifiers in bundled example results with neutral identifiers, with scores/responses unchanged | Fixture cleanup; omitted from user NEWS |
| `7ca1dfe2` | Adapt ordering test expectations to feedback tolerance | Test-only follow-up; omitted from user NEWS |
| `ef477bf5`, `cdd0e5d7` | Build exclusions and development-version bookkeeping | Release infrastructure; omitted from user NEWS |
| `ef601ee3`, `30f6bc4a` | Merge development histories/build exclusions | Audited through the resulting diff; no separate user-facing entry |

Existing metadata-function and legacy preview-feedback YAML deprecations were
reviewed and left at their current warning stage; this release does not remove
those interfaces.

## Validation

- Source build: passed; the archive contains tracked package files, the intended
  release edits and standard R-generated build metadata.
- README rebuilt with `devtools::build_readme()` against the candidate source;
  only Pandoc's Markdown hard-line-break formatting changed.
- `urlchecker::url_check()`: all URLs correct.
- `python3 tools/build-qti22-schemas.py --check`: passed.
- Local `R CMD check --as-cran --timings`, including incoming remote checks,
  examples, tests and the PDF/HTML manuals: **0 errors, 0 warnings, 0 notes**.
  The checked archive passed 1,926 test assertions with 20 skips (18 live OPAL,
  one browser and one pre-existing empty test).
  After the final NEWS wording edits, the archive was rebuilt and compared
  with the checked archive: only NEWS and the packaging timestamp changed.
- Test environment: Arch Linux x86_64, R 4.6.2, Pandoc 3.11. Live LMS tests are
  disabled (`RQTI_RUN_LIVE_TESTS=false`); browser integration is skipped in CI.
- The first incoming check requested `\doi{}` syntax for two new scoring
  references; both roxygen sources and generated help pages were corrected.
- That first complete run had no errors or warnings, one DOI-formatting NOTE,
  1,926 passing test assertions and 20 skips (18 live OPAL, one browser and one
  pre-existing empty test). Its PDF and HTML manual checks also passed.
- [CRAN's existing 1.3.1 checks](https://cran.r-project.org/web/checks/check_results_rqti.html)
  were all OK on 13 flavors (page updated 2026-11-17 08:52:49 CET).
- The live CRAN `PACKAGES.rds` index lists no direct reverse dependencies in
  Depends, Imports, LinkingTo or Suggests; no CRAN reverse-dependency checks are
  needed for that snapshot.
- [Latest main-branch CI](https://github.com/shevandrin/rqti/actions/runs/39925171168)
  passed macOS release, Windows release, Linux devel, Linux release and Linux
  oldrel-1 at `72e10e60`. It does not cover local `f32abea0` or these release edits.

## Handoff to Andrey

Before submission:

1. Review the release diff, especially NEWS, and push the candidate.
   Local `f32abea0` also needs to reach the remote (remote main was `72e10e60`
   when inspected). Wait for the platform matrix to pass on the final revision.
   Use a clean checkout of that revision for any rebuilds: this working checkout
   contains unrelated untracked files that were excluded from the candidate.
2. Run `devtools::check_win_devel()` from that exact source revision. This uploads
   the package and emails the registered maintainer; it has been left for Andrey.
   A macOS builder check is optional if the final macOS CI result is clean.
3. Add the final platform/builder results to `cran-comments.md`. Recheck CRAN
   status, URLs and reverse dependencies if submission is delayed or code changes.
4. Submit the exact checked source archive at <https://cran.r-project.org/submit.html>
   with `cran-comments.md`. Alternatively, run `devtools::submit_cran()` from the
   clean, checked source revision. Confirm the CRAN email sent to
   `shevandrin@gmail.com`.
5. After CRAN accepts 1.4.0, tag the submitted commit as `v1.4.0`, create the GitHub
   release from NEWS, update the website and bump development to `1.4.0.9000`.

The final archive and supporting logs/snapshots are saved under
`output/cran-1.4.0-20261117/`, which is already ignored by Git and excluded from
package builds. The source archive is `rqti_1.4.0.tar.gz`, with SHA-256
`7ca6aed35085171ae485c9f620a7819cc654e31907594214c711e5be37b9f091`.
The folder also contains the final check/install/test logs, CRAN/URL snapshots,
a review patch (`release-preparation.patch`), `manifest.json` and `SHA256SUMS`.
The patch records the preparation edits, including this checklist;
apply it to `f32abea0` if transferring the work to another checkout.
Scratch builds are in `/tmp/rqti-cran-release-20261117/`.
This checklist and `cran-comments.md` are also excluded from the source package.
