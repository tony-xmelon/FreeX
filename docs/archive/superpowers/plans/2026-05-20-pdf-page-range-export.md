# PDF/XPS Page Range Export Implementation Plan

## Tasks

- [x] Identify page-range export as the next small PDF/XPS publish-options fidelity gap.
- [x] Add `ExportPageRange` to export options and summaries.
- [x] Add page-range validation helper tests.
- [x] Add From/To page inputs to `ExportOptionsDialog`.
- [x] Add PDF page-range writing and page-count regression coverage.
- [x] Add XPS page-range paginator wrapper.
- [x] Route PDF/XPS exports through the page-range option.
- [x] Validate requested page ranges against rendered page count before writing PDF/XPS output.
- [x] Update architecture, command parity, toolbar parity, and ADR docs.
- [ ] Run focused verification, commit, merge to `main`, push, then continue with the next sensible fidelity slice.

## Decisions

- Page ranges are one-based to match user-facing Excel terminology.
- Dialog validation checks numeric ordering but does not pre-render the document just to know the total page count.
- PDF and XPS share the same `ExportOptions` model, but each applies the range through the least invasive output-specific adapter.
- Page-range validation stays in `ExportPlanner` so both PDF and XPS use the same user-facing error text while the PDF exporter can still guard against direct invalid calls.
