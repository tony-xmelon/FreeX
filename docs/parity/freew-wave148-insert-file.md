# FreeW Wave 148 parity: rich Insert Text from File

Date: 2026-08-04

## Mismatch

The WPF authority registers `freew.insert-file` as `InsertFileCommand` in
`freew/FreeW.App.Host/Ribbon/FreeWRibbonCommands.cs`. Its execution path loads a
DOCX with `DocxReader.Read`, then `DocumentView.InsertDocument` in
`freew/FreeW.App.Host/Editing/DocumentView.cs` clones the source blocks with
`DocumentMerge.CloneBlocksForInsertion` and inserts them with
`InsertBlockCommand`. This preserves rich body structure such as tables and run
formatting while keeping the inserted blocks independent of the source.

Avalonia routed the same command IDs to its file picker, but the DOCX branch
read `document.PlainText` and inserted it with `InsertQuickPartText`. That
flattened tables, formatting, and other block-level content into paragraphs.

## Implementation

`FreeW.App.Avalonia.Editing.DocumentView.InsertDocument` now follows the WPF
model-backed insertion path: it deep-clones source blocks, transfers missing
styles through the existing merge helper, inserts after the caret, and wraps
the block commands in one undo group. `MainWindow.InsertTextFromFileAsync`
uses this path for DOCX files and keeps the existing plain-text path for TXT
files. The ribbon callback remains the shared route for both command IDs.

## Behavioral evidence

- `freew/FreeW.App.Avalonia.Tests/InsertDepth2Tests.cs` verifies rich run
  formatting, table preservation, source independence, one-step undo, and
  consumption through the `freew.insert-file` ribbon callback.
- Existing `freew/FreeW.Core.Model.Tests/DocumentMergeTests.cs` coverage
  verifies the shared deep-clone merge semantics used by the Avalonia path.
