# PDF Document Title Viewer Preference

## Goal

Polish PDF document-property fidelity by asking PDF readers to display the workbook-derived document title when a title is exported.

## Scope

- Keep the option surface unchanged: this rides on `IncludeDocumentProperties`.
- Set `PdfViewerPreferences.DisplayDocTitle` only when a nonblank title is written to the PDF Info dictionary.
- Leave blank-title exports unchanged so viewers can continue using the filename.
- Update architecture and command parity documentation.

## Verification

- Focused App.Host tests for titled and blank-title PDF exports.
- Full solution build.
