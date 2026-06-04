# PDF Language Option

## Goal

Replace the hardcoded PDF catalog language with a modeled export option so generated PDFs can carry a requested workbook/user language tag.

## Scope

- Keep `en-US` as the default PDF catalog language.
- Add a normalized PDF language tag to `ExportOptions` and `ExportOptionsDialog.CreateResult`.
- Expose a small dialog field for the PDF language tag.
- Pass the option through `MainWindow.PrintExport` into `PdfDocumentExporter`.
- Write the requested PDF `/Lang` catalog value.
- Update architecture and command parity documentation.

## Verification

- Focused App.Host export tests.
- Full solution build with shared build servers disabled.
