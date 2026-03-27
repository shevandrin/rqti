# QTI.JS (rqti fork)

This repository is a maintained fork of the original
[QTI.JS](https://github.com/QTIJS/QTI.JS) project.

It is used as the rendering engine for the R package
[`rqti`](https://github.com/shevandrin/rqti), which provides tools for
creating, previewing, and delivering QTI 2.1 assessments.

## Purpose of this fork

The original QTI.JS project is designed as a general-purpose QTI runtime.
This fork contains modifications that ensure compatibility with the
`rqti` workflow, especially for:

- local preview of QTI items and tests
- integration with R-generated content
- handling of resource paths in packaged environments
- stylesheet support and customization
- small fixes and adjustments required for stable usage within `rqti`

These changes are primarily practical and integration-focused rather than
feature extensions of the QTI specification.

## Relationship to upstream

- Upstream repository: https://github.com/QTIJS/QTI.JS
- This fork is periodically synchronized with upstream when appropriate.
- Changes in this fork are maintained independently and are not guaranteed
  to be compatible with upstream without adaptation.

## Usage in rqti

The `rqti` package bundles a snapshot of this repository to provide a
self-contained preview environment without requiring external dependencies.

The bundled version can be found in: rqti/inst/qtijs/

Each bundled snapshot corresponds to a specific commit or tag in this fork.

## Development workflow

- All modifications are made and versioned in this repository.
- Stable states are tagged (e.g., `rqti-qtijs-vX.Y.Z`).
- The `rqti` package vendors these tagged snapshots.

## License

This project retains the original license of QTI.JS.
See the `LICENSE` file for details.

## Acknowledgements

All credit for the original implementation goes to the authors and
contributors of the QTI.JS project:
https://github.com/QTIJS/QTI.JS

