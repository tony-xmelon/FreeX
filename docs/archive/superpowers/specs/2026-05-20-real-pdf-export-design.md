# Real PDF Export Design

**Status:** Approved for implementation

## Goal

Replace FreeX's `.pdf` export fallback with deterministic local PDF file creation while keeping `.xps` export available.

## Scope

This slice makes `Export as PDF / XPS` create a real `.pdf` file for PDF paths. The exporter reuses the existing print renderer, converts each `FixedDocument` page to a page-sized image, and writes those pages through `PDFsharp-WPF`. This keeps the first PDF implementation aligned with the current print/XPS layout without building a parallel PDF layout engine.

## Architecture

`ExportPlanner` distinguishes `Pdf` and `Xps` formats. `MainWindow` renders the active sheet once via `PrintRenderer` and routes the `FixedDocument` to either a new `PdfDocumentExporter` service or the existing XPS writer. `PdfDocumentExporter` owns the PDF dependency and the WPF page-to-bitmap conversion; `MainWindow` remains orchestration-only.

## Non-Goals

- Full Excel PDF publish options such as workbook/sheet range selection, tagged PDF, PDF/A, bookmarks, comments modes beyond existing print support, or document property embedding.
- Selectable/vector PDF text. The first pass is print-faithful raster pages.
- Removing XPS export.

## Verification

Tests cover planner behavior and direct PDF file creation from a small `FixedDocument`. Focused verification runs App.Host export tests and command parity tests.
