# PDF Single Page Initial Layout

## Goal

Polish PDF export viewer fidelity by asking readers to open generated worksheet exports one page at a time.

## Scope

- Set `PdfDocument.PageLayout` to `SinglePage` for all generated PDFs.
- Keep this as an exporter default rather than a user-visible option.
- Preserve existing print-scaling and document-title viewer preferences.
- Update architecture and command parity documentation.

## Verification

- Red: focused App.Host PDF exporter test failed because `/PageLayout` was not written.
- Green: focused App.Host PDF exporter tests for page layout, print scaling, and document properties passed.
- Full solution build.
