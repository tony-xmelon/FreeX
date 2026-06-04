# PDF Document Properties Implementation Plan

## Tasks

1. Add failing App.Host tests for PDF Info metadata and export workflow wiring.
2. Add `PdfDocumentProperties` in `App.Host` as the boundary between workbook state and PDFsharp metadata.
3. Extend `PdfDocumentExporter.Save` with optional properties while preserving the existing rendering path.
4. Thread metadata from `MainWindow.PrintExport` only when `ExportOptions.IncludeDocumentProperties` is true.
5. Update architecture, command parity, toolbar parity, and command closeout ADR documentation.
6. Run focused App.Host export tests, review, then merge and sync.

## Decisions

- Keep the metadata mapper in `App.Host` because the current core workbook model does not yet expose Office-style document properties.
- Use deterministic FreeX values for author, subject, and keywords until a modeled document-property subsystem exists.
- Do not change XPS export in this slice; XPS still uses the Windows print package path.
