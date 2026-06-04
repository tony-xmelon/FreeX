# PDF Print Scaling Viewer Preference

## Goal

Polish PDF export fidelity by asking PDF readers to preserve actual worksheet page size when printing generated PDFs.

## Scope

- Write `/ViewerPreferences /PrintScaling /None` on all generated PDF files.
- Keep this as an exporter default rather than a user-visible option.
- Share viewer-preference dictionary creation with the existing document-title display preference.
- Update architecture and command parity documentation.

## Verification

- Red: focused App.Host tests failed because generated PDFs did not expose `/PrintScaling /None`.
- Green: focused App.Host tests for document properties, blank-title exports, and default print scaling passed.
- Full solution build.
