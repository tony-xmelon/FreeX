# Workbook Export Scope Design

## Goal

Advance PDF/XPS export options by adding an "entire workbook" scope.

## Scope

- Add `EntireWorkbook` as an export content scope.
- Surface the scope in `ExportOptionsDialog`.
- Render visible worksheets into one combined `FixedDocument` for PDF and XPS export.
- Keep hidden and veryHidden sheets out of workbook export.
- Update command parity and architecture documentation.

## Constraints

- Reuse `PrintRenderer.RenderWorksheet` per sheet so page setup and selected-range behavior remain centralized.
- Do not implement sheet selection subsets in this slice.
- Do not change PDF raster/vector semantics.
