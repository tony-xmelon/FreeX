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

### 2026-07-30 slide-level native table paste

The slide-level WPF clipboard route now distinguishes a standalone multi-cell RTF/Xaml table
from ordinary rich text. It converts that bounded tab-delimited projection into a native,
editable `Table` shape, preserving cell runs and using the existing undoable shape-add command.
Mixed prose, one-column projections, and in-canvas text-editor paste retain the previous
textbox/tab projection rather than silently dropping surrounding text.

For standalone native-table paste, the first valid RTF row's increasing `cellx` edges are
converted from twips to EMU and carried through the clipboard payload. Matching native table
columns therefore retain authored widths; XAML tables and malformed or column-count-mismatched
payloads use the existing equal-width fallback.

The common solid-cell style subset is preserved as well: `clcbpat` becomes an explicit cell
fill, and `clbrdrt`/`clbrdrl`/`clbrdrr`/`clbrdrb` with `brdrs`, `brdrw`, `brdrcf`, or `brdrnil`
become per-side cell outlines. This is shared by WPF and Avalonia native-table paste; the
existing text-editor projection remains style-safe and does not invent inline table nodes.

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
FreeP.App.Presentation.Tests: ExternalRichTextClipboardTests, 16 passed (build and no-build)
FreeP.App.Host.Tests: OsClipboardServiceTests.Paste_, 12 passed (build and no-build)
FreeP.App.Avalonia.Tests: PresentationClipboardInteropTests, 26 passed (build and no-build)
```

## Unsupported Constructs

The in-canvas text model still cannot retain an inline RTF table node, and the bounded
slide-level conversion intentionally does not yet import pattern fills, vertical alignment,
cell margins, merged-cell controls, nested table structure, or other table layout properties.
One-column and mixed-prose projections retain the existing
textbox fallback. Arbitrary fields, RTL/IME nuances, complete Word list-template numbering,
and PowerPoint-authoritative external RTF visual baselines remain deferred.
