# FreeX PDF/XPS Vector Fidelity Evidence - 2026-07-14

## Scope

This worker slice advances the FreeX print/export lane for final PDF vector output shared by WPF/Avalonia planning. It stays inside workbook PDF/XPS print/export fidelity and does not claim Microsoft Excel, OS printer, or Windows XPS baselines.

## Change

- `WorkbookPdfContentBuilder.BuildWithPageSetup` now carries visible worksheet chart and text-box blocks from the shared `PageContentLayout` model into the final `PdfContentDocument` as vector draw operations.
- Chart blocks emit vector fill/stroke rectangles plus selectable chart text overlays.
- Text boxes emit vector fill/stroke rectangles plus selectable text runs.
- The conversion reuses the same page filtering, hidden/off-page drawing exclusion, and page-order logic already used by WPF/Avalonia print preview evidence.

## Evidence

- `PortablePdfVectorDrawingTests.BuildWithPageSetup_EmitsChartAndTextBoxVectorOpsFromSharedPrintLayout` verifies that the page-setup PDF document contains chart fill/stroke vectors, text-box fill/stroke vectors, the chart-title text overlay, and the text-box text run.
- Existing `PrintExportDrawingEvidencePlannerTests` remain the host-neutral evidence source for page-by-page drawing counts and chart text role breadth.

## Remaining Gaps

- XPS remains Windows-only in the current planner surface; this slice does not add a non-Windows XPS writer or native Windows XPS baseline.
- Final chart rendering is still bounded chart-area/vector-placeholder plus selectable text overlays, not a full Excel-equivalent chart plot renderer.
- PDF/A and tagged PDF remain explicitly unsupported/rejected by the export option planner.
- Native print dialog execution and Microsoft Excel visual baselines remain separate host/foreground validation work.
