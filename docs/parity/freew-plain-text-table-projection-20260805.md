# FreeW plain-text table projection parity

## Gap

`PlainTextFileAdapter.Save` emitted top-level paragraphs but silently skipped every table block. Saving
a document as `.txt` therefore lost all table-cell characters even though the shared model already
defines a deterministic table-to-text projection.

## Change

Plain-text save now emits each table row as one logical text row, with tabs between cells. Cell
paragraphs retain their line breaks, normalized to the selected `TextSaveOptions` EOL, and empty cells
retain their tab position. Paragraph formatting and table geometry remain intentionally lossy.

The implementation is confined to `PlainTextFileAdapter`; the document model and native document
formats are unchanged.

## Verification

- Focused `PlainTextFileAdapterTests`: 12/12.
- Plain-text, adapter registration, and file-dialog controls: 55/55.
- Consuming `FreeW.Core.IO` Release build: 0 warnings, 0 errors.

## Word evidence boundary

A short-path Word COM probe was attempted before implementation. Automation created a responsive
owned `WINWORD` process, but this installation did not return from `Documents.Add` within the bounded
60-second call, so `SaveAs2` was never invoked and no generated text file was used as acceptance
evidence. The owned PowerShell and Word processes and `%TEMP%\fwpt` artifacts were removed. The
accepted contract follows FreeW's existing shared table-to-text convention; a fresh Word-generated
byte comparison remains useful external confirmation, not a blocker for preserving table content.
