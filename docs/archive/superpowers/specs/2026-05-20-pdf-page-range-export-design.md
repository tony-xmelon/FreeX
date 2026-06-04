# PDF/XPS Page Range Export Design

## Goal

Move FreeX's PDF/XPS publish options closer to Excel by supporting one-based page ranges.

## Scope

- Extend `ExportOptions` with an optional `ExportPageRange`.
- Let the export options dialog collect From/To page numbers.
- Include page-range details in export summaries.
- Apply the range to PDF export by subsetting rendered `FixedDocument` pages.
- Apply the range to XPS export by wrapping the generated `DocumentPaginator`.

## Non-Goals

- Page preview thumbnails or page-count validation in the dialog.
- Selectable/vector PDF text.
- Full Excel PDF optimization/security/tagging options.

## Verification

Focused tests cover page-range parsing, option summaries, PDF page count output, and source hygiene for the export workflow.
