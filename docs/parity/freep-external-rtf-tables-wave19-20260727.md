# FreeP External RTF Table Depth, Wave 19

Date: 2026-07-27

## Scope

This slice establishes the actual WPF-compatible behavior for a Word or LibreOffice RTF
table pasted into FreeP's in-canvas text editor and implements the closest truthful shared
semantic for both hosts.

WPF's `TextRange.Load(..., DataFormats.Rtf)` creates one native
`System.Windows.Documents.Table` block. Its WPF text projection is tab-delimited cells and
CRLF-delimited rows, for example `A\tB\r\nC\tD\r\n`. FreeP's renderer-neutral `TextBody` has
paragraphs and runs but no inline table node, so table structure cannot be persisted as a
table inside an edited text shape. The shared semantic therefore preserves the same logical
projection: `\cell`/`\nestcell` become cell-boundary tabs and `\row`/`\nestrow` become row
paragraph boundaries.

## Implemented

- Bounded common table controls: `trowd`, `cellx`, `cell`, `row`, `intbl`, `itap`,
  `nesttableprops`, `nestcell`, and `nestrow`.
- Nested RTF groups retain the existing state-stack behavior, so cell text keeps common
  font, size, bold, italic, underline, strikethrough, color, paragraph alignment, indent,
  spacing, list, and hyperlink metadata.
- Row/cell output is deterministic, including empty leading/trailing cells, and has a
  `MaxTableCellsPerRow` safety bound in addition to the existing byte, output-character, and
  group-depth limits.
- WPF and Avalonia use the same precedence for in-canvas paste: custom FreeP v2 payload,
  bounded external RTF, then plain Unicode text. WPF native table behavior remains the
  authority used to define the shared logical projection; no platform-specific table parser
  was added.

## Evidence

- `freep/FreeP.App.Host.Tests/WpfRichTextClipboardAdapterTests.cs` verifies the native WPF
  table block and its tab/CRLF text projection, plus WPF adapter fallback into the shared
  planner.
- `freep/FreeP.App.Presentation.Tests/ExternalRichTextClipboardTests.cs` verifies common
  table controls, nested formatting groups, rich cell runs, deterministic boundaries, and
  excessive-cell rejection.
- `freep/FreeP.App.Rendering.Avalonia.Tests/AvaloniaRichTextEditorTests.cs` verifies the
  real Avalonia data-transfer path and shared rich formatting for table cells.

Focused verification passed:

```text
FreeP.App.Presentation.Tests: ExternalRichTextClipboardTests, 10 passed
FreeP.App.Host.Tests: WpfRichTextClipboardAdapterTests, 5 passed
FreeP.App.Rendering.Avalonia.Tests: ClipboardPaste, 4 passed
```

## Unsupported Constructs

The current model cannot truthfully retain RTF table geometry or table objects. Cell widths
from `cellx`, borders, fills, vertical alignment, cell margins, merged-cell controls, nested
table structure, and other table layout properties are intentionally ignored after their
text boundaries are projected. XamlPackage, objects/pictures, arbitrary fields, RTL/IME
nuances, complete Word list-template numbering, and PowerPoint-authoritative external RTF
visual baselines remain deferred.
