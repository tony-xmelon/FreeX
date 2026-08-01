# FreeW Avalonia PDF column separator rules

## Result

The Avalonia direct-PDF path now exports the separator rules for multi-column
sections when `ColumnsLineBetween` is enabled. The rules repeat on every page,
use the resolved live column geometry, and are painted in the same layer order
as Print Layout: after table surfaces and before line numbers and body content.

The PDF path preserves the live renderer's pixel-centered X registration and
maps the 1-DIP black rule to 0.75 PDF points. Disabling the separator emits no
rule, even when the document has multiple columns.

## Verification

- `FreeW.App.Avalonia` Release build: 0 warnings, 0 errors.
- `FreeW.App.Avalonia.Tests` Release build: 0 warnings, 0 errors.
- `DocumentViewPdfExportTests|DocumentViewColumnLayoutTests`: 37/37 passed.
- The focused PDF contract verifies two resolved rules on every page of a
  three-column document, page-margin bounds, line width, ordering, and portable
  PDF serialization.

## Remaining scope

This slice covers direct-PDF column separators only. Header/footer images and
run-level character decorations remain separate PDF visual owners.
