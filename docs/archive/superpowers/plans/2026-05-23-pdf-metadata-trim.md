# PDF Metadata Trim Plan

## Goal

Polish PDF export metadata handling so explicit PDF Info dictionary fields are normalized consistently with workbook-derived document properties.

## Checklist

- [x] Add a focused red test proving explicit PDF document properties are trimmed before writing.
- [x] Normalize explicit PDF property strings in `PdfDocumentExporter`.
- [x] Re-run the focused PDF metadata test.
- [x] Run the focused export planner suite and final branch build.
- [x] Complete code review.
- [ ] Commit, merge to `main`, and sync the branch from updated `main`.

## Architectural Decision

PDF Info normalization belongs in `PdfDocumentExporter`, not only in `PdfDocumentProperties.FromWorkbook`, because future export dialogs or metadata sources can construct explicit `PdfDocumentProperties` directly. The exporter remains the last boundary before bytes are written and therefore owns blank-skip plus trim semantics for PDF metadata.
