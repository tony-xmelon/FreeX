# FreeP External RTF Paste, Wave 17

## Scope

FreeP's WPF in-canvas editor publishes three relevant clipboard representations: the FreeP
custom v2 payload, native RTF, and native XamlPackage, plus plain text. Before this slice the
Avalonia in-canvas editor consumed only the custom payload and plain text, so RTF copied from
Word, PowerPoint, or another rich editor lost its common inline formatting.

Wave 17 adds a renderer-neutral RTF ingestion path in `FreeP.App.Presentation`. Avalonia keeps
the existing custom v2 payload first, parses external RTF second, and uses plain text last.
WPF's native clipboard publisher and XamlPackage behavior are unchanged.

## Supported RTF Subset

The bounded parser supports `rtf1` documents with common ANSI/CP1252 text, font and color
tables, Unicode `\\uN` escapes with `\\ucN` fallback skipping, escaped characters, hex byte
escapes, paragraph breaks (`\\par`), soft line breaks (`\\line`), tabs (`\\tab`), and common
typographic escapes. It preserves paragraph boundaries and run-level bold, italic, underline,
font family, point size, and foreground color. Unsupported controls and destinations are ignored
when their surrounding group can be safely skipped.

The parser rejects non-RTF data, caps input at 8 MiB, caps output at 1,000,000 characters, and
caps group nesting at 256 levels. Malformed or oversized RTF returns to the normal plain-text
fallback without throwing.

## Clipboard Formats And Precedence

Avalonia reads native RTF using `Rich Text Format` on Windows and `text/rtf` on Linux through
`DataFormat.CreateBytesPlatformFormat`. The FreeP custom v2 format continues to use the existing
application/platform aliases. Paste precedence is:

1. FreeP custom v2 payload.
2. External RTF parsed into `InCanvasRichClipboardPayload`.
3. Avalonia plain text.

XamlPackage import is covered by the later shared bounded FlowDocument parser and host adapter
evidence. RTF lists, images, objects, fields, full paragraph property import, and complete
FlowDocument/RTL behavior are also outside this bounded subset.

## Evidence

- `freep/FreeP.App.Presentation.Tests/ExternalRichTextClipboardTests.cs` covers normal `rtf1`
  parsing, destination-group suppression/state restoration, font/color tables, Unicode, tabs,
  soft breaks, underline, malformed input, limits, and planner application.
- `freep/FreeP.App.Rendering.Avalonia.Tests/AvaloniaRichTextEditorTests.cs` covers Windows/Linux
  format identifiers, RTF-before-text, custom-v2-before-RTF, and malformed-Rtf-to-text fallback.
- Focused Release verification passed with no new dependency:
  `dotnet test freep/FreeP.App.Presentation.Tests/FreeP.App.Presentation.Tests.csproj --configuration Release --filter "FullyQualifiedName~ExternalRichTextClipboardTests|FullyQualifiedName~InCanvasRichClipboardTests" --logger "console;verbosity=minimal" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`
  and
  `dotnet test freep/FreeP.App.Rendering.Avalonia.Tests/FreeP.App.Rendering.Avalonia.Tests.csproj --configuration Release --filter FullyQualifiedName~AvaloniaRichTextEditorTests --logger "console;verbosity=minimal" --disable-build-servers -p:UseSharedCompilation=false -p:NodeReuse=false /nr:false -m:1`.
