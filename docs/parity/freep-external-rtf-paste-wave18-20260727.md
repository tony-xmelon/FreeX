# FreeP External RTF Paste Depth, Wave 18

Date: 2026-07-27

## Scope

FreeP's bounded external RTF clipboard parser now preserves a focused renderer-neutral subset of Word and LibreOffice paste semantics through the existing `TextBody`, `Paragraph`, and `Run` model. Clipboard precedence remains custom v2, then RTF, then plain text.

Supported semantics:

- Word `listtable` and `listoverridetable` definitions for bounded numbered and bullet lists.
- Nested list levels through `Paragraph.Level`, common number formats, first-item starts, and continuation behavior through `AutoNumStartAtSpecified`.
- Legacy `pn` list controls where the existing paragraph model can represent them.
- Paragraph alignment, left and first-line indentation, and before/after spacing from common RTF paragraph controls.
- External `HYPERLINK` field results for `http`, `https`, and `mailto` targets through `Run.Hyperlink`.
- Existing escaped text, Unicode fallback, groups, font/color/style controls, tabs, line breaks, and deterministic output/depth limits.

## Evidence

- `freep/FreeP.App.Presentation.Tests/ExternalRichTextClipboardTests.cs` covers Word list tables, nested groups and Unicode, LibreOffice-style unsupported destinations, hyperlink safety, continuation/restart metadata, paragraph layout, and malformed input.
- `freep/FreeP.App.Rendering.Avalonia.Tests/AvaloniaRichTextEditorTests.cs` proves the real Avalonia paste path applies shared paragraph and hyperlink metadata while preserving custom-v2 > RTF > plain-text precedence.
- `freep/FreeP.App.Presentation/ExternalRichTextClipboardPlanner.cs` is the single parser used by the Avalonia adapter; no platform-specific semantic fork was added.

## Residuals

XamlPackage, objects and pictures, arbitrary field types, rich RTF tables, RTL/IME nuances, complete Word list-template numbering, and PowerPoint-authoritative external RTF visual baselines remain outside this bounded slice. Unsupported destinations and controls continue to be ignored, and malformed or oversized untrusted input returns null or a deterministic bounded partial result without throwing to paste callers.
