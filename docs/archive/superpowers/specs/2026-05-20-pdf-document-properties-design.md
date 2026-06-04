# PDF Document Properties Design

## Goal

When the Export to PDF/XPS dialog is set to include document properties and the chosen format is PDF, FreeX should embed the supported workbook identity into the generated PDF Info dictionary.

## In Scope

- Keep PDF rendering on the existing `PrintRenderer` to `FixedDocument` to `PDFsharp-WPF` raster path.
- Add a small host-level metadata record that maps the current `Workbook` and `ExportOptions` to PDF properties.
- Embed the workbook name as PDF title when document properties are requested.
- Embed deterministic FreeX-authored author, subject, keywords, and creator values.
- Preserve the existing default where document properties are not included.

## Out of Scope

- A full workbook document-properties model.
- XLSX core/extended/custom property editing.
- Full Excel PDF publish option parity.
- Selectable/vector PDF text.

## Acceptance Tests

- A generated PDF with explicit properties has title, author, subject, keywords, and creator values in `pdf.Info`.
- `PdfDocumentProperties.FromWorkbook` returns null unless `IncludeDocumentProperties` is true.
- The export workflow passes `PdfDocumentProperties.FromWorkbook(_workbook, options)` into `PdfDocumentExporter.Save`.
