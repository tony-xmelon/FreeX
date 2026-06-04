# PDF Export Options Design

## Goal

Advance Export to PDF/XPS parity beyond file type selection by supporting a small Excel-like options surface:
active sheet vs selected range, document-properties flag in the export summary, and open-after-publish execution.

## Scope

- Add `Selection` as a modeled `ExportContentScope`.
- Add a host dialog result factory for export options.
- Render selected-range exports by passing a print-range override into `PrintRenderer`.
- Honor `OpenAfterPublish` after successful PDF/XPS export.
- Update command parity and architecture documentation.

## Constraints

- Do not implement workbook-wide export in this slice.
- Do not embed real PDF document properties yet; keep the flag surfaced in the option summary.
- Keep PDF and XPS on the shared print-renderer path.
